# frozen_string_literal: true

module CardsHelper
  def rand_card_number
    4.times.map do
      4.times.map { rand(10) }.join
    end.join('-')
  end

  def rans_cvv
    3.times.map { rand(10) }.join
  end
end
