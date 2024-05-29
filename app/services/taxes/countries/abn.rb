module Taxes
  module Countries
    ABN = Struct.new(:tin, :extra_info, keyword_init: true) do
      WEIGHTS = [10, 1, 3, 5, 7, 9, 11, 13, 15, 17, 19].freeze

      def self.from(tin)
        abn_digits = tin.gsub(/\D/, '')

        digits = abn_digits.split('').map(&:to_i)
        digits[0] -= 1 if digits[0] > 1
        weighted_sum = digits.zip(WEIGHTS).sum { |digit, weight| digit * weight }

        raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNNNN") unless abn_digits.length == 11 && (weighted_sum % 89).zero?

        new(tin: "#{abn_digits[0..1]} #{abn_digits[2..4]} #{abn_digits[5..7]} #{abn_digits[8..10]}")
      end

      EXTRA_INFO_KEYS = %i[organisation_name address status].freeze
      def with(abn_query)
        self.class.new(tin: tin,
                       extra_info: abn_query.to_h.slice(*EXTRA_INFO_KEYS))
      end

      def to_h
        { tin: tin }.merge({ extra_info: extra_info } || {})
      end
    end
  end
end
