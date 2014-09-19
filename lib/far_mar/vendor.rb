module FarMar
  class Vendor
    attr_accessor :id, :name, :no_of_employees, :market_id

    def initialize(vendor_array)
      @id               = vendor_array[0].to_i
      @name             = vendor_array[1]
      @no_of_employees  = vendor_array[2].to_i
      @market_id        = vendor_array[3].to_i
    end

    def self.all
      @all_vendors ||= CSV.open("./support/vendors.csv", "r") do |file|
        file.collect do |vendor|
          FarMar::Vendor.new(vendor)
        end
      end
    end

    def self.find(desired_id)
      all.find { |vendor| vendor.id == desired_id }
    end

    # Returns all of the vendors with the given market id
    def self.by_market(market_id)
      FarMar::Vendor.all.find_all { |vendor| vendor.market_id == market_id }
    end

    # Returns the Market instance associated with this vendor using the
    # vendor market_id field
    def market
      FarMar::Market.all.find { |market| market.id == market_id }
    end

    # Returns a collection of product instances associated w/market
    # by product's vendor_id field
    def products
      FarMar::Product.all.find_all { |product| product.vendor_id == id }
    end

    # Returns a collection of Sale instances by the vendor_id field.
    def sales
      FarMar::Sale.all.find_all { |sale| sale.vendor_id == id }
    end

    # Returns the sum of all of vendor's sales in cents
    def revenue
      final_total = 0
      sales.each do |sale|
        final_total += sale.amount
      end
      final_total
    end
  end
end
