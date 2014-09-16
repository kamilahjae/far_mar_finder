module FarMar
  class Vendor

    def initialize(vendor_array)
      @id = vendor_array[0]
      @name = vendor_array[1]
      @employees = vendor_array[2]
      @market_id = vendor_array[3]
    end

    def self.all
      @vendor_array = CSV.open("./support/vendors.csv", "r") do |file|
        file.collect do |vendor|
          FarMar::Vendor.new(vendor)
        end
      end
    end
  end
end
