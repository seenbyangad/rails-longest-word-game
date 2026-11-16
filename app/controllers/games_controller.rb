require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word].to_s.upcase
    @letters = params[:letters].to_s.split

    if !in_grid?(@word, @letters)
      @result = :not_in_grid
    elsif !english_word?(@word)
      @result = :not_english
    else
      @result = :valid
    end
  end

  private

  # Every letter in the word must be in the grid, and not used more times than it appears
  def in_grid?(word, letters)
    word.present? && word.chars.all? { |letter| word.count(letter) <= letters.count(letter) }
  end

  # Ask the online dictionary whether the word exists
  def english_word?(word)
    response = URI.parse("https://dictionary.lewagon.com/#{word}").read
    JSON.parse(response)["found"]
  end
end
