module A
  def some_method
    "Hello from A"
  end
end

module B
  def some_method
    "Hello from B"
  end
end

class SomeClass
  include A
  include B
end

some_object = SomeClass.new
puts some_object.some_method  # Output: "Hello from B"
