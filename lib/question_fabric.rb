require 'rexml/document'
class QuestionFabric
  attr_reader :correct_answer, :variants, :points, :question, :minutes

  def initialize(params)
    @minutes = params[:minutes]
    @question = params[:question]
    @variants = params[:variants].shuffle
    @correct_answer = params[:correct_answer]
    @points = params[:points]
  end

  def self.from_xml(path)
    raise 'Data quiz not found' unless File.exist?(path)

    document = File.open(path, 'r:UTF-8') { |file| REXML::Document.new(file) }

    document.root.get_elements('question_block').sample(5).map do |question_node|
      hash = {
        minutes: question_node.attributes['minutes'].to_i,
        points: question_node.attributes['points'].to_i,
        question: question_node.elements['question'].text
      }
      question_node.elements.each('variants/variant') do |variant_node|
        # Условное присвоение: Если не было ключа - присвоить []
        hash[:variants] ||= []
        hash[:correct_answer] = variant_node.text if variant_node.attributes['right']
        hash[:variants] << variant_node.text
      end
      self.new(hash)
    end
  end

  def variants_list
    @variants.each.with_index(1) do |variant, index|
      puts "#{index}. #{variant}"
    end
  end

  def question
    puts "\n#{@question}\nYou will get: #{@points} #{number_points(@points)}. " \
    "Time to answer: #{@minutes} #{number_minutes(@minutes)}!\n\n"
  end

  def number_points(number)
    if number == 1
      'point'
    else
      'points'
    end
  end

  def number_minutes(number)
    if number == 1
      'minute'
    else
      'minutes'
    end
  end
end
