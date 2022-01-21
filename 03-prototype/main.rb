require 'gosu'
require_relative 'states/game_state'
require_relative 'states/menu_state'
require_relative 'states/play_state'
require_relative 'game_window'

module Game
  def self.media_path
    File.join('../', File.dirname(File.dirname(__FILE)__)), 'media', file)
  end
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
