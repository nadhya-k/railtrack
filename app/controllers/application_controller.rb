# Layer - HTTP / Controller (Base)

class ApplicationController < Sinatra::Base
  before { content_type :json }

  def json_response(data, status: 200)
    self.status status
    Oj.dump(data, mode: :compat)
  end

  def json_body
    @json_body ||= JSON.parse(request.body.read, symbolize_names: true) rescue {}
  end

  def unprocessable(message)
    json_response({ error: message }, status: 422)
  end
end