// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

# Struct to define the CatalogService.
# + id - UUID assigned to the service
# + node - Name of the Consul node on which the service is registered
# + address - IP address of the Consul node on which the service is registered
# + datacenter - Data center of the Consul node on which the service is registered
# + taggedAddresses - List of explicit LAN and WAN IP addresses for the agent
# + nodeMeta - List of user-defined metadata key/value pairs for the node
# + serviceId -  A unique service instance identifier
# + serviceName - Name of the service
# + serviceTags -  List of tags for the service
# + serviceAddress - The IP address of the service host
# + servicePort - Port number of the service
# + serviceEnableTagOverride - Indicates whether service tags can be overridden on this service
# + createIndex - An internal index value representing when the service was created
# + modifyIndex - Last index that modified the service
public type CatalogService record {
    string id = "";
    string node = "";
    string address = "";
    string datacenter = "";
    string taggedAddresses = "";
    string nodeMeta = "";
    string serviceId = "";
    string serviceName = "";
    string[] serviceTags = [];
    string serviceAddress = "";
    int servicePort = 0;
    boolean serviceEnableTagOverride = false;
    int createIndex = 0;
    int modifyIndex = 0;
};

# Struct to define the HealthCheck.
# + node - Name or ID of the node
# + checkId - Id of the check
# + name - Name of the check
# + status - Status of the check
# + notes - Arbitrary information for humans
# + output - A human-readable message
# + serviceId - Id of the service
# + serviceName - Name of the service
# + serviceTags - List of tags for the service
# + definition - Definition of the check
# + createIndex - An internal index value representing when the check was created
# + modifyIndex - Last index that modified the check
public type HealthCheck record {
    string node = "";
    string checkId = "";
    string name = "";
    string status = "";
    string notes = "";
    string output = "";
    string serviceId = "";
    string serviceName = "";
    string[] serviceTags = [];
    string definition = "";
    int createIndex = 0;
    int modifyIndex = 0;
};

# Struct to define the Value.
# + lockIndex - The number of times this key has successfully been acquired in a lock
# + key - Full path of the entry.
# + flags - An opaque unsigned integer that can be attached to each entry
# + value - A base64-encoded blob of data.
# + createIndex - An internal index value representing when the entry was created
# + modifyIndex - Last index that modified the key
public type Value record {
    int lockIndex = 0;
    string key = "";
    int flags = 0;
    string value = "";
    int createIndex = 0;
    int modifyIndex = 0;
};

# Consul Connector configurations can be setup here.
# + uri -  The Consul API URL
# + aclToken -  The acl token consul agent
# + clientConfig -  Client endpoint configurations provided by the user
public type ConsulConfiguration record {
    string uri = "";
    string aclToken = "";
    http:ClientEndpointConfig clientConfig;
};
