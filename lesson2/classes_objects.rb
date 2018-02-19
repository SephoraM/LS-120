# 1. Given the below usage of the Person class, code the class definition.
class Person
  attr_accessor :name

  def initialize(name)
    self.name = name
  end
end

bob = Person.new('bob')
p bob.name                  # => 'bob'
bob.name = 'Robert'
p bob.name                  # => 'Robert'

# 2. Modify the class definition from above to facilitate the following methods.
# Note that there is no name= setter method now.
class Person
  attr_accessor :first_name, :last_name

  def initialize(first, last='')
    self.first_name = first
    self.last_name = last
  end

  def name
    "#{first_name} #{last_name}".strip
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'


# 3. Now create a smart name= method that can take just a first name or a full
# name, and knows how to set the first_name and last_name appropriately.
class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name=(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  private
  def parse_full_name(full_name)
    names = full_name.split
    self.first_name = names.first
    self.last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new('Robert')
p bob.name                  # => 'Robert'
p bob.first_name            # => 'Robert'
p bob.last_name             # => ''
bob.last_name = 'Smith'
p bob.name                  # => 'Robert Smith'

bob.name = "John Adams"
p bob.first_name            # => 'John'
p bob.last_name             # => 'Adams'

# 4. Using the class definition from step #3, let's create a few more people
# -- that is, Person objects.
class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name=(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def same_name?(other)
    name == other.name
  end

  private
  def parse_full_name(full_name)
    names = full_name.split
    self.first_name = names.first
    self.last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new('Robert Smith')
rob = Person.new('Robert Smith')

p rob.same_name?(bob)

# 5. Continuing with our Person class definition, what does the below print out?

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"

# it'll put the string representation of the 'bob' object's place in memory
# If we define our own to_s method in the class, we can return our chosen value
# as it would override Object's to_s method

class Person
  attr_accessor :first_name, :last_name

  def initialize(name)
    parse_full_name(name)
  end

  def name=(name)
    parse_full_name(name)
  end

  def name
    "#{first_name} #{last_name}".strip
  end

  def to_s
    name
  end

  def same_name?(other)
    name == other.name
  end

  private
  def parse_full_name(full_name)
    names = full_name.split
    self.first_name = names.first
    self.last_name = names.size > 1 ? names.last : ''
  end
end

bob = Person.new("Robert Smith")
puts "The person's name is: #{bob}"
