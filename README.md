RAGEagain Server
================

# Introduction

A RESTful API for the RAGEagain dataset by [Patrick Galbraith](http://www.pjgalbraith.com).

# Entity Resources

All Resources support GET,PUT,POST,DELETE

* /tracks
* /artists
* /playlists
* /labels

RAGEagain is based on the ```crud-service``` gem, and supports all query/relational URL params as detailed [here](https://github.com/tomcully/crud-service)

# Authorization

POST,PUT and DELETE require HMAC authorization, similar to the Amazon AWS api.

You should supply an Authorization header:

	Authorization: HMAC user:hmac_hash

The HMAC key is set in the HMAC_SHARED_SECRET environment variable. For client requests, the hash is the base64 encoded HMAC-SHA1 of "#{verb}:#{path}:#{MD5(body)}:#{UTC_date(YYYYMMDD)}" with the shared secret as the key, e.g.:

	HMAC_SHARED_SECRET:		fOiFYoR22odgbjKsDHcQdkfiLErjGa8r
	
	Verb:					POST
	Path:					/artists
	Body:					{"name":"Danger Will Robinson"}
	MD5 Body:				6c623b354d22cb960c7904169317f6da
	UTC Date:				20131009

	To Hash: 				POST:/artists:6c623b354d22cb960c7904169317f6da:20131009
	Base64 HMAC-SHA1: 		Z2zNW8Ew9hYMKl02WkYQ+hZaL+o=

	Header:					Authorization: HMAC public:Z2zNW8Ew9hYMKl02WkYQ+hZaL+o=

The *user* parameter is currently ignored.

# ENV config

* CLEARDB_DATABASE_URL - mysql2://*username:password*@*host:port/dbname*
* MEMCACHIER_SERVERS - *memcachier hosts*
* MEMCACHIER_USERNAME - *memcachier username*
* MEMCACHIER_PASSWORD - *memcachier password*

Memcache is optional and will only be used if configured.

# Credits

Created by [@tomdionysus](http://www.twitter.com/tomdionysus)

Based on data from [RAGEagain](http://www.pjgalbraith.com/2012/08/rageagain) by [Patrick Galbraith](http://www.pjgalbraith.com)



