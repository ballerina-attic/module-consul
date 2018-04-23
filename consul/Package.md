# Ballerina Consul Connector

Allows connecting Consul REST API.

The Consul Connector allows you to access the Consul REST API through ballerina. 
This connector provides facility to register services, register checks, create keys, read keys, list the details of 
the services, list the details of the check by state etc.
The following section provide you the details on how to use Ballerina Consul Connector.

## Compatibility
| Ballerina Language Version | Consul API version  |
| ------------- | -----|
| 0.970.0-beta12 | v1 |

### Getting started
1. Refer the [Getting Started guide](https://ballerina.io/learn/getting-started/) to download Ballerina and install tools.
2. Install Consul by visiting [https://www.consul.io/intro/getting-started/install.html](https://www.consul
   .io/intro/getting-started/install.html)
3. Obtain the ACL token (Required when the ACL bootstrap is enabled in Consul agent)
4. Create a new Ballerina project by executing the following command.
    ```ballerina
    <PROJECT_ROOT_DIRECTORY>$ ballerina init
    ```
5. Import the consul package to your Ballerina program as follows.

```ballerina
import ballerina/io;
import wso2/consul;

public function main(string[] args) {
    endpoint Client consulClient {
        uri:"<your_uri>",
        aclToken:"<your_aclToken>"
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
