# frozen_string_literal: true

class DamageGraphics < Component
  def initialize(object_pool)
    super
    @image = images.sample
    @angle = rand(0..360)
  end

  def draw(_viewport)
    @image.draw_rot(x, y, 0, @angle)
  end

  private

  def images
    @@images ||= (1..4).map do |i|
      Gosu::Image.new(Utils.media_path("damage#{i}.png"), tileable: false)
    end
  end
end
