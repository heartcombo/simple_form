class MockResponse

  def initialize(test_case)
    @test_case = test_case
  end

  def content_type
    'text/html'
  end

  def body
    @test_case.send :output_buffer
  end
end
