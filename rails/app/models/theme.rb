class Theme < ApplicationRecord
    after_save :check_active
    before_destroy :can_destroy?
    has_many_attached :logos
    validates :logos, blob: { content_type: ['image/png', 'image/jpg', 'image/jpeg'], size_range: 1..5.megabytes }

    private
    #sets first record (default) if no themes are active
    def check_active
        if Theme.find_by(active:true) == nil
            t = Theme.first
            t.active = true
            t.save
        end
    end

    def can_destroy?
        if self == Theme.first
            self.errors.add(:base, "Cannot destroy default theme")
            throw :abort
        end
    end

end
