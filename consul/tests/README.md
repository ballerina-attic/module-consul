# Ballerina Consul Connector Test

The Consul connector allows you to access the Consul REST API through ballerina. The following section provide you the 
details on how to use Ballerina Consul connector.
## Compatibility
| Language Version        | Connector Version          | Consul API version  |
| ------------- |:-------------:| -----:|
| ballerina-tools-0.970.0-alpha3-SNAPSHOT | 0.6 | v1 |


###### Running tests

1. Create `ballerina.conf` file in `package-consul`, with following keys and provide values for the variables.

```.conf
URI=""
ACL_TOKEN=""
```

2. Run tests :
```ballerina test consul``` from your connector directory.
