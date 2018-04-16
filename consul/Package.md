# Ballerina Consul Connector

The Consul connector allows you to access the Consul REST API through ballerina. 
The following section provide you the details on how to use Ballerina Consul connector.

## Compatibility
| Language Version                  | Connector Version   | Consul API Version|
| :-------------------------------- |:--------------------|:-----------------|
| ballerina-tools-0.970.0-beta0    | 0.6                 | v1               |

The following sections provide you with information on how to use the Ballerina Consul connector.

- [Getting started](#getting-started)
- [Quick Testing](#quick-testing)

### Getting started
1. Install Consul by visiting [https://www.consul.io/intro/getting-started/install.html](https://www.consul
   .io/intro/getting-started/install.html)
2. Obtain the ACL token (Required when the ACL bootstrap is enabled in Consul agent)
3. Clone the repository by running the following command
    `git clone https://github.com/wso2-ballerina/package-consul`
4. Import the package to your ballerina project.

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
             io:println(err.errorMessage);
             test:assertFail(msg = err.errorMessage);
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
        io:println(err.errorMessage);
        test:assertFail(msg = err.errorMessage);
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
            io:println(err.errorMessage);
            test:assertFail(msg = err.errorMessage);
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
            io:println(err.errorMessage);
            test:assertFail(msg = err.errorMessage);
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
            io:println(err.errorMessage);
            test:assertFail(msg = err.errorMessage);
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
            io:println(err.errorMessage);
            test:assertFail(msg = err.errorMessage);
        }
    }
```
