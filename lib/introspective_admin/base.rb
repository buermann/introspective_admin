module IntrospectiveAdmin
  class Base 
    # Generate an active admin interface by introspecting on the models.

    # For polymorphic associations set up virtual 'assign' attributes on the model like so:
    #
    # def <polymorphism>_assign
    #   "#{<polymorphism>_type}-#{<polymorphism>_id}"
    # end
    # def <polymorphism>_assign=(value)
    #   self.<polymorphism>_type,self.<polymorphism>_id = value.split('-')
    # end
    #
    # And designate the selection options in a class method, you can pass the
    # target model to modify the options list accordingly
    #
    # def self.<polymorphism>_options(model=nil)
    #   (Model.all + SecondModel.all).map { |i| [ i.name, "#{i.class}-#{i.id}"] }
    # end

    class << self

      def exclude_params 
        [] # do not display the field in the index page and forms.
      end

      def include_virtual_attributes 
        [] #
      end

      def polymorphic?(model,column)
        (model.reflections[column.sub(/_id$/,'')].try(:options)||{})[:polymorphic]
      end

      def column_list(model, extras=[])
        model.columns.map {|c|
          ref_name = c.name.sub(/(_type|_id)$/,'')
          model.reflections[ref_name] ? ref_name : c.name
        }.uniq-['created_at','updated_at']-exclude_params+extras
      end

      def params_list(model, extras=[])
        model.columns.map {|c|
          polymorphic?(model,c.name) ? c.name.sub(/_id$/,'')+"_assign" : c.name
        }+extras 
      end

      def link_record(record)
        link_text = record.try(:name) || record.try(:title) || record.class.to_s
        link_href = begin eval("admin_#{record.class.name.underscore}_path(#{record.id})") rescue false end
        if link_href
          link_to link_text, link_href
        elsif link_text
          link_text
        else
          record
        end
      end

      def register(model, &block)
        # Defining activeadmin pages will break pending migrations:
        begin ActiveRecord::Migration.check_pending! rescue return end 

        klass         = self
        model_name    = model.to_s.underscore
        nested_config = Hash[model.nested_attributes_options.reject {|name,o|
          klass.exclude_params.include?("#{name}_attributes")
        }.map {|assoc,options|
          reflection       = model.reflections[assoc.to_s]
          reflection_class = reflection.class_name.constantize
          # merge the options of the nested attribute and relationship declarations  
          options = options.merge(reflection_class.reflections[assoc.to_s].try(:options) || {})
          options[:class]   = reflection_class
          options[:columns] = klass.column_list(reflection_class)
          options[:params]  = klass.params_list(reflection_class)
          options[:reflection]            = reflection
          options[:polymorphic_reference] = reflection.options[:as].to_s
          [assoc, options]
        }]

        ActiveAdmin.register model do 
          instance_eval &block if block_given? # Evalutate the passed black for overrides to the defaults

          controller do
            def scoped_collection
              super.includes super.nested_attributes_options.keys
            end
          end

          index do 
            selectable_column
            cols = model.columns.map(&:name)-klass.exclude_params
            cols.each_with_index do |c,i|
              column c
            end
            actions
          end

          show do 
            instance = self.send(model_name)

            attributes_table do
              model.columns.each do |c|
                next if (c.name =~ /password/)
                row c.name
              end

              nested_config.each do |assoc,options|
                panel assoc.capitalize do
                  table_for instance.send(assoc) do 
                    options[:columns].each do |c|
                      if options[:class].reflections[c]
                        column( c ) do |r|
                          klass.link_record(r.send(c)) if r
                        end
                      else 
                        column c
                      end
                    end

                    admin_route = begin url_for(['admin', options[:class].name.underscore]) rescue false end
                    if admin_route
                      column 'actions' do |child|
                        span link_to "View",   url_for(['admin', child])
                        span link_to "Edit",   url_for(['edit','admin',child])
                        span link_to "Delete", url_for(['admin',child]), method: :delete, confirm: "Are you sure you want to delete this?"
                      end
                    end
                  end
                end
              end
            end
          end

          permit_params klass.params_list(model, klass.include_virtual_attributes) + [Hash[nested_config.map{|assoc,o|
            ["#{assoc}_attributes", o[:params]+[(o[:allow_destroy] ? :_destroy : '')] ]
          }]]

          form do |f|
            f.actions

            klass.column_list(model, klass.include_virtual_attributes).each do |column|
              if column == model.primary_key
              elsif klass.polymorphic?(model,column)
                f.input column+"_assign", collection: model.send("#{column}_assign_options")
              elsif model.respond_to?("options_for_#{column}")
                f.input column, collection: model.send("options_for_#{column}", f.object)
              else
                f.input column
              end
            end

            div { '&nbsp'.html_safe } 

            nested_config.each do |assoc,options|
              aclass  = options[:class]
              columns = options[:columns]-[aclass.primary_key]
              f.inputs do
                f.has_many assoc, allow_destroy: options[:allow_destroy] do |r|
                  columns.each do |c|
                    if c == model_name || c == options[:polymorphic_reference]
                      # the join to the parent is implicit
                    elsif klass.polymorphic?(aclass,c) 
                      r.input "#{c}_assign", collection: aclass.send("#{c}_assign_options")
                    elsif aclass.reflections[c] && aclass.respond_to?("options_for_#{c}")
                      # If the class has an options_for_<column> method defined use that
                      # rather than the default behavior, pass the instance for scoping,
                      # e.g. UserProjectJob.options_for_job is scoped by the Project's
                      # jobs:
                      r.input c, collection: aclass.send("options_for_#{c}",f.object)
                    else 
                      r.input c
                    end
                  end
                end
              end
            end
          end

        end
      end
    end
  end
end
