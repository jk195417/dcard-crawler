namespace :bert do
  desc '取得留言的文字向量'
  task get_comments_embeddings: :environment do
    GetCommentsEmbeddingsJob.perform_now
  end
end
