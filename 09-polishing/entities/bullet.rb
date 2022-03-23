# frozen_string_literal: true

class Bullet < GameObject
  attr_accessor :x, :y, :target_x, :target_y, :source, :speed, :fired_at

  def initialize(object_pool, source_x, source_y, target_x, target_y)
    super(object_pool)
    @x = source_x
    @y = source_y
    @target_x = target_x
    @target_y = target_y
    BulletPhysics.new(self, object_pool)
    BulletGraphics.new(self)
    BulletSounds.play
  end

  def box
    [x, y]
  end

  def explode
    Explosion.new(object_pool, @x, @y)
    mark_for_removal
  end

  def fire(speed)
    @source = source
    @speed = speed
    @fired_at = Gosu.milliseconds
  end

  def effect?
    false
  end
end
