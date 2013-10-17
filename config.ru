Encoding.default_internal = Encoding.default_external = 'UTF-8' if RUBY_VERSION >= '1.9'
$: << '.'

require "./lib/server"

run API::RageAgainApi