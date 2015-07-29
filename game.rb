# We take a deck of cards. Start game: Player bets x amount. Dealer deals two cards to player and himself. The player then decides to hit or stay. If his points go over 21, he busts and automatically loses. Otherwise more cards are delt until he stays. After player stay, dealer deals cards to himself automatically until score is over 17. If it goes over 21 he busts and automatically loses. Otherwise points are compared and a winner selected. Point calculation: 2-9 is 2-9 points. J Q K is 10. Ace is either 1 or 11.

class Deck
  def initialize
    suit = ["Spades", "Hearts", "Clubs", "Diamonds"]
    num =  ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
    @deck = suit.product(num)
  end

  def scramble!
    @deck.shuffle!
  end

  def deal_one
    @deck.pop
  end

end

module Hand
  def show_hand
    puts "#{@name} has the following hand:"
    hand.each do |array|
      puts "=> #{array[1]} of #{array[0]}"
    end
  end

  def has_ace?
    hand.each do |array|
      if array[1] == "Ace"
        return true
      end
    end
    false
  end

  def total
    @total = 0

    hand.each do |array|
      if [2, 3, 4, 5, 6, 7, 8, 9, 10].include?(array[1].to_i)
        @total += array[1].to_i
      elsif ["Jack", "Queen", "King"].include?(array[1])
        @total += 10
      elsif ["Ace"].include?(array[1])
        @total += 1
      end
    end

    # correct for aces
    if has_ace? && @total < 12
      @total += 10
    end

    puts "#{@name} has a total of #{@total} points"
    puts " "

    @total
  end

  def busted?
    if @total > 21
      true
    else
      false
    end
  end

end


class Player
  attr_accessor :hand, :name, :total_amount, :bet

  include Hand

  def initialize(name)
    @name = name
    @total_amount = 0
    @bet = 0
    @hand = []
  end
end


class Dealer
  attr_accessor :hand, :name

  include Hand

  def initialize
    @name = "Dealer"
    @hand = []
  end

end


class Game

  def initialize
    system 'clear'
    @dealer = Dealer.new
    @player = Player.new("Champ")
    puts "Lets play Blackjack!"
    set_player_name
    set_player_total_amount
  end

  def play_again
    puts " "
    puts "Press P to play again. Any other key to exit."
    play_key = gets.chomp.downcase
    puts " "

    if play_key == "p"
      system 'clear'
      play
    end

    puts "#{@player.name} is leaving the table with Rs #{@player.total_amount}. Good bye!"
  end

  def set_player_name
    puts "What is your name?"
    @player.name = gets.chomp
  end

  def set_player_total_amount
    puts "#{@player.name}, you have Rs 500.00 to start off"
    @player.total_amount = 500.00
  end

  def set_player_bet
    puts "How much would you like to bet?"
    @player.bet = gets.chomp.to_f
    puts "#{@player.name} has bet Rs #{@player.bet}"
    puts " "
  end

  def reset_round
    @cards = Deck.new
    @cards.scramble!
    @player.hand = []
    @dealer.hand = []
    set_player_bet
  end

  def game_flop
    @player.hand << @cards.deal_one
    @player.hand << @cards.deal_one
    @player.show_hand
    @player.total

    puts "Dealer's first card is hidden"
    @dealer.hand << @cards.deal_one
    @dealer.show_hand
    @dealer.total
  end

  def winner_declare
    if @player.busted?
      puts "#{@player.name} is busted!"
      puts " "
      
      puts "#{@player.name} lost Rs #{@player.bet}"
      @player.total_amount -= @player.bet
      puts "#{@player.name} has Rs #{@player.total_amount} remaining."

    elsif @dealer.busted?
      puts "#{@dealer.name} is busted!"
      puts " "

      puts "#{@player.name} won Rs #{@player.bet}"
      @player.total_amount += @player.bet
      puts "#{@player.name} has Rs #{@player.total_amount} remaining."

    elsif @player.total == @dealer.total
      puts "Both #{@player.name} and #{@dealer.name} have #{@player.total}"
      puts "Its a tie!"
      puts " "

      puts "#{@player.name} has Rs #{@player.total_amount} remaining."

    elsif @player.total > @dealer.total
      if player.total == 21
        puts "#{@player.name} has #{@player.total}"
        puts "#{@player.name} has a Blackjack!"
        puts " "

        puts "#{@player.name} won Rs #{@player.bet*1.5}"
        @player.total_amount += @player.bet*1.5
        puts "#{@player.name} has Rs #{@player.total_amount} remaining."
      else
        puts "#{@player.name} has #{@player.total} points and #{@dealer.name} has #{@dealer.total} points"
        puts "#{@player.name} wins!"
        puts " "

        puts "#{@player.name} won Rs #{@player.bet}"
        @player.total_amount += @player.bet
        puts "#{@player.name} has Rs #{@player.total_amount} remaining."
      end

    elsif @player.total < @dealer.total
      puts "#{@player.name} has #{@player.total} points and #{@dealer.name} has #{@dealer.total} points"
      puts "#{@player.name} loses!"
      puts " "

      puts "#{@player.name} lost Rs #{@player.bet}"
      @player.total_amount -= @player.bet
      puts "#{@player.name} has Rs #{@player.total_amount} remaining."
        
    end

  end

  def player_turn
    puts "It's #{@player.name}'s turn..."
    begin
      begin
        puts "Press H to hit or S to stay"
        key = gets.chomp.downcase
      end until key == "s" || key == "h"

      if key == "s"
        puts "#{@player.name} stays."
        break
      end

      current_card = @cards.deal_one
      puts "#{@player.name} got #{current_card[1]} of #{current_card[0]}"
      @player.hand << current_card
      @player.total

    end until @player.busted? || key == "s"

  end

  def dealer_turn
    if @player.busted? != true
      puts "It's Dealer's turn..."

      begin
        current_card = @cards.deal_one
        puts "Dealer got #{current_card[1]} of #{current_card[0]}"
        @dealer.hand << current_card
        # @dealer.total
      end until @dealer.total > 17 || @dealer.busted?

    end
  end

  def play

    reset_round
    game_flop
    player_turn
    dealer_turn
    winner_declare
    play_again
  end
end


blackjack = Game.new
blackjack.play
