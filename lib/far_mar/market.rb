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
      # self here refers to the encompassing scope,
      # which in this case is an instance of a market, and we know
      # because it is an instance method.
      all_vendors.find_all {|vendor| vendor.market_id == self.id}
    end

    # Goal: to return a collection of product instances associated with the market
    # through the Vendor class
    def products
      vendors.collect do |vendor|
        vendor.products
      end
    end

    # Goal: Return a collection of market instances
    # where market name OR vendor name contain the search term
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
    def preferred_vendor_single
      top_vendor = nil
      top_revenue = 0

      vendors.each do |vendor|
        if vendor.revenue > top_revenue
          top_vendor = vendor
        end
      end
      return top_vendor
    end

    # Goal: returns vendor with highest revenue for a given date.
    # input date in format year, month day
    def preferred_vendor(year,month,day)
      date = DateTime.new(year,month,day)
      date = date.to_s[0..9]
      #puts "this is the user's date in DateTime #{date}"

      # Step 2. Find all vendor's sales and isolate sales by date
      all_sales_from_each_vendor = vendors.collect {|vendor| vendor.sales}

      # Take all sales from each vendor collect individual sale objects
      individual_sales = all_sales_from_each_vendor.collect {|sale| sale}
      puts "These are the individual sales #{individual_sales}"
      #all_sales_from_vendor.each {|sale| }
      #sales_from_date = sales_from_vendors.find_all {|sale| sale.purchase_time.to_s.include? date }
      #puts "These are the sales from a given date #{sales_from_date}"


      # Step 3: Calculate each vendor's sale

      # Step 5: Get the top sale

      # Step 6: Return vendor from top sale

      # all_sales = FarMar::Sale.all
      # sales_on_date = all_sales.find_all {|sale| sale.purchase_time.to_s.include? date.to_s }
      # who_is_selling = sales_on_date.collect {|sale| sale.vendor}
      # days_vends_rev = who_is_selling.collect {|vend| vend.revenue}
      # puts "This is a vendors revenue #{days_vends_rev.first(5)}"
    end

    # Goal: Return the vendor with the highest revenue, for a particular market???
    def worst_vendor
      worst_vendor = nil
      top_revenue = 100000000 # chose arbitrarily high number

      vendors.each do |vendor|
        if vendor.revenue < top_revenue
          worst_vendor = vendor
        end
      end
      puts worst_vendor
      return worst_vendor # Code returns values when this is commented out
    end
  end
end
