#How to play this file!  Open the command line, type "irb" then type "load 'text_adventure.rb'" whenever you want to play!  The game will quit itself if you win or lose.  Load the file again to replay.


class Dungeon
	attr_accessor :player

	def initialize(player_name)
		@player = Player.new(player_name)
		@rooms = []
	end

	def add_room(reference, name, description, connections, eat_description, eatlethal, play_description, playlethal, win)
		@rooms << Room.new(reference, name, description, connections, eat_description, eatlethal, play_description, playlethal, win)
	end

	def start(location)
		@player.location = location
		show_current_description
		puts "\n"
	end

	def show_current_description
		puts find_room_in_dungeon(@player.location).full_description
		puts "\nWhat would you like to do next? Select \"Eat\", \"Play\", \"Explore\" or Exit\n"
	end

	def show_eat_description
		puts  "\n" + find_room_in_dungeon(@player.location).eat_description
	end

	def show_play_description
		puts "\n" + find_room_in_dungeon(@player.location).play_description
	end

	def find_room_in_dungeon(reference)
		@rooms.detect{ |room| room.reference == reference}
	end

	def find_room_in_direction(direction)
		find_room_in_dungeon(@player.location).connections[direction]
	end

	def prompt(selection)
		unless selection == "eat" || selection =="play" || selection =="explore" || selection == "exit" || @player.dead === true
			puts "\nSelect Eat, Play, Explore or Exit\n"
			selection = gets.chomp.downcase
		end

		case selection
		when "explore" 
			puts "\nWhich direction? North, South, East or West.\n"
			direction = gets.chomp.downcase
			unless direction == "north" || direction == "south" ||  direction == "east" ||  direction == "west" || direction == "exit"
				puts "\nSelect a valid drection, north south east or west.\n"
				direction = gets.chomp.downcase
			end
			go(direction.to_sym)
		when "eat"
			show_eat_description
			if(find_room_in_dungeon(@player.location).eatlethal)
				puts "GAME OVER #{@player.name}"
				@player.dead = true
			else
				puts "\n What would you like to do next? Select \"Eat\", \"Play\", or \"Explore\" or Exit\n"
			end
		when "play"
			show_play_description
			if(find_room_in_dungeon(@player.location).playlethal)
				puts "GAME OVER #{@player.name}"
				@player.dead = true
			elsif (find_room_in_dungeon(@player.location).win)
				puts "YOU WON, #{@player.name}!"
				@player.won = true
			else
				puts "\n What would you like to do next? Select \"Eat\", \"Play\", or \"Explore\" or Exit\n"
			end
		when "exit"
			puts "Goodbye breakfast-naut"
			@player.dead = true
		else
			puts "Invalid selection.  Say again?"
		end
	end

	def go(direction)
		if find_room_in_direction(direction) != nil
			puts "You go  #{direction.to_s} and find yourself in... \n\n"
			@player.location = find_room_in_direction(direction)
			show_current_description
		else
			puts "\nYou try to go #{direction} but soon reach a magnetic forcefield and must turn around"
		end
	end

	class Player
		attr_accessor :name, :location, :dead, :won

		def initialize(name)
			@name = name
			@dead = false
			@won = false
		end
	end

	class Room
		attr_accessor :reference, :name, :description, :connections, :eat_description, :eatlethal, :play_description, :playlethal, :win

		def initialize(reference, name, description, connections, eat_description, eatlethal, play_description, playlethal, win)
			@reference = reference
			@name = name
			@description = description
			@connections = connections
			@eat_description = eat_description
			@eatlethal = eatlethal
			@play_description = play_description
			@playlethal = playlethal
			@win = win
		end


		def full_description
			@name + "\n\nYou are in " + @description
		end
	end
