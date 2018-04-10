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

@Description {value:"Set the client configuration."}
public function <ConsulConfiguration consulConfig> ConsulConfiguration () {
    consulConfig.clientConfig = {};
}

@Description {value:"Initialize Consul endpoint."}
@Param {value:"consulConfig:Configuration from Consul."}
public function ConsulClient::init(ConsulConfiguration consulConfig) {
    consulConnector.uri = consulConfig.uri;
    consulConnector.aclToken = consulConfig.aclToken;
    consulConfig.clientConfig.targets = [{url:consulConfig.uri}];
    consulConnector.clientEndpoint.init(consulConfig.clientConfig);
}

@Description {value:"Returns the connector that client code uses"}
@Return {value:"The connector that client code uses"}
function ConsulClient::getClient() returns ConsulConnector {
    return consulConnector;
}

@Description {value:"Start Consul connector endpoint."}
public function ConsulClient::start() {}

@Description {value:"Stop Consul connector endpoint."}
public function ConsulClient::stop() {}

@Description {value:"Register Consul connector endpoint."}
@Param {value:"typedesc: Accepts types of data (int, float, string, boolean, etc)"}
public function ConsulClient::register(typedesc serviceType) {}