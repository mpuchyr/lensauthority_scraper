require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

    MAIN_HTML = "https://www.lensauthority.com"

    def self.scrape_special_deals(url)
        item_details = []
        doc = Nokogiri::HTML(open(url))
        items = doc.css(".product-list-item")
        items.each do |item|
            brand = item.css(".caption h5").text.split(" ")[0]
            name = item.css(".caption h5").text.split("Out of Stock")[0].strip
            link = item.css(".caption h5 a").attribute("href").text
            starting_price = item.css(".caption h4").text.strip
            starting_price = starting_price.split("$")[1].split(",").join("").to_i
            item_details << {:brand => brand, :name => name, :link => link, :starting_price => starting_price}
        end
        item_details
    end

    def self.scrape_details_page(product_link)
        html = MAIN_HTML + product_link
        doc = Nokogiri::HTML(open(html))
        descriptions = doc.css(".tab-content .tab-pane")

        # splits up item description to only include description, not purveyor opinion or warranty info
        text_match = descriptions[1].text.match(/[a-zA-Z\S]+ Take/).to_s
        if text_match != ""
            item_description = descriptions[1].text.split(text_match)[0].strip
        else
            item_description = descriptions[1].text.split("Are we out of stock")[0].strip
        end

        # populates stats based on whether or not item is in stock
        if doc.css(".row .label").text != "Out of Stock"
            all_conditions = []
            prices_conditions = doc.css(".table tr label").text
            prices_conditions = prices_conditions.split("\n")
            until prices_conditions == [] do
                condition = prices_conditions.shift
                condition = condition.split("Shutter: ")
                condition << prices_conditions.shift
                all_conditions << condition
            end
            stock = doc.css("#product-variants h4").text.strip
            item_details = {:description => item_description, :stock => stock, :condition => all_conditions}
        else
            stock = doc.css(".row .label").text
            item_details = {:description => item_description, :stock => stock}
        end
        item_details
    end


end

