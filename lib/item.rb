require 'colorize'
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
        search_terms = searched_name.downcase.split(" ")
        self.all.each do |item|
            if item.name.downcase == searched_name.downcase
                possible_matches = [item]
                break
            else
                search_terms.each do |term|
                    self.all.each do |item|
                        if item.name.downcase.include?(term)
                            if !possible_matches.include?(item)
                                possible_matches << item
                            end
                        end
                    end
                end
            end
        end
        possible_matches
    end

    def self.find_by_starting_price(price)
        matches = []
        self.all.each do |item|
            if item.starting_price <= price
                matches << item
            end
        end
        matches
    end


    def display_info
        puts "\n"
        puts self.name.colorize(:light_blue)
        puts "-------------"
        puts "Brand:" + " #{self.brand}".colorize(:light_blue)
        puts "\n"
        if self.condition
            self.condition.each do |detail|
                if detail.length == 3
                    puts "Condition: #{detail[0].colorize(:yellow)}  Shutter: #{detail[1].colorize(:yellow)}  Price: #{detail[2].colorize(:yellow)}"
                elsif detail.length == 2
                    puts "Condition: #{detail[0].colorize(:yellow)}  Price: #{detail[1].colorize(:yellow)}"
                end
            end
        end
        puts "\n"
        if self.stock == "Out of Stock"
            puts "Stock:" + " #{self.stock}".colorize(:red)
        else
            puts "Stock:" + " #{self.stock}".colorize(:green)
        end
        puts "-------------"
        puts "\n"
        puts self.description
        puts "\n\n"
    end


end
