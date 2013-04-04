require_relative 'helper'

module Kademlia
  class TestRoutingTable < MiniTest::Unit::TestCase
    def k(h) Key.from_hex(h) end

    def setup
      @key = Key.from_hex("dead")
      @table = RoutingTable.new(@key, 3)
    end

    def test_store_self
      @table.store(@key, :hello)
      res = @table.find_closest(@key)
      assert_equal [[@key, :hello]], res
    end

    def test_split
      @table.store(k("DEA0"), :a)
      @table.store(k("DEA1"), :b)
      @table.store(k("2EDA"), :d)
      @table.store(k("DEA2"), :c)

      assert @table.bucket.next, "the bucket wasn't split"
      fst = @table.bucket
      assert_equal 1, fst.content.size
      assert_equal [k("2EDA"), :d], fst.content[0].last
    end
  end
end

