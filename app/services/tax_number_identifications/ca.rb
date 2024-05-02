module TaxNumberIdentifications
  CA = Struct.new(:tin, keyword_init: true) do
    def self.from(tin)
      raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNNRTNNNNN") unless tin =~ /\A\d{9}RT\d+\z/
      new(tin: tin)
    end

    def to_h
      { tin: tin }
    end
  end
end
