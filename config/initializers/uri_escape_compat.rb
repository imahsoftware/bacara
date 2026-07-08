# URI.escape y URI.unescape fueron eliminados en Ruby 3.2
# Paperclip los usa internamente — este patch restaura la compatibilidad
require 'uri'

unless URI.respond_to?(:escape)
  module URI
    def self.escape(str, unsafe = /[^\-_.!~*'()a-zA-Z\d;\/?:@&=+$,\[\]%]/)
      str.to_s.gsub(unsafe) { |c|
        c.bytes.map { |byte| sprintf('%%%02X', byte) }.join
      }
    end

    def self.unescape(str)
      str.to_s.gsub(/%([0-9a-fA-F]{2})/) { [$1.hex].pack('C') }
    end
  end
end
