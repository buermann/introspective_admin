# frozen_string_literal: true

class ProjectJob < AbstractAdapter
  belongs_to :project
  belongs_to :job

  delegate :title, to: :job
end
