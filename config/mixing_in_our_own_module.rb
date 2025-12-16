# Use inheritance when the relationship is an "is-a" relationship
# A Car is a type of Vehicle
# Use Modules/mixins when the relationship is a "has-a" or "can-do" relationship
# A Car is towable, purchaseable, and crushable
# We can mix in multiple modules but only inherit from 1 superclass

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
