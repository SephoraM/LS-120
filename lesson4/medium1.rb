# 1. Ben is right. The attr_reader created a getter method for the instance
# variable @balance which means that the use of balance in the method
# definition of positive_balance? is an invocation of balance which returns
# the value of the instance variable @balance

# 2. There isn't a setter method for quantity and if there was one, it would be
# called on self. If there isn't one, then the instance variable can be accessed
# directly with the prefix @ (i.e. the instance variable name)

# 3. Nothing incorrect syntactically. However, you are altering the public
# interfaces of the class. In other words, you are now allowing clients of
# the class to change the quantity directly (calling the accessor with the
# instance.quantity = <new value> notation) rather than by going through the
# update_quantity method. It means that the protections built into the
# update_quantity method can be circumvented and potentially pose problems
# down the line. ---Launch School answer

# Understanding: So, by using the attr_accessor I create the setter method which
# means that my instance variable is now able to be set directly by the instance
# of the class. This is not the behavior I want in this case. I only want the
# instance variable able to be set by the instance method that I create which
# checks for invalid input. So, if I don't create a setter method and instead
# reassign new values to the instance variable directly, it's no longer able to
# be modified directly by the instance.

# 4.

class Greeting
  def greet(str)
    puts str
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

Hello.new.hi
Goodbye.new.bye

# 5.

class KrispyKreme
  attr_reader :filling_type, :glazing

  def initialize(filling_type, glazing)
    @filling_type = filling_type
    @glazing = glazing
  end

  def to_s
    filling = filling_type || "Plain"
    glazing ? "#{filling} with #{glazing}" : filling
  end
end

donut1 = KrispyKreme.new(nil, nil)
donut2 = KrispyKreme.new("Vanilla", nil)
donut3 = KrispyKreme.new(nil, "sugar")
donut4 = KrispyKreme.new(nil, "chocolate sprinkles")
donut5 = KrispyKreme.new("Custard", "icing")

puts donut1
#  => "Plain"

puts donut2
#  => "Vanilla"

puts donut3
#  => "Plain with sugar"

puts donut4
#  => "Plain with chocolate sprinkles"

puts donut5
#  => "Custard with icing"

# 6. Nothing, though the implementations are different (better not to use self
#    unless it's needed -- Ruby's style guide)

# 7. I would just name it information because this is called on the class and
#    the class name is Light so calling it light_information is redundant
