# frozen_string_literal: true

class TankSounds < Component
  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
  end

  def update
    id = object.object_id
    if object.physics.moving?
      move_volume = Utils.volume(
        object, @object_pool.camera
      )
      pan = Utils.pan(object, @object_pool.camera)
      if driving_sound.paused?(id)
        driving_sound.resume(id)
      elsif driving_sound.stopped?(id)
        driving_sound.play(id, pan, 0.5, 1, true)
      end
      driving_sound.volume_and_pan(id, move_volume * 0.5, pan)
    elsif driving_sound.playing?(id)
      driving_sound.pause(id)
    end
  end

  def collide
    vol, pan = Utils.volume_and_pan(
      object, @object_pool.camera
    )
    crash_sound.play(object_id, pan, vol, 1, false)
  end

  private

  def driving_sound
    @@driving_sound ||= StereoSample.new(
      Utils.media_path('tank_driving.mp3')
    )
  end

  def crash_sound
    @@crash_sound ||= StereoSample.new(
      Utils.media_path('crash.ogg')
    )
  end
end
