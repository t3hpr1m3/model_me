![ModelMe Logo](https://raw.github.com/t3hpr1m3/model_me/master/logo.png)

[![Build Status](https://secure.travis-ci.org/t3hpr1m3/model_me.png?branch=master)](http://travis-ci.org/t3hpr1m3/model_me)

*Legacy Data...Modernized.*
---

This is still a work in progress, but progress is good.

**ModelMe** attempts to fill the gap between the awesomeness of modern web
applications, and the grunge of dealing with legacy data sources.

Libraries such as [ActiveResource](http://github.com/rails/activeresource)
attempt to bridge this gap, but unfortunately, many of us are forced to
integrate with data sources that don't necessarily conform to any modern
standard.  If you've ever had to deal with an old custom TCP server, flat
files, or some other esoteric data storage mechanism, ModelMe is here to
help.

ModelMe's structure is based heavily on
[ActiveRecord](http://github.com/rails/rails/tree/master/activerecord), and a great deal of
credit is due to the Rails team for the development of that library.  Because
of this design, most of the constructs in ModelMe should be familiar to any
Rails developer.

## Why ModelMe?

An exhaustive explanation of why ModelMe came to exist can be found in
[this](http://blog.codingprime.com/2013/08/31/modelmewhy) blog post.  In a
nutshell:

 1.  I needed to use both local SQL data and a legacy data store in the same application, and
 1.  ActiveRecord was a requirement for the SQL, which meant using something
     like [DataMapper](http://datamapper.org) would have meant a lot of
     thinking during development (is this an AR or DM model?).

For these reasons, **ModelMe** came to be.

## Installation

Add to your Gemfile:

    gem 'model_me'

And then execute:

    $ bundle install

## Usage

Creating **ModelMe** classes is almost identical to using
[ActiveRecord](https://github.com/rails/activerecord).  The only noticable
difference is the need to explicitly define the attribute of your model,
instead of them being inferred from the data source.

```ruby
class Employee < ModelMe::Base
  attribute :badge_number, :integer, primary_key: true
  attribute :first_name,   :string
  attribute :last_name,    :string
  attribute :manager,      :boolean, default: false
end
```
We now have a model that can be used just like and ActiveRecord model:

```ruby
employee = Employee.new(badge_number: 1234, manager: true)
employee.first_name = 'Joe'
employee.last_name = 'Schmoe'
employee.save

employee = Employee.find(1234)
> #<Employee badge_number: 1234, first_name: "Joe", last_name: "Schmoe", manager: false>
```

We'll get into the nuts and bolts of how this persistence works later.

### ActiveModel Features

Because **ModelMe** includes all the goodies provided by ActiveModel, you
automatically have access to Validations, Callbacks, Dirty state, Observers,
etc.  For examples of their usage, the following links should be helpful:  
[Active Model](http://railscasts.com/episodes/219-active-model)  
[Make Any Ruby Object Feel Like ActiveRecord](http://yehudakatz.com/2010/01/10/activemodel-make-any-ruby-object-feel-like-activerecord/)  
[ActiveModel documentation](http://api.rubyonrails.org/classes/ActiveModel.html)

### Associations

**ModelMe** supports associations as well (although currently limited to has_one,
has_many, and belongs_to).  The syntax for both creating and using these is
identical to ActiveRecord.

```ruby
class Employee < ModelMe::Base
  belongs_to :department
end
```

These associations can be to other ModelMe models, or ActiveRecord models (yes,
you can have associations from ActiveRecord to ModelMe me as well.  Shazam!).

TODO: Finish this shizzle.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
