class Game
  attr_accessor :secret_word, :final_word

  def initialize(secret_word = nil)
    @secret_word = secret_word || File.readlines("google-10000-english-no-swears.txt").map(&:chomp).select { |word| word.length >= 5 && word.length <= 12 }.sample
    @final_word = "." * @secret_word.length
  end

  def play
    puts "Guess the letter or type 'save' to save the game."

    while @final_word != @secret_word
      guess = gets.chomp

      if guess == 'save'
        save_game
        puts "Game saved! Exiting..."
        break
      elsif guess.length == 1 && guess.match?(/[a-zA-Z]/) # Allow only valid letters (case-sensitive)
        if @secret_word.include?(guess)
          @secret_word.split("").each_with_index do |letter, index|
            @final_word[index] = letter if letter == guess
          end
          puts @final_word
          puts "Nice! Select the next letter."
          if @final_word == @secret_word
            puts "Congratulations! You guessed it right!"
            return
          end
        else
          puts "Wrong! Guess again!"
        end
      else
        puts "Invalid input. Please guess a single letter or type 'save'."
      end
    end
  end

  def save_game
    File.open("saved_game.dat", "wb") { |file| Marshal.dump(self, file) }
    puts "Game has been saved!"
  end

  def self.load_game
    if File.exist?("saved_game.dat")
      File.open("saved_game.dat", "rb") { |file| Marshal.load(file) }
    else
      puts "No saved game found."
      nil
    end
  end
end

# Main game logic to start a new game or load an existing one
def start_game
  puts "Welcome to Hangman!"
  puts "Type 'new' to start a new game or 'load' to continue from a saved game."

  choice = gets.chomp.downcase

  case choice
  when 'new'
    game = Game.new
    game.play
  when 'load'
    game = Game.load_game
    game.play if game
  else
    puts "Invalid option. Please start again."
  end
end

start_game
