module ThingsDb
  class Todo
    def initialize(dbfile=nil)
      @dbfile = dbfile || File.expand_path("~/Library/Application Support/Cultured Code/Things/Database.xml")
      self.all
    end

    def all
      @todos ||= self.load_xml
    end

    # Accessors for todos in specific locations

    def inbox
      self.by_focustype(:inbox)
    end

    def deleted
      self.by_focustype(:deleted)
    end

    def logbook
      self.by_focustype(:logbook)
    end

    def today
      self.by_focustype(:today)
    end

    def next
      self.by_focustype(:next)
    end

    def someday
      self.by_focustype(:someday)
    end

    # Status accessors
    def complete
      self.by_status(:complete)
    end

    def incomplete
      self.by_status(:incomplete)
    end

    def by_status(status)
      self.all.find_all{|c|
        c.status == status
      }
    end

    def by_focustype(focustype)
      self.all.find_all{|c|
        c.focustype == focustype
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
          todos << Thing.new(t)
        end
      end
      todos
    end #load_xml
  end

  class Thing
    STATUSES = {
      0 => :incomplete,
      3 => :complete,
    }
    FOCUSTYPES = {
      1 => :inbox,
      256 => :deleted,
      512 => :logbook,
      65536 => :today,
      131072 => :next,
      33554432 => :someday,
    }

    attr_reader :title, :status, :focustype, :index, :datecreated,
    :datemodified, :identifier

    def initialize(todo)
      @title = todo['title']
      @index = todo['index']
      @datecreated = todo['datecreated']
      @datemodified = todo['datemodified']

      @status = STATUSES[todo['status']]
      @focustype = FOCUSTYPES[todo['focustype']]

      @identifier = todo['identifier']
    end

    def complete?
      @status == :complete
    end

    def ==(other)
      other.identifier == @identifier
    end
    alias_method :===, :==
  end
end

t = ThingsDb::Todo.new
puts t.inbox
