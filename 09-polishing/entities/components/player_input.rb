# frozen_string_literal: true

class PlayerInput < Component
  # Dark green
  NAME_COLOR = Gosu::Color.argb(0xee084408)

  def initialize(name, camera, object_pool)
    super(nil)
    @name = name
    @camera = camera
    @object_pool = object_pool
  end

  def control(obj)
    self.object = obj
    obj.components << self
  end

  def on_collision(with); end

  def on_damage(amount); end

  def update
    return respawn if object.health.dead?

    # require 'pry'; binding.pry
    d_x, d_y = @camera.target_delta_on_screen
    atan = Math.atan2(($window.width / 2) - d_x - $window.mouse_x,
                      ($window.height / 2) - d_y - $window.mouse_y)
    object.gun_angle = -atan * 180 / Math::PI
    motion_buttons = [Gosu::KbW, Gosu::KbS, Gosu::KbA, Gosu::KbD]

    if any_button_down?(*motion_buttons)
      object.throttle_down = true
      object.physics.change_direction(
        change_angle(object.direction, *motion_buttons)
      )
    else
      object.throttle_down = false
    end

    object.shoot(*@camera.mouse_coords) if Utils.button_down?(Gosu::MsLeft)
  end

  def draw(_viewport)
    @name_image ||= Gosu::Image.from_text(
      @name, 20, font: Gosu.default_font_name
    )
    @name_image.draw(
      x - @name_image.width / 2 - 1,
      y + object.graphics.height / 2, 100,
      1, 1, Gosu::Color::WHITE
    )
    @name_image.draw(
      x - @name_image.width / 2,
      y + object.graphics.height / 2, 100,
      1, 1, NAME_COLOR
    )
  end

  private

  def respawn
    if object.health.should_respawn?
      object.health.restore
      object.x, object.y = @object_pool.map.spawn_point
      @camera.x = x
      @camera.y = y
      PlayerSounds.respawn(object, @camera)
    end
  end

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if Utils.button_down?(b)
    end
    false
  end

  def change_angle(previous_angle, up, down, right, left)
    if Utils.button_down?(up)
      angle = 0.0
      angle += 45.0 if Utils.button_down?(left)
      angle -= 45.0 if Utils.button_down?(right)
    elsif Utils.button_down?(down)
      angle = 180.0
      angle -= 45.0 if Utils.button_down?(left)
      angle += 45.0 if Utils.button_down?(right)
    elsif Utils.button_down?(left)
      angle = 90.0
      angle += 45.0 if Utils.button_down?(up)
      angle -= 45.0 if Utils.button_down?(down)
    elsif Utils.button_down?(right)
      angle = 270.0
      angle -= 45.0 if Utils.button_down?(up)
      angle += 45.0 if Utils.button_down?(down)
    end
    angle = (angle + 360) % 360 if angle&.negative?
    (angle || previous_angle)
  end
end
