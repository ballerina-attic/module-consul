# Ballerina Consul Connector

The Consul Connector allows you to access the Consul REST API through ballerina. 
The following section provide you the details on how to use Ballerina Consul Connector.

## Compatibility
| Ballerina Language Version | Consul API version  |
| ------------- | ----- |
| 0.970.0-beta11 | v1 |


The following sections provide you with information on how to use the Ballerina Consul Connector.

- [Contribute To Develop](#contribute-to-develop)
- [Working with Consul Connector actions](#working-with-consul-connector-actions)
- [Example](#example)

### Contribute To develop

Clone the repository by running the following command 
```ballerina
    git clone https://github.com/wso2-ballerina/package-consul.git
```

### Working with Consul Connector actions

All the actions return valid response or ConsulError. If the action is a success, then the requested resource will 
be returned. Else ConsulError object will be returned.

In order for you to use the Consul Connector, first you need to create a Consul Client endpoint.

```ballerina
    endpoint Client consulClient {
         uri:"http://localhost:8500",
         aclToken:"",
         clientConfig:{}
    };
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