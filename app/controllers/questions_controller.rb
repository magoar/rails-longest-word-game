require 'open-uri'
require 'json'

class QuestionsController < ApplicationController
  def ask
    charset = Array("A".."Z")
    @letters = (0...10).map { charset.to_a[rand(charset.size)] }
  end

  def answer
    @score = its_a_word(params[:word], params[:letters])
  end

  private

  def check_overused_letter(word, letters)
    flags = []
    word.chars.each do |letter|
      if letters.include?(letter.upcase)
        letters.chars.delete_at(letters.chars.index(letter.upcase))
        flags << true
      else
        flags << false
      end
    end
    flags.all?
  end

  def its_a_word(attempt, grid)
    # You will use the Wagon Dictionary API.
    url = "https://wagon-dictionary.herokuapp.com/#{attempt.to_s.downcase}"
    # your word is an actual English word
    hash_api = URI.open(url).read
    word = JSON.parse(hash_api)
    if word["found"]
      flag = check_overused_letter(attempt, grid)
      if flag
        return "well done!"
      else
        return "word not in the grid"
      end
    else
      return "not an english word"
    end
  end
end
