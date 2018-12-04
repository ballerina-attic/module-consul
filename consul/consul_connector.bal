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
# + aclToken - The acl token of the consul agent
# + consulClient - HTTP client endpoint
public type ConsulConnector client object {

    public string aclToken;
    public http:Client consulClient;

    public function __init(string url, ConsulConfiguration consulConfig) {
        self.consulClient = new (url, config = consulConfig.clientConfig);
        self.aclToken = consulConfig.aclToken;
    }

    # Get the details of a particular service.
    # + serviceName - The name of the service
    # + return - If success, returns CatalogService object with basic details, else returns error.
    remote function getService(string serviceName) returns CatalogService[]|error;

    # Get the details of the  passing/critical state checks.
    # + state - The state of the checks
    # + return - If success, returns HealthCheck Object with basic details, else returns error.
    remote function getCheckByState(string state) returns HealthCheck[]|error;

    # Get the details of a particular key.
    # + key - The path of the key to read
    # + return - If success, returns Value Object with basic details, else returns error.
    remote function readKey(string key) returns Value[]|error;

    # Register the service.
    # + jsonPayload - The details of the service
    # + return - If success, returns boolean else returns error.
    remote function registerService(json jsonPayload) returns boolean|error;

    # Register the check.
    # + jsonPayload - The details of the check
    # + return - If success, returns boolean else returns error.
    remote function registerCheck(json jsonPayload) returns boolean|error;

    # Create the key.
    # + keyName - Name of the key
    # + value - Value of the key
    # + return - If success, returns boolean else returns error.
    remote function createKey(string keyName, string value) returns boolean|error;

    # Deregister the service.
    # + serviceId - The id of the service
    # + return - If success, returns boolean else returns error.
    remote function deregisterService(string serviceId) returns boolean|error;

    # Deregister the check.
    # + checkId - The id of the check
    # + return - If success, returns boolean else returns error.
    remote function deregisterCheck(string checkId) returns boolean|error;

    # Delete key.
    # + keyName - Name of the key
    # + return - If success, returns boolean else returns error.
    remote function deleteKey(string keyName) returns boolean|error;

};

remote function ConsulConnector.getService(string serviceName) returns CatalogService[]|error {
    string consulPath = SERVICE_ENDPOINT + serviceName;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->get(consulPath, message = request);
    CatalogService[] serviceResponse = [];

    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        var consulJSONResponse = httpResponse.getJsonPayload();
        if (consulJSONResponse is error) {
            return consulJSONResponse;
        } else {
            if (statusCode == 200) {
                serviceResponse = convertToCatalogServices(consulJSONResponse);
                return serviceResponse;
            } else {
                error err = error(CONSUL_ERROR_CODE,{message: consulJSONResponse.errors[0].message.toString()});
                return err;
            }
        }
    }
}

remote function ConsulConnector.getCheckByState(string state) returns HealthCheck[]|error {
    string consulPath = CHECK_BY_STATE + state;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->get(consulPath, message = request);
    HealthCheck[] checkResponse = [];
    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        var consulJSONResponse = httpResponse.getJsonPayload();
        if (consulJSONResponse is error) {
            return consulJSONResponse;
        } else {
            if (statusCode == 200) {
                checkResponse = convertToHealthClients(consulJSONResponse);
                return checkResponse;
            } else {
                return setJsonResponseError(consulJSONResponse);
            }
        }
    }
}

remote function ConsulConnector.readKey(string key) returns Value[]|error {
    string consulPath = KEY_ENDPOINT + key;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->get(consulPath, message = request);
    Value[] keyResponse = [];

    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        var consulJSONResponse = httpResponse.getJsonPayload();
        if (consulJSONResponse is error) {
            return consulJSONResponse;
        } else {
            if (statusCode == 200) {
                keyResponse = convertToValues(consulJSONResponse);
                return keyResponse;
            } else {
                return setJsonResponseError(consulJSONResponse);
            }
        }
    }
}

remote function ConsulConnector.registerService(json jsonPayload) returns (boolean|error) {
    string consulPath = REGISTER_SERVICE_ENDPOINT;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = self.consulClient->put(consulPath, request);

    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

remote function ConsulConnector.registerCheck(json jsonPayload) returns boolean|error {
    string consulPath = REGISTER_CHECK_ENDPOINT;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = self.consulClient->put(consulPath, request);

    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

remote function ConsulConnector.createKey(string keyName, string value) returns boolean|error {
    string consulPath = KEY_ENDPOINT + keyName;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }
    request.setJsonPayload(value);
    var httpResponse = self.consulClient->put(consulPath, request);
    if (httpResponse is error) {
        return httpResponse;
    } else {
    int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

remote function ConsulConnector.deregisterService(string serviceId) returns boolean|error {
    string consulPath = DEREGISTER_SERVICE_ENDPOINT + serviceId;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->put(consulPath, request);
    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

remote function ConsulConnector.deregisterCheck(string checkId) returns boolean|error {
    string consulPath = DEREGISTER_CHECK_ENDPOINT + checkId;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->put(consulPath, request);
    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

remote function ConsulConnector.deleteKey(string keyName) returns boolean|error {
    string consulPath = KEY_ENDPOINT + keyName;

    http:Request request = new;
    if (self.aclToken != "") {
        request.setHeader(CONSUL_TOKEN_HEADER, self.aclToken);
    }

    var httpResponse = self.consulClient->delete(consulPath, request);
    if (httpResponse is error) {
        return httpResponse;
    } else {
        int statusCode = httpResponse.statusCode;
        if (statusCode == 200) {
            return true;
        } else {
            var consulStringResponse = httpResponse.getTextPayload();
            if (consulStringResponse is error) {
                return consulStringResponse;
            } else {
                return setStringResponseError(consulStringResponse);
            }
        }
    }
}

function setJsonResponseError(json response) returns error {
    error err = error(CONSUL_ERROR_CODE,{message: response["error"].message.toString()});
    return err;
}

function setStringResponseError(string response) returns error {
    error err = error(CONSUL_ERROR_CODE,{ message: response});
    return err;
}
