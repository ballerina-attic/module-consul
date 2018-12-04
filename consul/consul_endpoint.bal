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

import ballerina/http;

# Consul Client object.
# + consulConnector - ConsulConnector Connector object
public type Client client object {

    public ConsulConnector consulConnector;

    public function __init(ConsulConfiguration consulConfig) {
        self.consulConnector = new (consulConfig.uri, consulConfig);
    }

    # Get the details of a particular service.
    # + serviceName - The name of the service
    # + return - If success, returns CatalogService object with basic details, else returns error.
    remote function getService(string serviceName) returns CatalogService[]|error {
        return self.consulConnector->getService(serviceName);
    }

    # Get the details of the  passing / critical state checks.
    # + state - The state of the checks
    # + return - If success, returns HealthCheck Object with basic details, else returns error.
    remote function getCheckByState(string state) returns HealthCheck[]|error {
        return self.consulConnector->getCheckByState(state);
    }

    # Get the details of a particular key.
    # + key - The path of the key to read
    # + return - If success, returns Value Object with basic details, else returns error.
    remote function readKey(string key) returns Value[]|error {
        return self.consulConnector->readKey(key);
    }

    # Register the service.
    # + jsonPayload - The details of the service
    # + return - If success, returns boolean else returns error.
    remote function registerService(json jsonPayload) returns boolean|error {
        return self.consulConnector->registerService(jsonPayload);
    }

    # Register the check .
    # + jsonPayload - The details of the check
    # + return - If success, returns boolean else returns error.
    remote function registerCheck(json jsonPayload) returns boolean|error {
        return self.consulConnector->registerCheck(jsonPayload);
    }

    # Create the key.
    # + keyName - Name of the key
    # + value - Value of the key
    # + return - If success, returns boolean else returns error.
    remote function createKey(string keyName, string value) returns boolean|error {
        return self.consulConnector->createKey(keyName, value);
    }

    # Deregister the service.
    # + serviceId - The id of the service
    # + return - If success, returns boolean else returns error.
    remote function deregisterService(string serviceId) returns boolean|error {
        return self.consulConnector->deregisterService(serviceId);
    }

    # Deregister the check .
    # + checkId - The id of the check
    # + return - If success, returns boolean else returns error.
    remote function deregisterCheck(string checkId) returns boolean|error {
        return self.consulConnector->deregisterCheck(checkId);
    }

    # Delete key.
    # + keyName - Name of the key
    # + return - If success, returns boolean else returns error.
    remote function deleteKey(string keyName) returns boolean|error {
        return self.consulConnector->deleteKey(keyName);
    }
};