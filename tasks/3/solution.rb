module ParseHelpers
  def parse_arguments(runner, argument_values)
    argument_values.each_with_index do |value, index|
      @arguments[index][:block].call(runner, value)
    end
  end
  
  def parse_long_options(runner, long_options)
    long_options.each do |string|
      option_name = string.split('=')[0][2..-1]
      parameter = string.split('=')[1]
      value = parameter || true
      the_option = @options.find { |hash| hash[:long] == option_name }
      the_option[:block].call(runner, value)
    end
  end
  
  def parse_short_options(runner, short_options)
    short_options.each do |string|
      option_name = string[1]
      parameter = string[2..-1] unless string[2].nil?
      value = parameter || true
      the_option = @options.find { |hash| hash[:short] == option_name }
      the_option[:block].call(runner, value)
    end
  end
end

class CommandParser
  include ParseHelpers

  def initialize(command_name)
    @command_name = command_name
    @arguments = []
    @options = []
  end
  
  def argument(name, &block)
    @arguments.push({block: block, name: name})
  end
  
  def option(short, long, description, &block)
    hash = {short: short, long: long, block: block, description: description}
    @options.push(hash)
  end
  
  def option_with_parameter(short, long, description, parameter, &block)
    hash = {short: short, long: long, block: block, description: description, parameter: parameter}
    @options.push(hash)
    # @options.last[:parameter] = parameter
  end
  
  def parse(command_runner, argv)
    argument_values = argv.select { |string| string[0] != '-' }
    long_options = argv.select { |string| string.start_with? '--' }
    short_options = argv - argument_values - long_options
    
    parse_arguments(command_runner, argument_values)
    parse_long_options(command_runner, long_options)
    parse_short_options(command_runner, short_options)
  end
  
  def help
    usage_string = 'Usage: ' + @command_name
    
    @arguments.each do |hash|
      usage_string += ' [' + hash[:name] + ']'
    end

    @options.each do |hash|
      usage_string += "\n    -" + hash[:short] + ', --' + hash[:long]
      usage_string += '=' + hash[:parameter] if hash.key?(:parameter) 
      usage_string += ' ' + hash[:description]
    end

    usage_string
  end
end