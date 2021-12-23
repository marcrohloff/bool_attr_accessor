# frozen_string_literal: true

require 'bundler/setup'
Bundler.setup

require 'benchmark'
require 'benchmark/ips'
require 'benchmark/memory'

puts '```ruby'
puts File.read(__FILE__)
puts '```'
puts
puts '### Output'
puts
puts '```'

require_relative 'lib/bool_attr_accessor'

class Foo

  class << self

    attr_boolean   :bool
    attr_accessor  :direct

  end

end

def test_read_direct
  Foo.direct
end

def test_read_bool
  Foo.bool?
end

def test_write_direct
  Foo.direct = true
end

def test_write_bool
  Foo.bool = true
end

Benchmark.ips do |x|
  x.report('test_read_direct') { test_read_direct }
end
Benchmark.memory do |x|
  x.report('test_read_direct') { 100.times { test_read_direct } }
end

Benchmark.ips do |x|
  x.report('test_read_bool') { test_read_bool }
end
Benchmark.memory do |x|
  x.report('test_read_bool') { 100.times { test_read_bool } }
end

Benchmark.ips do |x|
  x.report('test_write_direct') { test_write_direct }
end
Benchmark.memory do |x|
  x.report('test_write_direct') { 100.times { test_write_direct } }
end

Benchmark.ips do |x|
  x.report('test_write_bool') { test_write_bool }
end
Benchmark.memory do |x|
  x.report('test_write_bool') { 100.times { test_write_bool } }
end

puts '```'
