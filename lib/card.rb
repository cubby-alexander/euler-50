class Card
  include Comparable

  attr_reader :value, :suit

  VALUES = ('2'..'9').to_a + %w(T J Q K A)
  SUITS = %w(H D C S)

  def initialize(card_str)
    @value = card_str[0]
    @suit = card_str[1]
  end

  def value_rank
    VALUES.index(value)
  end

  def <=>(other)
    value_rank <=> other.value_rank
  end

  def to_s
    "#{value}#{suit}"
  end
end