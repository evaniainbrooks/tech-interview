# frozen_string_literal: true

class LinkedList
  attr_accessor :nextp, :prevp, :data

  def initialize(nextp: nil, prevp: nil, data:)
    @nextp = nextp
    @prevp = prevp
    @data = data
  end

  def append(data)
    @nextp = LinkedList.new(data: data, prevp: self)
  end

  def unlink!
    @prevp.nextp = @nextp if @prevp
    @nextp.prevp = @prevp if @nextp
    self
  end
end
