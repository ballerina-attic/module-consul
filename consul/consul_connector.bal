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

import ballerina/io;
import ballerina/net.uri;
import ballerina/mime;

//Global Http Client
http:HttpClient httpClientGlobal = {};

//Consul Connector Struct
public struct ConsulConnector {
    string uri;
    string aclToken;
    http:HttpClient httpClient;
}

public function <ConsulConnector consulConnector> getService (string serviceName) returns CatalogService[]|ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/catalog/service/" + serviceName;

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }

    var httpResponse = consulConnector.httpClient.get(consulPath, request);
    CatalogService[] serviceResponse = [];

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var consulJSONResponse = response.getJsonPayload();
                                    match consulJSONResponse {
                                        mime:EntityError err => {
                                            consulError.errorMessage = err.message;
                                            return consulError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                serviceResponse = convertToCatalogServices(jsonResponse);
                                                return serviceResponse;
                                            } else {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }
    }
}

public function <ConsulConnector consulConnector> getCheckByState (string state) returns HealthCheck[]|
                                                                                         ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/health/state/" + state;

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }

    var httpResponse = consulConnector.httpClient.get(consulPath, request);
    HealthCheck[] checkResponse = [];

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var consulJSONResponse = response.getJsonPayload();
                                    match consulJSONResponse {
                                        mime:EntityError err => {
                                            consulError.errorMessage = err.message;
                                            return consulError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                checkResponse = convertToHealthClients(jsonResponse);
                                                return checkResponse;
                                            } else {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }
    }
}

public function <ConsulConnector consulConnector> readKey (string key) returns Value[]|
                                                                               ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/kv/" + key;

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }

    var httpResponse = consulConnector.httpClient.get(consulPath, request);
    Value[] keyResponse = [];

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    var consulJSONResponse = response.getJsonPayload();
                                    match consulJSONResponse {
                                        mime:EntityError err => {
                                            consulError.errorMessage = err.message;
                                            return consulError;
                                        }
                                        json jsonResponse => {
                                            if (statusCode == 200) {
                                                keyResponse = convertToValues(jsonResponse);
                                                return keyResponse;
                                            } else {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }
    }
}

public function <ConsulConnector consulConnector> registerService (json jsonPayload) returns boolean|
                                                                                             ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/agent/service/register";

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = consulConnector.httpClient.put(consulPath, request);

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    if (statusCode == 200) {
                                        return true;
                                    } else {
                                        var consulJSONResponse = response.getJsonPayload();
                                        match consulJSONResponse {
                                            mime:EntityError err => {
                                                consulError.errorMessage = err.message;
                                                return consulError;
                                            }
                                            json jsonResponse => {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }

    }
}

public function <ConsulConnector consulConnector> registerCheck (json jsonPayload) returns boolean|
                                                                                           ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/agent/check/register";

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }
    request.setJsonPayload(jsonPayload);
    var httpResponse = consulConnector.httpClient.put(consulPath, request);

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    if (statusCode == 200) {
                                        return true;
                                    } else {
                                        var consulJSONResponse = response.getJsonPayload();
                                        match consulJSONResponse {
                                            mime:EntityError err => {
                                                consulError.errorMessage = err.message;
                                                return consulError;
                                            }
                                            json jsonResponse => {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }
    }
}

public function <ConsulConnector consulConnector> createKey (string keyName, string value) returns boolean|
                                                                                                   ConsulError {
    ConsulError consulError = {};
    string aclToken = consulConnector.aclToken;
    string consulPath = "/v1/kv/" + keyName;

    http:Request request = {};
    if (consulConnector.aclToken != "") {
        request.setHeader("X-Consul-Token", aclToken);
    }
    request.setJsonPayload(value);
    var httpResponse = consulConnector.httpClient.put(consulPath, request);

    match httpResponse {
        http:HttpConnectorError err => { consulError.errorMessage = err.message;
                                         consulError.statusCode = err.statusCode;
                                         return consulError;
        }
        http:Response response => { int statusCode = response.statusCode;
                                    if (statusCode == 200) {
                                        return true;
                                    } else {
                                        var consulJSONResponse = response.getJsonPayload();
                                        match consulJSONResponse {
                                            mime:EntityError err => {
                                                consulError.errorMessage = err.message;
                                                return consulError;
                                            }
                                            json jsonResponse => {
                                                consulError.errorMessage = jsonResponse.error.message.toString();
                                                consulError.statusCode = statusCode;
                                                return consulError;
                                            }
                                        }
                                    }
        }
    }
}
