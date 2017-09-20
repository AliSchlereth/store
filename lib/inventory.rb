class Inventory

  attr_reader :date,
              :items

  def initialize(date)
    @date = date
    @items = {}
  end

  def record_item(item)
    item_name = item.keys[0]
    unless @items[item_name]
      @items[item_name] = item[item_name]
    else
      @items[item_name]["quantity"] += item[item_name]["quantity"] 
    end
  end

end
