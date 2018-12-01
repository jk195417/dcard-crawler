Sequel.migration do
	change do
		# migration code here...
		create_table(:posts) do
		  primary_key :id
		  Integer :dcard_id, unique: true
		  Integer :reply_id
		  Integer :comment_count
		  Integer :like_count
		  String :title
			String :excerpt, text: true
		  String :tags
		  String :topics
		  String :forum_name
		  String :forum_alias
		  String :gender
		  String :school
		  String :department
		  String :reply_title
		  String :reactions, text: true
		  String :custom_style, text: true
		  String :media, text: true
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
		end
	end
end
