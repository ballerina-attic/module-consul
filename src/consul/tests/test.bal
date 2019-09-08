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

import ballerina/test;
import ballerina/config;
import ballerina/io;

string testUri = config:getAsString("URI");
string testAclToken = config:getAsString("ACL_TOKEN");

ConsulConfiguration consulConfig = {
    uri: testUri,
    aclToken: testAclToken,
    clientConfig:{}
};

Client consulClient = new(consulConfig);

@test:Config {
}
function testRegisterService() {
    io:println("--------------Calling registerService----------------");
    json jsonPayload = {"ID":"redis", "Name":"redis1", "Address":"localhost", "port":8000, "EnableTagOverride":false};
    boolean|error serviceRegister = consulClient->registerService(jsonPayload);

    if (serviceRegister is boolean) {
        test:assertEquals(serviceRegister, true, msg = "Failed to call registerService()");
    } else {
       test:assertFail(msg = serviceRegister.detail()?.message ?: "failed to register service call!" );
    }
}

@test:Config {
    dependsOn:["testRegisterService"]
}
function testGetService() {
    io:println("--------------Calling getService----------------");
    string serviceName = "redis1";
    var serviceDetails = consulClient->getService(serviceName);
    if (serviceDetails is error) {
        string? val = serviceDetails.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to get service details!" );
    } else {
        test:assertTrue(serviceDetails.length() > 0, msg = "Failed to call getService()");
    }
}

@test:Config {
    dependsOn:["testGetService"]
}
function testDeregisterService() {
    io:println("--------------Calling deregisterService----------------");
    string serviceId = "redis";
    var serviceDeregister = consulClient->deregisterService(serviceId);
    if (serviceDeregister is boolean) {
        test:assertEquals(serviceDeregister, true, msg = "Failed to call deregisterService()");
    } else {
        string? val = serviceDeregister.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to test service deregister!" );
    }
}

@test:Config {}
function testRegisterCheck() {
    io:println("--------------Calling registerCheck----------------");
    json jsonCheck = {"ID":"mem", "Name":"Memory utilization", "Notes":"Ensure we don't oversubscribe memory",
        "DeregisterCriticalServiceAfter":"90m",
        "Args":["/usr/local/bin/check_mem.py"],
        "HTTP":"https://example.com",
        "Method":"POST",
        "Header":{"x-foo":["bar", "baz"]},
        "Interval":"10s",
        "TLSSkipVerify":true};
    var checkRegister = consulClient->registerCheck(jsonCheck);
    if (checkRegister is boolean) {
        test:assertEquals(checkRegister, true, msg = "Failed to call registerCheck()");
    } else {
        string? val = checkRegister.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to test register Check!" );
    }
}


@test:Config {
    dependsOn:["testRegisterCheck"]
}
function testGetCheckByState() {
    io:println("--------------Calling getCheckByState----------------");
    string state = "passing";
    var checkDetails = consulClient->getCheckByState(state);
    if (checkDetails is error) {
        string? val = checkDetails.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to test getCheckByState!" );
    } else {
        test:assertTrue(checkDetails.length() > 0, msg = "Failed to call getCheckByState()");
    }
}

@test:Config {
    dependsOn:["testGetCheckByState"]
}
function testDeregisterCheck() {
    io:println("--------------Calling deregisterCheck----------------");
    string checkId = "mem";
    var checkDeregister = consulClient->deregisterCheck(checkId);
    if (checkDeregister is boolean) {
        test:assertEquals(checkDeregister, true, msg = "Failed to call deregisterCheck()");
    } else {
        string? val = checkDeregister.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to test deregisterCheck!" );
    }
}

@test:Config {}
function testCreateKey() {
    io:println("--------------Calling createKey----------------");
    string keyName = "foo";
    string value = "bar";
    var keyRegister = consulClient->createKey(keyName, value);
    if (keyRegister is boolean) {
        test:assertEquals(keyRegister, true, msg = "Failed to call createKey()");
    } else {
        string? val = keyRegister.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to call createKey!" );
    }
}

@test:Config {
    dependsOn:["testCreateKey"]
}
function testReadKey() {
    io:println("--------------Calling readKey----------------");
    string key = "foo";
    var keyValue = consulClient->readKey(key);
    if (keyValue is error) {
        string? val = keyValue.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to call readKey!" );
    } else {
        test:assertTrue(keyValue.length() > 0, msg = "Failed to call readKey()");
    }
}

@test:Config {
    dependsOn:["testReadKey"]
}
function testDeleteKey() {
    io:println("--------------Calling deleteKey----------------");
    string keyName = "foo";
    var deleteKey = consulClient->deleteKey(keyName);
    if (deleteKey is boolean) {
        test:assertEquals(deleteKey, true, msg = "Failed to call deleteKey()");
    } else {
        string? val = deleteKey.detail()?.message;
        test:assertFail(msg = (val is string)? val: "failed to call deleteKey!" );
    }
}
