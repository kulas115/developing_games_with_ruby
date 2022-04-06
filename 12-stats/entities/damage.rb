# frozen_string_literal: true

class Damage < GameObject
  MAX_INSTANCES = 300

  @@instances = []

  def initialize(object_pool, x, y)
    super
    DamageGraphics.new(self)
    track(self)
  end

  def effect?
    true
  end

  private

  def track(instance)
    if @@instances.size < MAX_INSTANCES
    else
      out = @@instances.shift
      out.mark_for_removal
    end
    @@instances << instance
  end
end
