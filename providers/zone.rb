#
# Cookbook Name:: bind9
# Provider:: zone
#
# Copyright 2012, computerlyrik
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


IP_CIDR_VALID_REGEX = /\b(?:\d{1,3}\.){3}\d{1,3}\b(\/[0-3]?[0-9])?/

action :create do
  hosts = Hash.new
  @new_resource.hosts.each do |name,ip_name|
    hosts[name] = Hash.new
    hosts[name][:name] = name
    if IP_CIDR_VALID_REGEX.match(ip_name)
      hosts[name][:type] = "A"
      hosts[name][:ip_name] = ip_name
    else
      hosts[name][:type] = "CNAME"
      hosts[name][:ip_name] = "#{ip_name}."
    end
  end
  if @new_resource.xmpp
    hosts["_jabber._tcp"] = {
      :type => "SRV",
      :priority => "5 0 5269",
      :ip_name => "#{@new_resource.xmpp}."
    }
    hosts["_xmpp-server._tcp"] = {
      :type => "SRV",
      :priority => "5 0 5269",
      :ip_name => "#{@new_resource.xmpp}."
    }
    hosts["_xmpp-client._tcp"] = {
      :type => "SRV",
      :priority => "5 0 5222",
      :ip_name => "#{@new_resource.xmpp}."
    }
  end
  service "bind9" do
    supports :reload => true, :restart => true
    action :start
  end 
  

  
  directory "/etc/bind/chef/"
  
  #Set up counting variable for bind id
  node.set_unless['bind']['id'][@new_resource.domain] = 1
  machines = search(:node, "domain:#{new_resource.domain}").sort
  #reload does not work properly
  template "/etc/bind/chef/#{new_resource.domain}" do
    source "zone.erb"
    cookbook "bind9"
    owner "bind"
    group "bind"
    mode 0600
    variables(
      :hosts => hosts.sort,
      :machines => machines,
      :new_resource => new_resource
    )
    notifies :restart, resources(:service => "bind9")
  end
  
  
  update = true
      
  #break the loop between template and number increment with a helper variable
  ruby_block "update-id_#{new_resource.domain}" do
    block do
      if update
        node.set['bind']['id'][new_resource.domain] = node['bind']['id'][new_resource.domain]+1
        update = false
      end
    end
    action :nothing
    subscribes :create, resources(:template => "/etc/bind/chef/#{new_resource.domain}"), :immediately
    notifies :create, resources(:template => "/etc/bind/chef/#{new_resource.domain}")
  end
  
  
  ##REVERSE ZONE(s)
  
  zones = Hash.new
  machines.each do |machine|
    iparr = machine['ipaddress'].split(".")
    zone_name = "#{iparr[2]}.#{iparr[1]}.#{iparr[0]}.in-addr.arpa"
    unless zones[zone_name] then zones[zone_name] = Hash.new end
    zones[zone_name][iparr[3]] = machine['fqdn']
    node.set_unless['bind']['id'][zone_name] = 1
  end
  
  zones.each do |zone_name,ips|

    template "/etc/bind/chef/#{zone_name}" do
      source "zone_reverse.erb"
      cookbook "bind9"
      owner "bind"
      group "bind"
      mode 0600
      variables(
        :ips => ips.sort,
        :new_resource => new_resource
      )
      #reload does not work properly
      notifies :restart, resources(:service => "bind9")
    end
  
    update_reverse = true
    #break the loop between template and number increment with a helper variable
    ruby_block "update-id_#{zone_name}" do
      block do
        if update_reverse
          node.set['bind']['id'][zone_name] = node['bind']['id'][zone_name]+1
          update_reverse = false
        end
      end
      action :nothing
      subscribes :create, resources(:template => "/etc/bind/chef/#{zone_name}"), :immediately
      notifies :create, resources(:template => "/etc/bind/chef/#{zone_name}")
    end
    
  end
end
