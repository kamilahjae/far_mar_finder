module FarMar
  class Product
    attr_accessor :id, :name, :vendor_id

    def initialize(product_array)
      @id = product_array[0].to_i
      @name = product_array[1]
      @vendor_id = product_array[2].to_i
    end

    def self.all
      CSV.open("./support/products.csv", "r") do |file|
        file.collect do |product|
          FarMar::Product.new(product)
        end
      end
    end
  end
end
