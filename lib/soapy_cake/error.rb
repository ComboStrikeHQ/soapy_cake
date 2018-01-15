# frozen_string_literal: true

module SoapyCake
  class Error < RuntimeError; end

  class RequestFailed < Error
    attr_reader :request_path, :request_body, :response_body

    def initialize(message, request_path: nil, request_body: nil, response_body: nil)
      @request_path = request_path
      @request_body = request_body
      @response_body = response_body
      super(message)
    end
  end

  class RateLimitError < RequestFailed; end
end
