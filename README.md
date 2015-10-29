# IntrospectiveAdmin

IntrospectiveAdmin is a Rails Plugin for DRYing up ActiveAdmin configurations by
laying out simple defaults and including nested relations according to the models'
accepts_nested_attributes_for :relation declarations.

## Documentation

In your Gemfile:

```
gem 'introspective_admin'
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


