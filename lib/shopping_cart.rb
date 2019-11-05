class ShoppingCart
  class Item
    attr_accessor :qty, :desc, :price
    def initialize(qty:,desc:,price:,tax_exempt:,import:)
      @qty = Integer(qty)
      @desc = desc
      @price = Float(price)
      @tax_exempt = tax_exempt
      @import = import
    end

    def tax_exempt?
      @tax_exempt
    end

    def import?
      @import
    end

    def cost
      @cost ||= qty * price
    end

    def tax_rate
      tax = 0.0
      tax += 0.1 unless tax_exempt? 
      tax += 0.05 if import?
      tax
    end

    def sales_tax
      @sales_tax ||= (cost * tax_rate * 20).round * 0.05
    end

    def total
      @total ||= cost + sales_tax
    end

    def to_s
      "%d %s: %0.2f" % [qty, desc, total]
    end

    def import
      import? ? 'import' : 'not import'
    end

    def tax_exempt
      tax_exempt? ? 'tax exempt' : 'not exempt'
    end

    def inspect
      "%d %s at %0.2f %s %s %0.2f %0.2f %0.2f" % [qty, desc, price, import, tax_exempt, tax_rate, sales_tax, total]
    end
  end

  def items
    @items ||= []
  end

  def read(input=$stdin)
    input.each_line do |line|
      parse(line)
    end
  end

  def parse(line)
    return unless (match = /(\d+) (.*) at (\d+\.\d+)/.match(line))

    add( qty: match[1], desc: match[2], price: match[3])
  end

  def add(qty:, desc:, price:)
    items.push(Item.new(
      qty: qty,
      desc: desc,
      price: price,
      tax_exempt: desc.match?(/(?:pill|chocolate|book)/),
      import: desc.match?(/import/)
    ))
  end

  def write
    total = 0
    sales_tax = 0
    items.each do |item|
      total += item.total
      sales_tax += item.sales_tax
      puts item
    end
    puts "Sales Taxes: %0.2f"%[sales_tax]
    puts "Total: %0.2f"%[total]
  end
end
