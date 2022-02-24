# frozen_string_literal: true

class Component
  def initialize(game_object = nil)
    self.object = game_object
  end

  def update
    # override
  end

  def draw(viewport)
    # override
  end

  protected

  def object=(obj)
    return unless obj

    @object = obj
    obj.components << self
  end

  def x
    @object.x
  end

  def y
    @object.y
  end

  attr_reader :object
end
