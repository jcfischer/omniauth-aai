module OmniauthShibboleth
  module Generators
    class InitializerGenerator < Rails::Generators::Base
      namespace "shibboleth"

      source_root File.expand_path("../templates", __FILE__)
      
      argument :path_to_attribute_map_xml, :type => :string, :default => "/etc/shibboleth/attribute-map.xml"
    
      def copy_initializer_file
        template "omniauth.rb.erb", "config/initializers/omniauth.rb"
      end
    
      def attribute_fields(path_to_attribute_map_xml = self.path_to_attribute_map_xml)
        if File.exists? path_to_attribute_map_xml
          read_attributes( File.open(path_to_attribute_map_xml) )
        else
          {}
        end
      end
    
      def read_attributes(config_file)
        raise "You need nokogiri to run the generator" unless require 'nokogiri'
        doc = Nokogiri::XML(config_file)
        attributes = Hash.new
        doc.xpath('//xmlns:Attribute').each do |attr| 
           attributes[attr['id']] = (attr['aliases'].nil? ? [attr['id']] : attr['aliases'].split(" ") )
        end
        return attributes
      end
    end
  end
end
