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

public type ConsulConnector object {
    public {
       string uri;
       string aclToken;
       http:Client clientEndpoint = new;
    }

    documentation {Get the details of a particular service
        P{{serviceName}} The name of the service
        R{{}} CatalogService Object or Error occured during HTTP client invocation.}
    public function getService(string serviceName) returns (CatalogService[]|ConsulError);

    documentation {Get the details of the  passing/critical state checks
        P{{state}} The state of the checks
        R{{}} HealthCheck Object or Error occured during HTTP client invocation.}
    public function getCheckByState(string state) returns (HealthCheck[]|ConsulError);

    documentation {Get the details of a particular key
        P{{key}} The path of the key to read
        R{{}} Value Object or Error occured during HTTP client invocation.}
    public function readKey(string key) returns (Value[]|ConsulError);

    documentation {Register the service
        P{{jsonPayload}} The details of the service
        R{{}} Boolean or Error occured during HTTP client invocation.}
    public function registerService (json jsonPayload) returns (boolean|ConsulError);

    documentation {Register the check
        P{{jsonPayload}} The details of the check
        R{{}} Boolean or Error occured during HTTP client invocation.}
    public function registerCheck (json jsonPayload) returns (boolean|ConsulError);

    documentation {Create the key
        P{{keyName}} Name of the key
        P{{value}} Value of the key
        R{{}} Boolean or Error occured during HTTP client invocation.}
    public function createKey (string keyName, string value) returns (boolean|ConsulError);
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
    public function init (ConsulConfiguration consulConfig);

    documentation {Return the Consul connector client
        R{{}} Consul connector client
    }
    public function getCallerActions () returns ConsulConnector;
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

documentation {Struct to define the CatalogService.}
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

documentation {Struct to define the HealthCheck.}
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

documentation {Struct to define the Value.}
public type Value {
    int lockIndex;
    string key;
    int flags;
    string value;
    int createIndex;
    int modifyIndex;
};

documentation {Struct to define the error.}
public type ConsulError {
    string message;
    error? cause;
    int statusCode;
};
