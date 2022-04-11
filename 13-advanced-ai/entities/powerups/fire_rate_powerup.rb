# frozen_string_literal: true

class FireRatePowerup < Powerup
  def pickup(object)
    if object.instance_of?(Tank)
      object.fire_rate_modifier += 0.25 if object.fire_rate_modifier < 2
      true
    end
  end

  def graphics
    :straight_gun
  end
end
