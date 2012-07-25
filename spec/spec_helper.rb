require 'minitest/autorun'
require 'minitest/pride'
# require 'mocha'

begin; require 'turn/autorun'; rescue LoadError; end

require File.expand_path('../../lib/threequel.rb', __FILE__)

Turn.config.ansi = true
Turn.config.verbose = true
Turn.config.natural = true
Turn.config.format = :pretty
# Turn.config.format = :outline