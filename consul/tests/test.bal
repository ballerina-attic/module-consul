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

package tests;

import ballerina/test;
import ballerina/config;
import ballerina/io;

string uri = config:getAsString("URI");
string aclToken = config:getAsString("ACL_TOKEN");

endpoint Client consulClient {
    uri:uri,
    aclToken:aclToken,
    clientConfig:{}
};

@test:Config
function testRegisterService () {
    io:println("--------------Calling registerService----------------");
    json jsonPayload = {"ID":"redis", "Name":"redis1", "Address":"localhost", "port":8000, "EnableTagOverride":false};
    boolean serviceRegister = check consulClient -> registerService (jsonPayload);
    test:assertEquals(serviceRegister, true, msg = "Failed to call registerService()");
}

@test:Config {
    dependsOn:["testRegisterService"]
}
function testGetService () {
    io:println("--------------Calling getService----------------");
    string serviceName = "redis1";
    CatalogService[] serviceDetails = check consulClient -> getService(serviceName);
    test:assertNotEquals(serviceDetails, null, msg = "Failed to call getService()");
}

@test:Config
function testRegisterCheck () {
    io:println("--------------Calling registerCheck----------------");
    json jsonCheck = {"ID":"mem", "Name":"Memory utilization", "Notes":"Ensure we don't oversubscribe memory",
                         "DeregisterCriticalServiceAfter":"90m",
                         "Args":["/usr/local/bin/check_mem.py"],
                         "HTTP":"https://example.com",
                         "Method":"POST",
                         "Header":{"x-foo":["bar", "baz"]},
                         "Interval":"10s",
                         "TLSSkipVerify":true};
    boolean checkRegister = check consulClient -> registerCheck(jsonCheck);
    test:assertEquals(checkRegister, true, msg = "Failed to call registerCheck()");
}


@test:Config {
    dependsOn:["testRegisterCheck"]
}
function testGetCheckByState () {
    io:println("--------------Calling getCheckByState----------------");
    string state = "passing";
    HealthCheck[] checkDetails = check consulClient -> getCheckByState(state);
    test:assertNotEquals(checkDetails, null, msg = "Failed to call getCheckByState()");
}

@test:Config
function testCreateKey () {
    io:println("--------------Calling createKey----------------");
    string keyName = "foo";
    string value = "bar";
    boolean keyRegister = check consulClient -> createKey(keyName, value);
    test:assertEquals(keyRegister, true, msg = "Failed to call createKey()");
}

@test:Config {
    dependsOn:["testCreateKey"]
}
function testReadKey () {
    io:println("--------------Calling readKey----------------");
    string key = "foo";
    Value[] keyValue = check consulClient -> readKey(key);
    test:assertNotEquals(keyValue, null, msg = "Failed to call readKey()");
}
