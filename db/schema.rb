Sequel.migration do
  change do
    create_table(:forums, :ignore_index_errors=>true) do
      primary_key :id
      String :dcard_id, :size=>255
      String :alias, :size=>255
      String :name, :size=>255
      String :description, :size=>255
      String :title_placeholder, :size=>255
      String :subcategories, :size=>255
      String :topics, :size=>255
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
      
      index [:dcard_id], :name=>:sqlite_autoindex_forums_1, :unique=>true
      index [:alias], :name=>:sqlite_autoindex_forums_2, :unique=>true
      index [:name], :name=>:sqlite_autoindex_forums_3, :unique=>true
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
      String :title, :size=>255
      String :excerpt, :text=>true
      String :tags, :size=>255
      String :topics, :size=>255
      String :forum_name, :size=>255
      String :forum_alias, :size=>255
      String :gender, :size=>255
      String :school, :size=>255
      String :department, :size=>255
      String :reply_title, :size=>255
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
      foreign_key :forum_id, :forums
      
      index [:dcard_id], :name=>:sqlite_autoindex_posts_1, :unique=>true
    end
  end
end
