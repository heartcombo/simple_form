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
end
