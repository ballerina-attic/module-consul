# Ballerina Consul Connector

The Consul connector allows you to access the Consul REST API through ballerina. 
The following section provide you the details on how to use Ballerina Consul connector.

## Compatibility
| Language Version                  | Connector Version   | Consul API Version|
| :-------------------------------- |:--------------------|:-----------------|
| ballerina-tools-0.970.0-beta0    | 0.6                 | v1               |

The following sections provide you with information on how to use the Ballerina Consul connector.

- [Getting started](#getting-started)

### Getting started
1. Install Consul by visiting [https://www.consul.io/intro/getting-started/install.html](https://www.consul
   .io/intro/getting-started/install.html)
2. Obtain the ACL token (Required when the ACL bootstrap is enabled in Consul agent)
3. Clone the repository by running the following command
    `git clone https://github.com/wso2-ballerina/package-consul`
4. Import the package to your ballerina project.

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
    boolean serviceRegister = check consulClient -> registerService (jsonPayload);
    test:assertEquals(serviceRegister, true, msg = "Failed to call registerService()");
}
```