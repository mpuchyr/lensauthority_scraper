require_relative 'scraper.rb'
require_relative 'item.rb'
require 'pry'

class CommandLineInterface

    PAGE_HTML = "https://www.lensauthority.com/t/camera-systems/special-deals"

    def run
        create_deal_items
        add_details_to_items
        binding.pry
    end

    def create_deal_items
        all_deals = Scraper.scrape_special_deals(PAGE_HTML)
        all_deals.each do |deal|
            Item.new(deal)
        end        
    end

    def add_details_to_items
        Item.all.each do |item|
            details_hash = Scraper.scrape_details_page(item.link)
            item.add_more_details(details_hash)
        end
    end

    def menu
        puts "Please choose the number of the action you'd like to take:"
        puts "1. List all products"
        puts "2. Find specific product"
        puts "3. Find products by brand"
        puts "4. Find products by In Stock"
        puts "5. Find productions by condition"
        puts "5. Exit"
    end

end

cli = CommandLineInterface.new
cli.menu



