module ThingsDb
  class Todo
    def initialize(dbfile=nil)
      @dbfile = dbfile || "/Users/dbr/Library/Application Support/Cultured Code/Things/Database.xml"
      self.all
    end

    def all
      @todos ||= self.load_xml
    end

    def today
      self.all.find_all{|c|
        c['focustype'] == 65536
      }
    end
    
    def inbox
      self.all.find_all{|c|
        c['focustype'] == 1
      }
    end
    
    def load_xml
      xml_data = File.read(@dbfile)

      doc = Hpricot.parse(xml_data)

      todos = []

      (doc/:object).each do |ele|
        ctype = ele.attributes['type']
        if ctype == 'TODO'
          t = {}
          (ele/:attribute).each do |attrib|
            name = attrib['name']
            type = attrib['type']
            value = attrib.inner_text

            if type == 'date'
              val = Time.at(value.to_i)
              val = val + 978264705 # Time lags by 31 years..
            elsif type == 'bool'
              val = (val == "1")
            elsif type == 'string'
              val = value
            elsif type == 'int32' or type == 'int16'
              val = value.to_i
            else
              val = value
            end

            t[name] = val
          end
          todos << t
        end
      end
      todos
    end #load_xml
  end
end