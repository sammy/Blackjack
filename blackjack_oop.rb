# encoding: utf-8

class Participant
  attr_accessor :name, :hand

  def initialize
    @hand = []
  end

  def draw(card)
    hand << card
  end

  def show_hand(*one)
    if one.empty?
      hand.each do |card|
        print card.value + card.suit + '  '
      end
    else 
      print hand.last.value + hand.last.suit + ' ' 
    end
  end

  def calculate_total
    total = 0
    hand.each do |card|
      if card.value == 'A'
        total += 11
      elsif card.value.to_i == 0
        total +=10
      else
        total += card.value.to_i
      end
    end

    hand.select {|e| e.value == "A"}.count.times do
      total -=10 if total > 21
    end

    total
  end

end


class Player < Participant
  
  def initialize
    puts 'Welcome to Blackjack! What is your name?'
    @name = gets.chomp
    super
  end

  def stay
  end

end

class Dealer < Participant

  def initialize
    super
    @name = 'Dealer'
  end

end

class Card
  attr_accessor :suit, :value

  def initialize(suit,value)
    @suit = suit
    @value = value
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    ['♠', '♣', '♥', '♦'].each do |suit|
      ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A'].each do |face_value|
        @cards << Card.new(suit, face_value)
      end
    end
    scramble!
  end

  def scramble!
    cards.shuffle!
  end

  def deal
    cards.pop
  end
end


class Blackjack
  def initialize
    @player = Player.new
    @deck = Deck.new
    @dealer = Dealer.new
  end

  def ask(question);    puts "\033[36m#{question}\033[0m" end
  def emphasize(value); print "\033[32m#{value}\033[0m" end
  def bold(text);           "\033[32m#{text}\033[0m" end

  def deal_cards
    2.times do
      @player.draw(@deck.deal)
      @dealer.draw(@deck.deal)
    end
  end

  def show_flop
    print "#{@player.name} has: "  
    @player.show_hand
    print " with a total of: "
    emphasize(@player.calculate_total)
    puts ""
    puts "- - - - - - - - - - - - - - - - - - - - - -"
    print "#{@dealer.name} has: "
    @dealer.show_hand(1)
    print " and one hidden card."
    #emphasize(@dealer.calculate_total)
    puts ""
    emphasize("~~~~~~~~~~~~~~~~~~~~~~~~~")
    puts ""

    if @player.calculate_total == '21'
      emphasize('Blackjack! You won!')
    end

    if @dealer.calculate_total == '21'
      emphasize('Blackjack for the Dealer. Sorry, you lose')
    end

  end

  def player_round
    while @player.calculate_total < 21
    ask("Would you like to (h)it or (s)tay?")
    reply = gets.chomp

    if !['h', 's'].include? reply
      ask("Ooops! You need to choose h or s")
      next
    end

    if reply == 's'
      emphasize("You chose to stay!")
      break
    end

    @player.hand << @deck.deal
    emphasize("Dealing to #{@player.name} #{@player.hand.last.value} #{@player.hand.last.suit}  | Total now is: #{@player.calculate_total}")
    puts ""
  end



  end

  def run
    deal_cards
    show_flop
    player_round
  end

end

Blackjack.new.run
