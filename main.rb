# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require 'bimyou_segmenter'
require 'natto'
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

client.userstream do |status|
if status.text.include?("@sa2mi") && !status.text.include?("RT") then
nouns=[]
input = status.text.sub("@sa2mi ","")
nm = Natto::MeCab.new
nm.parse(input) do |n|
  type = n.feature.split(",")[0]
  if type == "名詞"
    nouns.push(n.surface)
  end
end
c = []
Twitter.search("#{nouns[0]}", :count => 50, :result_type => "latest").results.map do |status|
  next if status.text.include?("RT") or status.text.include?("http") or status.text.include?(".co") or status.text.include?("@")
  c.push("#{status.text.gsub("\n","")}")
end
print c
dictionary=[]
c.each do |cc|
  text=BimyouSegmenter.segment(cc)
  p text
  p text.length
  text.push("endpoint")
  p text
  p text.length
    if text.length == 5 
      deathflag = true
    end
  if !deathflag
    n=0
    counter = 0
    inputs = []

    while true do
      breakflag = false
      if n == 0 then
        inputs[counter] = "beginpoint #{text[n]} #{text[n+1]} #{text[n+2]} #{text[n+3]}"
        n+=2
      elsif n+2>=text.length+1 then
        breakflag = true
      else
        inputs[counter] = "#{text[n]} #{text[n+1]} #{text[n+2]} #{text[n+3]} #{text[n+4]}"
        n+=1
      end
      break if breakflag
      counter+=1
    end
    p inputs
    inc = inputs.include?("endpoint")

    inputs.each do|input|
      if !inc
        dictionary.push("#{input}")
      else
        dictionary.push("#{input} endpoint")
      end
    end
  end
end


    begins=[]
    text = ''
    isStatement = true

    dictionary.each do |word| #最初の一文節の候補を選ぶ
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
      7.times do
        dictionary.each do |word|
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

    puts text
    text = "@#{status.user.screen_name} #{text}"
    option = {"in_reply_to_status_id"=>status.id.to_s}
    Twitter.update text,option
  end
end
