class MediaLink < ApplicationRecord
    belongs_to :story

    def self.update_url(url)
        url["watch?v="]="embed/"
        # "watch?v=" ==> "embed/"
    end
end
