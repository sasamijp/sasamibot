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
mode = "japanese"
Twitter.update_profile(:name => "ささみbot(日本語モード)")
words = s.split("\n")
puts "ready to streaming"

client.userstream do |status|
  
  if status.text.include?("@sa2mi") && !status.text.include?("RT") then
    puts status.text
    if status.text[0..10] == "@sa2mi mode"
      case status.text.sub("@sa2mi mode ","")
      when "日本語" then
        s = File.read("dictionary.txt", :encoding => Encoding::UTF_8)
        mode = "japanese"
        Twitter.update_profile(:name => "ささみbot(日本語モード)")
      when "大日本帝国憲法" then
        s = File.read("dictionary_kenpou.txt", :encoding => Encoding::UTF_8)
        mode = "kenpou"
        Twitter.update_profile(:name => "ささみbot(帝国憲法モード)")
      when "奥の細道" then
        s = File.read("dictionary_matsuo.txt", :encoding => Encoding::UTF_8)
        mode = "hosomichi"
        Twitter.update_profile(:name => "ささみbot(奥のほそ道モード)")
      when "日本国憲法" then
        s = File.read("kenpoujapan.txt", :encoding => Encoding::UTF_8)
        mode = "kenpou_new"
        Twitter.update_profile(:name => "ささみbot(日本国憲法モード)")
      when "ホモ" then
        s = File.read("inmu.txt", :encoding => Encoding::UTF_8)
        mode = "homo"
        Twitter.update_profile(:name => "ささみbot(ホモモード)")
      when "歌う野獣"
        s = File.read("sing.txt", :encoding => Encoding::UTF_8)
        mode = "yaju"
        Twitter.update_profile(:name => "ささみbot(歌う野獣モード)")
      end
    end

    begins=[]
    text = ''
    isStatement = true

    words.each do |word| #最初の一文節の候補を選ぶ
      sword = word.split
      begins.push(word) if sword[0] == "beginpoint"
      isStatement = false if sword[sword.length-1] == "endpoint" #beginpointからすぐendpointに移行する場合、単語ツイートとして処理する
    end

    rnum = rand(begins.length)
    first = begins[rnum].sub('beginpoint ','') #最初の一文節を候補の中から乱数で決定
    text << first #なんかこう書くと速いらしい

    

    puts isStatement
    if isStatement then
      candidate = []
      10.times do
        words.each do |word|
          stext=text.split
          endword = stext[stext.length-1]
          candidate.push(word.sub(endword,'')) if word.split[0] == endword 
        end
      end

      while addword != stext[stext.length-1] do
        rnum = rand(candidate.length)
        addword = candidate[rnum]
        stext = text.split
        addword = candidate[rnum] if addword == stext[stext.length-1]
      end

      text << candidate[rnum]
      p text.split[stext.length-1]
      break if text.split[stext.length-1] == "endpoint"
    end

    text.gsub!(/ endpoint| |@/, " endpoint" => "", " " => "", "@" => "")

    if mode == "japanese" then
      emotions = ''
      case status.text[-1]
        when "！","!"
          emotions = "！"
        when "ｗ","w"
          emotions = "ｗ"
        when "な","ね"
          emotions = "。"
        when "。","…","."
          emotions = "..."
        when "？","?"
          text.gsub!("？","")
      end
      text << emotions
    end

    puts text
    text = "@#{status.user.screen_name} #{text}"
    option = {"in_reply_to_status_id"=>status.id.to_s}
    Twitter.update text,option

  end
end
