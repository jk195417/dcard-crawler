namespace :bert do
  desc '取得 沒有計算過文字向量且內容不是空白的留言 的文字向量'
  task get_comments_embeddings: :environment do
    # batch update comment's embedding, each time update 256 comments.
    batch_size = 256
    Comment.select(:id)
           .where(embedding: nil)
           .where.not(content: [nil, ''])
           .find_in_batches(batch_size: batch_size) do |comments|
      Bert::GetCommentsEmbeddings.perform_later(comments.first.id, comments.last.id)
    end
  end
end
