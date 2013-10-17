require 'rubygems'
require 'sinatra'
require 'openssl'
require 'base64'

module API
	class RageAgainApi < Sinatra::Base

    register CrudService::Api

    before do

      if ['PUT', 'POST', 'DELETE'].include? request.request_method and
        request.path!="/" and
        !settings.disable_auth and
        !authenticate(
          request.env["HTTP_AUTHORIZATION"], 
          request.request_method,
          request.path,
          request.body.read,
          settings.hmac_shared_secret
          )

        # Not Authorized
        response.status = 401
        throw :halt
      end

      request.body.rewind
      
      content_type 'application/json; charset=utf-8'

      add_cors_headers(response)
    end

    get "/" do
      content_type 'text/html; charset=utf-8'
      send_file File.join(settings.base,"index.html")
      200
    end

    crud_api 'tracks', :tracks_service, 'id'
    crud_api 'artists', :artists_service, 'id'
    crud_api 'playlists', :playlists_service, 'id'
    crud_api 'labels', :labels_service, 'id'

    # # Install
    post "/install" do
      stream do |out|
        out << "Starting..."
        require File.dirname(__FILE__)+"/installer"
        out << "Done"
      end
    end

    # Hide Errors
    not_found do
      404
    end

    error do
      params.each do |error|
        settings.log.error error
      end
      500
    end

    def sanitize_params(params)
      params.delete 'splat'
      params.delete 'captures'
    end

    def authenticate(auth_header, verb, path, body, key) 
      return false if 
        auth_header.nil? or auth_header.length==0 or
        key.nil? or key.length==0

      param = auth_header.match(/HMAC\s([^:\s]+):([^:\s]+)/i)
      return false if param.nil?

      body = OpenSSL::Digest::MD5.hexdigest(body)
      hmac = Base64.encode64(OpenSSL::HMAC.digest('sha1', key, "#{verb}:#{path}:#{body}:#{Time.now.gmtime.strftime("%Y%m%d")}")).chomp
      (param[2] == hmac)
    end

    def add_cors_headers(response)
      response.headers['Access-Control-Allow-Origin'] = '*'
      response.headers['Access-Control-Allow-Headers'] = 'Authorization, Content-Type'
      response.headers['Access-Control-Allow-Methods'] = 'GET, PUT, POST, DELETE, OPTIONS'
    end

	end
end


