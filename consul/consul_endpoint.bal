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

public function <ConsulConfiguration consulConfig> ConsulConfiguration () {
    consulConfig.clientConfig = {};
}

public function Client::init(ConsulConfiguration consulConfig) {
    self.consulConnector.uri = consulConfig.uri;
    self.consulConnector.aclToken = consulConfig.aclToken;
    consulConfig.clientConfig.targets = [{url:consulConfig.uri}];
    self.consulConnector.clientEndpoint.init(consulConfig.clientConfig);
}

public function Client::getClient() returns ConsulConnector {
    return self.consulConnector;
}

public function Client::start() {}

public function Client::stop() {}

public function Client::register(typedesc serviceType) {}