# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require './key.rb'

Twitter.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token            = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
end
TweetStream.configure do |config|
   config.consumer_key        = Const::CONSUMER_KEY
   config.consumer_secret     = Const::CONSUMER_SECRET
   config.oauth_token            = Const::ACCESS_TOKEN
   config.oauth_token_secret  = Const::ACCESS_TOKEN_SECRET
   config.auth_method            = :oauth
end

client = TweetStream::Client.new
s = File.read("new_dictionary.txt", :encoding => Encoding::UTF_8)
words = s.split("\n")
Twitter.update_profile(:name => "ささみbot(日本語モード)")
puts "ready to streaming"

client.userstream do |status|
  
  if status.text.include?("@sa2mi") && !status.text.include?("RT") then
    puts status.text

    begins=[]
    text = ''
    isStatement = true

    words.each do |word| #最初の一文節の候補を選ぶ
      sword = word.split
      begins.push(word) if sword[0] == "beginpoint"
    end

    rnum = rand(begins.length)
    first = begins[rnum].sub('beginpoint ','') #最初の一文節を候補の中から乱数で決定
    text << first #なんかこう書くと速いらしい
    isStatement = false if text.reverse[0..7] == "endpoint".reverse

p text
    puts isStatement


    if isStatement
      puts isStatement
      candidate = []
      10.times do
        words.each do |word|
          stext=text.split
          endword = stext[stext.length-1]
          candidate.push(word.sub(endword,'')) if word.split[0] == endword
        end

        p "2nd"
        p candidate

        break if candidate.length == 0
        rnum = rand(candidate.length)
        addword = candidate[rnum]
        stext = text.split

     p "3rd"
        text << addword
        break if text.split[stext.length-1] == "endpoint"
      end
    end

    text.gsub!(" endpoint","")
    text.gsub!(" ","")
    text.gsub!("@","")
p "4"

    emotions = ''
    case status.text[-1]
      when "！","!"
        emotions << "！"
      when "ｗ","w"
        emotions << "ｗ"
      when "な","ね"
        emotions << "。"
      when "。","…","."
        emotions << "..."
      when "？","?"
        text.gsub!("？","")
    end
    text << emotions

p "5"
    puts text
    text = "@#{status.user.screen_name} #{text}"
    option = {"in_reply_to_status_id"=>status.id.to_s}
    Twitter.update text,option
  end
end
