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

import ballerina/net.http;

@Description {value:"Struct to set the consul configuration."}
public struct ConsulConfiguration {
    string uri;
    string aclToken;
    http:ClientEndpointConfiguration clientConfig;
}

@Description {value:"Set the client configuration."}
public function <ConsulConfiguration consulConfig> ConsulConfiguration () {
    consulConfig.clientConfig = {};
}

@Description {value:"Consul Endpoint struct."}
public struct ConsulEndpoint {
    ConsulConfiguration consulConfig;
    ConsulConnector consulConnector;
}

@Description {value:"Initialize Consul endpoint."}
public function <ConsulEndpoint ep> init (ConsulConfiguration consulConfig) {
    ep.consulConnector = {
                             uri:consulConfig.uri,
                             aclToken:consulConfig.aclToken,
                             httpClient:http:createHttpClient(consulConfig.uri, consulConfig.clientConfig)
                         };
}

public function <ConsulConnector ep> register (typedesc serviceType) {
}

public function <ConsulConnector ep> start () {
}

@Description {value:"Returns the connector that client code uses."}
@Return {value:"The connector that client code uses."}
public function <ConsulEndpoint ep> getClient () returns ConsulConnector {
    return ep.consulConnector;
}

@Description {value:"Stops the registered service"}
@Return {value:"Error occured during registration"}
public function <ConsulEndpoint ep> stop () {
}

