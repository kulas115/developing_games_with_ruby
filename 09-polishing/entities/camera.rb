# frozen_string_literal: true

class Camera
  attr_accessor :x, :y, :zoom
  attr_reader :target

  def target=(target)
    @target = target
    @x = target.x
    @y = target.y
    @zoom = 1
  end

  def mouse_coords
    x, y = target_delta_on_screen
    mouse_x_on_map = @target.x +
                     (x + $window.mouse_x - ($window.width / 2)) / @zoom
    mouse_y_on_map = @target.y +
                     (y + $window.mouse_y - ($window.height / 2)) / @zoom
    [mouse_x_on_map, mouse_y_on_map].map(&:round)
  end

  def update
    shift = Utils.adjust_speed(@target.physics.speed)
    @x += shift if @x < @target.x - $window.width / 4
    @x -= shift if @x > @target.x + $window.width / 4
    @y += shift if @y < @target.y - $window.height / 4
    @y -= shift if @y > @target.y + $window.height / 4

    zoom_delta = @zoom.positive? ? 0.01 : 1.0
    zoom_delta = Utils.adjust_speed(zoom_delta)
    if $window.button_down?(Gosu::KbUp)
      @zoom -= zoom_delta unless @zoom < 0.7
    elsif $window.button_down?(Gosu::KbDown)
      @zoom += zoom_delta unless @zoom > 10
    else
      target_zoom = @target.physics.speed > 1.1 ? 0.85 : 1.0
      if @zoom <= (target_zoom - 0.01)
        @zoom += zoom_delta / 3
      elsif @zoom > (target_zoom + 0.01)
        @zoom -= zoom_delta / 3
      end
    end
  end

  def to_s
    "FPS: #{Gosu.fps}. " \
      "#{@x}:#{@y} @ #{format('%.2f', @zoom)}. " \
      'WASD to move, arrows to zoom.'
  end

  def target_delta_on_screen
    [(@x - @target.x) * @zoom, (@y - @target.y) * @zoom]
  end

  def draw_crosshair
    factor = 0.3
    x = $window.mouse_x
    y = $window.mouse_y
    c = crosshair
    c.draw(x - c.width * factor / 2,
           y - c.height * factor / 2,
           1000, factor, factor)
  end

  def viewport
    x0 = @x - ($window.width / 2)  / @zoom
    x1 = @x + ($window.width / 2)  / @zoom
    y0 = @y - ($window.height / 2) / @zoom
    y1 = @y + ($window.height / 2) / @zoom
    [x0, x1, y0, y1]
  end

  private

  def crosshair
    @crosshair ||= Gosu::Image.new(
      Utils.media_path('c_dot.png'), tileable: false
    )
  end
end
