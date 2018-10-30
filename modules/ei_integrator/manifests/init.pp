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

# Class: ei_integrator
# Init class of EI Integrator default profile
class ei_integrator (
  $user = $ei_integrator::params::user,
  $user_id = $ei_integrator::params::user_id,
  $user_group = $ei_integrator::params::user_group,
  $user_group_id = $ei_integrator::params::user_group_id,
  $product = $ei_integrator::params::product,
  $product_version = $ei_integrator::params::product_version,
  $profile = $ei_integrator::params::profile,
  $service_name = $ei_integrator::params::service_name,
  $template_list = $ei_integrator::params::template_list,
  $start_script_template = $ei_integrator::params::start_script_template,

  # ------ Configuration Params ------ #

  # master-datasources.xml
  $carbon_db_url = $ei_integrator::params::carbon_db_url,
  $carbon_db_username = $ei_integrator::params::carbon_db_username,
  $carbon_db_password = $ei_integrator::params::carbon_db_password,
  $carbon_db_driver = $ei_integrator::params::carbon_db_driver,

  # carbon.xml
  $security_keystore_location = $ei_integrator::params::security_keystore_location,
  $security_keystore_type = $ei_integrator::params::security_keystore_type,
  $security_keystore_password = $ei_integrator::params::security_keystore_password,
  $security_keystore_key_alias = $ei_integrator::params::security_keystore_key_alias,
  $security_keystore_key_password = $ei_integrator::params::security_keystore_key_password,

  $security_trust_store_location = $ei_integrator::params::security_trust_store_location,
  $security_trust_store_type = $ei_integrator::params::security_trust_store_type,
  $security_trust_store_password = $ei_integrator::params::security_trust_store_password,

  # axis2.xml
  $transport_receiver_keystore_location = $ei_integrator::params::transport_receiver_keystore_location,
  $transport_receiver_keystore_type = $ei_integrator::params::transport_receiver_keystore_type,
  $transport_receiver_keystore_password = $ei_integrator::params::transport_receiver_keystore_password,
  $transport_receiver_keystore_key_password = $ei_integrator::params::transport_receiver_keystore_key_password,

  $transport_receiver_trust_store_location = $ei_integrator::params::transport_receiver_trust_store_location,
  $transport_receiver_trust_store_type = $ei_integrator::params::transport_receiver_trust_store_type,
  $transport_receiver_trust_store_password = $ei_integrator::params::transport_receiver_trust_store_password,

  $transport_sender_keystore_location = $ei_integrator::params::transport_sender_keystore_location,
  $transport_sender_keystore_type = $ei_integrator::params::transport_sender_keystore_type,
  $transport_sender_keystore_password = $ei_integrator::params::transport_sender_keystore_password,
  $transport_sender_keystore_key_password = $ei_integrator::params::transport_sender_keystore_key_password,

  $transport_sender_trust_store_location = $ei_integrator::params::transport_sender_trust_store_location,
  $transport_sender_trust_store_type = $ei_integrator::params::transport_sender_trust_store_type,
  $transport_sender_trust_store_password = $ei_integrator::params::transport_sender_trust_store_password,

  $clustering_enabled = $ei_integrator::params::clustering_enabled,
  $clustering_membership_scheme = $ei_integrator::params::clustering_membership_scheme,
  $clustering_wka_members = $ei_integrator::params::clustering_wka_members,

  # user-mgt.xml
  $admin_username = $ei_integrator::params::admin_username,
  $admin_password = $ei_integrator::params::admin_password,
)

  inherits ei_integrator::params {

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
    Note: Ensure that file is available in modules -> ei_integrator -> files
  */
  # file { "${install_path}/repository/some_file":
  #   owner  => $user,
  #   group  => $user_group,
  #   mode   => '0644',
  #   source => "puppet:///modules/${module_name}/some_file",
  # }
}
