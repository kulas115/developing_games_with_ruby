# frozen_string_literal: true

class Bullet
  COLOR = Gosu::Color::BLACK
  MAX_DIST = 300
  START_DIST = 20

  def initialize(source_x, source_y, target_x, target_y)
    @x = source_x
    @y = source_y
    @target_x = target_x
    @target_y = target_y
    @x, @y = point_at_distance(START_DIST)

    @target_x, @target_y = point_at_distance(MAX_DIST) if trajectory_length > MAX_DIST
    sound.play
  end

  def draw
    if arrived?
      @explosion ||= Explosion.new(@x, @y)
      @explosion.draw
    else
      $window.draw_quad(@x - 2, @y - 2, COLOR,
                        @x + 2, @y - 2, COLOR,
                        @x - 2, @y + 2, COLOR,
                        @x + 2, @y + 2, COLOR,
                        1)
    end
  end

  def update
    fly_distance = (Gosu.milliseconds - @fired_at) * 0.001 * @speed
    @x, @y = point_at_distance(fly_distance)
    @explosion&.update
  end

  def arrived?
    @x == @target_x && @y == @target_y
  end

  def done?
    exploaded?
  end

  def exploaded?
    @explosion&.done?
  end

  def fire(speed)
    @speed = speed
    @fired_at = Gosu.milliseconds
    self
  end

  private

  def sound
    @@sound ||= Gosu::Sample.new(
      $window, Game.media_path('fire.mp3')
    )
  end

  def trajectory_length
    d_x = @target_x - @x
    d_y = @target_y - @y
    Math.sqrt(d_x * d_x + d_y * d_y)
  end

  def point_at_distance(distance)
    return [@target_x, @target_y] if distance > trajectory_length

    distance_factor = distance.to_f / trajectory_length
    p_x = @x + (@target_x - @x) * distance_factor
    p_y = @y + (@target_y - @y) * distance_factor
    [p_x, p_y]
  end
end
