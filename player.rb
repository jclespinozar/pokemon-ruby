require_relative "pokedex/pokemons"
require_relative "pokedex/moves"
require_relative "pokemon"
require_relative "get_input"

class Player
  # (Complete parameters)
  include GetInput
  attr_reader :pokemon, :name 

  def initialize(name, pokemon_name, species, level)
    # Complete this
    @name = name
    @pokemon = Pokemon.new(pokemon_name, species, level)
  end

  def select_move
    # Complete this
    move = get_moves("#{@name} "+"select".colorize(:blue)+" your move", @pokemon.moves.map{|x| x.capitalize}).downcase
    @pokemon.set_current_move(move)
  end
  private
  def get_moves(prompt, moves)
    get_with_options(prompt, moves)
  end
end

# Create a class Bot that inherits from Player and override the select_move method
class Bot < Player
  def select_move
    move = @pokemon.moves.sample
    @pokemon.set_current_move(Pokedex::MOVES[move])
  end
end
#Gymleader
class BotGym < Bot
  def initialize
    super("Brock", "Onix", "Onix", 10)
  end

  def select_move
    move = @pokemon.moves.sample
    @pokemon.set_current_move(Pokedex::MOVES[move])
  end
end
#Train with random person
class BotTrain < Bot
  def initialize
    list_pokemons = Pokedex::POKEMONS.keys
    selected_pokemon = list_pokemons.sample
    #selected_pokemon = "Spearow"
    level = rand(1..10)
    #level =1
    super("Random Person", selected_pokemon, selected_pokemon.capitalize, level)
  end

  def select_move
    move = @pokemon.moves.sample
    @pokemon.set_current_move(Pokedex::MOVES[move][:name])
  end
end
