# UNLESS
# Reading a negative conditional like this can be confusing:
# (BAD CODE)
if ! tweets.empty?
  puts "Timeline:"
  puts tweets
end

# It can be more intuitive to use unless:
# (GOOD CODE)
unless tweets.empty?
  puts "Timeline:"
  puts tweets
end

# However, unless+else can also be confusing:
# (BAD CODE)
unless tweets.empty?
  puts "Timeline:"
  puts tweets
else
  puts "No tweets found"
end

# so it is often helpful in these cases to flip the order around:
# (GOOD CODE)
if tweets.empty?
  puts "No tweets found"
else
  puts "Timeline:"
  puts tweets
end

# Reading positive if statements is typically more readable

# NIL IS FALSEY
# You can check for existence by comparing to nil:
# (BAD CODE)
if attachment.file_path != nil
  attachment.post
end

# but similar to JS, nil is falsey, so we can shorthand this:
# (GOOD CODE)
if attachment.file_path
  attachment.post
end

# Other Boolean evaluations (not like JS):
# "" - Empty string is TRUE
# 0 - Zero is TRUE
# [] - Empty Array is TRUE

# Because zero is truthy, this fails:
# (BAD CODE)
unless name.length
  warn "Username required"
end

# You would instead write something like:
# (GOOD CODE)
if name.empty?
  warn "Username required"
end

# INLINE CONDITIONALS
# Simple conditionals can be written inline to improve readability
# For example, instead of:
# (BAD CODE)
if password.length < 8
  fail "Password too short"
end
unless username
  fail "No username set"
end

# you can do something like:
# (GOOD CODE)
fail "Password too short" if password.length < 8
fail "No username set" unless username

# SHORT-CIRCUIT "AND"
# The AND operator is short-circuited, so instead of (sqf-like):
# (BAD CODE)
if user
  if user.signed_in?
    # Do things...
  end
end

# You can more succinctly write (js-like):
# (GOOD CODE)
if user && user.signed_in?
  # Do things...
end

# SHORT-CIRCUIT ASSIGNMENT
# Like JS, you can use the || operator for assigning defaults
# result in all the following lines will be 1:
result = nil || 1
result = 1 || nil
result = 1 || 2

# More realistic example:
# (BAD CODE)
tweets = timeline.tweets
tweets = [] unless tweets

# can be replaced with:
# (GOOD CODE)
tweets = timeline.tweets || []

# As always, readability needs to be considered whether an if-else or the
# || operator is better

# CONDITIONAL ASSIGNMENT
# There is an ||= operator that can be used for similar situations
# The ||= operator assigns a value if no value is already assigned:
i_was_set = 1
i_was_set ||= 2
puts i_was_set # 1, ||= not executed because the var was already set

i_was_not_set ||= 2
puts i_was_not_set # 2, ||= executed because the var was not set

# REFACTOR EXERCISE
# How would you refactor the following code?:
options[:country] = 'us' if options[:country].nil?
options[:privacy] = true if options[:privacy].nil?
options[:geotag] = true if options[:geotag].nil?

# My attempt (ended up same as solution):
options[:country] ||= 'us'
options[:privacy] ||= true
options[:geotag] ||= true

# CONDITIONAL RETURN VALUES
# In rb, conditionals always RETURN a value
# For example, when doing a conditional assignment like the following:
# (BAD CODE)
if list_name
  options[:path] = "/#{user_name}/#{list_name}"
else
  options[:path] = "/#{user_name}"
end

# you are instead able to assign the value of the if statement:
# (GOOD CODE)
options[:path] = if list_name
  "/#{user_name}/#{list_name}"
else
  "/#{user_name}"
end

# This conditional would be much better served in a method:
# (BAD CODE)
def list_url(user_name, list_name)
  if list_name
    url = "https://twitter.com/#{user_name}/#{list_name}"
  else
    url = "https://twitter.com/#{user_name}"
  end
  url
end

# but we can make this much more readable because conditionals return values:
# (GOOD CODE)
def list_url(user_name, list_name)
  if list_name
    "https://twitter.com/#{user_name}/#{list_name}"
  else
    "https://twitter.com/#{user_name}"
  end
end

# CASE statements also return values:
# (GOOD CODE)
client_url = case client_name
when "web"
  "http://twitter.com"
when "Facebook"
  "http://www.facebook.com/twitter"
else
  nil
end

# CASES ACCEPT RANGES AND REGEX:
# (GOOD CODE)
popularity = case tweet.retweet_count
when 0..9
  nil
when 10..99
  "trending"
else
  "hot"
end

tweet_type = case tweet.status
when /\A@\w+/
  :mention
when /\Ad\s+\w+/
  :direct_message
else
  :public
end

# CASE statements can be a little more readable using then:
tweet_type = case tweet.status
when /\A@\w+/ then :mention
when /\Ad\s+\w+/ then :direct_message
else :public
end
