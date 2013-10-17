require 'rubygems'

module DAL
	class LabelsDal < CrudService::Dal

    def initialize(mysql, memcache, log) 
      super mysql, memcache, log
      @table_name = 'labels'
      @fields = {
        "id"              => { :type=>:integer },
        "name"            => { :type=>:string, :length=>255, :required=>true },
      }
      @relations = {
        "tracks" => { 
          :type           => :has_many, 
          :table          => 'labels',
          :table_key      => 'labels_id', 
          :this_key       => 'id',
          :table_fields   => 'id,name'
        },
        "artists" => { 
          :type           => :has_many_through, 
          :table          => 'artists',
          :link_table     => 'artists_labels',
          :link_key       => 'label_id',
          :link_field     => 'artist_id',
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