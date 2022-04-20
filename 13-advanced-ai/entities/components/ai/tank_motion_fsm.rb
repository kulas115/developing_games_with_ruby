# frozen_string_literal: true

class TankMotionFSM
  STATE_CHANGE_DELAY = 500
  LOCATION_CHECK_DELAY = 5000

  def initialize(object, vision, gun)
    @object = object
    @vision = vision
    @gun = gun
    @roaming_state = TankRoamingState.new(object, vision)
    @fighting_state = TankFightingState.new(object, vision)
    @fleeing_state = TankFleeingState.new(object, vision, gun)
    @chasing_state = TankChasingState.new(object, vision, gun)
    @stuck_state = TankStuckState.new(object, vision, gun)
    @navigating_state = TankNavigatingState.new(object, vision)
    set_state(@roaming_state)
  end

  def on_collision(with)
    @current_state.on_collision(with)
  end

  def on_damage(_amount)
    set_state(@fighting_state) if @current_state == @roaming_state
  end

  def draw(_viewport)
    if $debug
      @image&.draw(
        @object.x - @image.width / 2,
        @object.y + @object.graphics.height / 2 - @image.height, 100
      )
    end
  end

  def update
    choose_state
    @current_state.update
  end

  def set_state(state)
    return unless state
    return if state == @current_state

    @last_state_change = Gosu.milliseconds
    @current_state = state
    state.enter
    if $debug
      @image = Gosu::Image.from_text(
        state.class.to_s, 18, font: Gosu.default_font_name
      )
    end
  end

  def choose_state
    set_state(@navigating_state) if !@vision.can_go_forward? && @current_state != @stuck_state
    # Keep unstucking itself for a while
    change_delay = STATE_CHANGE_DELAY
    change_delay *= 5 if @current_state == @stuck_state

    now = Gosu.milliseconds

    return unless now - @last_state_change > change_delay

    if @last_location_update.nil?
      @last_location_update = now
      @last_location = @object.location
    end

    if now - @last_location_update > LOCATION_CHECK_DELAY && !(@last_location.nil? || @current_state.waiting?) && (Utils.distance_between(
      *@last_location, *@object.location
    ) < 20)
      set_state(@stuck_state)
      @stuck_state.stuck_at = @object.location
    end

    @last_location_update = now
    @last_location = @object.location

    new_state = if @gun.target
                  if @object.health.health > 40
                    if @gun.distance_to_target > BulletPhysics::MAX_DIST
                      @chasing_state
                    else
                      @fighting_state
                    end
                  elsif @fleeing_state.can_flee?
                    @fleeing_state
                  else
                    @fighting_state
                  end
                else
                  @roaming_state
                end
    set_state(new_state)
  end
end
