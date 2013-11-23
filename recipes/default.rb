#
# Cookbook Name:: phpunit 
# Recipe:: default 
#
# Author:: Ryuzee <ryuzee@gmail.com>
#
# Copyright 2012, Ryutaro YOSHIBA 
#
# This software is released under the MIT License.
# http://opensource.org/licenses/mit-license.php

include_recipe "php"

package "php-dom" do
  action :install
  only_if { node[:platform] == "centos" and node[:platform_version] >= "6.0" }
end

package "ImageMagick-devel" do
  action :install
end

template "/etc/php.ini" do
  source "php.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  only_if { node[:platform] == "centos"}
end

php_pear "PEAR" do
  options "--force --alldeps"
  action :upgrade
  only_if { node[:platform] == "centos" and node[:platform_version][0] == "5" }
end

channels = [
  "pear.php.net",
  "pecl.php.net",
  "components.ez.no", 
  "pear.phpunit.de", 
  "pear.phpmd.org",
  "pear.symfony-project.com",
  "pear.phing.info",
  "pear.pdepend.org",
  "pear.docblox-project.org",
]

channels.each do |chan|
  php_pear_channel chan do
    action :discover
  end
end

php_pear_channel "pear.php.net" do
  action :update
end

php_pear_channel "pecl.php.net" do
  action :update
end

# because the bugs of detecting fixed version package, I removed the version directive.
# http://tickets.opscode.com/browse/COOK-2926
php_pear "PhpDocumentor" do
  channel "pear"
  preferred_state "stable"
  action :upgrade
end

php_pear "PHP_CodeSniffer" do
  channel "pear"
  preferred_state "stable"
  action :upgrade
end

php_pear "phpcpd" do
  preferred_state "stable"
  channel "phpunit"
  action :upgrade
end

php_pear "PHP_PMD" do
  preferred_state "stable"
  channel "phpmd"
  action :upgrade
end

# If you have encountered command timeout error, you should change the timeout value at
# /usr/lib/ruby/gems/1.8/gems/chef-0.9.14/bin/../lib/chef/shell_out.rb
# Note: At chef-10.4 you can set the value of timeout.
php_pear "PHPUnit" do
  preferred_state "stable"
  channel "phpunit"
  action :upgrade
end

php_pear "phing" do
  preferred_state "alpha"
  channel "phing"
  action :upgrade
end

php_pear "xdebug" do
  action :upgrade
end

case node[:platform]
when "centos"
  template "/etc/php.d/xdebug.ini" do
    source "xdebug.ini.erb"
    owner "root"
    group "root"
    mode "0644"
  end
end

# vim: filetype=ruby.chef
