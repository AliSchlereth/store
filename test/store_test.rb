require "minitest/autorun"
require "minitest/pride"
require "date"
require 'pry'
require "./lib/store"
require "./lib/inventory"

class StoreTest < Minitest::Test

  def test_store_has_a_name
    store = Store.new("Hobby Town", "894 Bee St", "Hobby")

    assert_equal "Hobby Town", store.name
  end

  def test_store_has_a_type
    store = Store.new("Ace", "834 2nd St", "Hardware")

    assert_equal "Hardware", store.type
  end

  def test_store_has_a_location
    store = Store.new("Acme", "324 Main St", "Grocery")

    assert_equal "324 Main St", store.address
  end

  def test_store_tracks_inventories
    store = Store.new("Ace", "834 2nd St", "Hardware")

    assert_equal [], store.inventory_record
  end

  def test_store_can_add_inventories
    store = Store.new("Ace", "834 2nd St", "Hardware")
    inventory = Inventory.new(Date.new(2017, 8, 6))

    assert store.inventory_record.empty?

    store.add_inventory(inventory)

    refute store.inventory_record.empty?
    assert_equal inventory, store.inventory_record[-1]
  end

  def test_store_stock_check_returns_hash_of_item
    acme = Store.new("Acme", "834 2nd St", "Hardware")

    inventory_1 = Inventory.new(Date.new(2017, 8, 5))
    inventory_1.record_item({"shoes" => {"quantity" => 40, "cost" => 30}})

    inventory_2 = Inventory.new(Date.new(2017, 8, 6))
    inventory_2.record_item({"shirt" => {"quantity" => 20, "cost" => 40}})

    acme.add_inventory(inventory_1)
    acme.add_inventory(inventory_2)

    assert_equal ({"quantity" => 20, "cost" => 40}),acme.stock_check("shirt")
  end

  def test_order_inventory_sorts_array_by_date
    acme = Store.new("Acme", "834 2nd St", "Hardware")

    inventory_1 = Inventory.new(Date.new(2017, 8, 5))
    inventory_1.record_item({"shoes" => {"quantity" => 40, "cost" => 30}})

    inventory_2 = Inventory.new(Date.new(2017, 8, 6))
    inventory_2.record_item({"shirt" => {"quantity" => 20, "cost" => 40}})

    acme.add_inventory(inventory_1)
    acme.add_inventory(inventory_2)

    assert_equal [inventory_1, inventory_2], acme.order_inventories
  end

  def test_amount_sold_checks_change_in_inventory
    ace = Store.new("Ace", "834 2nd St", "Hardware")

    inventory3 = Inventory.new(Date.new(2017, 9, 16))
    inventory3.record_item({"hammer" => {"quantity" => 20, "cost" => 20}})

    inventory4 = Inventory.new(Date.new(2017, 9, 18))
    inventory4.record_item({"mitre saw" => {"quantity" => 10, "cost" => 409}})
    inventory4.record_item({"hammer" => {"quantity" => 15, "cost" => 20}})

    ace.add_inventory(inventory3)
    ace.add_inventory(inventory4)

    assert_equal 5, ace.amount_sold("hammer")
  end

  def test_us_order_calculates_order_total
    hobby_town = Store.new("Hobby Town", "894 Bee St", "Hobby")

    inventory5 = Inventory.new(Date.new(2017, 3, 10))
    inventory5.record_item({"miniature orc" => {"quantity" => 2000, "cost" => 20}})
    inventory5.record_item({"fancy paint brush" => {"quantity" => 200, "cost" => 20}})

    hobby_town.add_inventory(inventory5)

    assert_equal "$620", hobby_town.us_order({"miniature orc" => 30, "fancy paint brush" => 1})
  end

  def test_brazilian_order_calculates_order_total
    hobby_town = Store.new("Hobby Town", "894 Bee St", "Hobby")

    inventory5 = Inventory.new(Date.new(2017, 3, 10))
    inventory5.record_item({"miniature orc" => {"quantity" => 2000, "cost" => 20}})
    inventory5.record_item({"fancy paint brush" => {"quantity" => 200, "cost" => 20}})

    hobby_town.add_inventory(inventory5)

    assert_equal "R$1909.6", hobby_town.brazilian_order({"miniature orc" => 30, "fancy paint brush" => 1})
  end

  def test_find_total_collects_order_information_and_returns_total
    hobby_town = Store.new("Hobby Town", "894 Bee St", "Hobby")

    inventory5 = Inventory.new(Date.new(2017, 3, 10))
    inventory5.record_item({"miniature orc" => {"quantity" => 2000, "cost" => 20}})
    inventory5.record_item({"fancy paint brush" => {"quantity" => 200, "cost" => 20}})

    hobby_town.add_inventory(inventory5)

    assert_equal 620, hobby_town.find_total({"miniature orc" => 30, "fancy paint brush" => 1})
  end

  def test_calculate_total_combines_information_calculates_to_integer
    hobby_town = Store.new("Hobby Town", "894 Bee St", "Hobby")

    inventory5 = Inventory.new(Date.new(2017, 3, 10))
    inventory5.record_item({"miniature orc" => {"quantity" => 2000, "cost" => 20}})
    inventory5.record_item({"fancy paint brush" => {"quantity" => 200, "cost" => 20}})

    hobby_town.add_inventory(inventory5)
    order_items = ["miniature orc", "fancy paint brush"]
    current_items = inventory5.items
    order_details = {"miniature orc" => 30, "fancy paint brush" => 1}

    assert_equal 620, hobby_town.calculate_total(order_items, current_items, order_details)
  end

end
