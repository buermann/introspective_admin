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

And bundle install.  In app/admin/my_admin.rb:

```
class MyAdmin < IntrospectiveAdmin::Base
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

Registering MyModel will set up the index, show, and form configurations for every attribute and nested association on the model excluding those in MyAdmin.exclude_params, with links to associated records (if they have ActiveAdmin screens), eager loading of nested associations, and permitting every non-excluded attribute on the model. 

Customizing select box options for associations is done by adding an 
"options_for_X" class method on the administrated model:

```
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

## Dependencies

Tool                  | Description
--------------------- | -----------
[ActiveAdmin]         | The current master branch or, when it's released, version >1.0

[ActiveAdmin]: https://github.com/activeadmin


