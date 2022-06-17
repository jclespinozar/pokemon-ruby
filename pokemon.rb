require_relative "pokedex/pokemons"

class Pokemon
  def initialize(name, type, level)
    char_details = Pokedex::POKEMON[type]
    @name = name
    @type = type
    
    @max_health = char_details[:base_stats][:hp]
    @speed = char_details[:base_stats][:speed]
    @attack = char_details[:base_stats][:attack]
    @defense = char_details[:base_stats][:defense]
    @satack = char_details[:base_stats][:special_attack]
    @sdefense = char_details[:base_stats][:special_defense]
    @moves = char_details[:moves]
    @ms = char_details[:growth_rate]
    @efftype = char_details[:effort_points][:type]
    @effsattack = char_details[:effort_points][:special_attack]
    @effamount = char_details[:effort_points][:amount]
    
    @level = level
    @health = nil
    @current_move = nil
    
    if level == 1
      @experience = 0
    else
      @experience = char_details[:base_exp]
    end
  end

  def prepare_for_battle
    @health = @max_health
    @current_move = nil
  end

  def receive_damage(damage)
    @health -= damage
  end

  def set_current_move
    # Complete this
  end

  def fainted?
    !@health.positive?
  end

  def attack(target)
    # Accuracy check
    # If the movement is not missed
    # -- Calculate base damage~~~~
    # -- Critical Hit check
    # -- If critical, multiply base damage and print message 'It was CRITICAL hit!'
    # -- Effectiveness check
    hits = @current_move[:accuracy] >= rand(1..100)
    multi = @current_move[:multiplier] >= rand(0..2)
    puts "#{@name} used #{@current_move[:name]}!"
    if hits
      other.receive_damage(@current_move[:power])
      if multi > 0 && multi <= 0.5     
        puts "It's not very effective..."
        puts "And it hit #{other.name} with #{@current_move[:power]} damage"
      elsif multi >= 1.5
        puts "It's super effective!"
        puts "And it hit #{other.name} with #{@current_move[:power]} damage"
      elsif multi == 0
        puts "It doesn't affect #{other.name}!"
        puts "And it hit #{other.name} with #{@current_move[:power]} damage"
      else
        puts "And it hit #{other.name} with #{@current_move[:power]} damage"
    else
      puts "#{@name} it MISSED!"
    end
  end

  def increase_experience(defeat_character)
    @experience = ((@experience * level) / 7.0).floor
  end
  end

  def increase_stats(target)
    if increase_experience(defeat_character) >= @ms
      puts "#{name} reached level #{level}!"
    end
  end


end
