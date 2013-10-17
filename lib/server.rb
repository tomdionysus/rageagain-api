require "crud-service"
require "logger"
require "dalli"

# DALs
require "./lib/tracks_dal"
require "./lib/artists_dal"
require "./lib/playlists_dal"
require "./lib/labels_dal"

# API
require "./lib/rage_again_api"

#class Server

# Setup Logger
log = Logger.new(STDOUT)

# Key must be supplied if auth is not disabled
if (ENV['HMAC_SHARED_SECRET'].nil? or ENV['HMAC_SHARED_SECRET'].length==0) and !ENV['DISABLE_AUTH']
  log.fatal("HMAC_SHARED_SECRET must be supplied unless DISABLE_AUTH = true")
  exit
end

# Connect to MySQL
if ENV['CLEARDB_DATABASE_URL'].nil? or not ENV['CLEARDB_DATABASE_URL'].is_a? String 
  log.fatal("ENV['CLEARDB_DATABASE_URL'] not supplied.")
  exit
end

# Test DB Connection
begin
  mysql_options = URI(ENV['CLEARDB_DATABASE_URL'])

  mysql = Mysql2::Client.new(
    :host      => mysql_options.host,
    :username  => mysql_options.user,
    :password  => mysql_options.password,
    :database  => mysql_options.path[1..-1],
    :encoding  => 'utf8',
    :reconnect => true,
  )

  mysql.server_info
rescue Exception => msg
  log.fatal("Cannot connect to MySQL server #{ENV['CLEARDB_DATABASE_URL']} - #{msg}")
  exit
end

# Connect to memcache
if ENV['MEMCACHIER_SERVERS'].nil?
  memcache = nil
  log.info("MEMCACHIER_SERVERS not supplied, disabling caching")
else
  memcache = Dalli::Client.new(
    ENV["MEMCACHIER_SERVERS"].split(","),
    {
      :username => ENV["MEMCACHIER_USERNAME"], 
      :password => ENV["MEMCACHIER_PASSWORD"]
    }
  )

  begin
    memcache.get('rage-service')
  rescue Exception => msg 
    log.warn("Cannot Contact Memcached servers at #{ENV['MEMCACHIER_SERVERS']} (#{msg}), disabling caching")
    memcache = nil
  end
end

# IoC DAL/Services

# - DAL
tracks_dal = DAL::TracksDal.new(mysql, memcache, log)
artists_dal = DAL::ArtistsDal.new(mysql, memcache, log)
playlists_dal = DAL::PlaylistsDal.new(mysql, memcache, log)
labels_dal = DAL::LabelsDal.new(mysql, memcache, log)

# Boot API
config = {
  :server => %w[thin mongrel webrick],

  :run => false,

  :bind => ENV['BIND'],
  :port => ENV['PORT'],
  
  :tracks_service  => CrudService::Service.new(tracks_dal, log),
  :artists_service  => CrudService::Service.new(artists_dal, log),
  :playlists_service  => CrudService::Service.new(playlists_dal, log),
  :labels_service  => CrudService::Service.new(labels_dal, log),
  
  :hmac_shared_secret  => ENV['HMAC_SHARED_SECRET'],
  :disable_auth        => ENV['DISABLE_AUTH'],

  :base => File.dirname(__FILE__)+"/../public",
  
  :log => log,
  
  :show_exceptions => false,
}

config.each do |k, v|
  API::RageAgainApi.set k,v
end
