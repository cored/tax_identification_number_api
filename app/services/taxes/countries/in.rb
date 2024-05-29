module Taxes
  module Countries

    IN = Struct.new(:tin, keyword_init: true) do
      def self.from(tin)
        raise InvalidTIN.new("invalid tin, correct TIN format NNXXXXXXXXXXNAN") unless tin =~ /\A\d{2}\w+\D\d\z/
        new(tin: tin)
      end

      def to_h
        { tin: tin }
      end
    end
  end
end
