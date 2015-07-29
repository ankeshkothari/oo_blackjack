# We take a deck of cards. Start game: Player bets x amount. Dealer deals two cards to player and himself. The player then decides to hit or stay. If his points go over 21, he busts and automatically loses. Otherwise more cards are delt until he stays. After player stay, dealer deals cards to himself automatically until score is over 17. If it goes over 21 he busts and automatically loses. Otherwise points are compared and a winner selected. Point calculation: 2-9 is 2-9 points. J Q K is 10. Ace is either 1 or 11.

class Deck
  attr_accessor :cards

  def initialize
    suit = ["Spades", "Hearts", "Clubs", "Diamonds"]
    num =  ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]
    @deck = suit.product(num)
  end

  def shuffle
    @cards = @deck.shuffle
  end

end

class Player
  def deal_card
    @cards = []
    @cards << Deck.cards.pop
    puts @cards
  end
end

class Dealer

end

class Game
  def play
    Deck.new.shuffle
    Player.new.deal_card
    # deal 2 cards to player
    # deal 2 cards to computer
    # ask player to hit or stay
    #   if hit deal new card
    #   count points
    #   check bust
    #   else stay
    # dealer hits till 17
    # count points
    # check bust
    # compare win
  end
end


Game.new.play