# MODULES

# In Ruby, we could create a set of related functions by simply placing them
# in a single file then require-ing the file, as in:
# (BAD CODE)
# image_utils.rb
def preview(image)
end

def transfer(image, destination)
end

# run.rb
require 'image_utils'
image = user.image
preview(image)

# This pollutes the global namespace, which is of course bad.
# Instead, we namespace our functions with a module
# (GOOD CODE)
# image_utils.rb
module ImageUtils
  def self.preview(image)
  end

  def self.transfer(image, destination)
  end
end

# run.rb
require 'image_utils'

image = user.image
ImageUtils.preview(image)

# Modules can be used as mixins for classes as well
# (BETTER CODE)
# image_utils.rb
module ImageUtils
  # no longer need image as an argument
  def preview
  end

  def transfer(destination)
  end
end

# searchable.rb
module Searchable
  def find_all_from(user)
  end
end

# avatar.rb
require 'image_utils'
class Image
  include ImageUtils # include will expose the module methods as instance methods
  extend Searchable # extend will expose the module methods as class methods
end

# run.rb
image = user.image
image.preview
images = Image.find_all_from('@GreggPollack')

# ANCESTORS
# What's actually happening when we include a module in a class is that
# the module gets inserted in the Class's ancestry chain
Image.ancestors # [Image, ImageUtils, Object, Kernel, BasicObject]
Image.included_modules # [ImageUtils, Kernel]

# MIXINS VS INHERITANCE
# Ruby does not allow multiple inheritance, but multiple modules can be included
# Inheritance suggests specialization, which may not always be the case
# Some behaviours simply don't fit well with a class and are better defined
# in a module

# Extend can be used on single instances as well
image = Image.new
image.extend(ImageUtils)
image.preview # works

image = Image.new
image.preview # NoMethodError because we only extended the previous instance

# We can build a module that contains both instance and class methods
# Ruby will automatically call self.included whenever a module is included
# in a class
module ImageUtils
  def self.included(base)
    base.extend(ClassMethods)
  end

  def preview
  end

  def transfer(destination)
  end

  # ClassMethods is the conventional name, but it could be any name
  module ClassMethods
    def fetch_from_twitter(user)
    end
  end
end

class Image
  include ImageUtils
end

# ACTIVESUPPORT::CONCERN
# To properly manage module dependencies, use ActiveSupport::Concerns
# (BAD CODE)
module ImageUtils
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def clean_up
    end
  end
end

module ImageProcessing
  include ImageUtils

  def self.included(base)
    base.clean_up
  end
end

class Image
  include ImageProcessing
end

# The above code does not properly resolve the dependency of the ImageProcessing
# module on the ImageUtils module. Calling base.clean_up will throw a
# NoMethodError because clean_up is not defined

# To resolve this, we simply extend ActiveSupport::Concern, which will
# add the `included` block, and will automatically look for a module
# named ClassMethods and extend the base class with it
# (GOOD CODE)
module ImageUtils
  extend ActiveSupport::Concern
  module ClassMethods
    def clean_up
    end
  end
end

# ActiveSupport::Concern ensures that the self.included method in dependent
# modules is invoked with the correct base class
module ImageProcessing
  extend ActiveSupport::Concern
  include ImageUtils
  included do
    clean_up
  end
end

class Image
  include ImageProcessing
end
