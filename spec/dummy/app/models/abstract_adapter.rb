# frozen_string_literal: true

class AbstractAdapter < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def human_attribute_name(attr, options = {})
      # The default formatting of validation errors sucks, this helps a little syntatically:
      "#{super.titleize}:"
    end

    def ransackable_attributes(_auth_object = nil)
      @ransackable_attributes ||= column_names + _ransackers.keys
    end

    def ransackable_associations(_auth_object = nil)
      @ransackable_associations ||= reflect_on_all_associations.map { |a| a.name.to_s } + _ransackers.keys
    end
  end
end
