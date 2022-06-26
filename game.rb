# require neccesary files
require 'colorize'
require_relative "get_input"
require_relative "player"
require_relative "pokedex/pokemons"
require_relative "battle"

class Game
  include GetInput
  def start
    # Create a welcome method(s) to get the name, pokemon and pokemon_name from the user
    @name = get_name
    @pokemon_type = get_pokemon_type(@name)
    @pokemon_name = get_pokemon_name(@name, @pokemon_type)
    puts("#{@name}, raise your young #{@pokemon_name} by making it fight!\
      \nWhen you feel ready you can challenge BROCK, the PEWTER's GYM LEADER"
    )

    # Then create a Player with that information and store it in @player
    @player = Player.new(@name, @pokemon_name, @pokemon_type,1)
    
    # Suggested game flow
    action = menu
    until action == "Exit"
      case action
      when "Train"
        train
        action = menu
      when "Leader"
        challenge_leader
        action = menu
      when "Stats"
        show_stats
        action = menu
      end
    end

    goodbye
  end

  def train
    bot = BotTrain.new
    puts(
      "#{@name} challenge #{bot.name} for training\
      \n#{bot.name} has a #{bot.pokemon.type} level #{bot.pokemon.level}\
    ")
    option = get_with_options("What "+"do".colorize(:blue)+" you want to "+"do".colorize(:blue)+" now?", ["Fight", "Leave"])
    if option == "Fight"
      battle = Battle.new(@player, bot)
      battle.start
    end
  end

  def challenge_leader
    bot = BotGym.new
    puts(
      "#{@name} challenge #{bot.name} "+"for".colorize(:blue)+" a fight\
      \n#{bot.name} has a #{bot.pokemon.type} level #{bot.pokemon.level}\
    ")
    option = get_with_options("What "+"do".colorize(:blue)+" you want to "+"do".colorize(:blue)+" now?", ["Fight", "Leave"])
    if option == "Fight"
      battle = Battle.new(@player, bot)
      battle.start
    end
    puts(
      "Congratulation! You have won the game!\
      \nYou can "+"continue".colorize(:green)+" training your Pokemon "+"if".colorize(:blue)+" you want"
    )
  end

  def show_stats
    pokemon = @player.pokemon
    puts(
      "\n#{pokemon.name}:\
      \nKind: #{pokemon.type}\
      \nLevel: #{pokemon.level}\
      \nType: #{pokemon.element_type.join(", ")}\
      \nStats:\
      \nHP: #{pokemon.stats[:hp]}\
      \nAttack: #{pokemon.stats[:attack]}\
      \nDefense: #{pokemon.stats[:defense]}\
      \nSpecial Attack: #{pokemon.stats[:special_attack]}\
      \nSpecial Defense: #{pokemon.stats[:special_defense]}\
      \nSpeed: #{pokemon.stats[:speed]}\
      \nExperience Points: #{pokemon.experience}\
      ")
  end

  def goodbye
    puts(
      "Thanks for playing Pokemon Ruby\
      \nThis game was created with love by: JOse CArlos Lucio Espinoza Rivas"
    )
  end

  def menu
    get_with_options("-----------------------Menu-----------------------\n\n",%w[Stats Train Leader Exit])
  end
  
  private

  def get_name
    puts(
      "#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#\
      \n#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#\
      \n#$##$##$##$ ---        Pokemon Ruby         --- #$##$##$#$#\
      \n#$#$#$#$#$#$#$                               $#$#$#$#$#$#$#\
      \n#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#$#\n".colorize(:green)
    )
    
    puts(
      "Hello there! Welcome to the world of POKEMON! My name is OAK!\
      \nPeople call me the POKEMON PROF!
      \
      \nThis world is inhabited by creatures called POKEMON! For some\
      \npeople, POKEMON are pets. Others use them for fights. Myself...\
      \nI study POKEMON as a profession."
    )
    get_input("First, what is your name?")
  end

  def get_pokemon_type(name)
    puts(
      "Right! So your name is #{name}!\
      \nYour very own POKEMON legend is about to unfold! A world of\
      \ndreams and adventures with POKEMON awaits! Let's go!\
      \nHere, #{name}! There are 3 POKEMON here! Haha!\
      \nWhen I was young, I was a serious POKEMON trainer.\
      \nIn my old age, I have only 3 left, but you can have one! Choose!\
      \n "
    )
    get_with_options("", %w[Bulbasaur Charmander Squirtle])
  end

  def get_pokemon_name(name, pokemon_type)
    puts(
      "\nYou selected #{pokemon_type}. Great choice!\
      \nGive your pokemon a name?"
    )
    print(">")
    pokemon_name = gets.chomp
    pokemon_name.empty? ? pokemon_type : pokemon_name
  end
end

game = Game.new
game.start
