class GetForumsJob < ApplicationJob
  queue_as :default

  def perform
    new_forums = []
    response = JSON.parse(HTTP.get(Dcard::Api.forums).to_s)
    response.each do |row|
      f = Forum.load_from_dcard(row)
      forum = Forum.find_by(name: row['name'])
      forum.nil? ? (new_forums << f) : forum.update(f)
    end
    Forum.import(new_forums)
    Rails.logger.info 'All fourms is up to date.'
  end
end