require 'rubygems'

module DAL
	class TracksDal < CrudService::Dal

    def initialize(mysql, memcache, log) 
      super mysql, memcache, log
      @table_name = 'tracks'
      @fields = {
        "id"              => { :type=>:integer },
        "name"            => { :type=>:string, :length=>255, :required=>true },
        "label_id"       => { :type=>:integer, :required=>true },
        "artist_id"       => { :type=>:integer, :required=>true },
      }
      @relations = {
        "artist" => { 
          :type           => :has_one, 
          :table          => 'tracks',
          :table_key      => 'id', 
          :this_key       => 'artist_id',
          :table_fields   => 'id,name'
        },
        "label" => { 
          :type           => :has_one, 
          :table          => 'labels',
          :table_key      => 'id', 
          :this_key       => 'label_id',
          :table_fields   => 'id,name'
        },
      }
      @primary_key = 'id'
      @auto_primary_key = true
    end
	end
end