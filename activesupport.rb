# ACTIVESUPPORT
# The ActiveSupport gem adds many helpers to existing Ruby classes

# ARRAY EXTENSIONS
array = ["a","b","c","d","e","f","g"]

array.from(4) # ["d","e","f","g"]
array.to(2) # ["a","b","c"]
array.in_groups_of(3) # [["a","b","c"],["d","e","f"],["g",nil,nil]]
array.split(2) #[["a","b"],["d","e","f","g"]]

# DATE EXTENSIONS
apocalypse = DateTime.new(2012,12,21,14,27,45) # Fri, 21 Dec 2012, 14:27:45 +0000

apocalypse.at_beginning_of_day # Fri, 21 Dec 2012, 00:00:00 +0000
apocalypse.at_end_of_month # Mon, 31 Dec 2012, 23:59:59 +0000
apocalypse.at_beginning_of_year # Sun, 1 Jan 2012, 00:00:00 +0000
apocalypse.advance(years: 4, months: 3, weeks: 2, days: 1) # Wed, 05 Apr 2017 14:27:45 +0000
apocalypse.tomorrow # Sat, 22 Dec 2012, 14:27:45 +0000
apocalypse.yesterday # Thu, 20 Dec 2012, 14:27:45 +0000

# HASH EXTENSIONS
options = {user: 'codeschool', lang: 'fr'}
new_options = {user: 'codeschool', lang: 'fr', password: 'dunno'}
defaults = {lang: 'en', country: 'us'}

options.diff(new_options) # {:password=>"dunno"}
options.stringify_keys # {"user"=>"codeschool", "lang"=>"fr"}
options.reverse_merge(defaults) # {user: 'codeschool', lang: 'fr', country: 'us'}
new_options.except(:password) # {user: 'codeschool', lang: 'fr'}
new_options.assert_valid_keys(:user, :lang) # Unknown key(s): password

# INTEGER EXTENSIONS
index = 10

index.odd? # false
index.even? # true

# INFLECTOR
index.ordinalize # "10th"
"user".pluralize # "users"
"women".singularize # "woman"
"octopus".pluralize # "octopi"
"ruby bits".titleize # "Ruby Bits"
"account_options".humanize # "Account options"
