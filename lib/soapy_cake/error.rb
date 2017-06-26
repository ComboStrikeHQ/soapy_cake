# frozen_string_literal: true

module SoapyCake
  class Error < RuntimeError; end
  class RequestFailed < Error; end
  class RateLimitError < RequestFailed; end
end
