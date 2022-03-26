# frozen_string_literal: true

class Explosion < GameObject
  attr_accessor :x, :y

  def initialize(object_pool, x, y)
    super(object_pool)
    @x = x
    @y = y
    ExplosionGraphics.new(self)
    ExplosionSounds.play(self, object_pool.camera)
    inflict_damage
    Damage.new(@object_pool, @x, @y) if @object_pool.map.can_move_to?(x, y)
  end

  def effect?
    true
  end

  private

  def inflict_damage
    object_pool.nearby(self, 100).each do |obj|
      next unless obj.instance_of?(Tank)

      obj.health.inflict_damage(
        Math.sqrt(3 * 100 - Utils.distance_between(
          obj.x, obj.y, x, y
        ))
      )
    end
  end
end
