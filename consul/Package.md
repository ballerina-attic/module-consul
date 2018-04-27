Connects to Consul from Ballerina.

# Package Overview

The Consul connector allows you to register services and checks, create and read keys, list the details of the services, and list the details of checks in a given state through the Consul REST API.

**Service Operations**

The `wso2/consul` package contains operations that register services and get the details of a particular service.

**Check Operations**

The `wso2/consul` package contains operations that register and get the details of checks of a given state.

**Key Operations**

The `wso2/consul` package contains operations that create entries and get the details of a particular key.


## Compatibility

|                                 |       Version                  |
|  :---------------------------:  |  :---------------------------: |
|  Ballerina Language             |    0.970.0                     |
|  Consul API                     |   V1                           |

## Sample

First, import the `wso2/consul` package into the Ballerina project.

```ballerina
import wso2/consul;
```

**Obtain the ACL Token to Run the Sample**

Obtain the ACL token (required when the ACL bootstrap is enabled in the Consul agent) using the following curl command:
```ballerina
curl -X PUT http://localhost:8500/v1/acl/bootstrap
```

You can now enter the token in the Consul client config:
```ballerina
endpoint Client consulClient {
    uri:uri,
    aclToken:aclToken,
};
```

Register services in Consul with the given `jsonPayload`.
```ballerina
var serviceRegister = consulClient->registerService(jsonPayload);
match serviceRegister {
    boolean response => io:println(response);
    ConsulError err => io:println(err);
}
```

Get the details of the service with the given `serviceName`.
```ballerina
var serviceDetails = consulClient->getService(serviceName);
match serviceDetails {
    CatalogService[] response => io:println(response);
    ConsulError err => io:println(err);
}
```

Register a check in Consul with the given `jsonCheck`.
```ballerina
var checkRegister = consulClient->registerCheck(jsonCheck);
match checkRegister {
    boolean response => io:println(response);
    ConsulError err => io:println(err);
}
```

Get the details of checks with the given `state`.
```ballerina
var checkDetails = consulClient->getCheckByState(state);
match checkDetails {
    HealthCheck[] response => io:println(response);
    ConsulError err => io:println(err);
}
```

Create the entry in Consul with the given `keyName` and `value`.
```ballerina
var keyRegister = consulClient->createKey(keyName, value);
match keyRegister {
    boolean response => io:println(response);
    ConsulError err => io:println(err);
}
```

Read the key in Consul with the given `key`.
```ballerina
var keyValue = consulClient->readKey(key);
match keyValue {
    Value[] response => io:println(response);
    ConsulError err => io:println(err);
}
```
