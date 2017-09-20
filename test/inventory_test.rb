require "minitest/autorun"
require "minitest/pride"
require "date"
require './lib/inventory'

class InventoryTest < Minitest::Test

  def test_inventory_takes_a_date
    date = Date.new(2017, 8, 4)
    inventory = Inventory.new(date)

    assert_equal date, inventory.date
  end

  def test_inventory_starts_with_empty_item_hash
    inventory = Inventory.new(Date.new(2017, 8, 4))

    assert_equal ({}), inventory.items
  end

  def test_inventory_record_item_adds_item_hash
    inventory = Inventory.new(Date.new(2017, 8, 4))
    item_record = {"shirt" => {"quantity" => 50, "cost" => 15}}

    inventory.record_item(item_record)

    assert_equal item_record, inventory.items
  end

  def test_record_item_can_add_multiple_of_same_item
    inventory = Inventory.new(Date.new(2017, 8, 4))
    item_record_1 = {"shirt" => {"quantity" => 50, "cost" => 15}}
    item_record_2 = {"shirt" => {"quantity" => 10, "cost" => 15}}

    inventory.record_item(item_record_1)
    inventory.record_item(item_record_2)

    updated_item = {"shirt" => {"quantity" => 60, "cost" => 15}}
    assert_equal updated_item, inventory.items

  end

end
