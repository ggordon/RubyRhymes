require 'ruby_rhymes'

require 'minitest/autorun'
require 'minitest/reporters'
if ENV['RUBYMINE_TESTUNIT_REPORTER']
  MiniTest::Reporters.use! [MiniTest::Reporters::RubyMineReporter.new]
else
  MiniTest::Reporters.use! [MiniTest::Reporters::DefaultReporter.new(color: true, slow_count: 2)]
end

class AcceptanceSpec < MiniTest::Spec
end
MiniTest::Spec.register_spec_type( /Integration$/, AcceptanceSpec )
