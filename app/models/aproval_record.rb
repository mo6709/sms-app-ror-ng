class ApprovalRecord
    include Mongoid::Document
    include Mongoid::Timestamps
    
    field :status, type: String
    field :notes, type: String
   
    belongs_to :user
    belongs_to :manager

    validate :status, presence: true, inclusion { in: ['approved', 'rejected'] }
    validate :manger, presence: true
    validate :user, presence: true

    validate :manager_id, uniqueness: { scope: :user_id }  #make sure the manager can vote once

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