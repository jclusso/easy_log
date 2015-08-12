require 'spec_helper'



describe EasyLog do

  it 'has a version number' do
    expect(EasyLog::VERSION).not_to be nil
  end

  describe "#set_logger" do
    it 'sets the logger only if it responds to info method' do
      logger = Logger.new(STDOUT)
      expect(EasyLog.set_logger(logger)).to equal(logger)
    end

    it 'raises invalid logger error if it doesn\'t respond to info' do
      expect { EasyLog.set_logger(String.new) }
        .to raise_error(EasyLog::InvalidLoggerError,
        'Logger must respond to info!')
    end
  end

  describe '.msg' do
    before do
      class TestClass
        include EasyLog

        def simple_log
          msg(:start)
        end

        def log_with_message
          msg(:success, 'The Message')
        end

        def log_with_message_and_parameters(p1, p2)
          msg(:finish, 'The Message')
        end

        def log_with_additional_parameters(p1, p2)
          msg(:error, 'The Message', p3: 'Pumpkin')
        end

        def log_with_instance_variable
          @p4 = 'Cucumber'
          msg(:warning, 'The Message')
        end

        def advanced_log(p1, p2)
          @p3 = 'Pumpkin'
          msg(:error, 'The Message', p4: 'Cucumber')
        end

        def argument_error_log
          msg(:error)
        end
      end
    end
    let(:test_class) { TestClass.new }
    let(:p1) { 'Apples' }
    let(:p2) { 'Oranges' }
    let(:p3) { 'Pumpkin' }
    let(:p4) { 'Cucumber' }

    it 'outputs for simple_log' do
      message = "TestClass#simple_log: START!"
      expect(test_class.simple_log).to eql(message)
    end

    it 'outputs for log_with_message' do
      message = "TestClass#log_with_message: SUCCESS: The Message"
      expect(test_class.log_with_message).to eql(message)
    end

    it 'outputs for log_with_message_and_parameters' do
      message = "TestClass#log_with_message_and_parameters: FINISH: The Message"\
        " w/ p1: #{p1} p2: #{p2}"
      expect(test_class.log_with_message_and_parameters(p1, p2)).to eql(message)
    end

    it 'outputs for log_with_additional_parameters' do
      message = "TestClass#log_with_additional_parameters: ERROR: The Message"\
        " w/ p1: #{p1} p2: #{p2} p3: #{p3}"
      expect(test_class.log_with_additional_parameters(p1, p2)).to eql(message)
    end

    it 'outputs for log_with_instance_variable' do
      message = "TestClass#log_with_instance_variable: WARNING: The Message"\
        " w/ @p4: #{p4}"
      expect(test_class.log_with_instance_variable).to eql(message)
    end

    it 'outputs for advanced_log' do
      message = "TestClass#advanced_log: ERROR: The Message"\
        " w/ @p3: #{p3} p1: #{p1} p2: #{p2} p4: #{p4}"
      expect(test_class.advanced_log(p1, p2)).to eql(message)
    end

    it 'raises an argument error' do
      expect { test_class.argument_error_log }
        .to raise_error(EasyLog::ArgumentError, "message required for error")
    end
  end
end
