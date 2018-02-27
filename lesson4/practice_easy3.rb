# 1.
class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def hi
    greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end
# What happens in each of the following cases:
hello = Hello.new
hello.hi # => Hello

# hello = Hello.new
# hello.bye # a no method error - NoMethodError

# hello = Hello.new
# hello.greet # a wrong number of arguments error - ArgumentError

hello = Hello.new
hello.greet("Goodbye") # => Goodbye

# Hello.hi # a no method error - NoMethodError

# 2. If we call Hello.hi we get an error message. How would you fix this?

class Greeting
  def greet(message)
    puts message
  end
end

class Hello < Greeting
  def self.hi
    Greeting.new.greet("Hello")
  end
end

class Goodbye < Greeting
  def bye
    greet("Goodbye")
  end
end

Hello.hi

# 3. When objects are created they are a separate realization of a particular
# class.

# Given the class below, how do we create two different instances of this class,
# both with separate names and ages?

class AngryCat
  def initialize(age, name)
    @age  = age
    @name = name
  end

  def age
    puts @age
  end

  def name
    puts @name
  end

  def hiss
    puts "Hisssss!!!"
  end
end

cat1 = AngryCat.new(2, "Fillo")
cat2 = AngryCat.new(3, "Aggie")
cat1.name
cat1.age
cat2.name
cat2.age

# 4. Given the class below, if we created a new instance of the class and then
# called to_s on that instance we would get something like
# "#<Cat:0x007ff39b356d30>"

# How could we go about changing the to_s output on this method to look like
# this: I am a tabby cat? (this is assuming that "tabby" is the type we passed
# in during initialization).

class Cat
  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    "I am a #{type} cat!"
  end
end

my_cat = Cat.new("Tabby")
p my_cat.to_s

# 5. What would happen if I called the methods like shown below?

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

tv = Television.new
tv.manufacturer # NoMethodError because the moethod is class method
tv.model # method logic

Television.manufacturer # method logic
Television.model # NoMethodError

# 6. In the make_one_year_older method we have used self. What is another way
# we could write this method so we don't have to use the self prefix?

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

# We could use the instance variable itself rather than the setter method
# so @age instead of self.age

# 7. What is used in this class but doesn't add any value?

class Light
  attr_accessor :brightness, :color

  def initialize(brightness, color)
    @brightness = brightness
    @color = color
  end

  def self.information
    return "I want to turn on the light with a brightness level of super high and a color of green"
  end

end

# attr_accessor because it sets up getter and setter methods that the class
# never uses. We also unnecessarily use an explicit return when the last expression
# is already implicitly returned with Ruby
