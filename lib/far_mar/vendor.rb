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

    def self.find(desired_id)
      all.find_all {|vendor| vendor.id == desired_id}
    end

    # Return all of the vendors with the given market id
    def self.by_market(market_id)
      vendors = FarMar::Vendor.all
      vendors.find_all {|vendor| vendor.market_id == market_id}
    end

    # Return the Market instance associated with this vendor using the
    # vendor market_id field
    def market
      all_markets = FarMar::Market.all
      all_markets.find {|market| market.id == self.market_id}
    end

  end
end
