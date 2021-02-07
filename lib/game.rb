# frozen_string_literal: true
require_relative 'frame'

class Game
  attr_reader :frames, :scores, :running_total, :score_list, :roll

  def initialize
    @frames = []
    @score_list = []
    @scores = []
    @running_total = 0
  end

  def input_bowl(pins)
    @scores = {:frame => frames.length, :pins => pins}
    @score_list << scores

    frames << Frame.new(frames.length + 1) if add_frame?

    frames[-1].add_roll(pins)
  end

  def calculate_score
    @running_total = 0
    @score_list.each do |x| @running_total +=  x[:pins] end
  end

  def add_frame?
    frames.empty? || frames[-1].open == false
  end
end
