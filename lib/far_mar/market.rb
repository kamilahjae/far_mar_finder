module FarMar
  class Market
    attr_accessor :id, :name, :address, :city, :county, :state, :zip

    def initialize(market_array_from_all)
      puts "the value of market_array_from_all[0] is #{market_array_from_all[0]}"
      @id = market_array_from_all[0],
      @name = market_array_from_all[1],
      @address = market_array_from_all[2],
      @city = market_array_from_all[3],
      @county = market_array_from_all[4],
      @state = market_array_from_all[5],
      @zip = market_array_from_all[6]
      puts "The value of @id in initialize is #{@id}"
    end

    # Goal: create 500 market objects
    def self.all
      CSV.open("./support/markets.csv", "r") do |file|
        file.collect do |market|
          #puts "This is value of market in .all #{market}"
          FarMar::Market.new(market)
        end
      end
    end

    # Goal: return the row where the ID field matches the argument
    # Is it going to be a problem that our method is called find,
    # Just like the .find method?
    def self.find(desired_id)
      all.find {|market| market.id == desired_id}
    end

    # Goal: return collection of vendors associated with given market id
    def vendors(id)
      @vendor_array = CSV.open("./support/vendors.csv", "r")
      market_id = @vendor_array
    end

  end
end
