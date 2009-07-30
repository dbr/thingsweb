require 'rubygems'
# require 'sinatra'

require 'rexml/document'

xml_data = File.open("/Users/dbr/Library/Application Support/Cultured Code/Things/Database.xml").read()

doc = REXML::Document.new(xml_data)

doc.elements.each('database/object') do |ele|
  type = ele.attributes['type']
  if type == 'TODO'
    ele.each do |attrib|
      begin
        if attrib.attributes['name'] == 'title'
          puts attrib.text
        end
      rescue NoMethodError
        # puts "NoMethodError"
      end
    end
  end
end