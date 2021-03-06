class HomeUser < ChefBase

  def initialize(attributes = {})
    attributes.each_pair { |key, value|
         metaclass.send :attr_accessor, key.gsub("?","")
         send "#{key.gsub("?","")}=".to_sym, value
       }
     @@attributes = attributes

     metaclass.send :attr_accessor, "databag"
     send "databag=".to_sym, Usermanagement.find(Digest::MD5.hexdigest(self.username))

  end




  def self.find(username)
    all = []
    Node.search("users_username:#{username}").each do |node|
      node_info = {:name => node.name, :hostname => node.hostname, :errors => node.error?}
      node.automatic["users"].map{|x| all << self.new(x.merge!({"nodes" => [node_info]})) if x["username"] == username}
    end
    return all.first if all.size == 1
    all
  end

  def self.all
    all = []
    Node.search("users_username:*").each do |node|
#      node_info = {:name => node.name, :hostname => node.hostname, :errors => node.error?}
#      node.automatic["users"].map{|x| all << self.new(x.merge!({"nodes" => [node_info]}))}
#    end
#    all
#  end
      node_info = {:name => node.name, :hostname => node.hostname, :errors => node.error?}
      node.automatic['users'].each do |usernode|
        userexist = false
        all.each do |userall|
          if userall.username == usernode['username']
            userall.nodes << node_info
#            all << userall
            userexist = true
          end
        end
        unless userexist
          all << self.new(usernode.merge!({"nodes" => [node_info]}))
        end
      end
     end
    all
  end
  

  def skel
    Cookbook.skel_for("usermanagement", "usermanagement", false)
  end

  def multiple_in_skel
    Cookbook.multiple_in_skel_for("usermanagement", "usermanagement")
  end

end
