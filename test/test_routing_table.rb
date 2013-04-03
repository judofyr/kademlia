require_relative 'helper'

module Kademlia
  class TestRoutingTable < MiniTest::Unit::TestCase
    def setup
      @key = Key.from_hex("dead")
      @table = RoutingTable.new(@key)
    end

    def test_store_self
      @table.store(@key, :hello)
      res = @table.find_closest(@key)
      assert_equal [[@key, :hello]], res
    end
  end
end

