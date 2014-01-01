# -*- encoding: utf-8 -*-
require 'tweetstream'
require 'twitter'
require 'bimyou_segmenter'
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
  p status.text
  if !status.text.include?("RT") && !status.text.include?("http") && !status.text.include?(".co") && status.text.length < 50 then
    text=BimyouSegmenter.segment(status.text)
  end
  if text[0] == '@' then
    text = text.delete(text[0])
    text = text.delete(text[1])
  end
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

  count = 0

  inputs.each do|input|
    File.open("new_dictionary.txt","a") do |file|
      file.write("#{input}\n")
      count+=1
    end
  end
end
end
