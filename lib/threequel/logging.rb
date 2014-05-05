module Threequel
  module Logging

    def log(name = 'Anonymous', attributes = {}, *loggers)
      logging_handler(loggers).handle_logging(name, attributes) do
        yield
      end
    end

    def logging_handler(loggers)
      Threequel::LoggingHandler.new do |config|
        config.register_logger Threequel::DBLogger          if loggers.include?(:db)
        config.register_logger Threequel::ConsoleLogger     if loggers.include?(:console)
        config.register_logger Threequel::CheetahMailLogger if loggers.include?(:cheetah_mail)
      end
    end

    def add_logging_to method, *loggers
      stashed_method = "stashed_#{method}".to_sym
      class_eval do
        alias_method stashed_method, method
        define_method method do |*args, &block|

          log(name, attributes, *loggers) do
            send stashed_method, *args, &block
          end

        end
      end
    end

  end
end
