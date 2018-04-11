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

@Description {value:"Struct to initialize the connection with SonarQube."}
public type ConsulConnector object {
    public {
       string uri;
       string aclToken;
       http:Client clientEndpoint = new;
    }
    public function getService(string serviceName) returns (CatalogService[]|ConsulError);
    public function getCheckByState(string state) returns (HealthCheck[]|ConsulError);
    public function readKey(string key) returns (Value[]|ConsulError);
    public function registerService (json jsonPayload) returns (boolean|ConsulError);
    public function registerCheck (json jsonPayload) returns (boolean|ConsulError);
    public function createKey (string keyName, string value) returns (boolean|ConsulError);
};

@Description {value:"Consul client struct."}
public type ConsulClient object {
    public {
        ConsulConfiguration consulConfig = {};
        ConsulConnector consulConnector = new;
    }
    public function init (ConsulConfiguration consulConfig);
    public function register (typedesc serviceType);
    public function start ();
    public function getClient () returns ConsulConnector;
    public function stop ();
};

@Description {value:"Struct to set the Consul configuration."}
public type ConsulConfiguration {
    string uri;
    string aclToken;
    http:ClientEndpointConfiguration clientConfig;
};

@Description {value:"Struct to define the CatalogService."}
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

@Description {value:"Struct to define the HealthCheck."}
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

@Description {value:"Struct to define the CattalogServiceList."}
public type Value {
    int lockIndex;
    string key;
    int flags;
    string value;
    int createIndex;
    int modifyIndex;
};

@Description {value:"Struct to define the error."}
public type ConsulError {
    int statusCode;
    string errorMessage;
};
