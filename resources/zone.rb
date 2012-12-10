#
# Cookbook Name:: bind9
# Resource:: zone
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

actions :create

default_action :create
 
attribute :domain, :kind_of => String, :name_attribute => true
attribute :ttl, :kind_of => Integer, :default => 86400
attribute :email, :kind_of => String, :required => true


attribute :refresh, :kind_of => Integer, :default => 3600
attribute :retry, :kind_of => Integer, :default => 600
attribute :expire, :kind_of => Integer, :default => 86400
attribute :neg_ttl, :kind_of => Integer, :default => 3600


attribute :nameserver, :kind_of => Array, :default => Array.new
attribute :mailserver, :kind_of => String
attribute :xmpp, :kind_of => String

attribute :hosts, :kind_of => Hash, :default => Hash.new
