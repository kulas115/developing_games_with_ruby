# frozen_string_literal: true

class HealthPowerup < Powerup
  def pickup(object)
    object.health.increase(25) if object.instance_of?(Tank)
  end

  def graphics
    :life_up
  end
end
