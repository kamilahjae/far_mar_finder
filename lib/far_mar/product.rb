module FarMar
  class Product
    attr_accessor :id, :name, :vendor_id

    def initialize(product_array)
      @id        = product_array[0].to_i
      @name      = product_array[1]
      @vendor_id = product_array[2].to_i
    end

    def self.all
      @all_products ||= CSV.open("./support/products.csv", "r") do |file|
        file.collect do |product|
          FarMar::Product.new(product)
        end
      end
    end

    def self.find(desired_id)
      all.find { |product| product.id == desired_id }
    end

    def self.by_vendor(vendor_id)
      all.find_all { |product| product.vendor_id == vendor_id }
    end

    # Returns the Vendor instance that is associated with this vendor
    # using the Product vendor_id field
    def vendor
      FarMar::Vendor.all.find { |vendor| vendor.id == vendor_id }
    end

    # Returns collection of sale instances, using the Sale product_id field.
    def sales
      FarMar::Sale.all.find_all { |sale| sale.product_id == id }
    end

    # Returns the number of times a particular product has been sold.
    def number_of_sales
      sales.count
    end
  end
end
