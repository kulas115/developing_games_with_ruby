# frozen_string_literal: true

class PowerupSounds
  class << self
    def play(object, camera)
      volume, pan = Utils.volume_and_pan(object, camera)
      sound.play(object.object_id, pan, volume)
    end

    private

    def sound
      @@sound ||= StereoSample.new(
        Utils.media_path('powerup.mp3')
      )
    end
  end
end
