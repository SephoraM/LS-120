class Rock
  def >(other_move)
    other_move == 'scissors' || other_move == 'lizard'
  end

  def <(other_move)
    other_move == 'paper' || other_move == 'spock'
  end
end

class Spock
  def >(other_move)
    other_move == 'scissors' || other_move == 'rock'
  end

  def <(other_move)
    other_move == 'paper' || other_move == 'lizard'
  end
end

class Lizard
  def >(other_move)
    other_move == 'spock' || other_move == 'paper'
  end

  def <(other_move)
    other_move == 'rock' || other_move == 'scissors'
  end
end

class Scissors
  def >(other_move)
    other_move == 'paper' || other_move == 'lizard'
  end

  def <(other_move)
    other_move == 'rock' || other_move == 'spock'
  end
end

class Paper
  def >(other_move)
    other_move == 'rock' || other_move == 'spock'
  end

  def <(other_move)
    other_move == 'scissors' || other_move == 'lizard'
  end
end

class Move
  attr_reader :value, :choice

  VALUES = { 'rock' => Rock, 'paper' => Paper, 'scissors' => Scissors,
             'lizard' => Lizard, 'spock' => Spock }

  def initialize(value)
    @value = value
    @choice = VALUES[value].new
  end

  def >(other_move)
    choice > other_move.value
  end

  def <(other_move)
    choice < other_move.value
  end

  def to_s
    @value
  end
end

class AllMoves
  attr_accessor :list, :losses

  def initialize
    @list = []
    @losses = []
  end

  def add(move)
    list << move
  end

  def add_loser(move)
    losses << move
  end
end

class AI
  MOVES = ['scissors', 'rock', 'paper', 'lizard', 'spock']
end

# R2d2 doubles the odds of picking a move that has not lost more than 60%
# of the time when it was played
class R2d2 < AI
  def name
    'R2D2'
  end

  def choices(past_moves)
    moves = past_moves.list
    losses = past_moves.losses

    MOVES.each_with_object([]) do |e, arr|
      moves.count(e) * 0.6 > losses.count(e) ? 2.times { arr << e } : arr << e
    end
  end
end

# Hal doubles the odds of picking the last move if it lost
class Hal < AI
  def name
    'Hal'
  end

  def choices(past_moves)
    last_move = past_moves.list.last
    last_loser = past_moves.losses.last

    last_move == last_loser ? MOVES + [last_loser] : MOVES
  end
end

# Chappie never picks lizard or spock
class Chappie < AI
  def name
    'Chappie'
  end

  def choices
    MOVES[0, 3]
  end
end

# Sonny has three times the odds of picking spock and never picks scissors
class Sonny < AI
  def name
    'Sonny'
  end

  def choices
    MOVES[1..-1].concat(['spock', 'spock'])
  end
end

# Number 5 plays with even odds across the board
class Number5 < AI
  def name
    'Number 5'
  end

  def choices
    MOVES
  end
end

class Player
  attr_accessor :move, :name, :score

  def initialize
    @score = 0
    set_name
  end

  def reset
    @score = 0
  end

  def add_point
    @score += 1
  end
end

class Human < Player
  def set_name
    n = ''
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, you must enter a value."
    end
    self.name = n.capitalize
  end

  def choose
    choice = nil
    loop do
      puts "Do you choose rock, paper, spock, lizard, or scissors?"
      choice = gets.chomp
      break if Move::VALUES.keys.include? choice.downcase
      puts "Sorry. Invalid choice! Try Again."
    end
    self.move = Move.new(choice.downcase)
  end
end

class Computer < Player
  attr_accessor :personality

  def set_personality
    self.personality = [R2d2, Hal, Chappie, Sonny, Number5].sample.new
  end

  def set_name
    set_personality
    self.name = personality.name
  end

  def choose(past_moves)
    self.move = if name == 'R2D2' || name == 'Hal'
                  Move.new(personality.choices(past_moves).sample)
                else
                  Move.new(personality.choices.sample)
                end
  end
end

class RPSGame
  TARGET = 10
  attr_accessor :human, :computer, :computer_moves, :human_moves

  def initialize
    @human = Human.new
    @computer = Computer.new
    @human_moves = AllMoves.new
    @computer_moves = AllMoves.new
    clear
  end

  def display_welcome_message
    puts "Hi, #{human.name}. Welcome to Rock, Paper, Scissors, Lizard, Spock!"
    puts "Today you'll be playing against #{computer.name}\n\n"
  end

  def display_goodbye_message
    puts "Thanks for playing Rock, Paper, Scissors. Good bye!"
  end

  def display_moves
    puts "#{human.name} chose #{human.move}."
    puts "#{computer.name} chose #{computer.move}.\n\n"
  end

  def display_winner
    if human.move > computer.move
      puts "#{human.name} won!"
    elsif human.move < computer.move
      puts "#{computer.name} won!"
    else
      puts "It's a tie!"
    end
  end

  def display_score
    puts "#{human.name} has won #{human.score} games.  |  |  " \
         "#{computer.name} has won #{computer.score} games.\n\n"
  end

  def display_stats
    display_score
    puts "#{human.name}'s moves so far: #{human_moves.list.join(', ')}"
    puts "#{computer.name}'s moves so far: #{computer_moves.list.join(', ')}"
    puts # adding a newline
  end

  def display_grand_winner(name)
    puts "#{name} won #{TARGET} games and is the grand winner of the match!\n\n"
    puts "We should have a rematch..."
  end

  def record_losing_move
    c_move = computer.move
    h_move = human.move
    if h_move > c_move
      computer_moves.add_loser(c_move.value)
    elsif h_move < c_move
      human_moves.add_loser(h_move.value)
    end
  end

  def record_moves
    human_moves.add(human.move.value)
    computer_moves.add(computer.move.value)

    record_losing_move
  end

  def keep_score
    if human.move > computer.move
      human.add_point
    elsif human.move < computer.move
      computer.add_point
    end
  end

  def reset_scoreboard
    human.reset
    computer.reset
  end

  def target_reached?
    human.score == TARGET || computer.score == TARGET
  end

  def end_current_match
    display_grand_winner(human.score == TARGET ? human.name : computer.name)
    reset_scoreboard
  end

  def play_again?
    answer = ''
    loop do
      puts "Do you want to play again? (y/n)"
      answer = gets.chomp
      break if ['y', 'n'].include? answer.downcase
      puts "Sorry, must be y or n."
    end
    !!(answer.downcase == 'y')
  end

  def clear
    system('clear') || system('cls')
  end

  def play
    display_welcome_message
    loop do
      human.choose
      computer.choose(computer_moves)
      display_moves
      display_winner
      keep_score
      record_moves
      display_stats
      end_current_match if target_reached?
      break unless play_again?
      clear
    end
    display_goodbye_message
  end
end

RPSGame.new.play
