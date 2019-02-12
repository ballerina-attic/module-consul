Connects to Consul from Ballerina.

# Module Overview

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
|  Ballerina Language         |   0.990.3                   |
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
json jsonPayload = {"ID":"redis", "Name":"redis1", "Address":"localhost", "port":8000, "EnableTagOverride":false};
var serviceRegister = consulClient->registerService(jsonPayload);
if (serviceRegister is boolean) {
   io:println("Status of the service: ", serviceRegister);
} else {
   io:println("Error: ", <string>serviceRegister.detail().message);
}
```

Get the details of the service with the given `serviceName`.
```ballerina
var serviceDetails = consulClient->getService(serviceName);
if (serviceDetails is consul:CatalogService[]) {
   io:println("Details of a particular service: ", serviceDetails);
} else {
   io:println("Error: ", <string>serviceDetails.detail().message);
}
```

Register a check in Consul with the given `jsonCheck`.
```ballerina
var checkRegister = consulClient->registerCheck(jsonCheck);
if (checkRegister is boolean) {
   io:println("Status of the check: ", checkRegister);
} else {
   io:println("Error: ", <string>checkRegister.detail().message);
}
```

Get the details of checks with the given `state`.
```ballerina
var checkDetails = consulClient->getCheckByState(state);
if (checkDetails is consul:HealthCheck[]) {
   io:println("Details of the  passing/critical state checks: ", checkDetails);
} else {
   io:println("Error: ", <string>checkDetails.detail().message);
}
```

Create the entry in Consul with the given `keyName` and `value`.
```ballerina
var keyRegister = consulClient->createKey(keyName, value);
if (keyRegister is boolean) {
   io:println("Status of the key: ", keyRegister);
} else {
   io:println("Error: ", <string>keyRegister.detail().message);
}
```

Read the key in Consul with the given `key`.
```ballerina
var keyValue = consulClient->readKey(key);
if (keyValue is consul:Value[]) {
   io:println("Details of a particular key: ", keyValue);
} else {
   io:println("Error: ", <string>keyValue.detail().message);
}
```

Deregister services with the given `serviceId`.
```ballerina
var serviceDeregister = consulClient->deregisterService(serviceId);
if (serviceDeregister is boolean) {
   io:println("Status of the service: ", serviceDeregister);
} else {
   io:println("Error: ", <string>serviceDeregister.detail().message);
}
```

Deregister checks with the given `checkId`.
```ballerina
var checkDeregister = consulClient->deregisterCheck(checkId);
if (checkDeregister is boolean) {
   io:println("Status of the check: ", checkDeregister);
} else {
   io:println("Error: ", <string>checkDeregister.detail().message);
}
```

Delete entries with the given `keyName`.
```ballerina
var deleteKey = consulClient->deleteKey(keyName);
if (deleteKey is boolean) {
   io:println("Status of the key: ", deleteKey);
} else {
   io:println("Error: ", <string>deleteKey.detail().message);
}
```
