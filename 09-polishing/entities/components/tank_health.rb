# frozen_string_literal: true

class TankHealth < Component
  attr_accessor :health

  def initialize(object, object_pool)
    super(object)
    @object_pool = object_pool
    @health = 100
    @health_updated = true
    @last_damage = Gosu.milliseconds
  end

  def update
    update_image
  end

  def update_image
    if @health_updated
      if dead?
        text = '✝'
        font_size = 25
      else
        text = @health.to_s
        font_size = 18
      end
      @image = Gosu::Image.from_text(
        text, font_size, font: Gosu.default_font_name
      )
      @health_updated = false
    end
  end

  def dead?
    @health < 1
  end

  def inflict_damage(amount)
    if @health.positive?
      @health_updated = true
      @health = [@health - amount.to_i, 0].max
      Explosion.new(@object_pool, x, y) if @health < 1
    end
  end

  def draw(_viewport)
    @image.draw(
      x - @image.width / 2,
      y - object.graphics.height / 2 -
      @image.height, 100
    )
  end
end
