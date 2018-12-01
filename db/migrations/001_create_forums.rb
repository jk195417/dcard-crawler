Sequel.migration do
	change do
		# migration code here...
		create_table(:forums) do
		  primary_key :id
		  String :dcard_id, unique: true
		  String :alias, unique: true
		  String :name, unique: true
		  String :description
		  String :title_placeholder
		  String :subcategories
		  String :topics
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
		end
	end
end
