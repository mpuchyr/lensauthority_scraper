require_relative 'scraper.rb'
require_relative 'item.rb'
require 'pry'

class CommandLineInterface
    attr_accessor :user_input

    PAGE_HTML = "https://www.lensauthority.com/t/camera-systems/special-deals"

    def run
        create_deal_items
        until @user_input == "exit" do
            main_menu
            @user_input = gets.chomp

            case @user_input
            when "1"
                display_all
                puts "Enter the number of the item you'd like to know more about:"
                @user_input = gets.chomp
                if @user_input != "exit"
                    choose_item((@user_input.to_i - 1), Item.all)
                end

            when "2"
                puts "Enter the product name:"
                @user_input = gets.chomp
                if @user_input != "exit"
                items = Item.find_by_name(@user_input)
                    if items != []
                        if items.length > 1
                            puts "Here are some possible matches of what you're looking for."
                        end
                        display_specific_items(items)
                        puts "Enter the number of the item you'd like to know more about:"
                        @user_input = gets.chomp
                        if @user_input != "exit"
                            choose_item((@user_input.to_i - 1), items)
                        end
                    else
                        puts "Sorry, there are no items by that name."
                    end
                end
            when "3"
                puts "Enter the brand you're looking for:"
                @user_input = gets.chomp
                if @user_input != "exit"
                    items = Item.find_by_brand(@user_input)
                    if items != []
                        display_specific_items(items)
                        puts "Enter the number of the item you'd like to know more about:"
                        @user_input = gets.chomp
                        if @user_input != "exit"
                            choose_item((@user_input.to_i - 1), items)
                        end
                    else
                        puts "Sorry, there are no items from that brand."
                    end
                end
            when "4"
                puts "Enter the price you're looking for:"
                @user_input = gets.chomp
                if @user_input != "exit"
                    user_price = @user_input.to_i
                    items = Item.find_by_starting_price(user_price)
                    if items != []
                        display_specific_items(items)
                        puts "Enter the number of the item you'd like to know more about:"
                        @user_input = gets.chomp
                        choose_item((@user_input.to_i - 1), items)
                    else
                        puts "Sorry, there are not items at that price."
                    end
                end
            end
        end
    end

    def create_deal_items
        all_deals = Scraper.scrape_special_deals(PAGE_HTML)
        all_deals.each do |deal|
            Item.new(deal)
        end        
    end

    def add_details_to_item(item)
        if !item.description
            details_hash = Scraper.scrape_details_page(item.link)
            item.add_more_details(details_hash)
        end
    end

    def main_menu
        puts "Please choose the number of the action you'd like to take:"
        puts "Type 'exit' to quit."
        puts "1. List all products"
        puts "2. Find specific product"
        puts "3. Find products by brand"
        puts "4. Find products by starting price"
    end

    def display_all
        Item.all.each.with_index(1) do |item, index|
            puts "#{index}. #{item.name}"
        end
    end

    def display_specific_items(item_array)
        item_array.each.with_index(1) do |item, index|
            puts "#{index}. #{item.name}"
        end
    end

    def choose_item(index, item_array)
        item = item_array[index]
        add_details_to_item(item)
        item.display_info
    end


end

