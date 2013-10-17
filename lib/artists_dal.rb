require 'rubygems'

module DAL
	class ArtistsDal < CrudService::Dal

    def initialize(mysql, memcache, log) 
      super mysql, memcache, log
      @table_name = 'artists'
      @fields = {
        "id"              => { :type=>:integer },
        "name"            => { :type=>:string, :length=>255, :required=>true },
      }
      @relations = {
        "tracks" => { 
          :type           => :has_many, 
          :table          => 'tracks',
          :table_key      => 'artists_id', 
          :this_key       => 'id',
          :table_fields   => 'id,name'
        },
        "labels" => { 
          :type           => :has_many_through, 
          :table          => 'labels',
          :link_table     => 'artists_labels',
          :link_key       => 'artist_id',
          :link_field     => 'label_id',
          :table_key      => 'id', 
          :this_key       => 'id',
          :table_fields   => 'id,name',
        },
      }
      @primary_key = 'id'
      @auto_primary_key = true
    end
	end
end