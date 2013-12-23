# -*- encoding: utf-8 -*-

require 'bimyou_segmenter'

input = gets.gsub('。','')

text=BimyouSegmenter.segment(input)
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
    inputs[counter] = "beginpoint #{text[n]} #{text[n+1]}"
    n+=1
  else
    inputs[counter] = "#{text[n]} #{text[n+1]} #{text[n+2]}"
    n+=1
  end
  counter+=1
  if n+3>=text.length+1 then
    break
  end
end
p inputs

count = 0

inputs.each do|input|
  File.open("dictionary.txt","a") do |file|
    file.write("#{input}\n")
  end
  count+=1
end
