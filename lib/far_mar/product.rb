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

    def self.find(desired_id)
      all.find {|product| product.id == desired_id}
    end

    def self.by_vendor(vendor_id)
      all.find_all {|product| product.vendor_id == vendor_id}
    end
    # vendor - returns the Vendor instance that is associated with this vendor
    # using the Product vendor_id field
    def vendor
      all_vendors = FarMar::Vendor.all
      all_vendors.find {|vendor| vendor.id == self.vendor_id}
    end
    # goal: return collection of sale instances, using the Sale product_id field.
    def sales
      all_sales = FarMar::Sale.all
      all_sales.find_all {|sale| sale.product_id == self.id}
    end

    # Next we will need to write the number_of_sales function.

  end
end
