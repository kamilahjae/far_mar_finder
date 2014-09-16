module FarMar
  class Vendor
    attr_accessor :id, :name, :no_of_employees, :market_id

    def initialize(vendor_array)
      @id = vendor_array[0].to_i
      @name = vendor_array[1]
      @no_of_employees = vendor_array[2].to_i
      @market_id = vendor_array[3].to_i
    end

    def self.all
      CSV.open("./support/vendors.csv", "r") do |file|
        file.collect do |vendor|
          FarMar::Vendor.new(vendor)
        end
      end
    end

    def self.find(desired_id)
      all.find {|vendor| vendor.id == desired_id}
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

    # Return a collection of product instances associated w/market
    # by product's vendor_id field
    def products
      all_products = FarMar::Product.all
      all_products.find_all {|product| product.vendor_id == self.id}
    end
    # returns a collection of Sale instances
    # by the vendor_id field.
    def sales
      all_sales = FarMar::Sale.all
      all_sales.find_all {|sale| sale.vendor_id == self.id}
    end

    # Return the sum of all of vendor's sales in cents
    def revenue
      final_total = 0
      sales.each do |sale|
        final_total += sale.amount
      end
      return final_total
    end
  end
end
