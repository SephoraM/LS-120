# 1. You are given the following code:

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end
# What is the result of calling
oracle = Oracle.new
oracle.predict_the_future

# the return value of oracle.predict_the_future is a concatenated string with
# a random choice concatenated with "You will"

# 2. We have an Oracle class and a RoadTrip class that inherits from the Oracle
# class.

class Oracle
  def predict_the_future
    "You will " + choices.sample
  end

  def choices
    ["eat a nice lunch", "take a nap soon", "stay at work late"]
  end
end

class RoadTrip < Oracle
  def choices
    ["visit Vegas", "fly to Fiji", "romp in Rome"]
  end
end

# What is the result of the following:

trip = RoadTrip.new
trip.predict_the_future

# the instance method in the RoadTrip class overrides the choices instance
# method of the same name in Oracle. RoadTrip still has access to the
# predict_the_future method as it is because it's not been redefined. So, the
# choices for RoadTrip are the choices defined in the RoadTrip class and they
# are what are used for the returned concatenated string.

# 3. How do you find where Ruby will look for a method when that method is
# called? How can you find an object's ancestors?

module Taste
  def flavor(flavor)
    puts "#{flavor}"
  end
end

class Orange
  include Taste
end

class HotSauce
  include Taste
end

# What is the lookup chain for Orange and HotSauce?

# You can call the ancestors method on the class to find the method lookup path
# This is a class method and will not work on an instance of the class

p HotSauce.ancestors
p Orange.ancestors

# 4. What could you add to this class to simplify it and remove two methods from
# the class definition while still maintaining the same functionality?

class BeesWax
  def initialize(type)
    @type = type
  end

  def type
    @type
  end

  def type=(t)
    @type = t
  end

  def describe_type
    puts "I am a #{@type} of Bees Wax"
  end
end

# attr_accessor instead of the getter and setter methods, like so:

class BeesWax
  attr_accessor :type

  def initialize(type)
    @type = type
  end

  def describe_type
    puts "I am a #{type} of Bees Wax"
  end
end

# 5. There are a number of variables listed below. What are the different types
# and how do you know which is which?

# excited_dog = "excited dog" -> local variable
# @excited_dog = "excited dog" -> instance variable
# @@excited_dog = "excited dog" -> class variable

# The prefix of the variables. @ : instance, @@ : class, and none for local

# 6. Which one of these is a class method (if any) and how do you know? How
# would you call a class method?

class Television
  def self.manufacturer
    # method logic
  end

  def model
    # method logic
  end
end

# the manufacturer method name is called on self which is the class within which
# the method is being defined. This tells me that this is a class method and
# that it will be called on the class itself

# 7. Explain what the @@cats_count variable does and how it works. What code
# would you need to write to test your theory?

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

# The @@cats_count variable will track how many instances of Cat there are. The
# Every time a new Cat object is instantiated, the @@cats_count variable is
# incremented by one. This works because there's only one copy of the class
# variable. Test:

otto = Cat.new("needy")
p Cat.cats_count
max = Cat.new("aloof")
p Cat.cats_count

# 8. What can we add to the Bingo class to allow it to inherit the play method
# from the Game class?

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game # added the less than symbol and the class to inherit from
  def rules_of_play
    #rules of play
  end
end

# 9. What would happen if we added a play method to the Bingo class, keeping in
# mind that there is already a method of this name in the Game class that the
# Bingo class inherits from.

class Game
  def play
    "Start the game!"
  end
end

class Bingo < Game
  def rules_of_play
    #rules of play
  end
end

# The play method in the Bingo class would override the implementation of the
# play method in the Game class for all objects of class Bingo.

# 10. What are the benefits of using Object Oriented Programming in Ruby?
# Think of as many as you can.

# You can abstract away all the different functionality of your program so that
# it doesn't sit in one blob. This means that you can modify separate portions
# of code without having to worry about breaking other bits of code

# You can DRY up your code by using classes or modules for bits of logic that
# are used in multiple places by leveraging inheritance and mixins

# You can override other bits of logic with new implementations that affect only
# specific types of data

# You can contain and protect data that you want to make inaccessible to other
# parts of the program so that data won't be mistakenly modified

# It can help manage a complicated code base  
