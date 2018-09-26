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
# + consulConfig -  Consul Connector configurations
# + consulConnector -  Consul Connector object
public type Client object {

    public ConsulConfiguration consulConfig = {};
    public ConsulConnector consulConnector = new;

    # Consul Connector endpoint initialization function.
    # + config -  Consul Connector Configuration
    public function init(ConsulConfiguration config);

    # Return the Consul Connector Client.
    # + return - Consul Connector Client
    public function getCallerActions() returns ConsulConnector;
};

# Consul Connector configurations can be setup here.
# + uri -  The Consul API URL
# + aclToken -  The acl token consul agent
# + clientConfig -  Client endpoint configurations provided by the user
public type ConsulConfiguration record {
    string uri;
    string aclToken;
    http:ClientEndpointConfig clientConfig;
};

function Client::init(ConsulConfiguration config) {
    self.consulConnector.uri = config.uri;
    self.consulConnector.aclToken = config.aclToken;
    config.clientConfig.url = config.uri;
    self.consulConnector.clientEndpoint.init(config.clientConfig);
}

function Client::getCallerActions() returns ConsulConnector {
    return self.consulConnector;
}
