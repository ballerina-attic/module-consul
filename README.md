# Ballerina Consul Connector

The Consul connector allows you to access the Consul REST API through ballerina. 
The following section provide you the details on how to use Ballerina Consul connector.

## Compatibility
| Language Version                  | Connector Version   | Consul API Version|
| :-------------------------------- |:--------------------|:-----------------|
| ballerina-tools-0.970.1-alpha0    | 0.6                 | v1               |

##### Getting started
1. Clone the repository by running the following command
    `git clone https://github.com/wso2-ballerina/package-consul`
2. Import the package to your ballerina project.

##### Prerequisites
1. Download the ballerina [distribution](https://ballerinalang.org/downloads/).
2. Install Consul by visiting [https://www.consul.io/intro/getting-started/install.html](https://www.consul.io/intro/getting-started/install.html)
3. Obtain the ACL token (Required when the ACL bootstrap is enabled in Consul agent)