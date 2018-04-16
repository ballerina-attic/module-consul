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

package consul;

import ballerina/http;
import ballerina/util;
import ballerina/io;

public type ConsulConnector object {
    public {
       string uri;
       string aclToken;
       http:Client clientEndpoint = new;
    }

    documentation {Get the details of a particular service
        P{{serviceName}} The name of the service
        returns CatalogService Object or Error occured during HTTP client invocation.}
    public function getService(string serviceName) returns (CatalogService[]|error);

    documentation {Get the details of the  passing/critical state checks
        P{{state}} The state of the checks
        returns HealthCheck Object or Error occured during HTTP client invocation.}
    public function getCheckByState(string state) returns (HealthCheck[]|error);

    documentation {Get the details of a particular key
        P{{key}} The path of the key to read
        returns Value Object or Error occured during HTTP client invocation.}
    public function readKey(string key) returns (Value[]|error);

    documentation {Register the service
        P{{jsonPayload}} The details of the service
        returns boolean or Error occured during HTTP client invocation.}
    public function registerService (json jsonPayload) returns (boolean|error);

    documentation {Register the check
        P{{jsonPayload}} The details of the check
        returns boolean or Error occured during HTTP client invocation.}
    public function registerCheck (json jsonPayload) returns (boolean|error);

    documentation {Create the key
        P{{keyName}} name of the key
        P{{value}} value of the key
        returns boolean or Error occured during HTTP client invocation.}
    public function createKey (string keyName, string value) returns (boolean|error);
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

    documentation {Register Consul connector endpoint
        P{{serviceType}} Accepts types of data (int, float, string, boolean, etc)
    }
    public function register (typedesc serviceType);

    documentation {Start Consul connector endpoint}
    public function start ();

    documentation {Return the Consul connector client
        returns Consul connector client
    }
    public function getClient () returns ConsulConnector;

    documentation {Stop Consul connector client}
    public function stop ();
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

documentation {value:"Struct to define the CatalogService."}
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

documentation {value:"Struct to define the HealthCheck."}
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

documentation {value:"Struct to define the Value."}
public type Value {
    int lockIndex;
    string key;
    int flags;
    string value;
    int createIndex;
    int modifyIndex;
};

documentation {value:"Struct to define the error."}
public type ConsulError {
    int statusCode;
    string message;
    error? cause;
};
