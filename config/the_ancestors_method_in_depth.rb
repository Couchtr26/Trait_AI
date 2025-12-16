module Purchaseable
  def purchase(item)
    "#{item} has been purchased."
  end
end

class Bookstore
  include Purchaseable
end

class Supermarket
  include Purchaseable
end

class Bodega < Supermarket
end

bookstore = Bookstore.new
puts bookstore.purchase("The Great Gatsby")

supermarket = Supermarket.new
puts supermarket.purchase("Apples")

bodega = Bodega.new
puts bodega.purchase("Sandwich")

p Bookstore.ancestors
p Purchaseable.ancestors
p Object.ancestors
p Kernel.ancestors
p BasicObject.ancestors

p Bookstore.class
p Purchaseable.class
p Object.class
p Kernel.class
p BasicObject.class

p bookstore.is_a?(Bookstore)
p bookstore.is_a?(Purchaseable)
p bookstore.is_a?(Object)
p bookstore.is_a?(Kernel)
p bookstore.is_a?(BasicObject)
