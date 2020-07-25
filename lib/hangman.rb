require 'yaml'

class Board
	def initialize(word, b_arr, g_arr)
		@word = word
		@blank_array = b_arr
		@guess_array = g_arr

		@@word_array = @word.split("")
		
		puts "word: " + @blank_array.join(" ")
	end

	def guess
		puts "Incorrect guesses: " + @guess_array.join(" ")
		print "Guess a letter (type 'save' to save and quit): "
		
		player_guess = gets.chomp
		temp_arr = []
		return_value = nil

		if player_guess == "save"
			self.save_game
			exit
		elsif @@word_array.include?(player_guess)
			@@word_array.each_with_index do |value, index|
				if value == player_guess
					temp_arr << index
				end
			end
			return_value = true
		else
			return_value = false
			@guess_array << player_guess
		end

		temp_arr.each do |value|
			@blank_array[value] = player_guess
		end
		return return_value
	end

	def game
		counter = @guess_array.length
		puts "\n"

		puts self.image(counter)

		while counter < 6
			attempt = self.guess
			if attempt
				puts self.image(counter)
				puts "Success!\n"
				puts @blank_array.join(" ")
			else
				
				counter += 1
				puts self.image(counter)
				puts "Failure\n"
				puts @blank_array.join(" ")
			end

			if !@blank_array.include?("_")
				puts "YOU WIN!!!!"
				puts "YOU HAVE SAVED THIS MAN FROM DEATH"
				exit
			elsif counter == 6
				puts "YOU'VE FAILED"
				puts "YOUR KNOWLEDGE OF WORDS DID NOT SAVE THE MAN"
				puts "The word was \"#{@word}\""
				exit
			end
		end
	end

	def image(num)
		#makes the hangman image
		case num
		when 0
			"_____\n     |\n     |\n     |\n_____|"
		when 1
			"_____\n o   |\n     |\n     |\n_____|"
		when 2
			"_____\n o   |\n |   |\n     |\n_____|"
		when 3
			"_____\n o/  |\n |   |\n     |\n_____|"
		when 4
			"_____\n\\o/  |\n |   |\n     |\n_____|"
		when 5
			"_____\n\\o/  |\n |   |\n/    |\n_____|"
		when 6
			"_____\n\\o/  |\n |   |\n/ \\  |\n_____|"
		end
	end

	def save_game
	    save = YAML.dump({
	    	:word_array => @@word_array,
			:word => @word,
			:blank_array => @blank_array,
			:guess_array => @guess_array
	    })

	    Dir.mkdir("SavedGames") unless Dir.exists?("SavedGames")
	    filename = "SavedGames/Save.txt"
	    File.open(filename, 'w') do |file|
	      file.puts save
	    end
  	end
end

def load_game
	load_file = YAML::load(File.open("SavedGames/Save.txt"))
	myboard = Board.new(load_file[:word], load_file[:blank_array], load_file[:guess_array])
	return myboard
end

def starting_sequence
	puts "We will generate a random word."
	sleep(1)
	puts "You will try to figure out what the word is by guessing one letter at a time."
	sleep(1)
	puts "If you fail 6 times, we will put a man to death."
	sleep(1)

	file = File.readlines "../5desk.txt"
	my_word = file[rand(file.length-1)].strip

	my_blank_array = []
	my_word.length.times do |x|
		my_blank_array << '_'
	end

	my_guess_array = []
	myboard = Board.new(my_word, my_blank_array, my_guess_array)
	myboard.game
end

puts "WELCOME TO HANGMAN"
sleep(1)
puts "Load saved game? (Y/N): "

load_answer = gets.chomp.downcase

if load_answer == 'y'
	begin
		load_game.game
	rescue
		puts "Error locating save file. Starting new game."
		starting_sequence
	end
else
	starting_sequence
end
