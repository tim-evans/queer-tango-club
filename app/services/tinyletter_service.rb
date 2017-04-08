require 'httparty'

class TinyletterService
  def initialize
    get_cookies_and_token
    login(ENV['TINYLETTER_USERNAME'], ENV['TINYLETTER_PASSWORD'])
  end

  def request(service, data)
    response = HTTParty.post('https://app.tinyletter.com/__svcbus__/',
                             body: [[[service, data]], [], @csrf_token].to_json,
                             headers: {
                               'Cookie' => @cookies.to_cookie_string,
                               'Content-Type' => 'application/json',
                               'Accept' => 'application/json',
                               'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'
                             })

    @cookies = HTTParty::CookieHash.new
    response.get_fields('Set-Cookie').each { |c| @cookies.add_cookies(c) }
    result = JSON.parse(response.body)[0][0]
    if result['success']
      result['result'] || true
    else
      result['errmsg']
    end
  end

  def login(username, password)
    request("service:User.loginService",
            [username, password, nil, nil, nil, nil])
  end


  def get_cookies_and_token
    response = HTTParty.get('https://app.tinyletter.com',
                            headers: {
                              'User-Agent' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/56.0.2924.87 Safari/537.36'
                            })

    @cookies = HTTParty::CookieHash.new
    response.get_fields('Set-Cookie').each { |c| @cookies.add_cookies(c) }
    @csrf_token = response.body[/csrf_token="([^"]+)"/, 1]
  end

  def subscribe(email)
    request("service:MC_Import_Emails.import", [[email]])
  end

  def find(email)
    request("query:Contact", [{ email: email }, "created_at desc", "0 10"])[0]
  end

  def unsubscribe(email)
    contact = find(email)
    request('delete:Contact', [contact['id']])
  end
end
