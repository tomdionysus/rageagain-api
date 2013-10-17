require 'rubygems'

module DAL
	class PlaylistsDal < CrudService::Dal

    def initialize(mysql, memcache, log) 
      super mysql, memcache, log
      @table_name = 'playlists'
      @fields = {
        "id"              => { :type=>:integer },
        "title"           => { :type=>:string, :length=>255, :required=>true },
        "special"         => { :type=>:string, :length=>255, :required=>true },
        "timeslot"        => { :type=>:string, :length=>25, :required=>true },
        "url"             => { :type=>:string, :length=>255, :required=>true },
        "year"            => { :type=>:integer, :required=>true },
        "month"           => { :type=>:integer, :required=>true },
        "day"             => { :type=>:integer, :required=>true },
      }
      @relations = {
        "tracks" => { 
          :type         => :has_many_through, 
          :table        => 'tracks',
          :link_table   => 'playlist_track',
          :link_key     => 'playlist_id',
          :link_field   => 'track_id',
          :table_key    => 'id', 
          :this_key     => 'id',
          :table_fields => 'id,name,artist_id',
        }
      }
      @primary_key = 'id'
      @auto_primary_key = true
    end
	end
end