require 'date'
require_relative 'lib/question_fabric'

puts 'Fun Quiz: 5 questions'

path = File.new(File.join(__dir__, 'data', 'questions.xml'))
quiz = QuestionFabric.from_xml(path)

points = 0
score = 0

quiz.each do |i|
  i.question
  i.variants_list

  start_time = Time.now
  user_input = $stdin.gets.to_i

  while  user_input > i.variants.size || user_input.zero?
    puts 'Please, choose a variant from options'
    user_input = $stdin.gets.to_i
  end

  if Time.now - start_time > i.minutes * 60
    puts "You didn't finish, and your wrist feels like spaghetti."
    exit
  end

  if i.variants[user_input - 1] == i.correct_answer
    points += i.points.to_i
    score += 1
    puts "Correct answers\n"
  else
    puts "Wrong answer. The correct answer is: #{i.correct_answer}\n"
  end
  puts "You have earned: #{points} #{i.number_points(points)}"
end

puts "\nYou have #{score} correct answers from #{quiz.size} questions."
