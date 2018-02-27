# 1. Which of the following are objects in Ruby? If they are objects, how
# can you find out what class they belong to?

# true
# "hello"
# [1, 2, 3, "happy days"]
# 142

# They are all objects. You can find out their class by calling the class method
# on them.

# 2. If we have a Car class and a Truck class and we want to be able to go_fast,
# how can we add the ability for them to go_fast using the module Speed? How can
# you check if your Car or Truck can now go fast?

module Speed
  def go_fast
    puts "I am a #{self.class} and going super fast!"
  end
end

class Car
  include Speed

  def go_slow
    puts "I am safe and driving slow."
  end
end

class Truck
  include Speed

  def go_very_slow
    puts "I am a heavy truck and like going very slow."
  end
end

Car.new.go_fast
Truck.new.go_fast

# 3. When we called the go_fast method from an instance of the Car class (as
# shown below) you might have noticed that the string printed when we go fast
# includes the name of the type of vehicle we are using. How is this done?

# Since the class method returns the class name of the object it's been called
# on, and self refers to the object itself, self.class will return the object's
# class name.

# 4. If we have a class AngryCat how do we create a new instance of this class?

# The AngryCat class might look something like this:

class AngryCat
  def hiss
    puts "Hisssss!!!"
  end
end

my_cat = AngryCat.new

# 5. Which of these two classes has an instance variable and how do you know?

class Fruit
  def initialize(name)
    name = name
  end
end

class Pizza
  def initialize(name)
    @name = name
  end
end

# class Pizza has an instance variable. The instance variable has a @ before
# name.

# 6. What could we add to the class below to access the instance variable
# @volume?

class Cube
  attr_accessor :volume

  def initialize(volume)
    @volume = volume
  end
end

# we could add an attr_accessor, which is the special syntax for adding a setter
# and getter method for the instance variable or we could define those getter
# and setter methods ourselves if we like

# 7. What is the default return value of to_s when invoked on an object? Where
# could you go to find out if you want to be sure?

# The object's class and an encoding of the object id. You can check the Ruby
# documentation for the Object class for information on the default class.

# 3. You can see in the make_one_year_older method we have used self. What does
# self refer to here?

class Cat
  attr_accessor :type, :age

  def initialize(type)
    @type = type
    @age  = 0
  end

  def make_one_year_older
    self.age += 1
  end
end

# It'll refer to the instance of the class(the object formed by newing up the
# class). So it'll the calling object of the instance method.

# 4. In the name of the cats_count method we have used self. What does self
# refer to in this context?

class Cat
  @@cats_count = 0

  def initialize(type)
    @type = type
    @age  = 0
    @@cats_count += 1
  end

  def self.cats_count
    @@cats_count
  end
end

# This refers to the class itself. So, self is the class Cat

# 10. If we have the class below, what would you need to call to create a new
# instance of this class.

class Bag
  def initialize(color, material)
    @color = color
    @material = material
  end
end

Bag.new("red", "leather")
