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

# Claas ei_analytics_worker::params
# This class includes all the necessary parameters.
class ei_analytics_worker::params {
  $user = 'wso2carbon'
  $user_id = 802
  $user_group = 'wso2'
  $user_home = '/home/$user'
  $user_group_id = 802
  $product = 'wso2ei'
  $product_version = '6.4.0'
  $profile = 'analytics-worker'
  $service_name = "${product}-${profile}"
  $hostname = 'localhost'
  $mgt_hostname = 'localhost'
  $jdk_version = 'jdk1.8.0_192'
  $ei_package = 'wso2ei-6.4.0.zip'

  # Define the template
  $start_script_template = 'wso2/analytics/wso2/worker/bin/carbon.sh'
  $template_list = [
    'wso2/analytics/conf/worker/deployment.yaml'
  ]

  # -------------- Deploymeny.yaml Config -------------- #

  # Carbon Configuration Parameters
  $ports_offset = 0

  # transport.http config
  $default_listener_host = '0.0.0.0'
  $msf4j_host = '0.0.0.0'
  $msf4j_listener_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $msf4j_listener_keystore_password = 'wso2carbon'
  $msf4j_listener_keystore_cert_pass = 'wso2carbon'

  # siddhi.stores.query.api config
  $siddhi_default_listener_host = '0.0.0.0'
  $siddhi_msf4j_host = '0.0.0.0'
  $siddhi_msf4j_listener_keystore = '${carbon.home}/resources/security/wso2carbon.jks'
  $siddhi_msf4j_listener_keystore_password = 'wso2carbon'
  $siddhi_msf4j_listener_keystore_cert_pass = 'wso2carbon'

  # Configuration used for the databridge communication
  $databridge_keystore = '${sys:carbon.home}/resources/security/wso2carbon.jks'
  $databridge_keystore_password = 'wso2carbon'
  $binary_data_receiver_hostname = '0.0.0.0'

  # Configuration of the Data Agents - to publish events through
  $thrift_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $thrift_agent_trust_store_password = 'wso2carbon'
  $binary_agent_trust_store = '${sys:carbon.home}/resources/security/client-truststore.jks'
  $binary_agent_trust_store_password = 'wso2carbon'

  # Secure Vault Configuration
  $securevault_key_store = '${sys:carbon.home}/resources/security/securevault.jks'
  $securevault_private_key_alias = 'wso2carbon'
  $securevault_secret_properties_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/secrets.properties'
  $securevault_master_key_reader_file = '${sys:carbon.home}/conf/${sys:wso2.runtime}/master-keys.yaml'

  # Data Sources Configuration
  $metrics_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/dashboard/database/metrics;AUTO_SERVER=TRUE'
  $metrics_db_username = 'wso2carbon'
  $metrics_db_password = 'wso2carbon'
  $metrics_db_driver = 'org.h2.Driver'

  $permission_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/${sys:wso2.runtime}/database/PERMISSION_DB;IFEXISTS=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000;MVCC=TRUE'
  $permission_db_username = 'wso2carbon'
  $permission_db_password = 'wso2carbon'
  $permission_db_driver = 'org.h2.Driver'

  $message_tracing_db_url = 'jdbc:h2:${sys:carbon.home}/wso2/dashboard/database/MESSAGE_TRACING_DB;AUTO_SERVER=TRUE'
  $message_tracing_db_username = 'wso2carbon'
  $message_tracing_db_password = 'wso2carbon'
  $message_tracing_db_driver = 'org.h2.Driver'

  $ei_analytics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/EI_ANALYTICS?useSSL=false'
  $ei_analytics_db_username = 'CF_DB_USERNAME'
  $ei_analytics_db_password = 'CF_DB_PASSWORD'
  $ei_analytics_db_driver = 'com.mysql.jdbc.Driver'

  $ei_carbon_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_CARBON_DB?useSSL=false'
  $ei_carbon_db_username = 'CF_DB_USERNAME'
  $ei_carbon_db_password = 'CF_DB_PASSWORD'
  $ei_carbon_db_driver = 'com.mysql.jdbc.Driver'

  $ei_persistent_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_PERSISTENCE_DB?useSSL=false'
  $ei_persistent_username = 'CF_DB_USERNAME'
  $ei_persistent_password = 'CF_DB_PASSWORD'
  $ei_persistent_driver = 'com.mysql.jdbc.Driver'

  $ei_metrics_db_url = 'jdbc:mysql://CF_RDS_URL:3306/WSO2_METRICS_DB?useSSL=false'
  $ei_metrics_username = 'CF_DB_USERNAME'
  $ei_metrics_password = 'CF_DB_PASSWORD'
  $ei_metrics_driver = 'com.mysql.jdbc.Driver'
}
