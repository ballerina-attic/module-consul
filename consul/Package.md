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
   endpoint Client consulClient {
       uri:"uri",
       aclToken:"acl token",
       clientConfig:{}
   };
```

2. Register service.

```ballerina
   boolean serviceRegister = check consulClient -> registerService (jsonPayload);
   test:assertEquals(serviceRegister, true, msg = "Failed to call registerService()");
   }
```
     
3. Retrieve the details of a given service.

```ballerina
    CatalogService[] serviceDetails = check consulClient -> getService(serviceName);
    test:assertNotEquals(serviceDetails, null, msg = "Failed to call getService()");
```

4. Register check.

```ballerina
    boolean checkRegister = check consulClient -> registerCheck(jsonCheck);
    test:assertEquals(checkRegister, true, msg = "Failed to call registerCheck()");
```

5. Get the details of the  passing/critical state checks

```ballerina
    HealthCheck[] checkDetails = check consulClient -> getCheckByState(state);
    test:assertNotEquals(checkDetails, null, msg = "Failed to call getCheckByState()");
```

6. Create Key.

```ballerina
     boolean keyRegister = check consulClient -> createKey(keyName, value);
     test:assertEquals(keyRegister, true, msg = "Failed to call createKey()");
``` 

7.  Read key.

```ballerina
     Value[] keyValue = check consulClient -> readKey(key);
     test:assertNotEquals(keyValue, null, msg = "Failed to call readKey()");
```
