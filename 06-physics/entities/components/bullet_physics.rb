# frozen_string_literal: true

class BulletPhysics < Component
  START_DIST = 20
  MAX_DIST = 300

  def initialize(game_object, object_pool)
    super(game_object)
    @object_pool = object_pool
    object.x, object.y = point_at_distance(START_DIST)
    object.target_x, object.target_y = point_at_distance(MAX_DIST) if trajectory_lenght > MAX_DIST
  end

  def update
    fly_speed = Utils.adjust_speed(object.speed)
    fly_distance = (Gosu.milliseconds - object.fired_at) * 0.001 * fly_speed
    object.x, object.y = point_at_distance(fly_distance)
    check_hit
    object.explode if arrived?
  end

  def trajectory_lenght
    Utils.distance_between(object.target_x, object.target_y, x, y)
  end

  def point_at_distance(distance)
    return [object.target_x, object.target_y] if distance > trajectory_lenght

    distance_factor = distance.to_f / trajectory_lenght
    p_x = x + (object.target_x - x) * distance_factor
    p_y = y + (object.target_y - y) * distance_factor
    [p_x, p_y]
  end

  private

  def check_hit
    # require 'pry'; binding.pry
    @object_pool.nearby(object, 50).each do |obj|
      next if obj == object.source # Don't hit source tank

      next unless Utils.point_in_poly(x, y, *obj.box)

      obj.health.inflict_damage(20)
      object.target_x = x
      object.target_y = y
      return
    end
  end

  def arrived?
    x == object.target_x && y == object.target_y
  end
end
