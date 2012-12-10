#
# Cookbook Name:: bind9
# Recipe:: default
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

package "bind9"

service "bind9" do
  supports :reload => true, :restart => true
  action :start
end 


template "/etc/bind/named.conf.local" do
  owner "bind"
  group "bind"
  mode 0644
  variables(
    :zones => node['bind']['id'].keys.sort
  )
  notifies :reload, resources(:service => "bind9")
end

template "/etc/bind/named.conf.options" do
  owner "bind"
  group "bind"
  mode 0644
  notifies :reload, resources(:service => "bind9")
end
