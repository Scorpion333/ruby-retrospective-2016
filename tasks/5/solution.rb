class Hash
  def satisfy?(request)
    request.all? do |key, value|
      self[key] == value
    end
  end
end

class ArrayStore
  def initialize
    @storage = []
  end
  
  def create(record)
    @storage.push(record)
  end
  
  def find(request)
    @storage.select { |hash| hash.satisfy?(request) }
  end
  
  def update(id, new_attributes)
    updated_index = @storage.find_index { |hash| hash.satisfy?({id: id}) }
    @storage[updated_index].merge!(new_attributes) unless updated_index.nil?
  end
  
  def delete(request)
    @storage.delete_if { |hash| hash.satisfy?(request) }
  end
end

class HashStore
  def initialize
    @storage = {}
  end
  
  def create(record)
    @storage[record[:id]] = record
  end
  
  def find(request)
    @storage.values.select { |hash| hash.satisfy?(request) }
  end
  
  def update(id, new_attributes)
    @storage[id].merge!(new_attributes) if @storage.key?(id)
  end
  
  def delete(request)
    @storage.delete_if { |_id, hash| hash.satisfy?(request) }
  end
end

class DataModel  
  class << self
    attr_accessor :store, :free_id
    attr_reader :attributes_list
  end
  
  def self.attributes(*attributes_names)
    if attributes_names.empty?
      @attributes_list.map { |attribute| attribute.to_sym }
    else
      @free_id = 1
      @attributes_list = attributes_names + [:id]
      create_accessors_and_finder
    end
  end
  
  def self.data_store(store_object = nil)
    @store = store_object unless store_object.nil?
    @store
  end
  
  def self.where(request)
    @store.find(request).map { |hash| self.new(hash) }
  end
  
  def self.create_accessors_and_finder
    @attributes_list.each do |key|       
      define_method (key) { @attributes_hash[key] }
      define_method ("#{key}=".to_sym) { |value| @attributes_hash[key] = value }
      finder = "find_by_#{key}".to_sym
      define_singleton_method (finder) { |value| @store.find({key => value}) }
    end
  end
  
  def initialize(attributes_values = {})
    @attributes_hash = {}
    self.class.attributes_list.each do |attribute|
      @attributes_hash[attribute] = attributes_values[attribute]
    end
  end
  
  def save
    if id.nil?
      self.id = self.class.free_id
      self.class.free_id = self.class.free_id + 1
      self.class.store.create(@attributes_hash)
    else
      self.class.store.update(id, @attributes_hash)
    end
  end
  
  def delete
    self.class.store.delete({id: id}) unless self.class.store.nil? || id.nil?
  end
  
  def ==(other)
    self.equal?(other) || (self.class == other.class && id != nil && id == other.id)
  end
end