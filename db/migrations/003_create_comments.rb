Sequel.migration do
	change do
		create_table(:comments) do
			primary_key :id
			Integer :dcard_post_id
			Integer :floor
			Integer :like_count
			String :content, text: true
			String :dcard_id
			String :gender
			String :school
			String :department
			String :report_reason
			TrueClass :anonymous
			TrueClass :with_nickname
			TrueClass :hidden_by_author
			TrueClass :host
			TrueClass :hidden
			TrueClass :in_review
			DateTime :created_at
			DateTime :updated_at
			foreign_key :post_id, :posts
			unique [:dcard_post_id, :floor]
		end
	end
end
