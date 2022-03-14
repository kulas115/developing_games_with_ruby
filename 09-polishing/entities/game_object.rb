# frozen_string_literal: true

class GameObject
  def initialize(object_pool)
    @components = []
    @object_pool = object_pool
    @object_pool.objects << self
  end

  attr_reader :components

  def update
    @components.map(&:update)
  end

  def draw(viewport)
    @components.each { |c| c.draw(viewport) }
  end

  def removable?
    @removable
  end

  def mark_for_removal
    @removable = true
  end

  def box; end

  def collide; end

  protected

  attr_reader :object_pool
end
