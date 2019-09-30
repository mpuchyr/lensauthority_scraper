class Item
    attr_accessor :brand, :name, :link, :description, :price, :stock, :condition

    @@all = []

    def initialize(item_hash)
        item_hash.each do |key, value|
            self.send("#{key}=", value)
        end
        @@all << self
    end

    def self.all
        @@all
    end

    def add_more_details(details_hash)
        details_hash.each do |d_key, d_value|
            self.send("#{d_key}=", d_value)
        end  
    end

end