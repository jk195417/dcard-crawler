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
  end
end
