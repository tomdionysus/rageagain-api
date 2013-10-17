require "rack/test"

require "server"

def app
  API::RageAgainApi
end

# def install_test_db
#   # Connect to MySQL
#   mysql_options = URI(ENV['CLEARDB_DATABASE_URL'])

#   mysql = Mysql2::Client.new(
#     :host      => mysql_options.host,
#     :username  => mysql_options.user,
#     :password  => mysql_options.password,
#     :database  => mysql_options.path[1..-1],
#     :encoding  => 'utf8',
#     :reconnect => true,
#   )

#   qry = File.read(File.dirname(__FILE__)+"/../data/test_seeds.sql")

#   qry.split(';').each do |qryline|
#     qryline.strip!
#     mysql.query(qryline)
#   end
# end

# require "installer"
# install_test_db

RSpec.configure do |config|
  config.include Rack::Test::Methods
end