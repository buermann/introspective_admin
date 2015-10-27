class UserAdmin < IntrospectiveAdmin::Base
  def self.exclude_params
    %w(reset_password_at current_sign_in_at current_sign_in_ip remember_created_at sign_in_count encrypted_password reset_password_sent_at reset_password_token password authentication_token unlock_token failed_attempts last_sign_in_at locked_at last_sign_in_ip)
  end

  register User do
  end

end
