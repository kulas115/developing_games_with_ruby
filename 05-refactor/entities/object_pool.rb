# frozen_string_literal: true

class ObjectPool
  attr_accessor :objects, :map

  def initialize(map)
    @map = map
    @objects = []
  end
end
