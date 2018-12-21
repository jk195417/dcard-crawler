module App::Actions
  extend self
  def update_forums
    new_forums = []
    response = JSON.parse(HTTP.get(DcardAPI.forums).to_s)
    response.each do |row|
      f = Forum.load_from_dcard(row)
      forum = Forum.find_by(name: row['name'])
      forum.nil? ? (new_forums << f) : forum.update(f)
    end
    Forum.import(new_forums)
    App.logger.info "All fourms is up to date."
  end
end
