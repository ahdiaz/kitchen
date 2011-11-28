module Spice
  class Node < Spice::Chef
    def self.all(options={})
      connection.get("/nodes")
    end
    
    def self.[](name)
      connection.get("/nodes/#{name}")
    end
    
    def self.show(options={})
      raise ArgumentError, "Option :name must be present" unless options[:name]
      name = options.delete(:name)
      connection.get("/nodes/#{name}")
    end
    
    def self.create(options={})
      raise ArgumentError, "Option :name must be present" unless options[:name]
      options[:chef_type] ||= "node"
      options[:json_class] ||= "Chef::Node"
      options[:attributes] ||= {}
      options[:overrides] ||= {}
      options[:defaults] ||={}
      options[:run_list] ||= []
      connection.post("/nodes", options)
    end
    
    def self.update(options={})
      raise ArgumentError, "Option :name must be present" unless options[:name]
      name = options.delete(:name)
      connection.put("/nodes/#{name}", options)
    end
    
    def self.delete(options={})
      raise ArgumentError, "Option :name must be present" unless options[:name]
      name = options.delete(:name)
      connection.delete("/nodes/#{name}", options)
    end
  end
end