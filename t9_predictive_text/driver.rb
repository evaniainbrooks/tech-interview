# frozen_string_literal: true

require 'yaml'
require_relative './t9_predict'

DICTIONARY = YAML.load_file('nouns.yml')

predict = T9Predict.new(DICTIONARY)

result = predict.input_sequence([2, 7, 7])
puts "Suggestions #{result.inspect}"
predict.reset

result = predict.input_sequence([5, 6])
puts "Suggestions #{result.inspect}"
predict.reset

result = predict.input_sequence([8, 3])
puts "Suggestions #{result.inspect}"
predict.reset

result = predict.input_sequence([7, 6, 8, 8])
puts "Suggestions #{result.inspect}"
predict.reset

result = predict.input_sequence([4, 3])
puts "Suggestions #{result.inspect}"
predict.reset
