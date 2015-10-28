# IntrospectiveAdmin

IntrospectiveAdmin is a Rails Plugin for DRYing up ActiveAdmin configurations by
laying out simple defaults and including nested relations according to the models'
accepts_nested_attributes_for :relation declarations.

## Documentation

In your Gemfile:

```
gem 'introspective_admin', git: 'https://github.com/buermann/introspective_admin.git'
```

And bundle install.

```
class MyAdmin < IntrospectiveAdmin::Base
  def self.exclude_params
    %w(fields to exclude from the admin screen)
  end
  
  register MyModel do
    # Add additional ActiveAdmin configuration options under the Admin::MyModelController namespace. 
  end
end
```

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

## Dependencies

Tool                  | Description
--------------------- | -----------
[ActiveAdmin]         | The current master branch or, when it's released, version >1.0

[ActiveAdmin]: https://github.com/activeadmin

