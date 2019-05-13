class Dcard::UpdateForumsJob < ApplicationJob
  queue_as :default

  def perform
    forums = Dcard::Forum.to_records(Dcard::Forum.get)
    result = ::Forum.import(forums, on_duplicate_key_update: {
                              conflict_target: [:alias],
                              columns: ::Forum.column_names - %w[id alias created_at updated_at]
                            })
    Rails.logger.info "Forum #{result.ids} updated."
  end
end
