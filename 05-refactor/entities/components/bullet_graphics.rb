# frozen_string_literal: true

class BulletGraphics < Component
  COLOR = Gosu::Color::BLACK

  def draw(_viewport)
    $window.draw_quad(x - 2, y - 2, COLOR,
                      x + 2, y - 2, COLOR,
                      x - 2, y + 2, COLOR,
                      x + 2, y + 2, COLOR,
                      1)
  end
end
