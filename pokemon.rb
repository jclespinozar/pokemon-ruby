require_relative "pokedex/pokemons"

class Pokemon
  attr_reader :name, :type, :health, :stats, :element_type, :moves, :current_move, :base_exp, :experience, :level
  def initialize(name, type, level)    
    char_details = Pokedex::POKEMONS[type]
    @type = char_details[:species]
    @element_type = char_details[:type]
    @base_exp = char_details[:base_exp]
    @growth_rate = char_details[:growth_rate]
    @base_stats = char_details[:base_stats]
    @effort_points = char_details[:effort_points]
    @moves = char_details[:moves]
    @name = name
    @level = level
    @stat_individual_values = calculate_individual_values
    @stat_effort_values = calculate_effort_values
    @experience = calculate_experience
    
    update_stats
    @health = nil
    @current_move = nil
  end

  def prepare_for_battle
    @health = @stats[:hp]
    @current_move = nil
  end
  
  def update_stats
    @stats = calculate_total_stats
  end

  def receive_damage(damage)
    @health -= damage
  end

  def set_current_move(selected_move)
    @current_move = Pokedex::MOVES.select{|move, data| move == selected_move}.values.first
  end

  def fainted?
    !@health.positive?
  end

  def attack(other)
    puts ("--------------------------------------------------")
    puts "#{@name} used #{@current_move[:name]}!"
    # Accuracy check
    hits = @current_move[:accuracy] >= rand(1..100)
    # If the movement is not missed
    if hits
      # -- Calculate base damage~~~~
      offensive_stat = calculate_offensive_stat
      move_power = @current_move[:power]
      target_defensive_stat = calculate_target_defensive_stat(other)
      damage = calculate_damage(offensive_stat, move_power, target_defensive_stat)
      # -- Critical Hit check
      critical_hit = rand(1..16) == 1 ? 1.5 : 1
      # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
      damage *= critical_hit
      # -- Effectiveness check
      effectiveness = get_effectiveness(other)
      damage *= effectiveness
      multi = rand(0..2)
      other.receive_damage(damage.floor)
      if multi > 0 && multi <= 0.5     
        puts "It's not very effective..."
        puts "And it hit #{other.name} with #{damage.floor} damage"
      elsif multi >= 1.5
        puts "It's super effective!"
        puts "And it hit #{other.name} with #{damage.floor} damage"
      elsif multi == 0
        puts "It doesn't affect #{other.name}!"
        puts "And it hit #{other.name} with #{damage.floor} damage"
      else
        puts "And it hit #{other.name} with #{damage.floor} damage"
      end
    else
      puts "#{@name} it MISSED!"
    end
  end

  def increase_experience(defeat_character)
    experience_gained = ((defeat_character.base_exp * defeat_character.level) / 7.0).floor
    puts "#{@name} gained #{experience_gained} experience points"
    @experience += experience_gained
  end

  def level_up?
    @experience >= Pokedex::LEVEL_TABLES[@growth_rate][@level]
  end

  def increase_level
    @level += 1
    puts "#{@name} reached level #{@level}!"
  end

  def increase_effort_stats
    @stat_effort_values[@effort_points[:type]] += @effort_points[:amount]
  end

  private
  def calculate_experience
    @level != 1 ? Pokedex::LEVEL_TABLES[@growth_rate][@level] : 0
  end

  def calculate_effort_values
    @base_stats.map{|k, v| [k, 0]}.to_h
  end

  def calculate_individual_values
    @base_stats.map{|stat, v| [stat, rand(0..31)]}.to_h
  end

  def calculate_hp
    ((2 * @base_stats[:hp] + @stat_individual_values[:hp] + @stat_effort_values[:hp]) * @level / 100 + @level + 10).floor
  end

  def calculate_other_stats(stat)
    ((2 * @base_stats[stat] + @stat_individual_values[stat] + @stat_effort_values[stat]) * @level / 100 + 5).floor
  end

  def calculate_total_stats
    @base_stats.map{|stat, v| [stat, stat != :hp ? calculate_other_stats(stat) : calculate_hp]}.to_h
  end

  def calculate_offensive_stat
    Pokedex::SPECIAL_MOVE_TYPE.include?(@current_move[:type]) ? @stats[:special_attack] : @stats[:attack]
  end

  def calculate_target_defensive_stat(other)
    Pokedex::SPECIAL_MOVE_TYPE.include?(@current_move[:type]) ? other.stats[:special_defense] : other.stats[:defense]
  end

  def get_effectiveness(target)
    multiplier = 1
    for type in target.element_type do
      type_multiplier = Pokedex::TYPE_MULTIPLIER.select{|item|  item[:user] == @current_move[:type] && item[:target] == type}
      multiplier *= type_multiplier.length != 0 ? type_multiplier.first[:multiplier]  : 1
    end
    multiplier
  end

  def calculate_damage(offensive_stat, move_power, target_defensive_stat)
    (((2 * @level / 5.0 + 2).floor * offensive_stat * move_power / target_defensive_stat).floor / 50.0).floor + 2
  end
end
