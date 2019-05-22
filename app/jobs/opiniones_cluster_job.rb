# Usage :
# OpinionesClusterJob.perform_now(post.id, 6)

class OpinionesClusterJob < ApplicationJob
  queue_as :default

  def perform(id, k=2)
    # find k clusters in data
    post = Post.find id
    comments = post.comments.where.not(embedding: nil).order(:floor)
    post_and_comments = [post] + comments
    data, labels = generate_data_and_labels post_and_comments
    kmeans = KMeansClusterer.run k.to_i, data, labels: labels
    kmeans
  end

  private

  def generate_data_and_labels(post_and_comments)
    data = []
    labels = []
    post_and_comments.each do |it|
      data << it.embedding
      labels << it.floor
    end
    [data, labels]
  end
end
