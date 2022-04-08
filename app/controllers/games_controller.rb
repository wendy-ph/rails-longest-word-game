class GamesController < ApplicationController
  def new
    alphabet = ('A'..'Z').to_a
    @letters = []
    10.times { @letters.push(alphabet.sample) }
  end

  def score
    word_chars = params[:word].upcase.chars
    @score = 0
    @message = if validate_word(params[:word])
                 if word_chars.all? { |a| word_chars.count(a) <= params[:letters].count(a) }
                  @score += params[:word].length
                   "Congratulations! #{params[:word]} is a valid English word."
                 else
                   "Sorry, but #{params[:word]} cannot be built out of #{params[:letters]}."
                 end
               else
                 "#{params[:word]} is not an English word."
               end
    total_score(@score)
  end

  def reset
    session.delete(:score)
    redirect_to new_path
  end

  def total_score(score)
    session[:score].nil? ? session[:score] = score : session[:score] += score
  end

  private

  def validate_word(query)
    url = "https://wagon-dictionary.herokuapp.com/#{query}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)

    word["found"].to_s == "true"
  end
end
