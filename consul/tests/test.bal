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
    var serviceRegister = consulClient -> registerService(jsonPayload);

    match serviceRegister {
        boolean response => {
            test:assertEquals(response, true, msg = "Failed to call registerService()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testRegisterService"]
}
function testGetService () {
    io:println("--------------Calling getService----------------");
    string serviceName = "redis1";
    var serviceDetails = consulClient -> getService(serviceName);

    match serviceDetails {
        CatalogService[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getService()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
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
    var checkRegister = consulClient -> registerCheck(jsonCheck);

    match checkRegister {
        boolean response => {
            test:assertEquals(response, true, msg = "Failed to call registerCheck()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
}


@test:Config {
    dependsOn:["testRegisterCheck"]
}
function testGetCheckByState () {
    io:println("--------------Calling getCheckByState----------------");
    string state = "passing";
    var checkDetails = consulClient -> getCheckByState(state);

    match checkDetails {
        HealthCheck[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getCheckByState()");
        }
        ConsulError err => {
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config
function testCreateKey () {
    io:println("--------------Calling createKey----------------");
    string keyName = "foo";
    string value = "bar";
    var keyRegister = consulClient -> createKey(keyName, value);

    match keyRegister {
        boolean response => {
            test:assertEquals(response, true, msg = "Failed to call createKey()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
}

@test:Config {
    dependsOn:["testCreateKey"]
}
function testReadKey () {
    io:println("--------------Calling readKey----------------");
    string key = "foo";
    var keyValue = consulClient -> readKey(key);

    match keyValue {
        Value[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call readKey()");
        }
        ConsulError err => {
            test:assertFail(msg = err.message);
        }
    }
}
