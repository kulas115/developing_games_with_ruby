# frozen_string_literal: true

class TankSpeedPowerup < Powerup
  def pickup(object)
    if object.instance_of?(Tank)
      object.speed_modifier += 0.10 if object.speed_modifier < 1.5
      true
    end
  end

  def graphics
    :wingman
  end
end
