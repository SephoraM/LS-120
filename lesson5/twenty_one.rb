class Participant
  attr_reader :hand

  def initialize
    @hand = []
  end

  def hit(card)
    @hand << card
  end

  def busted?
    total > 21
  end

  def card_values
    @hand.map(&:actual_value)
  end

  def any_aces?
    card_values.include?(1)
  end

  def small_total
    card_values.reduce(:+)
  end

  def total
    any_aces? && small_total <= 11 ? small_total + 10 : small_total
  end

  def two_totals?
    small_total != total
  end
end

class Player < Participant
  attr_reader :name

  def initialize
    super
    @name = username
  end

  def username
    name = nil
    puts "Heya!"
    loop do
      puts "What's your name?"
      name = gets.chomp
      break unless name.strip.empty?
      puts "I didn't get that. Wanna try again?"
    end
    name.capitalize
  end
end

class Dealer < Participant
  def at_least_seventeen?
    total > 17
  end
end

class Deck
  CARDS = {
    spades: ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King'],
    hearts: ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King'],
    clubs: ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King'],
    diamonds: ['Ace', 2, 3, 4, 5, 6, 7, 8, 9, 10, 'Jack', 'Queen', 'King']
  }
  attr_reader :cards

  def initialize
    reset
  end

  def reset
    @cards = []
    CARDS.each { |suit, vals| vals.each { |v| @cards << Card.new(suit, v) } }
  end

  def deal
    card = cards.sample
    cards.delete(card)
  end
end

class Card
  def initialize(suit, value)
    @suit = suit
    @value = value
    @real_value = actual_value
  end

  def actual_value
    case @value
    when (2..10) then @value
    when 'Ace'   then 1
    else              10
    end
  end

  def to_s
    "#{@value} of #{@suit}"
  end
end

class Game
  attr_reader :player, :dealer, :deck

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def clear
    system('clear') || system('cls')
  end

  def deal_cards
    2.times { player.hit(deck.deal) }
    2.times { dealer.hit(deck.deal) }
  end

  def display_welcome_message
    puts "Hello, #{player.name}. Welcome to the game of Twenty-one."
    puts "Try to get as close to 21 as possible, without going over." \
         " If you go over 21, or the dealer is closer to 21, you lose.\n\n"
    puts "Good Luck! Let's begin.\n\n"
  end

  def display_dealers_first_card
    puts ">> The dealer's card: #{dealer.hand[0]}"
    puts ""
  end

  def display_players_cards
    puts ">> #{player.name}'s cards:" \
         " #{player.hand.map { |card| card }.join(', ')}\n\n"
  end

  def show_initial_cards
    display_dealers_first_card
    display_players_cards
  end

  def display_possible_totals
    if player.two_totals?
      puts "Having an ace has given #{player.name} two possible values: " \
           "#{player.small_total} or #{player.total}\n\n"
    else
      puts "The total value of #{player.name}'s cards: #{player.total}\n\n"
    end
  end

  def player_turn
    loop do
      display_possible_totals
      answer = nil
      loop do
        puts "Do you want to stay or hit? (s/h)"
        answer = gets.chomp.downcase
        break if ['s', 'h'].include?(answer)
        puts "That's not one of the options. Type h or s."
      end
      break if answer == 's'
      player.hit(deck.deal)
      break if player.busted?
    end
  end

  def start
    clear
    display_welcome_message
    deal_cards
    show_initial_cards
    player_turn
    # dealer_turn
    # show_result
  end
end

Game.new.start
