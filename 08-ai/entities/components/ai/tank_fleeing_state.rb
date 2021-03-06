# frozen_string_literal: true

class TankFleeingState < TankMotionState
  MAX_FLEE_TIME = 15 * 1000 # 15 seconds

  def initialize(object, vision, gun)
    super(object, vision)
    @object = object
    @vision = vision
    @gun = gun
  end

  def can_flee?
    return true unless @started_fleeing

    Gosu.milliseconds - @started_fleeing < MAX_FLEE_TIME
  end

  def enter
    @started_fleeing ||= Gosu.milliseconds
  end

  def update
    change_direction if should_change_direction?
    drive
  end

  def change_direction
    @object.physics.change_direction(
      180 + @gun.desired_gun_angle - @gun.desired_gun_angle % 45
    )

    @changed_direction_at = Gosu.milliseconds
    @will_keep_direction_for = turn_time
  end

  def drive_time
    10_000
  end

  def turn_time
    rand(300..600)
  end
end
