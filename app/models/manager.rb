class Manager
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, type: String
    field :role, type: String

    has_many :approval_records

    # has_many: :users, through: :approval_records
    def users
        User.where(
            :_id.in => approval_records.where(manager_id: self._id)
            .pluck(:user_id)
        )
    end
end