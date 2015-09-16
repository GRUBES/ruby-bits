# OPTIONAL ARGUMENTS
# This tweet method takes three parameters, and all are required
# (BAD CODE)
def tweet(message, lat, long)
  # tweet tweet...
end

# We'd need to call this as:
tweet("AWESOME TWEET #BRO", nil, nil)

# However, we won't always get a lat/long, so how do we make them optional?
# First option is default values:
# (GOOD CODE)
def tweet(message, lat = nil, long = nil)
  # tweet tweet...
end

# Then we can call the method without specifying lat and long:
tweet("MORE AWESOME TWEET")

# NAMED ARGUMENTS HASH
# If we have a long list of parameters, this gets very hard to read:
# (BAD CODE)
def tweet(message, lat=nil, long=nil, reply_id=nil)
  # so many params...
end

# One way to alleviate this is to replace all optional params with an options hash
# NOTE This syntax is new as of Ruby 2.1 (https://robots.thoughtbot.com/ruby-2-keyword-arguments)
# (GOOD CODE)
def tweet(message:, lat: nil, long: nil, reply_id: nil)
  # do tweety things
end

# Now when we call this, we can pass in named parameters, which convey
# the meaning of the values right there inline:
tweet("BEST TWEET EVAR", lat: 28.55, long: -81.33, reply_id: 12345)

# EXCEPTIONS
# Exceptions are raised with the raise keyword
def get_tweets(list)
  unless list.authorized(@user)
    raise AuthorizationException.new
  end
  list.tweets
end

# Exceptions are handled by begin-rescue blocks
begin
  tweets = get_tweets(my_list)
rescue AuthorizationException
  warn "No authorize!"
end

# SPLAT ARGUMENTS
# A splat argument, indicated by the *, signifies we are sending in an array
# of parameters
def mention(status, *names)
  tweet("#{names.join(' ')} #{status}")
end

# When we call this method like:
mention('I am mentioning you!', 'eallam', 'greggpollack', 'jasonvanlue')
# then each parameter gets assigned the corresponding array position, so here,
# names[0] = 'eallam'
# names[1] = 'greggpollack'
# names[2] = 'jasonvanlue'

# CLASSES
class Tweet
  # Use the attr_* keywords to define different accessibilities of properties
  attr_accessor :status # read/write property
  attr_reader :created_at # read-only property
  def initialize(status, name)
    @status = status
    @created_at = Time.new
    # When writing instance variables, you must use self, or else a local
    # variable will get created instead
    self.name = name
  end
end

# Classes can be reopened later to add behaviour or override methods
class Tweet
  def to_s
    "#{@status}\n#{@created_at}"
  end
end
# I see this as being similar to overriding built-in functionalities or
# prototypes in JS in that, sure you can do it, but it seems dangerous.
# Increases fragility of systems that rely on third-party libraries
