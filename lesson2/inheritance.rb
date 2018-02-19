# 1. Create a sub-class from Dog called Bulldog overriding the swim method to
#    return "can't swim!"

class Pet # from exercise 2
  def run
    'running!'
  end

  def jump
    'jumping!'
  end
end

class Dog < Pet
  def speak
    'bark!'
  end

  def swim
    'swimming!'
  end

  def fetch
    'fetching!'
  end
end

teddy = Dog.new
puts teddy.speak           # => "bark!"
puts teddy.swim           # => "swimming!"

# ->
class Bulldog < Dog
  def swim
    "can't swim!"
  end
end

karl = Bulldog.new
puts karl.speak           # => "bark!"
puts karl.swim            # => "can't swim!"

# 2. Create a new class called Cat, which can do everything a dog can, except
# swim or fetch. Assume the methods do the exact same thing. Hint: don't just
# copy and paste all methods in Dog into Cat; try to come up with some class
# hierarchy.

class Cat < Pet
  def speak
    'meow!'
  end
end

pete = Pet.new
kitty = Cat.new
dave = Dog.new
bud = Bulldog.new

p pete.run                # => "running!"
# pete.speak              # => NoMethodError

p kitty.run               # => "running!"
p kitty.speak             # => "meow!"
# kitty.fetch             # => NoMethodError

p dave.speak              # => "bark!"

p bud.run                 # => "running!"
p bud.swim                # => "can't swim!"

=begin
 3. Draw a class hierarchy diagram of the classes from step #2

                                Pet
                              methods- run, jump
                     |                     |
                  Cat                     Dog
                methods- speak               methods- speak, swim, fetch
                                           |
                                        Bulldog
                                       methods- swim
 =end

 # 4. What is the method lookup path and how is it important?

 # The method lookup path is the pattern that Ruby follows as it looks up the
 # inheritance chain for the method definition. It's important to know where 
 # Ruby will look next as it searches for the method definition because there
 # can be behavior that is overridden by other implementations of a method and
 # if you don't know the path, you could end up calling the wrong method.
