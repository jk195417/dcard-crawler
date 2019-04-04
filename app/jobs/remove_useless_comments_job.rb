class RemoveUselessCommentsJob < ApplicationJob
  queue_as :default

  def perform
    already_removed_comments = Comment.where(hidden: true, content: nil)
    already_removed_comments.destroy_all
    no_content_comments = Comment.where("(trim(content) = '') is true")
    no_content_comments.destroy_all
  end
end
