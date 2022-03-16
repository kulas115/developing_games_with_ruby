# frozen_string_literal: true

class TankHealth < Health
  attr_accessor :health

  def initialize(object, object_pool)
    super(object, object_pool, 100, true)
  end

  protected

  def draw?
    true
  end
end
