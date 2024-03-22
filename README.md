# IntrospectiveAdmin

[![Gem Version][GV img]][Gem Version]
[![Build Status][BS img]][Build Status]
[![Dependency Status][DS img]][Dependency Status]
[![Coverage Status][CS img]][Coverage Status]

[Gem Version]: https://rubygems.org/gems/introspective_admin
[Build Status]: https://travis-ci.org/buermann/introspective_admin
[travis pull requests]: https://travis-ci.org/buermann/introspective_admin/pull_requests
[Dependency Status]: https://gemnasium.com/buermann/introspective_admin
[Coverage Status]: https://coveralls.io/r/buermann/introspective_admin

[GV img]: https://badge.fury.io/rb/introspective_admin.png
[BS img]: https://travis-ci.org/buermann/introspective_admin.png
[DS img]: https://gemnasium.com/buermann/introspective_admin.png
[CS img]: https://coveralls.io/repos/buermann/introspective_admin/badge.png?branch=master

IntrospectiveAdmin is a Rails Plugin for DRYing up ActiveAdmin configurations by
laying out simple defaults and including nested relations according to the models'
accepts_nested_attributes_for :relation declarations.

## Documentation

In your Gemfile:

```
gem 'introspective_admin'
```

And bundle install.

In app/admin/my_admin.rb:

```
class MyAdmin < IntrospectiveAdmin::Base
  def self.include_virtual_attributes
    %w(password)
  end

  def self.exclude_params
    %w(fields to exclude from the admin screen)
  end

  register MyModel do
    # It yields the ActiveAdmin DSL context back, allowing further configuration to
    # be added here, just as you would normally, to the Admin::MyModelController
    # namespace.
  end
end
```

Registering MyModel will set up the index, show, and form configurations for every attribute, virtual attribute listed in MyAdmin.include_virtual_attributes (e.g. a password field for a Devise model), and nested association on the model excluding those in MyAdmin.exclude_params. It will link to associated records (if they have ActiveAdmin screens), perform eager loading of nested associations, and permit parameters for every non-excluded attribute on the model.

Customizing select box options for associations is done by adding an
"options_for_X" class method on the administrated model:

```
app/models/my_model.rb
class MyModel < ActiveRecord::Base
  belongs_to :parent
  has_many :other_models
  accepts_nested_attributes_for :other_models, :allow_destroy => true

  def self.options_for_parent(instance_of_my_model)
    Parent.order(:appelation).map.{|p| ["#{p.appelation}", p.id] }
  end
end
```

IntrospectiveAdmin will detect nested polymorphic relations and attempt to handle
them using virutal attributes that you must add to the model instance, plus a class
method for the select box options, using a shared delimiter string for the compound ID.

E.g. here we use a hyphen:

```
app/models/my_model.rb
class MyModel < ActiveRecord::Base
  belongs_to :poly_model, polymorphic: true
  accepts_nested_attributes_for :poly_model, :allow_destroy => true

  def self.options_for_poly_model
    PolyModel.all.map { |i| [ "#{i.class}: #{i.name}", "#{i.class}-#{i.id}"] }
  end

  def poly_model_assign
    poly_model.present? ? "#{poly_model_type}-#{poly_model_id}" : nil
  end

  def poly_model_assign=(value)
    self.poly_model_type,self.poly_model_id = value.split('-')
  end

end
```

ActiveAdmin relies on [Ransack](https://github.com/activerecord-hackery/ransack) to power its searches. You will need
to explicitly declare attributes and associations to be accessible to ActiveAdmin. You can defeat the purpose by declaring everything accessible via your models' abstract base class, but be sure to exclude sensitive data:

```
app/models/application_record.rb
def ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def ransackable_attributes(auth_object = nil)
      @ransackable_attributes ||= column_names + _ransackers.keys - %w(password)
    end

    def ransackable_associations(auth_object = nil)
      @ransackable_associations ||= reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
    end
  end
end
```


## Dependencies

Tool                  | Description
--------------------- | -----------
[ActiveAdmin]         | The current master branch or, when it's released, version >1.0

[ActiveAdmin]: https://github.com/activeadmin


