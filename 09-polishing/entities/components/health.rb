# frozen_string_literal: true

class Health < Component
  attr_accessor :health

  def initialize(object, object_pool, health, explodes)
    super(object)
    @explodes = explodes
    @object_pool = object_pool
    @initial_health = @health = health
    @health_updated = true
  end

  def restore
    @health = @initial_health
    @health_updated = true
  end

  def dead?
    @health < 1
  end

  def update
    update_image
  end

  def inflict_damage(amount)
    if @health.positive?
      @health_updated = true
      @health = [@health - amount.to_i, 0].max
      after_death if dead?
    end
  end

  def draw(_viewport)
    return unless draw?

    @image&.draw(
      x - @image.width / 2,
      y - object.graphics.height / 2 - @image.height, 100
    )
  end

  protected

  def draw?
    $debug
  end

  def update_image
    return unless draw?

    if @health_updated
      text = @health.to_s
      font_size = 18
      @image = Gosu::Image.from_text(
        text, font_size, font: Gosu.default_font_name
      )
    end
  end

  def after_death
    if @explodes
      if Thread.list.count < 8
        Thread.new do
          sleep(rand(0.1..0.3))
          Explosion.new(@object_pool, x, y)
          sleep 0.3
          object.mark_for_removal
        end
      else
        Explosion.new(@object_pool, x, y)
        object.mark_for_removal
      end
    else
      object.mark_for_removal
    end
  end
end
