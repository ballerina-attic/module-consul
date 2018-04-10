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

import ballerina/io;
import consul;
import ballerina/net.http;
import ballerina/mime;

public function main (string[] args) {

    endpoint consul:ConsulEndpoint consulEP {
        uri:args[0],
        aclToken:args[1],
        clientConfig:{}
    };

    io:println("--------------Calling registerService----------------");
    json jsonPayload = {"ID":"redis", "Name":"redis1", "Address":"localhost", "port":8000, "EnableTagOverride":false};
    var serviceRegister = consulEP -> registerService(jsonPayload);
    match serviceRegister {
        boolean response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }

    io:println("--------------Calling getService----------------");
    string serviceName = "redis1";
    var serviceDetails = consulEP -> getService(serviceName);
    match serviceDetails {
        consul:CatalogService[] response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }

    io:println("--------------Calling createKey----------------");
    string keyName = "foo";
    string value = "bar";
    var keyRegister = consulEP -> createKey(keyName, value);
    match keyRegister {
        boolean response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }

    io:println("--------------Calling registerCheck----------------");
    json jsonCheck = {"ID":"mem", "Name":"Memory utilization", "Notes":"Ensure we don't oversubscribe memory",
                         "DeregisterCriticalServiceAfter":"90m",
                         "Args":["/usr/local/bin/check_mem.py"],
                         "HTTP":"https://example.com",
                         "Method":"POST",
                         "Header":{"x-foo":["bar", "baz"]},
                         "Interval":"10s",
                         "TLSSkipVerify":true};
    var checkRegister = consulEP -> registerCheck(jsonCheck);
    match checkRegister {
        boolean response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }

    io:println("--------------Calling getCheckByState----------------");
    string state = "passing";
    var checkDetails = consulEP -> getCheckByState(state);
    match checkDetails {
        consul:HealthCheck[] response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }

    io:println("--------------Calling readKey----------------");
    string key = "foo";
    var keyValue = consulEP -> readKey(key);
    match keyValue {
        consul:Value[] response => io:println(response);
        consul:ConsulError err => io:println("Error message : " + err.errorMessage);
    }
}
