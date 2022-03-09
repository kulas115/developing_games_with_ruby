# frozen_string_literal: true

class ExplosionSounds
  class << self
    def play
      sound.play
    end

    private

    def sound
      @@sound ||= Gosu::Sample.new(
        Utils.media_path('explosion.mp3')
      )
    end
  end
end
