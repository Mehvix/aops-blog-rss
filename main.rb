require "sinatra/base"
require "nokogiri"
require "redis"

# todos
# catch private blogs
# feed colors + favicon
# prevent hibernation

class Main < Sinatra::Base
    configure do
        # set :port, 1234
        set :public_folder, __dir__ + '/public'
        set :server, "puma"
        # set :static, true
        # set :static_cache_control, [:public, :max_age => 3600]
    end

    def initialize
        super
        $redis = Redis.new(url: ENV["REDISTOGO_URL"])
    end

    get "/" do
        return File.read(File.join("public", "index.html"))
    end

    get "/:blog_id" do
        blog_id = params["blog_id"] #|| ENV["BLOG_ID"]
        return "Invalid Blog ID (should be seven digits!)" unless blog_id.match(/^\d{7}$/)

        value = $redis.get("blogs:#{blog_id}")
        if value.nil?
            value = Nokogiri::HTML(URI.open("https://artofproblemsolving.com/community/c"+blog_id)).css("script")[1].to_s.split("AoPS.bootstrap_data = ")[1].split("AoPS.bd = AoPS.bootstrap_data;")[0][0..-4].to_s
            $redis.set("blogs:#{blog_id}", value)
            $redis.expire("blogs:#{blog_id}", 3600)  # 30 min
        end

        # todo error catching here

        # parsed = JSON.parse(data)
        parsed = JSON.parse(value)
        overview = parsed["blog_base"]

        content_type "application/rss+xml; charset=utf-8"
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
                item.updated = Time.at(post[1]["last_update_time"]).rfc822.to_s
                item.link = "https://artofproblemsolving.com/community/c" + overview["category_id"].to_s + "h" + post[1]["topic_id"].to_s
                
                if post[1]["attachment"]
                    item.image_item.resource = post[0].attachments[0]["href"]
                end
                # todo this don't work!^
            end
        end
        end.to_xml
    end
    
    # run! if app_file == $0 # start the server if ruby file executed directly
    # don't run directly; instead, do `rackup config.ru`
end

# 'Testers'
# puts genRSS("https://artofproblemsolving.com/community/c1969146") # hansen
# puts genRSS("1969146") # hansen
# puts genRSS("https://artofproblemsolving.com/community/c1248416") # sanj
# puts genRSS("https://artofproblemsolving.com/community/c1082257") # ash
# puts genRSS("https://artofproblemsolving.com/community/c1273888") # dan
