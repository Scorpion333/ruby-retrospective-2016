class String
  def argument?
    self[0] == '-'
  end
  
  def option?
    self[0] == '-'
  end
  
  def short_option?
    option? && self[1] != '-'
  end
  
  def long_option?
    option? && self[1] == '-'
  end
end

module ParseHelpers
  def parse_arguments(runner, argv)
    argv.select { |string| string[0] != '-' }.each_with_index do |argument, index|
      @arguments[index][:block].call(runner, argument)
    end
  end
  
  def parse_options(runner, argv)
    argv.select { |string| string[0] == '-' }.each do |string|
      if string[1] == '-'	  
	    option_name = string.split('=')[0]
		parameter = string.split('=')[1]
      else
        option_name = string[0..1]
        parameter = string[2..-1]
      end
      value = (parameter.nil? || parameter == '') ? true : parameter
	  @options[option_name][:block].call(runner, value) if @options.has_key?(option_name)
    end
  end
end

class CommandParser
  include ParseHelpers

  def initialize(command_name)
    @command_name = command_name
	@arguments = []
	@options = {}
  end
  
  def argument(name, &block)
    @arguments.push({block: block, name: name})
  end
  
  def option (short, long, description, &block)
    option_data = {block: block, description: description}
    @options['-' + short] = option_data
    @options['--' + long] = option_data.merge({short: "-#{short}"})
  end
  
  def option_with_parameter (short, long, description, parameter, &block)
    option_data = {block: block, description: description, parameter: parameter}
    @options['-' + short] = option_data
    @options['--' + long] = option_data.merge({short: "-#{short}"})
  end
  
  def parse(command_runner, argv)
    parse_arguments(command_runner, argv)
    parse_options(command_runner, argv)
  end
  
  def help
    usage_string = 'Usage: ' + @command_name
	
	@arguments.each do |argument_hash|
	  usage_string += ' [' + argument_hash[:name] + ']'
	end
	
	@options.each_key do |key|
	  if key[0..1] == '--'
		usage_string += "\n    " + @options[key][:short] + ', ' + key
        usage_string += '=' + @options[key][:parameter] if @options[key].has_key?(:parameter) 
        usage_string += ' ' + @options[key][:description]
	  end
	end
	
	usage_string
  end
end