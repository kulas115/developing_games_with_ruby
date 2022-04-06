# frozen_string_literal: true

class Explosion < GameObject
  def initialize(object_pool, x, y)
    super
    @object_pool = object_pool
    Damage.new(@object_pool, x, y) if @object_pool.map.can_move_to?(x, y)
    ExplosionGraphics.new(self)
    ExplosionSounds.play(self, object_pool.camera)
    inflict_damage
  end

  def effect?
    true
  end

  private

  def inflict_damage
    object_pool.nearby(self, 100).each do |obj|
      next unless obj.respond_to?(:health)

      obj.health.inflict_damage(
        Math.sqrt(3 * 100 - Utils.distance_between(
          obj.x, obj.y, @x, @y
        ))
      )
    end
  end
end
