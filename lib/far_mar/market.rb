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

    # Goal is to return a collection of product instances associated with the market
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

    # Goal: Return the vendor with the highest revenue, for a particular market???
    # THIS IS BROKEN
    def preferred_vendor
      top_vendor = nil
      top_revenue = 0

      if vendor_revenue > top_revenue
      end


      # revenue_collection = []
      # vendors.collect do |vendor|
      #   revenue_collection << vendor.revenue
      #   if revenue_collection.max
      #     return vendor
      #   end
      # end
       #revenue_collection.max
    end


    # def worst_vendor
    #   revenue_collection = []
    #   vendors.collect do |vendor|
    #     revenue_collection << vendor.revenue
    #   revenue_collection.min
    #   end
    #end
  end
end
