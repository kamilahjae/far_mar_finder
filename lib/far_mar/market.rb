module FarMar
  class Market
    def self.all
      @market_array = CSV.open("./support/markets.csv", "r")
    end

    # Goal: return the row where the ID field matches the argument
    def self.find(id)
      # 1 Feeds in ID as parameter
      # 2 Match the given ID with the Market's ID
      row_id = @market_array.find {|row| row[0] == id }
      # Row is returned implicitly
    end

    def vendors(id)
      @vendor_array = CSV.open("./support/vendors.csv", "r")
      market_id = @vendor_array
    end

  end
end
