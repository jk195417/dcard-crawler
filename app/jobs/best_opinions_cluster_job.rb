# Usage :
# BestOpinionsClusterJob.perform_now(post)

class BestOpinionsClusterJob < ApplicationJob
  queue_as :default

  def perform(post)
    best_k = 2
    best_kmeans = OpinionsClusterJob.perform_now(post, best_k)
    best_score = best_kmeans.silhouette
    loop do
      try_k = best_k + 1
      try_kmeans = OpinionsClusterJob.perform_now(post, try_k)
      try_score = try_kmeans.silhouette
      break if best_score >= try_score

      best_k = try_k
      best_kmeans = try_kmeans
      best_score = try_score
    end
    best_kmeans
  end
end
