# Ballerina Consul Connector Test

The Consul Connector allows you to access the Consul REST API through ballerina. The following section provide you the 
details on how to use Ballerina Consul Connector.

## Compatibility
| Ballerina Language Version | Consul API version  |
| ------------- | ----- |
| 0.970.0-beta11 | v1 |


###### Running tests

1. Create `ballerina.conf` file in `package-consul`, with following keys and provide values for the variables.

```.conf
URI=""
ACL_TOKEN=""
```

2. Navigate to the folder package-consul

3. Run tests :

    ```
    ballerina init
    ballerina test consul --config ballerina.conf
   ```