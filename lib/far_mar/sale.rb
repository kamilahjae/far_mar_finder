module FarMar
  class Sale
    attr_accessor :id, :amount, :purchase_time, :vendor_id, :product_id

    def initialize(sale_array)
      @id             = sale_array[0].to_i
      @amount         = sale_array[1].to_i
      @purchase_time  = DateTime.parse(sale_array[2])
      @vendor_id      = sale_array[3].to_i
      @product_id     = sale_array[4].to_i
    end

    def self.all
      @all_sales ||= CSV.open("./support/sales.csv", "r") do |file|
        file.collect do |sale|
          FarMar::Sale.new(sale)
        end
      end
    end

    # Returns the row where the id matches the argument
    def self.find(desired_id)
      all.find { |sale| sale.id == desired_id }
    end

    # Returns the vendor instance associated with sale, using the sale's vendor
    # id field
    def vendor
      FarMar::Vendor.all.find { |vendor| vendor.id == vendor_id }
    end

    # Returns a collection of sales objects where the purchase time is btw the
    # two times given as arguments
    def self.between(beginning_time, end_time)
      all.find_all do |sale|
        sale.purchase_time.between?(beginning_time, end_time)
      end
    end

    # Returns the Product instance that is associated with the sale using the
    # Sale product_id field
    def product
      FarMar::Product.all.find { |product| product.id == product_id }
    end
  end
end
