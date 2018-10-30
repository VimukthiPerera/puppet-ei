# ----------------------------------------------------------------------------
#  Copyright (c) 2018 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
# ----------------------------------------------------------------------------

# Class: ei_broker
# Init class of EI Integrator - Broker profile
class ei_broker (
  $user = $ei_broker::params::user,
  $user_id = $ei_broker::params::user_id,
  $user_group = $ei_broker::params::user_group,
  $user_group_id = $ei_broker::params::user_group_id,
  $product = $ei_broker::params::product,
  $product_version = $ei_broker::params::product_version,
  $profile = $ei_broker::params::profile,
  $service_name = $ei_broker::params::service_name,
  $template_list = $ei_broker::params::template_list,
  $start_script_template = $ei_broker::params::start_script_template,

  # ------ Configuration Params ------ #

  # broker.xml
  $amqp_keystore_location = $ei_broker::params::amqp_keystore_location,
  $amqp_keystore_password = $ei_broker::params::amqp_keystore_password,
  $amqp_keystore_cert_type = $ei_broker::params::amqp_keystore_cert_type,

  $amqp_trust_store_location = $ei_broker::params::amqp_trust_store_location,
  $amqp_trust_store_password = $ei_broker::params::amqp_trust_store_password,
  $amqp_trust_store_cert_type = $ei_broker::params::amqp_trust_store_cert_type,

  $mqtt_keystore_location = $ei_broker::params::mqtt_keystore_location,
  $mqtt_keystore_password = $ei_broker::params::mqtt_keystore_password,
  $mqtt_keystore_cert_type = $ei_broker::params::mqtt_keystore_cert_type,

  $mqtt_trust_store_location = $ei_broker::params::mqtt_trust_store_location,
  $mqtt_trust_store_password = $ei_broker::params::mqtt_trust_store_password,
  $mqtt_trust_store_cert_type = $ei_broker::params::mqtt_trust_store_cert_type,

  # master-datasources.xml
  $carbon_db_url = $ei_broker::params::carbon_db_url,
  $carbon_db_username = $ei_broker::params::carbon_db_username,
  $carbon_db_password = $ei_broker::params::carbon_db_password,
  $carbon_db_driver = $ei_broker::params::carbon_db_driver,

  $mb_store_db_url = $ei_broker::params::mb_store_db_url,
  $mb_store_db_username = $ei_broker::params::mb_store_db_username,
  $mb_store_db_password = $ei_broker::params::mb_store_db_password,
  $mb_store_db_driver = $ei_broker::params::mb_store_db_driver,

  # carbon.xml
  $security_keystore_location = $ei_broker::params::security_keystore_location,
  $security_keystore_type = $ei_broker::params::security_keystore_type,
  $security_keystore_password = $ei_broker::params::security_keystore_password,
  $security_keystore_key_alias = $ei_broker::params::security_keystore_key_alias,
  $security_keystore_key_password = $ei_broker::params::security_keystore_key_password,

  $security_trust_store_location = $ei_broker::params::security_trust_store_location,
  $security_trust_store_type = $ei_broker::params::security_trust_store_type,
  $security_trust_store_password = $ei_broker::params::security_trust_store_password,

  # user-mgt.xml
  $admin_username = $ei_broker::params::admin_username,
  $admin_password = $ei_broker::params::admin_password,
)

  inherits ei_broker::params {

  # Create wso2 group
  group { $user_group:
    ensure => present,
    gid    => $user_group_id,
    system => true,
  }

  # Create wso2 user
  user { $user:
    ensure => present,
    uid    => $user_id,
    gid    => $user_group_id,
    home   => "/home/${user}",
    system => true,
  }

  # Ensure the installation directory is available
  file { "/opt/${product}":
    ensure => 'directory',
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2ei":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  file { "/usr/lib/wso2/wso2ei/6.4.0/":
    ensure => directory,
    owner  => $user,
    group  => $user_group,
  }

  # Copy the relevant installer to the /opt/is directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/${ei_package}":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/${ei_package}",
  }

  # Install WSO2 Identity Server
  exec { 'unzip':
    command => 'unzip wso2ei-6.4.0.zip',
    cwd     => '/usr/lib/wso2/wso2ei/6.4.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  #jdk
  file { "/usr/lib/wso2/wso2ei/6.4.0/jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz":
    owner  => $user,
    group  => $user_group,
    mode   => '0644',
    source => "puppet:///modules/installers/jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz",
  }

  # Install WSO2 Identity Server
  exec { 'tar':
    command => 'tar -xvf jdk-8u192-ea-bin-b02-linux-x64-19_jul_2018.tar.gz',
    cwd     => '/usr/lib/wso2/wso2ei/6.4.0/',
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
  }

  # Copy configuration changes to the installed directory
  $template_list.each | String $template | {
    file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/${template}":
      ensure  => file,
      owner   => $user,
      group   => $user_group,
      mode    => '0644',
      content => template("${module_name}/carbon-home/${template}.erb")
    }
  }

  # Copy wso2server.sh to installed directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/${start_script_template}":
    ensure  => file,
    owner   => $user,
    group   => $user_group,
    mode    => '0754',
    content => template("${module_name}/carbon-home/${start_script_template}.erb")
  }

  # Copy mysql connector to the installed directory
  file { "/usr/lib/wso2/wso2ei/6.4.0/wso2ei-6.4.0/lib/mysql-connector-java-5.1.41-bin.jar":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/mysql-connector-java-5.1.41-bin.jar",
  }

  file { "/usr/local/bin/private_ip_extractor.py":
    owner  => $user,
    group  => $user_group,
    mode   => '0754',
    source => "puppet:///modules/installers/private_ip_extractor.py",
  }

  # Copy the unit file required to deploy the server as a service
  file { "/etc/systemd/system/${service_name}.service":
    ensure  => present,
    owner   => root,
    group   => root,
    mode    => '0754',
    content => template("${module_name}/${service_name}.service.erb"),
  }

  /*
    Following script can be used to copy file to a given location.
    This will copy some_file to install_path -> repository.
    Note: Ensure that file is available in modules -> ei_broker -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }
}
