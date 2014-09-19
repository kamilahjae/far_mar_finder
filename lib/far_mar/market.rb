require_relative 'vendor'

module FarMar
  class Market
    attr_accessor :id, :name, :address, :city, :county, :state, :zip

    def initialize(market_array_from_all)
      @id = market_array_from_all[0].to_i
      @name = market_array_from_all[1]
      @address = market_array_from_all[2]
      @city = market_array_from_all[3]
      @county = market_array_from_all[4]
      @state = market_array_from_all[5]
      @zip = market_array_from_all[6]
    end

    # Create 500 market objects
    def self.all
      @all_markets ||= CSV.open("./support/markets.csv", "r") do |file|
        file.collect do |market|
          FarMar::Market.new(market)
        end
      end
    end

    # Return the row where the ID field matches the argument
    def self.find(desired_id)
      all.find { |market| market.id == desired_id }
    end

    # Return collection of vendor objects associated with given market id
    def vendors
      all_vendors = FarMar::Vendor.all
      # self here refers to the encompassing scope, an instance of a market
      all_vendors.find_all { |vendor| vendor.market_id == id }
    end

    # Return a collection of product instances associated with the market
    # through the Vendor class
    def products
      vendors.collect { |vendor| vendor.products }
    end

    # Return a collection of market instances where market OR vendor
    # name contain the search term
    def self.search(search_term)
      all_names = []

      all.each do |market|
        all_names << market.name
        all_vendors = market.vendors
        all_vendors.each { |vendor| all_names << vendor.name }
      end
      all_names.find_all do |name|
        name.downcase.strip.include? search_term.downcase.strip
      end
    end

    # Return the vendor with the highest revenue, for a particular market.
    def preferred_vendor_comparison(vendor_array)
      top_vendor = nil
      top_revenue = 0
      vendor_array.each do |vendor|
        if vendor.revenue > top_revenue
          top_revenue = vendor.revenue
          top_vendor = vendor
        end
      end
      top_vendor
    end

    # Returns all sales on a given day, grouped by vendor
    def sales_per_day(date)
      puts "The value of date in separate function is #{ date }"
      vendors.collect do |vendor|
        vendor.sales.find_all { |sale| sale.purchase_time.to_s.include? date }
      end
    end

    # Calculates the revenue of each vendor and pushes to a hash
    def calculate_revenue(date)
      @hash_vend_rev = {}
      sales_per_day(date).each do |vendor_sales_subset|
        vendor_revenue = 0
        vendor_sales_subset.collect do |sale_object|
          vendor_revenue += sale_object.amount
          @hash_vend_rev[sale_object.vendor] = vendor_revenue
        end
      end
    end

    # Finds max revenue from hash and returns vendor object associated with it
    def max_revenue
      max_hash = @hash_vend_rev.max_by { |_vendor, revenue| revenue }
      max_hash[0]
    end

    # Returns vendor with highest revenue overall or for a given date.
    def preferred_vendor(year = nil, month = nil, day = nil)
      if year.nil? && month.nil? && day.nil?
        preferred_vendor_comparison(vendors)
      else
        date = DateTime.new(year, month, day)
        date = date.to_s[0..9]

        calculate_revenue(date)
        max_revenue
      end
    end

    # Returns the vendor with the highest revenue for a particular market
    def worst_vendor_comparison(vendor_array)
      worst_vendor = nil
      top_revenue = 100_000_000 # chose arbitrarily high number

      vendor_array.each do |vendor|
        if vendor.revenue < top_revenue
          top_revenue = vendor.revenue
          worst_vendor = vendor
        end
      end
      worst_vendor
    end

    # Returns worst vendor object from hash
    def min_revenue
      min_hash = @hash_vend_rev.min_by { |_vendor, revenue| revenue }
      min_hash[0]
    end

    # Returns worst performing vendor overall or on specific day
    def worst_vendor(year = nil, month = nil, day = nil)
      if year.nil? && month.nil? && day.nil?
        worst_vendor_comparison(vendors)
      else
        date = DateTime.new(year, month, day)
        date = date.to_s[0..9]

        calculate_revenue(date)
        min_revenue
      end
    end
  end
end
