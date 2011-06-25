class MockController
  attr_accessor :action_name

  def _routes
    self
  end

  def action_name
    @action_name || "edit"
  end

  def url_for(*args)
    "http://example.com"
  end

  def url_helpers
    self
  end

  def hash_for_user_path(*args); end
  def hash_for_validating_user_path(*args); end
  def hash_for_other_validating_user_path(*args); end
  def hash_for_users_path(*args); end
end
