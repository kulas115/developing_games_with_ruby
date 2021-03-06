# frozen_string_literal: true

class Explosion < GameObject
  attr_accessor :x, :y

  def initialize(object_pool, x, y)
    super(object_pool)
    @x = x
    @y = y
    ExplosionGraphics.new(self)
    ExplosionSounds.play
  end
end
