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

    # Goal: create 500 market objects
    def self.all
      CSV.open("./support/markets.csv", "r") do |file|
        file.collect do |market|
          FarMar::Market.new(market)
        end
      end
    end

    # Goal: return the row where the ID field matches the argument
    def self.find(desired_id)
      all.find {|market| market.id == desired_id}
    end

    # Goal: return collection of vendor objects associated with given market id
    def vendors
      all_vendors = FarMar::Vendor.all
      # self here refers to the encompassing scope, an instance of a market
      all_vendors.find_all {|vendor| vendor.market_id == self.id}
    end

    # Goal: return a collection of product instances associated with the market
    # through the Vendor class
    def products
      vendors.collect {|vendor| vendor.products}
    end

    # Goal: Return a collection of market instances where market OR vendor
    # name contain the search term
    def self.search(search_term)
      all_names = []

      all.each do |market|
        all_names << market.name
        all_vendors = market.vendors
        all_vendors.each do |vendor|
          all_names << vendor.name
        end
      end
      all_names.find_all {|name| name.downcase.strip.include? search_term.downcase.strip}
    end

    # Goal: Return the vendor with the highest revenue, for a particular market.
    def preferred_vendor_comparison(vendor_array)
      top_vendor = nil
      top_revenue = 0
      vendor_array.each do |vendor|
        if vendor.revenue > top_revenue
          top_revenue = vendor.revenue
          top_vendor = vendor
        end
      end
      return top_vendor
    end

    # Goal: returns vendor with highest revenue for a given date.
    def preferred_vendor(year=nil, month=nil, day=nil)
      if year == nil && month == nil && day == nil
        preferred_vendor_comparison(vendors)
      else
        date = DateTime.new(year,month,day)
        date = date.to_s[0..9]

        # returns all sales on a given day.
        sales_per_day = vendors.collect do |vendor|
          vendor.sales.find_all { |sale| sale.purchase_time.to_s.include? date}
        end

        hash_vend_rev = {}
        # calculates the revenue of each vendor
        sales_per_day.each do |vendor_sales_subset|
          vendor_revenue = 0
          vendor_sales_subset.collect do |sale_object|
            vendor_revenue += sale_object.amount
            hash_vend_rev[sale_object.vendor] = vendor_revenue
          end
        end
        puts "hash of vendors and the incrementing revenue #{hash_vend_rev}"

        max_hash = hash_vend_rev.max_by {|vendor,revenue| revenue}
        puts "This should be a vendor object #{max_hash[0]}"
        max_hash[0]

        # Take all sales from each vendor collect individual sale objects
        # individual_sales = all_sales_from_vendors.flatten

        # # Need date of sales to equal user's desired date
        # sales_on_date = individual_sales.find_all {|sale| sale.purchase_time.to_s.include? date}
        # puts "this is sales on date #{sales_on_date}

        # # hash separates sales by vendor ID on a particular day
        # vendor_hash = sales_on_date.group_by {|sale| sale.vendor_id}
        # puts "this is the vendor hash #{vendor_hash}"

        # Sum the sale amount for each vendor
        # vendor_hash.each do |id, sale_objects|
        #   puts "This is the id #{id}"
        #   puts "This sould be an array of sale_obejcts #{sale_objects}"
        #   each_id_total = 0
        #   sale_objects.each do |sale|
        #     puts "#{sale.amount}"
        #     each_id_total += sale.amount
        #     puts "This is the total #{each_id_total}"
        #   end
        # end

          # sale_objects
          # sale_objects.collect do |sale|
          #   puts "this is the individual sale object #{sale}"
          #   return sale
          # end


        # # Need vendor objects associatd with each of these sales
        # vendors_on_date = sales_on_date.collect {|sale| sale.vendor}
        #
        # # Perform revenue on vendors to get totals for their sales, and return top vendor
        # preferred_vendor_comparison(vendors_on_date)
      end
    end

    # Goal: Return the vendor with the highest revenue for a particular market
    def worst_vendor_comparison(vendor_array)
      worst_vendor = nil
      top_revenue = 100000000 # chose arbitrarily high number

      vendor_array.each do |vendor|
        if vendor.revenue < top_revenue
          worst_vendor = vendor
        end
      end
      return worst_vendor
    end

    def worst_vendor(year = nil, month = nil, day = nil)
      if year == nil && month == nil && day == nil
        worst_vendor_comparison(vendors)
      else
        date = DateTime.new(year,month,day)
        date = date.to_s[0..9]

        # Find all vendor's sales and isolate sales by date
        all_sales_from_vendors = vendors.collect {|vendor| vendor.sales}

        # Take all sales from each vendor collect individual sale objects
        individual_sales = all_sales_from_vendors.flatten

        # Need date of sales to equal user's desired date
        sales_on_date = individual_sales.find_all {|sale| sale.purchase_time.to_s.include? date}

        # Need vendor objects associatd with each of these sales
        vendors_on_date = sales_on_date.collect {|sale| sale.vendor}

        # Perform revenue on vendors to get totals for their sales, and return top vendor
        worst_vendor_comparison(vendors_on_date)
      end
    end
  end
end
