# frozen_string_literal: true

class ExplosionGraphics < Component
  FRAME_DELAY = 16.66

  def initialize(game_object)
    super
    @current_frame = 0
  end

  def draw(_viewport)
    image = current_frame
    image.draw(
      x - image.width / 2 + 3,
      y - image.height / 2 - 35,
      20
    )
  end

  def update
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    @last_frame = now if delta > FRAME_DELAY
    @current_frame += (delta / FRAME_DELAY).floor
    object.mark_for_removal if done?
  end

  private

  def current_frame
    animation[@current_frame % animation.size]
  end

  def done?
    @done ||= @current_frame >= animation.size
  end

  def animation
    @@animation ||= Gosu::Image.load_tiles(
      Utils.media_path('explosion.png'),
      128, 128, tileable: false
    )
  end
end
