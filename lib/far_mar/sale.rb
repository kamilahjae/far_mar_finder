module FarMar
  class Sale
    attr_accessor :id, :amount, :purchase_time, :vendor_id, :product_id

    def initialize(sale_array)
      @id = sale_array[0].to_i
      @amount = sale_array[1].to_i
      @purchase_time = DateTime.parse(sale_array[2])
      @vendor_id = sale_array[3].to_i
      @product_id = sale_array[4].to_i
      #@day = sale_array[2][8,2] #we could have used this as a method.
    end

    def self.all
       CSV.open("./support/sales.csv", "r") do |file|
        file.collect do |sale|
          FarMar::Sale.new(sale)
        end
      end
    end

    # Return the row where the id matches the argument
    def self.find(desired_id)
      all.find {|sale| sale.id == desired_id}
    end

    # Return the vendor instance associated with sale, using the sale's vendor
    # id field
    def vendor
      all_vendors = FarMar::Vendor.all
      all_vendors.find {|vendor| vendor.id == self.vendor_id}
    end

    # Return a collection of sales objects where the purchase time is btw the
    # two times given as arguments

    def self.between(beginning_time, end_time)
      #all.find_all {|sale| sale.purchase_time.between?(DateTime.parse(beginning_time), DateTime.parse(end_time))}
      all.find_all do |sale|
        sale.purchase_time.between?(beginning_time, end_time)
      end

    end

  end
end
