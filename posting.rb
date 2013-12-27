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

puts "select a dictionary from the list below"

Dir::foreach('.') do |f|
  if File::ftype(f) == "file" && f.include?('.txt') then
    p f
  end
end

client = TweetStream::Client.new
s = File.read("#{gets.chop}", :encoding => Encoding::UTF_8)

client.userstream do |status|
  isreply = status.text.include?("@sa2mi")
  isrt = status.text.include?("RT")
  if isreply && !isrt then

    isStatement = true
    words = s.split("\n")
    begins=[]
    text = ''

    words.each do |word|
      sword = word.split
      if sword[0] == "beginpoint" then
   	    begins.push(word)
      end
      if !sword[sword.length-1] == "endpoint" then
        isStatement = false
      else
        isStatement = true
      end
    end

    rnum = rand(begins.length)
    first = begins[rnum].sub('beginpoint ','')
    text << first

    if isStatement then
      candidate=[]
      10.times do
        words.each do |word|
        stext=text.split
        endword = stext[stext.length-1]
        if word.split[0] == endword then
          candidate.push(word.sub(endword,''))
        end
      end

      while true do
        rnum = rand(candidate.length)
        addword = candidate[rnum]
        stext = text.split
        if addword == stext[stext.length-1] then
          addword = candidate[rnum]
        else
          break
        end
      end

      text << candidate[rnum]
      stext = text.split
      p stext[stext.length-1]
      if stext[stext.length-1] == "endpoint" then
        break
      end
    end

    text = text.gsub(' endpoint','')
    text = text.gsub(' ','')
    text = text.gsub('@','')
    puts text
    text = "@#{status.user.screen_name} #{text}"
    option = {"in_reply_to_status_id"=>status.id.to_s}
    Twitter.update text,option
  end             #このend絶対いらないと思うんだけどないとエラー出る死ね
  end
end
