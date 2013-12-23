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
  s = File.read("dictionary.txt", :encoding => Encoding::UTF_8)
  client.userstream do |status|
   isreply = status.text.include?("@sa2mi")
   isrt = status.text.include?("RT")
  if isreply && !isrt then
  words = s.split("\n")
  c = 0
  dic=[]
  begins=[]
  text = ''
  words.each do |word|
    dic[c] = word.split
    c+=1
    if word.split[0] == "beginpoint" then
     	begins.push(word)
    end
  end
  #p dic
  rnum = rand(begins.length)
  first = begins[rnum].sub('beginpoint ','')
  #first = first.gsub(' ','') 最後に
  text << first

  #p text
candidate=[]
  10.times do
    words.each do |word|
      stext=text.split
      endword = stext[stext.length-1]
      if word.split[0] == endword then
        candidate.push(word.sub(endword,''))
      end
    end
    rnum = rand(candidate.length)
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
end
end
