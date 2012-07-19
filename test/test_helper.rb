require 'minitest/autorun'
require 'minitest/pride'

begin; require 'turn/autorun'; rescue LoadError; end

require File.expand_path('../../lib/threequel.rb', __FILE__)

Turn.config.ansi = true
Turn.config.verbose = true
Turn.config.natural = true
Turn.config.format = :cue
# Turn.config.format = :outline