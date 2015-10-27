ActiveAdmin.setup do |config|
  config.authentication_method = nil #:authenticate_admin_user!
  config.current_user_method = nil #:current_admin_user
  config.logout_link_path = :destroy_admin_user_session_path
  config.batch_actions = true
end

