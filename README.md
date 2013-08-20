## mongoid_has_arrr

Dead simple Mongoid <=> ActiveRecord associations

### Usage and installation

Tested for [Mongoid 2.x](http://two.mongoid.org).

```ruby
gem "mongoid_has_arrr"
```

or

```sh
gem install mongoid_has_arrr
```

In your code:

```ruby
require 'mongoid_has_arrr'

class Book

  include Mongoid::Document
  include Mongoid::ActiveRecordRelations

  field :title,       :type => String

  with_active_record do
    belongs_to :author
    belongs_to :label, :foreign_key => "this_one_id"
    belongs_to :address, :foreign_key => "city_id", :class => "City"
    has_one    :price
  end
```

**Note:** You don't have to define any foreign_key fields!

### Dones and TODOS

| Association or Feature                  | Status              |
|:----------------------------------------|:--------------------|
| BelongsTo                               | Done                |
| HasOne                                  | Done                |
| HasMany                                 | ToDo                |
| HasAndBelongsToMany                     | ToDo                |
| Mongoid integration into ActiveRecord   | ToDo                |

## Tests

Run

```
rspec spec
```

## Contributing to mongoid_has_arrr

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012/2013 [Daniel Schmidt](https://github.com/dsci). See LICENSE.txt for
further details.

