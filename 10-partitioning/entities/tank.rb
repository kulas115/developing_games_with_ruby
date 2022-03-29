# frozen_string_literal: true

class Tank < GameObject
  SHOOT_DELAY = 500

  attr_accessor :throttle_down, :direction, :gun_angle, :sounds, :physics, :graphics, :health, :input

  def initialize(object_pool, input)
    x, y = object_pool.map.spawn_point
    super(object_pool, x, y)
    @input = input
    @input.control(self)
    @health = TankHealth.new(self, object_pool)
    @physics = TankPhysics.new(self, object_pool)
    @graphics = TankGraphics.new(self)
    @sounds = TankSounds.new(self, object_pool)
    @direction = rand(0..7) * 45
    @gun_angle = rand(0..360)
  end

  def box
    @physics.box
  end

  def effect?
    false
  end

  def shoot(target_x, target_y)
    if can_shoot?
      @last_shot = Gosu.milliseconds
      Bullet.new(object_pool, @x, @y, target_x, target_y).fire(self, 1500)
    end
  end

  def can_shoot?
    Gosu.milliseconds - (@last_shot || 0) > SHOOT_DELAY
  end

  def on_collision(object)
    return unless object

    # Avoid recursion
    if object.instance_of?(Tank)
      # Inform AI about hit
      object.input.on_collision(object)
    else
      # Call only on non-tanks to avoid recursion
      object.on_collision(self)
    end
    # Bullets should not slow tanks down
    @sounds.collide if object.class != Bullet && (@physics.speed > 1)
  end
end
