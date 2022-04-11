# frozen_string_literal: true

class ScoreDisplay
  def initialize(object_pool)
    tanks = object_pool.objects.select do |o|
      o.instance_of?(Tank)
    end
    stats = tanks.map(&:input).map(&:stats)
    stats.sort! do |stat1, stat2|
      stat2.kills <=> stat1.kills
    end
    create_stats_image(stats)
  end

  def create_stats_image(stats)
    text = stats.map do |stat|
      "#{stat.kills}: #{stat.name} "
    end.join("\n")
    @stats_image = Gosu::Image.from_text(
      text, 30, font: Utils.main_font
    )
  end

  def draw
    @stats_image.draw(
      $window.width / 2 - @stats_image.width / 2,
      $window.height / 4 + 30,
      1000
    )
  end
end
