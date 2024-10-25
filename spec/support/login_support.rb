module LoginSupport
  def logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end
 
RSpec.configure do |config|
  config.include LoginSupport
end

