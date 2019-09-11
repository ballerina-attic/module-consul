[![Build Status](https://travis-ci.org/wso2-ballerina/module-consul.svg?branch=master)](https://travis-ci.org/wso2-ballerina/module-consul)
# Ballerina Consul Connector

## Module Overview

The Consul connector allows you to register services and checks, deregister services and checks, create, read and 
delete keys, list the details of the 
services, and list the details of checks in a given state through the Consul REST API.

**Service Operations**

The `wso2/consul` module contains operations that register services, deregister services and get the details of a 
particular service.

**Check Operations**

The `wso2/consul` module contains operations that register checks, deregister checks and get the details of checks
 of a given state.

**Key Operations**

The `wso2/consul` module contains operations that create entries, delete entries and get the details of a particular 
key.


## Compatibility
|                             |       Version               |
|:---------------------------:|:---------------------------:|
|  Ballerina Language         |   1.0.0                     |
|  Consul API                 |   V1                        |

## Sample

First, import the `wso2/consul` module into the Ballerina project.

```ballerina
import wso2/consul;
```

**Obtain the ACL Token to Run the Sample**

1. Install and start the consul server. For more information, see [https://linoxide.com/devops/install-consul-server-ubuntu-16/](https://linoxide.com/devops/install-consul-server-ubuntu-16/) 

2. Obtain the ACL token (required when the ACL bootstrap is enabled in the Consul agent) using the following curl command:
    ```shell
    curl -X PUT http://localhost:8500/v1/acl/bootstrap
    ```

You can now enter the token in the Consul client config:
```ballerina
consul:ConsulConfiguration consulConfig = {
    uri: "http://localhost:8500",
    aclToken: "",
    clientConfig: {}
};
    
consul:Client consulClient = new(consulConfig);
```

Register services in Consul with the given `jsonPayload`.
```ballerina
json jsonPayload = { "ID": "redis", "Name": "redis1", "Address": "localhost", "port": 8000, "EnableTagOverride": false };
var serviceRegistrationResponse = consulClient->registerService(jsonPayload);
if (serviceRegistrationResponse is boolean) {
   io:println("Status of service registration: ", serviceRegistrationResponse);
} else {
   io:println("Error: ", <string>serviceRegistrationResponse.detail().message);
}
```

Get the details of the service with the given `serviceName`.
```ballerina
var serviceDetails = consulClient->getService(serviceName);
if (serviceDetails is consul:CatalogService[]) {
   io:println("Details of the service: ", serviceDetails);
} else {
   io:println("Error: ", <string>serviceDetails.detail().message);
}
```

Register a check in Consul with the given `jsonCheck`.
```ballerina
var checkRegistrationResponse = consulClient->registerCheck(jsonCheck);
if (checkRegistrationResponse is boolean) {
   io:println("Status of the check registration: ", checkRegistrationResponse);
} else {
   io:println("Error: ", <string>checkRegistrationResponse.detail().message);
}
```

Get the details of checks with the given `state`.
```ballerina
var checkStateResponse = consulClient->getCheckByState(state);
if (checkStateResponse is consul:HealthCheck[]) {
   io:println("Details of checks by state: ", checkStateResponse);
} else {
   io:println("Error: ", <string>checkStateResponse.detail().message);
}
```

Create the entry in Consul with the given `keyName` and `value`.
```ballerina
var keyCreationResponse = consulClient->createKey(keyName, value);
if (keyCreationResponse is boolean) {
   io:println("Status of the key creation: ", keyCreationResponse);
} else {
   io:println("Error: ", <string>keyCreationResponse.detail().message);
}
```

Read the key in Consul with the given `key`.
```ballerina
var keyValue = consulClient->readKey(key);
if (keyValue is consul:Value[]) {
   io:println("Details of the key: ", keyValue);
} else {
   io:println("Error: ", <string>keyValue.detail().message);
}
```

Deregister services with the given `serviceId`.
```ballerina
var serviceDeregisterResponse = consulClient->deregisterService(serviceId);
if (serviceDeregisterResponse is boolean) {
   io:println("Status of service deregistration: ", serviceDeregisterResponse);
} else {
   io:println("Error: ", <string>serviceDeregisterResponse.detail().message);
}
```

Deregister checks with the given `checkId`.
```ballerina
var checkDeregisterResponse = consulClient->deregisterCheck(checkId);
if (checkDeregisterResponse is boolean) {
   io:println("Status of check deregistration: ", checkDeregisterResponse);
} else {
   io:println("Error: ", <string>checkDeregisterResponse.detail().message);
}
```

Delete entries with the given `keyName`.
```ballerina
var keyDeletionResponse = consulClient->deleteKey(keyName);
if (keyDeletionResponse is boolean) {
   io:println("Status of the key deletion: ", keyDeletionResponse);
} else {
   io:println("Error: ", <string>keyDeletionResponse.detail().message);
}
```
