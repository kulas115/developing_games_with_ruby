# frozen_string_literal: true

class TankHealth < Health
  RESPAWN_DELAY = 5000
  attr_accessor :health

  def initialize(object, object_pool)
    super(object, object_pool, 100, true)
  end

  def should_respawn?
    Gosu.milliseconds - @death_time > RESPAWN_DELAY
  end

  def after_death
    @death_time = Gosu.milliseconds
  end

  protected

  def draw?
    true
  end
end
