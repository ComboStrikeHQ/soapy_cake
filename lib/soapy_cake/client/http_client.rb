require 'httparty'

class HTTPartySekken
  def get(url)
    HTTParty.get(url).body
  end

  def post(url, headers, body)
    HTTParty.post(url, headers: headers, body: body).body
  end
end
