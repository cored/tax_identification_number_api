require_relative 'abn'
require_relative 'acn'

module TaxNumberIdentifications
  AU = Struct.new(:tin, keyword_init: true) do
    def self.from(tin)
      raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNN") unless tin =~ /\A\d{9}|\d{11}/

      formatted_tin = if tin.length == 9
        ACN.from(tin)
      else
        ABN.from(tin)
      end

      new(tin: formatted_tin.tin)
    end

    def to_h
      { tin: tin }
    end
  end
end
