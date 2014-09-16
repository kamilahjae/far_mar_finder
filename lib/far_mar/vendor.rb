module FarMar
  class Vendor
    attr_accessor :id, :name, :employees, :market_id

    def initialize(vendor_array)
      @id = vendor_array[0].to_i
      @name = vendor_array[1]
      @employees = vendor_array[2]
      @market_id = vendor_array[3].to_i
    end

    def self.all
      @vendor_array = CSV.open("./support/vendors.csv", "r") do |file|
        file.collect do |vendor|
          FarMar::Vendor.new(vendor)
        end
      end
    end

    # def self.find(desired_id)
    #   all.find_all {|vendor| vendor.market_id == desired_id}
    # end
  end
end
