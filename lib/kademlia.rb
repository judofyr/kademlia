module Kademlia
  class Key
    attr_reader :size, :data

    def initialize(size, data)
      @size = size
      @data = data
    end

    def self.from_hex(hex)
      new(hex.size * 4, [hex].pack('H*'))
    end

    def xor(other)
      data = ""
      @data.bytes.zip(other.data.bytes) do |(a, b)|
        data << (a ^ b)
      end
      Key.new(@size, data)
    end
  end

  class Bucket
    def initialize(size, pos = 0)
      @content = []
    end

    def store(lookup, key, data)
      @content << [key, data]
    end

    def find_closest(key)
      @content
    end
  end

  class RoutingTable
    def initialize(me, size = 20)
      @me = me
      @bucket = Bucket.new(size)
    end

    def store(key, data)
      diff = @me.xor(key)
      @bucket.store(diff, key, data)
    end

    def find_closest(key)
      diff = @me.xor(key)
      @bucket.find_closest(diff)
    end
  end
end

