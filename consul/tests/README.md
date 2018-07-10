# Ballerina Consul Connector Test

The Consul connector allows you to register services and checks, deregister the services and checks, create, read and 
delete keys, list the details of the services, list the details of checks in a given state such as passing, warning, 
or critical etc.

## Compatibility
| Ballerina Language Version | Consul API version  |
| -------------------------- | ------------------- |
|  0.980.0                   | v1                  |


### Running tests

1. Create `ballerina.conf` file in `package-consul`, with following keys and provide values for the variables.

    ```.conf
    URI=""
    ACL_TOKEN=""
    ```

2. Navigate to the folder package-consul

3. Run tests :

    ```shell
    ballerina init
    ballerina test consul --config ballerina.conf
    ```
