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

import ballerina/io;
import ballerina/mime;

# Define the Consul Connector.
# + uri - The Consul API URL
# + aclToken - The acl token of the consul agent
# + clientEndpoint - HTTP client endpoint
public type ConsulConnector object {
    public string uri;
    public string aclToken;
    public http:Client clientEndpoint = new;

    # Get the details of a particular service.
    # + serviceName - The name of the service
    # + return - If success, returns CatalogService object with basic details, else returns error.
    public function getService(string serviceName) returns (CatalogService[]|error);

    # Get the details of the  passing/critical state checks.
    # + state - The state of the checks
    # + return - If success, returns HealthCheck Object with basic details, else returns error.
    public function getCheckByState(string state) returns (HealthCheck[]|error);

    # Get the details of a particular key.
    # + key - The path of the key to read
    # + return - If success, returns Value Object with basic details, else returns error.
    public function readKey(string key) returns (Value[]|error);

    # Register the service.
    # + jsonPayload - The details of the service
    # + return - If success, returns boolean else returns error.
    public function registerService(json jsonPayload) returns (boolean|error);

    # Register the check.
    # + jsonPayload - The details of the check
    # + return - If success, returns boolean else returns error.
    public function registerCheck(json jsonPayload) returns (boolean|error);

    # Create the key.
    # + keyName - Name of the key
    # + value - Value of the key
    # + return - If success, returns boolean else returns error.
    public function createKey(string keyName, string value) returns (boolean|error);

    # Deregister the service.
    # + serviceId - The id of the service
    # + return - If success, returns boolean else returns error.
    public function deregisterService(string serviceId) returns (boolean|error);

    # Deregister the check.
    # + checkId - The id of the check
    # + return - If success, returns boolean else returns error.
    public function deregisterCheck(string checkId) returns (boolean|error);

    # Delete key.
    # + keyName - Name of the key
    # + return - If success, returns boolean else returns error.
    public function deleteKey(string keyName) returns (boolean|error);

};

function ConsulConnector::getService(string serviceName) returns CatalogService[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = SERVICE_ENDPOINT + serviceName;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->get(consulPath, message = request);
    CatalogService[] serviceResponse = [];

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            var consulJSONResponse = response.getJsonPayload();
            match consulJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        serviceResponse = convertToCatalogServices(jsonResponse);
                        return serviceResponse;
                    } else {
                        error err = {};
                        err.message = jsonResponse.errors[0].message.toString();
                        return err;
                    }
                }
            }
        }
    }
}

function ConsulConnector::getCheckByState(string state) returns HealthCheck[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = CHECK_BY_STATE + state;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->get(consulPath, message = request);
    HealthCheck[] checkResponse = [];

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            var consulJSONResponse = response.getJsonPayload();
            match consulJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        checkResponse = convertToHealthClients(jsonResponse);
                        return checkResponse;
                    } else {
                        return setJsonResponseError(jsonResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::readKey(string key) returns Value[]|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = KEY_ENDPOINT + key;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->get(consulPath, message = request);
    Value[] keyResponse = [];

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            var consulJSONResponse = response.getJsonPayload();
            match consulJSONResponse {
                error err => {
                    return err;
                }
                json jsonResponse => {
                    if (statusCode == 200) {
                        keyResponse = convertToValues(jsonResponse);
                        return keyResponse;
                    } else {
                        return setJsonResponseError(jsonResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::registerService(json jsonPayload) returns (boolean|error) {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = REGISTER_SERVICE_ENDPOINT;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = clientEndpoint->put(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }

    }
}

function ConsulConnector::registerCheck(json jsonPayload) returns boolean|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = REGISTER_CHECK_ENDPOINT;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = clientEndpoint->put(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::createKey(string keyName, string value) returns boolean|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = KEY_ENDPOINT + keyName;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(value);
    var httpResponse = clientEndpoint->put(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::deregisterService(string serviceId) returns boolean|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = DEREGISTER_SERVICE_ENDPOINT + serviceId;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->put(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::deregisterCheck(string checkId) returns boolean|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = DEREGISTER_CHECK_ENDPOINT + checkId;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->put(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }
    }
}

function ConsulConnector::deleteKey(string keyName) returns boolean|error {
    endpoint http:Client clientEndpoint = self.clientEndpoint;
    string consulPath = KEY_ENDPOINT + keyName;

    http:Request request;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = clientEndpoint->delete(consulPath, request);

    match httpResponse {
        error err =>
        {
            return err;
        }
        http:Response response =>
        {
            int statusCode = response.statusCode;
            if (statusCode == 200) {
                return true;
            } else {
                var consulStringResponse = response.getTextPayload();
                match consulStringResponse {
                    error err => {
                        return err;
                    }
                    string stringResponse => {
                        return setStringResponseError(stringResponse);
                    }
                }
            }
        }
    }
}

function setJsonResponseError(json response) returns error {
    error err = {};
    err.message = response.error.message.toString();
    return err;
}

function setStringResponseError(string response) returns error {
    error err = {};
    err.message = response;
    return err;
}
