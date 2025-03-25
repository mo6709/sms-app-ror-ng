class ApprovalRecord < MongoidRcord
    field :status, type: String
    field :notes, type: String
   
    belongs_to :user
    belongs_to :manager

    validates :status, presence: true, inclusion { in: ['approved', 'rejected'] }
    validates :manger, presence: true
    validates :user, presence: true

    validates :manager_id, uniqueness: { scope: :user_id }  #make sure the manager can vote once

    #Callback
    after_save :update_user_approval_count

    private

    def update_user_approval_count
        if self.status === 'approved'
            current_count = self.user.approval_records.where(status: 'approved').count
            self.user.update(approval_count: current_count)
            self.user.activate_if_approved
        end
    end
end