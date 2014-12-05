require 'httparty'

class HTTPartySekken
  include HTTParty
  read_timeout 3 * 60

  def get(url)
    self.class.get(url).body
  end

  def post(url, headers, body)
    self.class.post(url, headers: headers, body: body).body
  end
end
