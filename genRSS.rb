require 'rss'
require 'open-uri'
require 'net/http'
require 'json'
require 'nokogiri'
require 'time'

# todos
# catch private blogs


def genRSS(url)
    url = (url.length == 7 ? "https://artofproblemsolving.com/community/c" + url : url)
    # allows either https://artofproblemsolving.com/community/cXXXXXXX or XXXXXXX
    # todo should be more stict

    doc = Nokogiri::HTML(URI.open(url))
    data = doc.css("script")[1].to_s.split("AoPS.bootstrap_data = ")[1].to_s.split("AoPS.bd = AoPS.bootstrap_data;")[0].to_s[0..-4].to_s
    # I got errors w/o the .to_s -- if you know a better way to fix this please tell me

    parsed = JSON.parse(data.to_s)
    overview = parsed["blog_base"]
    rss = RSS::Maker.make("2.0") do |maker|
        maker.channel.title = overview["category_name"]
        maker.channel.description = overview["short_description"]
        maker.channel.link = "https://artofproblemsolving.com/community/c" + overview["category_id"].to_s
        maker.channel.author = overview["creator_username"]
        maker.image.url = "https:" + overview["creator_avatar"]  # todo not working, fix later
        maker.channel.generator = "https://github.com/Mehvix/aops-blog-rss"
        maker.channel.updated = Time.at(overview["shout_topic_data"]["last_update_time"]).rfc822.to_s  # given times are epoch, rss time is rfc822
        
        parsed["blog_topics"]["topics_data"].each do |post|  # todo change
        maker.items.new_item do |item|
            item.guid.content = post[0].to_s
            item.author = post[1]["username"]
            item.title = post[1]["topic_title"]
            item.content_encoded = post[1]["preview"] 
            item.date = Time.at(post[1]["posts_data"][0]["post_time"]).rfc822.to_s
            item.updated.content = Time.at(post[1]["last_update_time"]).rfc822.to_s
            item.link = "https://artofproblemsolving.com/community/c" + overview["category_id"].to_s + "h" + post[1]["topic_id"].to_s
            # todo why are there two different date types in output? does it matter?
            
            if post[1]["attachment"] == true
                item.image_item.resource = post[0].attachments[0]["href"]
            end
            # todo don't work!^
        end
    end
    end
    return rss.to_xml
end

# 'Testers'
# puts genRSS("https://artofproblemsolving.com/community/c1969146") # hansen
# puts genRSS("1969146") # hansen
# puts genRSS("https://artofproblemsolving.com/community/c1248416") # sanj
# puts genRSS("https://artofproblemsolving.com/community/c1082257") # ash
# puts genRSS("https://artofproblemsolving.com/community/c1273888") # dan
