Sequel.migration do
  change do
    create_table(:forums, :ignore_index_errors=>true) do
      primary_key :id
      String :dcard_id, :text=>true
      String :alias, :text=>true
      String :name, :text=>true
      String :description, :text=>true
      String :title_placeholder, :text=>true
      String :subcategories, :text=>true
      String :topics, :text=>true
      Integer :subscription_count
      TrueClass :is_school
      TrueClass :can_post
      TrueClass :invisible
      TrueClass :fully_anonymous
      TrueClass :can_use_nickname
      TrueClass :should_categorized
      TrueClass :nsfw
      DateTime :created_at
      DateTime :updated_at
      
      index [:alias], :name=>:forums_alias_key, :unique=>true
      index [:dcard_id], :name=>:forums_dcard_id_key, :unique=>true
      index [:name], :name=>:forums_name_key, :unique=>true
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:posts, :ignore_index_errors=>true) do
      primary_key :id
      Integer :dcard_id
      Integer :reply_id
      Integer :comment_count
      Integer :like_count
      String :title, :text=>true
      String :excerpt, :text=>true
      String :tags, :text=>true
      String :topics, :text=>true
      String :forum_name, :text=>true
      String :forum_alias, :text=>true
      String :gender, :text=>true
      String :school, :text=>true
      String :department, :text=>true
      String :reply_title, :text=>true
      String :reactions, :text=>true
      String :custom_style, :text=>true
      String :media, :text=>true
      TrueClass :anonymous_school
      TrueClass :anonymous_department
      TrueClass :pinned
      TrueClass :with_nickname
      TrueClass :hidden
      TrueClass :with_images
      TrueClass :with_videos
      DateTime :created_at
      DateTime :updated_at
      foreign_key :forum_id, :forums, :key=>[:id]
      
      index [:dcard_id], :name=>:posts_dcard_id_key, :unique=>true
    end
    
    create_table(:comments, :ignore_index_errors=>true) do
      primary_key :id
      Integer :dcard_post_id
      Integer :floor
      Integer :like_count
      String :content, :text=>true
      String :dcard_id, :text=>true
      String :gender, :text=>true
      String :school, :text=>true
      String :department, :text=>true
      String :report_reason, :text=>true
      TrueClass :anonymous
      TrueClass :with_nickname
      TrueClass :hidden_by_author
      TrueClass :host
      TrueClass :hidden
      TrueClass :in_review
      DateTime :created_at
      DateTime :updated_at
      foreign_key :post_id, :posts, :key=>[:id]
      
      index [:dcard_post_id, :floor], :name=>:comments_dcard_post_id_floor_key, :unique=>true
    end
  end
end
