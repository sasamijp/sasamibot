# -*- encoding: utf-8 -*-

require 'bimyou_segmenter'

text=BimyouSegmenter.segment(gets.to_s)
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
count = 0

inputs.each do|input|
  File.open("new_dictionary.txt","a") do |file|
    if !inc
      file.write("#{input}\n")
    else
      file.write("#{input} endpoint\n")
    end
    count+=1
  end
end
end