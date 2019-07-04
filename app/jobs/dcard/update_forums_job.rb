# Usage :
# Dcard::UpdateForumsJob.perform_now

class Dcard::UpdateForumsJob < ApplicationJob
  queue_as :default

  def perform
    forums = Dcard::Forum.to_records(Dcard::Forum.get)
    ::Forum.import(forums, on_duplicate_key_update: { conflict_target: [:alias], columns: valid_column_names })
  end

  private

  def valid_column_names
    ::Forum.column_names - %w[id alias posts_count created_at updated_at]
  end
end
