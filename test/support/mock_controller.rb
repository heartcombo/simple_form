class MockController
  attr_writer :action_name

  def _routes
    self
  end

  def action_name
    defined?(@action_name) ? @action_name : "edit"
  end

  def url_for(*args)
    "http://example.com"
  end

  def url_options
    {}
  end

  def hash_for_user_path(*); end
  def hash_for_validating_user_path(*); end
  def hash_for_other_validating_user_path(*); end
  def hash_for_users_path(*); end
end
