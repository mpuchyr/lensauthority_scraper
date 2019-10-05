require_relative 'scraper.rb'
require_relative 'item.rb'
require 'colorize'
require 'pry'

class CommandLineInterface
    attr_accessor :user_input

    PAGE_HTML = "https://www.lensauthority.com/t/camera-systems/special-deals"

    def run
        create_deal_items
        until @user_input == "exit" do
            main_menu
            @user_input = gets.chomp
            user_choice(@user_input)
        end
    end

    def user_choice(input)
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
                    get_specific_item_info_from_list(items)
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
                    get_specific_item_info_from_list(items)
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
                    get_specific_item_info_from_list(items)
                else
                    puts "Sorry, there are not items at that price."
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
        puts "Please choose the number of the action you'd like to take:".colorize(:light_blue)
        puts "Type 'exit' to quit.".colorize(:light_blue)
        puts "1.".colorize(:light_blue) + " List all products"
        puts "2.".colorize(:light_blue) + " Find product by name/keyword"
        puts "3.".colorize(:light_blue) + " Find products by brand"
        puts "4.".colorize(:light_blue) + " Find products by starting price (includes all items starting at a lower price)"
    end

    def display_all
        Item.all.each.with_index(1) do |item, index|
            puts "#{index.to_s.colorize(:green)}. #{item.name}"
        end
    end

    def display_specific_items(item_array)
        item_array.each.with_index(1) do |item, index|
            puts "#{index.to_s.colorize(:green)}. #{item.name}"
        end
    end

    def choose_item(index, item_array)
        item = item_array[index]
        add_details_to_item(item)
        item.display_info
    end

    def get_specific_item_info_from_list(items)
        display_specific_items(items)
        puts "Enter the number of the item you'd like to know more about:"
        @user_input = gets.chomp
        if @user_input != "exit"
            choose_item((@user_input.to_i - 1), items)
        end
    end


end

