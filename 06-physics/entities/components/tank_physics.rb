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
    old_x = object.x
    old_y = object.y
    object.x = x
    object.y = y
    return false unless @map.can_move_to?(x, y)

    @object_pool.nearby(object, 100).each do |obj|
      next unless collides_with_poly?(obj.box)

      # Allow to get unstuck
      old_distance = Utils.distance_between(
        obj.x, obj.y, old_x, old_y
      )
      new_distance = Utils.distance_between(
        obj.x, obj.y, x, y
      )
      return false if new_distance < old_distance
    end
    true
  ensure
    object.x = old_x
    object.y = old_y
  end

  def moving?
    @speed.positive?
  end

  def box_height
    @box_height ||= object.graphics.height
  end

  def box_width
    @box_width ||= object.graphics.width
  end

  # Tank box looks like H. Vertices:
  # 1   2   5   6
  #     3   4
  #
  #    10   9
  # 12 11   8   7
  def box
    w = box_width / 2 - 1
    h = box_height / 2 - 1
    tw = 8 # track width
    fd = 8 # front depth
    rd = 6 # rear depth
    Utils.rotate(object.direction, x, y,
                 x + w,      y + h,      # 1
                 x + w - tw, y + h,      # 2
                 x + w - tw, y + h - fd, # 3
                 x - w + tw, y + h - fd, # 4
                 x - w + tw, y + h,      # 5
                 x - w,      y + h,      # 6
                 x - w,      y - h,      # 7
                 x - w + tw, y - h,      # 8
                 x - w + tw, y - h + rd, # 9
                 x + w - tw, y - h + rd, # 10
                 x + w - tw, y - h,      # 11
                 x + w,      y - h)      # 12
  end

  def update
    if object.throttle_down && !object.health.dead?
      accelarate
    else
      decelerate
    end
    if @speed.positive?
      new_x = x
      new_y = y
      speed = apply_movement_penalty(@speed)
      shift = Utils.adjust_speed(speed)
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
        object.sounds.collide if speed > 1
        speed = 0.0

      end
    end
  end

  def change_direction(new_direction)
    change = (new_direction - object.direction + 360) % 360
    change = 360 - change if change > 180
    if change > 90
      @speed = 0
    elsif change > 45
      @speed *= 0.33
    elsif change.positive?
      @speed *= 0.66
    end
    object.direction = new_direction
  end

  private

  def accelarate
    @speed += 0.08 if @speed < 5
  end

  def decelerate
    @speed -= 0.5 if @speed.positive?
    @speed = 0.0 if @speed < 0.01 # damp
  end

  def collides_with_poly?(poly)
    if poly
      poly.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *box)
      end
      box.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *poly)
      end
    end
    false
  end

  def apply_movement_penalty(speed)
    speed * (1.0 - @map.movement_penalty(x, y))
  end
end
