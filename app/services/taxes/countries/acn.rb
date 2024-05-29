module Taxes
  module Countries
    ACN = Struct.new(:tin, keyword_init: true) do
      def self.from(tin)
        raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNN") unless tin =~ /\A\d{9}\z/

        new(tin: "#{tin[0..2]} #{tin[3..5]} #{tin[6..8]}")
      end

      def to_h
        { tin: tin }
      end
    end
  end
end
