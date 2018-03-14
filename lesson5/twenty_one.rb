module Clearable
  def clear
    system('clear') || system('cls')
  end
end

module Handable
  def hit(card)
    hand << card
  end

  def busted?
    total > 21
  end

  def card_values
    hand.map(&:actual_value)
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

  def winner?(other)
    total > other.total && !busted?
  end

  def tie?(other)
    total == other.total
  end
end

class Score
  attr_reader :total

  def initialize
    @total = 0
  end

  def add_point
    @total += 1
  end
end

class Participant
  attr_reader :hand, :name, :score
  include Handable

  def initialize
    reset
    @score = Score.new
  end

  def reset
    @hand = []
  end
end

class Player < Participant
  include Clearable

  def initialize
    super
    @name = username
  end

  def username
    clear
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
  def initialize
    super
    @name = ['Hal', 'Sonny', 'Robo', 'Jack', 'Wall-e'].sample
  end

  def under_eighteen?
    total < 18
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
    CARDS.each { |suit, vals| vals.each { |v| cards << Card.new(suit, v) } }
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
  include Clearable
  attr_reader :player, :dealer, :deck, :dealer_name, :player_name

  def initialize
    @player = Player.new
    @dealer = Dealer.new
    @deck = Deck.new
    @dealer_name = dealer.name
    @player_name = player.name
  end

  def deal_cards
    2.times { player.hit(deck.deal) }
    2.times { dealer.hit(deck.deal) }
  end

  def display_welcome_message
    puts "Hello, #{player_name}. Welcome to the game of Twenty-one." \
         " #{dealer_name} will be your dealer today.\n\n"
    puts "Try to get as close to 21 as possible, without going over." \
         " If you go over 21, or #{dealer_name} is closer to 21, you lose.\n\n"
    puts "Good Luck! Let's begin.\n\n"
  end

  def display_goodbye_message
    clear
    puts "Goodbye, #{player_name}! Thanks for playing.\n\n"
  end

  def display_dealers_first_card
    puts ">> #{dealer_name}'s card: #{dealer.hand.first}"
    puts ""
  end

  def display_dealers_last_card
    puts ">> #{dealer_name}'s newest card: #{dealer.hand.last}"
    puts ""
  end

  def display_dealers_cards
    puts ">> #{dealer_name}'s cards:" \
         " #{dealer.hand.map { |card| card }.join(', ')}\n\n"
  end

  def display_players_cards
    puts ">> #{player_name}'s cards:" \
         " #{player.hand.map { |card| card }.join(', ')}\n\n"
  end

  def show_initial_cards
    display_dealers_first_card
    display_players_cards
  end

  def display_all_cards
    display_players_cards
    display_dealers_cards
  end

  def display_two_totals(participant)
    puts "Having an ace has given #{participant.name} two possible values: " \
         "#{participant.small_total} or #{participant.total}\n\n"
  end

  def display_players_total
    puts "The total value of #{player_name}'s cards: #{player.total}\n\n"
  end

  def display_dealers_total
    puts "The total value of #{dealer_name}'s cards: #{dealer.total}\n\n"
  end

  def display_dealers_last_card_and_total
    display_dealers_last_card
    dealer.two_totals? ? display_two_totals(dealer) : display_dealers_total
  end

  def display_cards_and_players_total
    show_initial_cards
    player.two_totals? ? display_two_totals(player) : display_players_total
  end

  def display_cards_and_both_totals
    display_all_cards
    display_players_total
    display_dealers_total
  end

  def player_turn
    loop do
      answer = nil
      loop do
        puts "Do you want to stay or hit? (s/h)"
        answer = gets.chomp.downcase
        break if ['s', 'h'].include?(answer)
        puts "That's not one of the options. Type h or s."
      end
      break if answer == 's'
      player.hit(deck.deal)
      clear
      display_cards_and_players_total
      break if player.busted?
    end
  end

  def dealer_turn
    clear
    display_cards_and_both_totals
    loop do
      break unless dealer.under_eighteen?
      puts "...#{dealer_name} deals himself another card...\n\n"
      dealer.hit(deck.deal)
      display_dealers_last_card_and_total
    end
    puts "#{dealer_name} stays.\n\n" unless dealer.busted?
  end

  def dealer_winner?
    dealer.winner?(player) || player.busted?
  end

  def player_winner?
    player.winner?(dealer) || dealer.busted?
  end

  def keep_score
    dealer.score.add_point if dealer_winner?
    player.score.add_point if player_winner?
  end

  def participant_scores
    "#{player_name} wins: #{player.score.total}    |" \
    "#{dealer_name} wins: #{dealer.score.total}"
  end

  def result
    if dealer_winner?
      "*** #{dealer_name} Won! ***"
    elsif player_winner?
      "*** #{player_name} Won! ***"
    else
      "*** It's a tie! ***"
    end
  end

  def busted_msg
    puts player.busted? ? "#{player_name} is Bust!" : "#{dealer_name} is Bust!"
  end

  def display_result_and_scores
    puts busted_msg if player.busted? || dealer.busted?
    puts result
    puts ""
    puts participant_scores
  end

  def play_again?
    answer = nil
    loop do
      puts "Do you want to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Invalid input! Type y or n."
    end
    answer == 'y'
  end

  def reset
    clear
    dealer.reset
    player.reset
    deck.reset
  end

  def start
    clear
    display_welcome_message
    loop do
      deal_cards
      display_cards_and_players_total
      player_turn
      dealer_turn unless player.busted?
      keep_score
      display_result_and_scores
      break unless play_again?
      reset
    end
    display_goodbye_message
  end
end

Game.new.start