end


	puts "\nWelcome to 
	\n==BREAKFAST GALAXY QUEST== \n\n"
	puts "Player, what is your name?"
	player_name = gets.chomp
	new_game = Dungeon.new(player_name)
	# initalizing locations
	new_game.add_room(:pancakenebula, "THE PANCAKE NEBULA", "a hazy region just north of Orion's griddle contain billions of pancake asteroids of all sizes.  They are as fluffy as they are delicious.", {:south => :orionsgriddle, :north => :baconbelt, :east => :celestialcrepes, :west => :browndwarfbagels}, "These pancakes are delicious!  The are perfectly browned with a hint of space-spice.  Uh oh.  You are now addicted to spice.", false, "You try playing with the pancakes a little too violently and a medium-sized cake spins out of control, thwaping you on the helmet causing you to lose consciousness briefly.", false, false)

	new_game.add_room(:orionsgriddle, "ORION'S GRIDDLE", "an area in which mysterious magnetism between the angle of nearby stars combined with a fortunate shipwreck of egg cargo has resulted in a seemingly neverending supply of perfectly cooked, zero-gravity formed scrambled eggs.", {:north => :pancakenebula}, "You take a bite and the eggs are magnificent! You didn't know scrambled eggs could be so good!", false, "You attempt to play with the eggs but they form a face on your plate that looks distinctly disapproving.  All the other space-diners stop and stare.  The space-record-needle swerves off the tracks.  You have committed an intergalactic space crime.  The burliest chef comes out of the kitchen and the last thing you remember is a frying pan quickly approaching your face plate...", true, false)

	new_game.add_room(:baconbelt, "THE BACON BELT", "a vast expanse of bacon strips in ring formation that spans the entire circumfrence of Breakfast-Saturn, the Bacon belt rings vary in crispyness according to their proximity to the celestial body.  For well-done, try the outermost ring!.", {:south => :pancakenebula}, "You choose bacon on the crispier side and have fallen into a trance, a bacon-trance.  You start imagining moving to the bacon belt, permanently.", false, "You try playing with bacon but run out of ideas, fast.  Zero-gravity isn't very conducive to bacon art.", false, false)

	new_game.add_room(:celestialcrepes, "CELESTIAL CREPES", "a mysterious location in which crepes are as delicious as they are dangerous. These massive, moon-sized crepes are edible and benign until they reach maturity, at which time they gain sentience and the ability to swallow breakfast-nauts whole, like a venus fly trap would swallow an unassuming gnat.  Their jam, accordingly, is dangerous to harvest and commands a great price in the intergalactic cafeteria.", {:west => :pancakenebula}, "You carefully select a crepe with your space fork, but you selected wrong!  This medium-size crape expands in size drastically as its delicious-looking jaws open wide to eat YOU for breakfast! Death by crepes.", true, "Instead of attempting to eat these beautiful creatures you tickle one with your fork.  It smiles in friendship and the crepes form a space-sofa to carry you as their new space emperor.", false, true)

	new_game.add_room(:browndwarfbagels, "BROWN DWARF BAGELS", "a zone formerly occuped by a star that went brown dwarf and thus did not achieve sufficient energy to explode.  An enterprising breakfast-naut by the name of Hans saw the opportunity here to open a planet-sized delicatessen, harnessing the area's natural toasty-ness. They are famous for their bagels and brag a 'bagel event horizon' radius of 50 miles!", {:east => :pancakenebula}, "You attempt to eat a brown dwarf bagel...and succeed!  Space lox and celestial cream cheese appear out of nowhere to make your space bagel more delicious.", false, "You try playing with your bagel but the bagel takes it too seriously and turns into a bready-black hole, engulfing you, the entire restaurant and the full galaxy, without even chewing.  As a result the bagel is slightly bigger, but no one is around to notice.", true, false)
	#end intializing locations


	puts "\n#{new_game.player.name}, you have just completed your one THOUSANDTH illustrious space mission and
have been awarded one round-trip hyper-space voyage to the ==BREAKFAST GALAXY==. The hyper-space arrival doc is located directly in...\n\n"

	new_game.start(:pancakenebula)
	selection = gets.chomp.downcase
	while(selection != "exit")
		new_game.prompt(selection)
		if new_game.player.dead || new_game.player.won
			break
		else
		selection = gets.chomp.downcase
		end
	end






