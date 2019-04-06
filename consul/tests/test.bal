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

@test:Config
function testRegisterService() {
    io:println("--------------Calling registerService----------------");
    json jsonPayload = {"ID":"redis", "Name":"redis1", "Address":"localhost", "port":8000, "EnableTagOverride":false};
    var serviceRegister = consulClient->registerService(jsonPayload);

    if (serviceRegister is boolean) {
        test:assertEquals(serviceRegister, true, msg = "Failed to call registerService()");
    } else {
        io:println(<string>serviceRegister.detail().message);
        test:assertFail(msg = <string>serviceRegister.detail().message);
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
        io:println(<string>serviceDetails.detail().message);
        test:assertFail(msg = <string>serviceDetails.detail().message);
    } else {
        test:assertNotEquals(serviceDetails, (), msg = "Failed to call getService()");
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
        io:println(<string>serviceDeregister.detail().message);
        test:assertFail(msg = <string>serviceDeregister.detail().message);
    }
}

@test:Config
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
        io:println(<string>checkRegister.detail().message);
        test:assertFail(msg = <string>checkRegister.detail().message);
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
        io:println(<string>checkDetails.detail().message);
        test:assertFail(msg = <string>checkDetails.detail().message);
    } else {
        test:assertNotEquals(checkDetails, (), msg = "Failed to call getCheckByState()");
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
        io:println(<string>checkDeregister.detail().message);
        test:assertFail(msg = <string>checkDeregister.detail().message);
    }
}

@test:Config
function testCreateKey() {
    io:println("--------------Calling createKey----------------");
    string keyName = "foo";
    string value = "bar";
    var keyRegister = consulClient->createKey(keyName, value);
    if (keyRegister is boolean) {
        test:assertEquals(keyRegister, true, msg = "Failed to call createKey()");
    } else {
        io:println(<string>keyRegister.detail().message);
        test:assertFail(msg = <string>keyRegister.detail().message);
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
        io:println(<string>keyValue.detail().message);
        test:assertFail(msg = <string>keyValue.detail().message);
    } else {
        test:assertNotEquals(keyValue, (), msg = "Failed to call readKey()");
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
        test:assertEquals(deleteKey, true, msg = "Failed to call createKey()");
    } else {
        io:println(<string>deleteKey.detail().message);
        test:assertFail(msg = <string>deleteKey.detail().message);
    }
}
