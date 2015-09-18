# CLASSES
# Classes are the basis of encapsulation
# Passing around data as strings or numbers breaks this as it forces
# pieces using that data to know too much
# It also forces individual changes to require multiple updates in various
# places of the code
# Enter the class.

class Tweet
  attr_accessor :status, :owner_id

  def owner
    retrieve_user(owner_id)
  end
end

def send_tweet(message)
  message.owner
  # ...
end

tweet = Tweet.new
tweet.status = "MY TWEET!"
tweet.owner_id = current_user.id

send_tweet(tweet)

# Classes are not the only option as they add a lot of overhead
# If all you have is data, an option hash may suffice
# Once there is behaviour to go with the data, a class can be introduced

# By default, all methods in a class are public
class User
  def up_vote(friend)
    bump_karma
    friend.bump_karma # This will fail because bump_karma is private
  end

  private
  def bump_karma
    puts "karma up for #{name}"
  end
end

# If instead, bump_karma is protected, then it is not accessible outside
# the class, but IS accessible via other instances of the same class
# "Explicit receiver"

# INHERITANCE
# Ruby is so super ub3r DRY!
# These two classes have the exact same to_s method, so it can be extracted
# to a parent
class Image
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, {@size}"
  end
end

class Video
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, {@size}"
  end
end

# Extract the Attachment parent
class Attachment
  attr_accessor :title, :size, :url
  def to_s
    "#{@title}, {@size}"
  end
end

class Image < Attachment
end

class Video < Attachment
  attr_accessor :duration
  # Methods can be overridden
  def to_s
    # You can use super to invoke methods from the parent
    # super here invokes to_s from the parent (method of the same name)
    super + " #{@duration}"
  end
end

# to_s will be called automatically by Ruby whenever an instance is used
# in place of a string
