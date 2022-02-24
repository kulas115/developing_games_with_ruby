# frozen_string_literal: true

class ExplosionSounds
  class << self
    sounds.play
  end

  private

  def sound
    @@sound ||= Gosu::Sample.new(
      @window, Utils.media_path('explosion.mp3')
    )
  end
end
