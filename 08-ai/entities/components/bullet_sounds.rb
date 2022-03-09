# frozen_string_literal: true

class BulletSounds
  class << self
    def play
      sound.play
    end

    private

    def sound
      @@sound ||= Gosu::Sample.new(
        Utils.media_path('fire.mp3')
      )
    end
  end
end
