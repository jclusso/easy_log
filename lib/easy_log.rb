require 'binding_of_caller'
require 'easy_log/version'
require 'logger'

module EasyLog

  def self.included cls
    cls.extend EasyLog
  end

  def self.set_logger(logger)
    if logger.respond_to? :info
      @logger = logger
    else
      fail InvalidLoggerError, 'Logger must respond to info!'
    end
  end

  def self.logger
    @logger ||= (defined?(Rails) ? Rails.logger : Logger.new(STDOUT))
  end

  def log(*args)
    @current_binding = binding.of_caller(1)
    EasyLog.logger.info msg(*args)
  end

  def msg(*args)
    @current_binding = binding.of_caller(1) unless @current_binding
    types = [:start, :finish, :success, :info, :warning, :error]
    requires_message = {
      start: false,
      finish: false,
      success: false,
      info: true,
      warning: true,
      error: true
    }
    type = args.shift if args.first.is_a?(Symbol) && types.include?(args.first)
    message = args.shift if args.first.is_a?(String)
    additional_params = args.shift

    if requires_message[type] && !message
      fail(ArgumentError, "message required for #{type}")
    end

    display_type = "#{type.to_s.upcase}#{message ? ': ' : '!'}" if type

    param_string = build_params_string(
      instance_params,
      method_params,
      additional_params
    )

    "#{class_method_string}: #{display_type}#{message}#{param_string}"
  end

  private

  # gets the class and method name as a string
  def class_method_string
    full_str = @current_binding.eval('method(__method__).to_s')
    full_str.sub('#<Method: ', '').sub(/>$/, '')
  end

  # retrieves the method params from the current binding
  def method_params
    params_method = 'method(__method__).parameters'
    @current_binding.eval(params_method).inject({}) do |a, param|
      value = @current_binding.eval(param.last.to_s)
      a[param.last.to_s] = value if value
      a
    end
  end

  def instance_params
    @current_binding.eval('instance_variables').inject({}) do |a, param|
      unless [:@current_binding, :@logger].include?(param)
        value = @current_binding.eval(param.to_s)
        a[param] = value if value
      end
      a
    end
  end

  # build a param string from the method method_params and any additional_params
  def build_params_string(instance, method, additional)
    full_hash = instance.to_h.merge(method.to_h).merge(additional.to_h)
    params_string = full_hash.inject('') do |a, (k, v)|
      a += " #{k}: #{v}"
    end

    " w/#{params_string}" unless params_string.nil? || params_string == ''
  end

  class Error < StandardError; end
  class ArgumentError < Error; end
  class InvalidLoggerError < Error; end
end
