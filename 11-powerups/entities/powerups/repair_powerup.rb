# frozen_string_literal: true

class RepairPowerup < Powerup
  def pickup(object)
    if object.instance_of?(Tank)
      object.health.restore if object.health.health < 100
      true
    end
  end

  def graphics
    :repair
  end
end
