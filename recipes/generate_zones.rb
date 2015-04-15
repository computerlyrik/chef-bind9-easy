#
# Cookbook Name:: bind9
# Recipe:: generate_zones
#
# Copyright 2014, computerlyrik
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
config_dir = node['bind9-easy']['config_dir']

template "#{config_dir}/named.conf.local" do
  owner node['bind9-easy']['usergroup']
  group node['bind9-easy']['usergroup']
  mode 0644
  variables(
    :zones => node['bind9-easy']['id'].keys.sort
  )
  notifies :reload, 'service[bind9]'
end

template "#{config_dir}/named.conf.options" do
  owner node['bind9-easy']['usergroup']
  group node['bind9-easy']['usergroup']
  mode 0644
  notifies :restart, 'service[bind9]'
end

service 'bind9' do
  service_name node['bind9-easy']['service']
  supports :reload => true, :restart => true
  action :start
end
