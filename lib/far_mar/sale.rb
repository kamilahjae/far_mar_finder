module FarMar
  class Sale
    attr_accessor :id, :amount, :purchase_time, :vendor_id, :product_id

    def initialize(sale_array)
      @id = sale_array[0]
      @amount = sale_array[1]
      @purchase_time = sale_array[2]
      @vendor_id = sale_array[3]
      @product_id = sale_array[4]
    end

    def self.all
       CSV.open("./support/sales.csv", "r") do |file|
        file.collect do |sale|
          FarMar::Sale.new(sale)
        end
      end
    end
    
  end
end
