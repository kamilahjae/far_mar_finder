require 'csv'
require 'time'
require 'date'
require 'benchmark'

# This file is to require all of our dependencies (each of the classes we make)
require_relative 'far_mar/market'
require_relative 'far_mar/vendor'
require_relative 'far_mar/product'
require_relative 'far_mar/sale'
# to load in irb do require_relative 'far_mar/market'

### Benchmarking Far_mar Market
# m = FarMar::Market.find(1)
#
# Benchmark.bm do |x|
#   x.report { m.preferred_vendor(2013,11,11)}
#   x.report { FarMar::Market.find(90)}
# end
