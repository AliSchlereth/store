class Store

  attr_reader :name,
              :address,
              :type,
              :inventory_record

  def initialize(name, address, type)
    @name = name
    @address = address
    @type = type
    @inventory_record = []
  end

  def add_inventory(inventory)
    @inventory_record << inventory
  end

  def stock_check(item)
    recent_inventory = order_inventories[-1]
    recent_inventory.items[item]
  end

  def order_inventories
    @inventory_record.sort_by do |inventory|
      inventory.date
    end
  end

  def amount_sold(item)
    ordered_inventories = order_inventories
    current_items = ordered_inventories[-1].items
    latest_items = ordered_inventories[-2].items
    latest_items[item]['quantity'] - current_items[item]['quantity']
  end

  def us_order(order_details)
    total = find_total(order_details)
    total.to_s.insert(0, "$")
  end

  def brazilian_order(order_details)
    total = find_total(order_details)
    converted = (total * 3.08).round(2)
    converted.to_s.insert(0, "R$")
  end

  def find_total(order_details)
    order_items = order_details.keys
    current_items = order_inventories[-1].items
    total = calculate_total(order_items, current_items, order_details)
  end

  def calculate_total(order_items, current_items, order_details)
    order_items.reduce(0) do |total, item_name|
      cost_per_item = current_items[item_name]['cost']
      cost = order_details[item_name] * cost_per_item
      total += cost
    end
  end


end
