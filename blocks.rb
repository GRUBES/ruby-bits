# BLOCKS

# Blocks are executable pieces of code that can be passed around like arguments

# We could print out the elements of an array like this:
# (BAD CODE)
words = ['Had', 'eggs', 'for', 'breakfast.']
for index in 0..(words.length - 1)
  puts words[index]
end

# Instead, we can use the each method, which takes a block as an argument:
# (GOOD CODE)
words.each { |word| puts word }
# or
words.each do |word|
  puts word
end

# There are two different conventions with blocks.
# 1. Use curly braces for single-line blocks; use do-end for multi-line.
# 2. Use curly-braces if you're simply using a return value. Use
#    do-end if the block does something (has a side-effect)

# YIELD
# Passed-in blocks can be executed inside a method by using the yield command
def call_this_block_twice
  yield
  yield
end

call_this_block_twice { puts "twitter" }  # twitter
                                          # twitter
call_this_block_twice { puts "tweet" }  # tweet
                                        # tweet

# Arguments can also be passed in to yield and thus into the block
def call_this_block
  yield "tweet"
end

# Whatever we pass to yield gets passed in through |myarg|
call_this_block { |myarg| puts myarg } # tweet
call_this_block { |myarg| puts myarg.upcase } # TWEET

# ALL blocks return a value
def puts_this_block
  puts yield
end

puts_this_block { "tweet" } # tweet

# Putting all the techniques together:
def call_this_block
  # We pass in "foo" to yield so that the block gets passed an argument
  block_result = yield "foo" # Our block returns a value, which we store in block_result
  puts block_result # then we put our result to use and print it out
end

call_this_block { |arg| arg.reverse } # oof

# How would you rewrite the following code using blocks?
# (BAD CODE)
class Timeline
  def list_tweets
    @user.friends.each do |friend|
      friend.tweets.each { |tweet| puts tweet }
    end
  end
  def store_tweets
    @user.friends.each do |friend|
      friend.tweets.each { |tweet| tweet.cache }
    end
  end
end

# My attempt:
class Timeline
  def list_tweets
    each_friends_tweet { |tweet| puts tweet }
  end

  def store_tweets
    each_friends_tweet { |tweet| tweet.cache }
  end

  private

  def each_friends_tweet
    @user.friends.each do |friend|
      friend.tweets.each { |tweet| yield tweet }
    end
  end
end

# Suggested Solution:
class Timeline
  def each
    @user.friends.each do |friend|
      friend.tweets.each { |tweet| yield tweet }
    end
  end
end

timeline = Timeline.new(user)
timeline.each { |tweet| puts tweet }
timeline.each { |tweet| tweet.cache }

# My syntax and logic was correct; I simply provided a different architecture
# Their solution makes a bit more sense and makes the Timeline class a bit more
# flexible, allowing clients to arbitrarily run code on each tweet in the timeline

# Defining the each method also allows us to mixin Enumerable
class Timeline
  def each
    # ...
  end
  include Enumerable
end

# Enumerable adds many utility methods that rely on the iteration performed
# by this each method
timeline.sort_by { |tweet| tweet.created_at }
timeline.map { |tweet| tweet.status }
timeline.find_all { |tweet| tweet.status =~ /\@codeschool/ }

# We can use blocks to "execute around" code
# (BAD CODE)
def update_status(user, tweet)
  begin
    sign_in(user)
    post(tweet)
  rescue ConnectionError => e
    logger.error(e)
  ensure
    sign_out(user)
  end
end

def get_list(user, list_name)
  begin
    sign_in(user)
    retrieve_list(list_name) # this is the only difference between the two
  rescue ConnectionError => e
    logger.error(e)
  ensure
    sign_out(user)
  end
end

# Instead, let's bring all the repeated logic into a method, and then pass
# in the business logic that's different as a block.
# Note that because we are in a method here, the begin and end for the
# rescue block are unnecessary
# (GOOD CODE)
def while_signed_in_as(user)
  sign_in(user)
  yield
  rescue ConnectionError => e
    logger.error(e)
  ensure
    sign_out(user)
end

while_signed_in_as(user) do
  post(tweet)
end

while_signed_in_as(user) do
  retrieve_list(list_name)
end
