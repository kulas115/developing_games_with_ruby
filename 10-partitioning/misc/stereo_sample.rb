# frozen_string_literal: true

class StereoSample
  MAX_POLIPHONY = 16
  @@all_instances = []

  def self.register_instances(instances)
    @@all_instances << instances
  end

  def self.cleanup
    @@all_instances.each do |instances|
      instances.each do |key, instance|
        instances.delete(key) unless instance.playing? || instance.paused?
      end
    end
  end

  def self.stop_all
    @@all_instances.each do |instances|
      instances.each do |_key, instance|
        instance.stop if instance.playing?
      end
    end
  end

  def initialize(sound_l, sound_r = sound_l)
    @sound_l = Gosu::Sample.new(sound_l)
    # Use same sample in mono -> stereo
    @sound_r = if sound_l == sound_r
                 @sound_l
               else
                 Gosu::Sample.new(sound_r)
               end
    @instances = {}
    self.class.register_instances(@instances)
  end

  def paused?(id = :default)
    i = @instances["#{id}_l"]
    i&.paused?
  end

  def playing?(id = :default)
    i = @instances["#{id}_l"]
    i&.playing?
  end

  def stopped?(id = :default)
    @instances["#{id}_l"].nil?
  end

  def play(id = :default, pan = 0,
           volume = 1, speed = 1, looping = false)
    return if @instances.size > MAX_POLIPHONY

    @instances["#{id}_l"] = @sound_l.play_pan(
      -0.2, 0, speed, looping
    )
    @instances["#{id}_r"] = @sound_r.play_pan(
      0.2, 0, speed, looping
    )
    volume_and_pan(id, volume, pan)
  end

  def pause(id = :default)
    @instances["#{id}_l"].pause
    @instances["#{id}_r"].pause
  end

  def resume(id = :default)
    @instances["#{id}_l"].resume
    @instances["#{id}_r"].resume
  end

  def stop
    @instances.delete("#{id}_l").stop
    @instances.delete("#{id}_r").stop
  end

  def volume_and_pan(id, volume, pan)
    return unless @instances["#{id}_l"]

    if pan.positive?
      pan_l = 1 - pan * 2
      pan_r = 1
    else
      pan_l = 1
      pan_r = 1 + pan * 2
    end
    pan_l *= volume
    pan_r *= volume
    @instances["#{id}_l"].volume = [pan_l, 0.05].max
    @instances["#{id}_r"].volume = [pan_r, 0.05].max
  end
end
