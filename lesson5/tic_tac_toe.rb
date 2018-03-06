module Joinable
  DELIMITER = ','
  JOINING_WORD = 'or'

  def joinor(arr)
    return arr.join("#{JOINING_WORD} ") if arr.size <= 2
    arr[0..-2].join("#{DELIMITER} ") + " #{JOINING_WORD} #{arr.last}"
  end
end

class Board
  WINNING_LINES = [[1, 2, 3], [4, 5, 6], [7, 8, 9]] + # rows
                  [[1, 4, 7], [2, 5, 8], [3, 6, 9]] + # columns
                  [[1, 5, 9], [3, 5, 7]]              # diagonals
  attr_reader :squares

  def initialize
    @squares = {}
    (1..9).each { |key| @squares[key] = Square.new }
  end

  def []=(key, marker)
    @squares[key].marker = marker
  end

  def unmarked_keys
    squares.select { |_, sq| sq.unmarked? }.keys
  end

  def full?
    unmarked_keys.empty?
  end

  def someone_won?
    !!winning_marker
  end

  def winning_marker
    WINNING_LINES.each do |line|
      markers = marked_squares(squares.values_at(*line))
      return markers.first if line_of_three?(markers)
    end
    nil
  end

  # rubocop:disable Metrics/AbcSize
  def draw
    puts "     |     |"
    puts "  #{squares[1]}  |  #{squares[2]}  |  #{squares[3]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{squares[4]}  |  #{squares[5]}  |  #{squares[6]}"
    puts "     |     |"
    puts "-----|-----|-----"
    puts "     |     |"
    puts "  #{squares[7]}  |  #{squares[8]}  |  #{squares[9]}"
    puts "     |     |"
  end
  # rubocop:enable Metrics/AbcSize

  def reset
    (1..9).each { |key| squares[key].reset_marker }
  end

  private

  def line_of_three?(markers)
    markers.size == 3 && markers.min == markers.max
  end

  def marked_squares(line)
    line.select { |sq| !sq.unmarked? }.map(&:marker)
  end
end

class CurrentBoard < Board
  def initialize(board)
    @squares = {}.merge(board.squares)
  end
end

class Score
  attr_reader :points

  def initialize
    reset
  end

  def add_point
    @points += 1
  end

  def reset
    @points = 0
  end

  def grand_winner?
    points == TTTGame::TARGET_WINS
  end
end

class Square
  INITIAL_MARKER = " "
  attr_accessor :marker

  def initialize(marker=INITIAL_MARKER)
    @marker = marker
  end

  def to_s
    marker
  end

  def unmarked?
    marker == INITIAL_MARKER
  end

  def reset_marker
    self.marker = INITIAL_MARKER
  end
end

class Player
  HUMAN_MARKER = "X"
  COMPUTER_MARKER = "O"
  attr_reader :marker

  def initialize(marker)
    @marker = marker
  end
end

class Human < Player
  def initialize
    super(HUMAN_MARKER)
  end
end

class AI < Player
  def initialize()
    super(COMPUTER_MARKER)
  end

  def move(board)
    @board = CurrentBoard.new(board)
    strategic_move
  end

  def winning_move(marker)
    @board.unmarked_keys.each do |key|
      @board[key] = marker
      return key if @board.someone_won?
      @board[key] = Square::INITIAL_MARKER
    end
    nil
  end

  def strategic_move
    winning_move(marker) ||
    winning_move(HUMAN_MARKER) ||
    (5 if @board.unmarked_keys.include?(5)) ||
    @board.unmarked_keys.sample
  end
end

class TTTGame
  include Joinable

  TARGET_WINS = 5
  FIRST_PLAYER = 'choose'
  attr_reader :board, :human, :computer, :human_score, :computer_score
  attr_accessor :current_player

  def initialize
    @board = Board.new
    @human = Human.new
    @computer = AI.new
    @human_score = Score.new
    @computer_score = Score.new
  end

  private

  def clear
    system('clear') || system('cls')
  end

  def human_player_first?
    answer = nil
    loop do
      puts "Would you like to play first? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include?(answer)
      puts "Invalid input. Please type y or n."
    end
    answer == 'y'
  end

  def choose_first_player
    self.current_player = human_player_first? ? human.marker : computer.marker
    clear
  end

  def set_first_player
    choose_first_player if FIRST_PLAYER == 'choose'
    self.current_player = computer.marker if FIRST_PLAYER == 'computer'
    self.current_player = human.marker if FIRST_PLAYER == 'player'
  end

  def display_welcome_message
    puts "Welcome to Tic Tac Toe!"
    puts "The first player to win #{TARGET_WINS} games is the grand winner!"
    puts
  end

  def display_goodbye_message
    puts "Thanks for playing Tic Tac Toe! Goodbye!"
  end

  def display_board
    puts "You're a #{human.marker}. Computer is a #{computer.marker}"
    puts ""
    board.draw
    puts ""
  end

  def clear_screen_and_display_board
    clear
    display_board
  end

  def display_play_again_message
    puts "Let's play again!"
    puts ""
  end

  def display_result
    clear_screen_and_display_board

    case board.winning_marker
    when human.marker    then puts "You won!"
    when computer.marker then puts "Computer won!"
    else                      puts "It's a tie!"
    end
  end

  def display_grand_winner
    puts "*** We have a grand winner!!! ***"
    msg = "won #{TARGET_WINS} games! How about a rematch?"
    puts human_score.grand_winner? ? "You #{msg}" : "Computer #{msg}"
    puts ""
  end

  def display_scores
    puts "Your wins: #{human_score.points}" \
         "  |  Computer wins: #{computer_score.points}"
    puts ""
    display_grand_winner if grand_winner?
  end

  def keep_score
    human_score.add_point if board.winning_marker == human.marker
    computer_score.add_point if board.winning_marker == computer.marker
  end

  def reset_score
    human_score.reset
    computer_score.reset
  end

  def human_moves
    puts "Choose a square (#{joinor(board.unmarked_keys)}): "
    square = nil
    loop do
      square = gets.chomp.to_i
      break if board.unmarked_keys.include?(square)
      puts "Sorry, that's not a valid choice."
    end

    board[square] = human.marker
  end

  def computer_moves
    board[computer.move(board)] = computer.marker
  end

  def human_turn?
    current_player == human.marker
  end

  def grand_winner?
    computer_score.grand_winner? || human_score.grand_winner?
  end

  def toggle_current_player
    self.current_player = human_turn? ? computer.marker : human.marker
  end

  def current_player_moves
    human_turn? ? human_moves : computer_moves
    toggle_current_player
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? (y/n)"
      answer = gets.chomp.downcase
      break if ['y', 'n'].include? answer
      puts "Invalid input. Please answer with y or n."
    end
    answer == 'y'
  end

  public

  def play
    clear
    display_welcome_message

    loop do
      set_first_player
      display_board

      loop do
        current_player_moves
        break if board.someone_won? || board.full?

        clear_screen_and_display_board if human_turn?
      end
      display_result
      keep_score
      display_scores
      break unless play_again?
      reset_score if grand_winner?
      board.reset
      clear
      display_play_again_message
    end
    display_goodbye_message
  end
end

game = TTTGame.new
game.play
