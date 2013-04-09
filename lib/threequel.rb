require_relative './threequel/version'
require 'active_record'
require 'active_support'
require_relative './threequel/timer'
require_relative './threequel/sql/utils'
require_relative './threequel/sql/statement_array'
require_relative './threequel/loggers/console_logger'
require_relative './threequel/loggers/db_logger_storage'
require_relative './threequel/loggers/db_logger'
require_relative './threequel/logging_handler'
require_relative './threequel/logging'
require_relative './threequel/sql/statement'
require_relative './threequel/sql/command'
require_relative './threequel/sql/command_hash'
require_relative './threequel/commandant/commandant'

module Threequel
  # Your code goes here...
  STATEMENT_TERMINATOR = "\nGO"
end
