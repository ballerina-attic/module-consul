# Ballerina Consul Endpoint

The Consul Endpoint allows you to access the Consul REST API through ballerina. 
The following section provide you the details on how to use Ballerina Consul Endpoint.

## Compatibility
| Language Version                  | Endpoint Version   | Consul API Version|
| :-------------------------------- |:--------------------|:-----------------|
| 0.970.0-beta1-SNAPSHOT	   | 0.6                 | v1               |

>> **Note :** The source code of the Consul endpoint can be found at [package-consul](https://github.com/wso2-ballerina/package-consul)

The following sections provide you with information on how to use the Ballerina Consul Endpoint.

- [Getting started](#getting-started)
- [Quick Testing](#quick-testing)

### Getting started
1. Install Consul by visiting [https://www.consul.io/intro/getting-started/install.html](https://www.consul
   .io/intro/getting-started/install.html)
2. Obtain the ACL token (Required when the ACL bootstrap is enabled in Consul agent)
3. Import the package to your ballerina project.
    ```ballerina
       import wso2/consul;
    ```
    This will download the consul artifacts from Ballerina central repository to your local repository.


### Quick Testing
1. Create a Consul endpoint.

```ballerina
   endpoint ConsulClient consulClient {
       uri:"uri",
       aclToken:"acl token",
       clientConfig:{}
   };
```

2. Register service.

```ballerina
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
```
     
3. Retrieve the details of a given service.

```ballerina
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
```

4. Register check.

```ballerina
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
```

5. Get the details of the  passing/critical state checks

```ballerina
    var checkDetails = consulClient -> getCheckByState (state);
    match checkDetails {
        HealthCheck[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call getCheckByState()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
```

6. Create Key.

```ballerina
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
``` 

7.  Read key.

```ballerina
    var keyValue = consulClient -> readKey (key);
    match keyValue {
        Value[] response => {
            test:assertNotEquals(response, null, msg = "Failed to call readKey()");
        }
        ConsulError err => {
            io:println(err.message);
            test:assertFail(msg = err.message);
        }
    }
```

##### Example

```ballerina
import ballerina/io;
import wso2/consul;

public function main(string[] args) {
    endpoint Client consulClient {
        uri:"http://localhost:8500",
        aclToken:""
    };
    
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
```
