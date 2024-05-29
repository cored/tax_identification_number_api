require_relative 'abn'
require_relative 'acn'

module Taxes
  module Countries
    module AU
      def self.from(tin, abn_query: Taxes::AbnQuery)
        raise InvalidTIN.new("invalid tin: #{tin}") unless tin.match?(/^\d{9,11}$/)
        return ACN.from(tin) if tin.length == 9

        abn = ABN.from(tin)
        abn_query = abn_query.call(abn)
        abn.with(abn_query)
      end
    end
  end
end
