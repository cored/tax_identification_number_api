module TaxNumberIdentifications
  ABN = Struct.new(:tin, keyword_init: true) do
    WEIGHTS = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19].freeze

    def self.from(tin)
      abn_digits = tin.gsub(/\D/, '')

      digits = abn_digits.split('').map(&:to_i)
      digits[0] -= 1 if digits[0] > 1
      weighted_sum = digits.zip(WEIGHTS).sum { |digit, weight| digit * weight }

      raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNNNN") unless abn_digits.length == 11 && (weighted_sum % 89).zero?

      new(tin: "#{abn_digits[0..1]} #{abn_digits[2..4]} #{abn_digits[5..7]} #{abn_digits[8..10]}")
    end

    def to_h
      { tin: tin }
    end
  end
end
