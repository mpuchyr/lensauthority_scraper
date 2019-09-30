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
            item_details << {:brand => brand, :name => name, :link => link}
        end
        item_details
    end

    def self.scrape_details_page(product_link)
        html = MAIN_HTML + product_link
        doc = Nokogiri::HTML(open(html))
        descriptions = doc.css(".tab-content .tab-pane")

        text_match = descriptions[1].text.match(/[a-zA-Z\S]+ Take/).to_s
        if text_match != ""
            item_description = descriptions[1].text.split(text_match)[0].strip
        else
            item_description = descriptions[1].text.split("Are we out of stock")[0].strip
        end


        if doc.css(".row .label").text != "Out of Stock"
            price = doc.css("#display-price").text.strip
            stock = doc.css("#product-variants h4").text.strip
            condition = doc.css("table td")[1].text.strip
            item_details = {:description => item_description, :stock => stock, :condition => condition, :price => price}
        else
            stock = doc.css(".row .label").text
            item_details = {:description => item_description, :stock => stock}
        end
        item_details
    end


end



