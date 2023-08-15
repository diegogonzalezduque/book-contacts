class ApplicationController < ActionController::Base

    def user_for_paper_trail
        user_signed_in? ? current_user.id : 'Public user'
    end
end
