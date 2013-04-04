module Kademlia
  class Key
    attr_reader :size, :data

    def initialize(size, data)
      @size = size
      @data = data
    end

    def ==(other)
      self.class == other.class and
      self.size  == other.size and
      self.data  == other.data
    end

    def self.from_hex(hex)
      new(hex.size * 4, [hex].pack('h*'))
    end

    def [](pos)
      @data[pos >> 8].ord[pos & 7] == 1
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
    attr_accessor :content, :next

    def initialize(size, pos = 0)
      @size = size
      @pos = pos
      @content = []
      @next = nil
    end

    def store(key, data)
      if @next && !key[@pos]
        @next.store(key, data)
        return
      end

      @content << [key, data]

      if @content.size > @size
        split unless @next
      end
    end

    def find_closest(key)
      @content
    end

    def split
      @next = Bucket.new(@size, @pos + 1)
      @content, @next.content = @content.partition { |key, data| key[@pos] }
    end
  end

  class RoutingTable
    attr_reader :bucket

    def initialize(me, size = 20)
      @me = me
      @bucket = Bucket.new(size)
    end

    def store(key, data)
      diff = @me.xor(key)
      @bucket.store(diff, [key, data])
    end

    def find_closest(key, n = 3)
      diff = @me.xor(key)
      @bucket.find_closest(diff).map do |key, data|
        data
      end
    end
  end
end

