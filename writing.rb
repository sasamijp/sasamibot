# -*- encoding: utf-8 -*-

require 'bimyou_segmenter'

text=BimyouSegmenter.segment(gets.to_s)
p text
p text.length
text.push("endpoint")
p text
p text.length

n=0
counter = 0
inputs = []

while true do
  if n == 0 then
    inputs[counter] = "beginpoint #{text[n]} #{text[n+1]} #{text[n+2]} #{text[n+3]}"
    n+=2
  elsif n+5>=text.length+1 then
    break
  else
    inputs[counter] = "#{text[n]} #{text[n+1]} #{text[n+2]} #{text[n+3]} #{text[n+4]}"
    n+=1
  end
  counter+=1
end
p inputs

count = 0

inputs.each do|input|
  File.open("new_dictionary.txt","a") do |file|
    file.write("#{input}\n")
  end
  count+=1
end
