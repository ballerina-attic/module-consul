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

documentation {Struct to define the Consul connector
     F{{uri}} - The Consul API URL
     F{{aclToken}} - The acl token of the consul agent
     F{{clientEndpoint}} - HTTP client endpoint
}
public type ConsulConnector object {
    public {
        string uri;
        string aclToken;
        http:Client clientEndpoint = new;
    }

    documentation {Get the details of a particular service
        P{{serviceName}} The name of the service
        R{{}} If success, returns CatalogService object with basic details, else returns ConsulError object.}
    public function getService(string serviceName) returns (CatalogService[]|ConsulError);

    documentation {Get the details of the  passing/critical state checks
        P{{state}} The state of the checks
        R{{}} If success, returns HealthCheck Object with basic details, else returns ConsulError object.}
    public function getCheckByState(string state) returns (HealthCheck[]|ConsulError);

    documentation {Get the details of a particular key
        P{{key}} The path of the key to read
        R{{}} If success, returns Value Object with basic details, else returns ConsulError object.}
    public function readKey(string key) returns (Value[]|ConsulError);

    documentation {Register the service
        P{{jsonPayload}} The details of the service
        R{{}} If success, returns boolean else returns ConsulError object.}
    public function registerService(json jsonPayload) returns (boolean|ConsulError);

    documentation {Register the check
        P{{jsonPayload}} The details of the check
        R{{}} If success, returns boolean else returns ConsulError object.}
    public function registerCheck(json jsonPayload) returns (boolean|ConsulError);

    documentation {Create the key
        P{{keyName}} Name of the key
        P{{value}} Value of the key
        R{{}} If success, returns boolean else returns ConsulError object.}
    public function createKey(string keyName, string value) returns (boolean|ConsulError);
};

documentation {Consul Client object
    F{{consulConfig}} Consul connector configurations
    F{{consulConnector}} Consul Connector object
}
public type Client object {
    public {
        ConsulConfiguration consulConfig = {};
        ConsulConnector consulConnector = new;
    }

    documentation {Consul connector endpoint initialization function
        P{{consulConfig}} Consul connector configuration
    }
    public function init(ConsulConfiguration consulConfig);

    documentation {Return the Consul connector client
        R{{}} Consul connector client
    }
    public function getCallerActions() returns ConsulConnector;
};

documentation {Consul connector configurations can be setup here
    F{{uri}} The Consul API URL
    F{{aclToken}} The acl token consul agent
    F{{clientConfig}} Client endpoint configurations provided by the user
}
public type ConsulConfiguration {
    string uri;
    string aclToken;
    http:ClientEndpointConfig clientConfig;
};

documentation {Struct to define the CatalogService
    F{{id}} UUID assigned to the service
    F{{node}} Name of the Consul node on which the service is registered
    F{{address}} IP address of the Consul node on which the service is registered
    F{{datacenter}} Data center of the Consul node on which the service is registered.
    F{{taggedAddresses}} List of explicit LAN and WAN IP addresses for the agent
    F{{nodeMeta}} List of user-defined metadata key/value pairs for the node
    F{{serviceId}}  A unique service instance identifier
    F{{serviceName}} Name of the service
    F{{serviceTags}}  List of tags for the service
    F{{serviceAddress}} The IP address of the service host
    F{{servicePort}} Port number of the service
    F{{serviceEnableTagOverride}} Indicates whether service tags can be overridden on this service
    F{{createIndex}} An internal index value representing when the service was created
    F{{modifyIndex}} Last index that modified the service
}
public type CatalogService {
    string id;
    string node;
    string address;
    string datacenter;
    string taggedAddresses;
    string nodeMeta;
    string serviceId;
    string serviceName;
    string[] serviceTags;
    string serviceAddress;
    int servicePort;
    boolean serviceEnableTagOverride;
    int createIndex;
    int modifyIndex;
};

documentation {Struct to define the HealthCheck
    F{{node}} Name or ID of the node
    F{{checkId}} Id of the check
    F{{name}} Name of the check
    F{{status}} Status of the check
    F{{notes}} Arbitrary information for humans
    F{{output}} A human-readable message
    F{{serviceId}} Id of the service
    F{{serviceName}} Name of the service
    F{{serviceTags}} List of tags for the service
    F{{definition}} Definition of the check
    F{{createIndex}} An internal index value representing when the check was created
    F{{modifyIndex}} Last index that modified the check
}
public type HealthCheck {
    string node;
    string checkId;
    string name;
    string status;
    string notes;
    string output;
    string serviceId;
    string serviceName;
    string[] serviceTags;
    string definition;
    int createIndex;
    int modifyIndex;
};

documentation {Struct to define the Value
    F{{lockIndex}} The number of times this key has successfully been acquired in a lock.
    F{{key}} Full path of the entry.
    F{{flags}} An opaque unsigned integer that can be attached to each entry
    F{{value}} A base64-encoded blob of data.
    F{{createIndex}} An internal index value representing when the entry was created
    F{{modifyIndex}} Last index that modified the key
}
public type Value {
    int lockIndex;
    string key;
    int flags;
    string value;
    int createIndex;
    int modifyIndex;
};

documentation {Struct to define the error
    F{{message}} - Error message of the response
    F{{cause}} - The error which caused the Consul error
    F{{statusCode}} - Status code of the response}
public type ConsulError {
    string message;
    error? cause;
    int statusCode;
};
