# frozen_string_literal: true

class TankPhysics < Component
  attr_accessor :speed

  def initialize(game_object, object_pool)
    super(game_object)
    @object_pool = object_pool
    @map = object_pool.map
    game_object.x, game_object.y = @map.find_spawn_point
    @speed = 0.0
  end

  def can_move_to?(x, y)
    @map.can_move_to?(x, y)
  end

  def moving?
    @speed.positive?
  end

  def update
    if object.throttle_down
      accelarate
    else
      decelerate
    end
    if @speed.positive?
      new_x = x
      new_y = y
      shift = Utils.adjust_speed(@speed)
      case @object.direction.to_i
      when 0
        new_y -= shift
      when 45
        new_x += shift
        new_y -= shift
      when 90
        new_x += shift
      when 135
        new_x += shift
        new_y += shift
      when 180
        new_y += shift
      when 225
        new_y += shift
        new_x -= shift
      when 270
        new_x -= shift
      when 315
        new_x -= shift
        new_y -= shift
      end
      if can_move_to?(new_x, new_y)
        object.x = new_x
        object.y = new_y
      else
        object.sounds.collide if @speed > 1
        @speed = 0.0

      end
    end
  end

  private

  def accelarate
    @speed += 0.08 if @speed < 5
  end

  def decelerate
    @speed -= 0.5 if @speed.positive?
    @speed = 0.0 if @speed < 0.01 # damp
  end
end
