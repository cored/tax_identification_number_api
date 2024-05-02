module TaxNumberIdentifications
  AU = Struct.new(:tin, keyword_init: true) do
    def self.from(tin)
      raise InvalidTIN.new("invalid tin, correct TIN format NNNNNNNNN or NNNNNNNNNNN") unless tin =~ /\A\d{9}|\d{11}/
      formatted_tin = if tin.length == 9
                        "#{tin[0..2]} #{tin[3..5]} #{tin[6..9]}"
                      else
                        "#{tin[0..1]} #{tin[2..4]} #{tin[5..7]} #{tin[8..10]}"
                      end

      new(tin: formatted_tin)
    end

    def to_h
      { tin: tin }
    end
  end
end
