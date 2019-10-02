require 'pry'
class Item
    attr_accessor :brand, :name, :link, :description, :starting_price, :stock, :condition

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

    def self.find_by_brand(searched_brand)
        self.all.select {|item| item.brand.downcase == searched_brand.downcase}
    end

    def self.find_by_name(searched_name)
        possible_matches = []
        self.all.each do |item|
            if item.name.downcase == searched_name.downcase
                possible_matches = [item]
                break
            elsif item.name.downcase.include?(searched_name.downcase)
                possible_matches << item
            end
        end
        possible_matches
    end

    def self.find_by_starting_price(price)
        matches = []
        self.all.each do |item|
            if item.starting_price == price
                matches << item
            end
        end
        matches
    end


    def display_info
        puts "\n"
        puts self.name
        puts "Brand: #{self.brand}"
        puts "-------------"
        if self.condition
            self.condition.each do |detail|
                if detail.length == 3
                    puts "Condition: #{detail[0]}  Shutter:#{detail[1]}  Price:#{detail[2]}"
                elsif detail.length == 2
                    puts "Condition: #{detail[0]}  Price:#{detail[1]}"
                end
            end
        end
        puts "\n"
        puts "Stock: #{self.stock}"
        puts "-------------"
        puts "\n"
        puts self.description
        puts "\n\n"
    end


end
