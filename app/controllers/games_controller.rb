class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @abc = params[:letters]
    baseurl = 'https://wagon-dictionary.herokuapp.com/'
    url = "#{baseurl}#{@word}"
    response = RestClient.get(url)
    @response_json = JSON.parse(response)

    @letters_of_word = @word.split('').map(&:upcase)

    @counter = @letters_of_word.all? do |letter|
      @letters_of_word.count(letter) <= @abc.count(letter)
    end

    cookies[:score] = @score_num.to_i

    if @counter == false
      @result = "SORRY #{@word} can't be built out of #{@abc}"
    elsif @counter && @response_json['found'] == false
      @result = "SORRY #{@word} is not a valid English word"
    elsif @counter && @response_json['found']
      @result = "CONGRATULATIONS #{@word} is a valid English word"
    end
  end
end
