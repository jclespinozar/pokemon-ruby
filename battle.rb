class Battle
  # (complete parameters)
  def initialize(player, bot)
    @player = player
    @bot = bot
  end

  def start
    # Prepare the Battle (print messages and prepare pokemons)
    print_chosen_pokemons
    @player.pokemon.prepare_for_battle
    @bot.pokemon.prepare_for_battle
    # Until one pokemon faints
    battle_loop
    # Check which player won and print messages
    winner = result(@player,@bot)
    # If the winner is the Player increase pokemon stats
    increase_points(winner)
    puts "-------------------Battle Ended!-------------------"
  end

  def battle_loop
    until @player.pokemon.fainted? || @bot.pokemon.fainted?
      # --Print Battle Status
      print_battle_status
      # --Both players select their moves
      @player.select_move
      @bot.select_move
      puts ""
      # --Calculate which go first and which second
      first = attack_first(@player, @bot)
      second = first == @player ? @bot : @player
      # --First attack second
      first.pokemon.attack(second.pokemon)
      # --If second is fainted, print fainted message
      break if second.pokemon.fainted?
      # --If second not fainted, second attack first
      second.pokemon.attack(first.pokemon)
      # --If first is fainted, print fainted
      break if first.pokemon.fainted?
      puts "--------------------------------------------------"
    end
  end

  def result(user1, user2)
    winner = user2.pokemon.fainted? ? user1 : user2
    looser = winner == user1 ? user2 : user1
    puts "--------------------------------------------------"
    puts "#{looser.pokemon.name} FAINTED!"
    puts "--------------------------------------------------"
    puts "#{winner.pokemon.name} WINS!"
    winner
  end

  def attack_first(player, bot)
    player_priority = player.pokemon.current_move[:priority]
    player_speed = player.pokemon.stats[:speed]
    bot_priority = bot.pokemon.current_move[:priority]
    bot_speed = bot.pokemon.stats[:speed]
    if player_priority > bot_priority
      player
    elsif player_priority < bot_priority
      bot
    elsif player_speed > bot_speed
      player
    elsif player_speed <bot_speed
      bot
    else
      [player, bot].sample
    end
  end

  def print_battle_status
    puts (
      "#{@player.name}"+"'s #{@player.pokemon.name} - Level #{@player.pokemon.level}\
      \nHP: #{@player.pokemon.health}\
      \n#{@bot.name}".colorize(:light_red)+"'s #{@bot.pokemon.name} - Level #{@bot.pokemon.level}\
      \nHP: #{@bot.pokemon.health}\n"
    )
  end

  def print_chosen_pokemons
    puts (
      "#{@bot.name} sent out #{@bot.pokemon.name}!\
      \n#{@player.name} sent out #{@player.pokemon.name}!\
      \n-------------------Battle Start!-------------------\n "
    )
  end

  def increase_points(winner)
    if winner == @player
      @player.pokemon.increase_experience(@bot.pokemon)
      p @player.pokemon.level_up?
      @player.pokemon.increase_level if @player.pokemon.level_up?
      @player.pokemon.increase_effort_stats
      @player.pokemon.update_stats
    end
  end
end
