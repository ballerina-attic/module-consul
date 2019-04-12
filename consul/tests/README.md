# Ballerina Consul Connector Test

The Consul connector allows you to register services and checks, deregister the services and checks, create, read and 
delete keys, list the details of the services, list the details of checks in a given state such as passing, warning, 
or critical etc.

## Compatibility
| Ballerina Language Version | Consul API version  |
| -------------------------- | ------------------- |
|  0.991.0                   | v1                  |


### Running tests

1. Install and start the consul server. For more information, see [https://linoxide.com/devops/install-consul-server-ubuntu-16/](https://linoxide.com/devops/install-consul-server-ubuntu-16/) 

2. Obtain the ACL token (required when the ACL bootstrap is enabled in the Consul agent) using the following curl command:
   ```shell
   curl -X PUT http://localhost:8500/v1/acl/bootstrap
   ```
3. Create `ballerina.conf` file in `module-consul`, with following keys and provide values for the variables.

    ```.conf
    URI=""
    ACL_TOKEN=""
    ```

4. Navigate to the folder module-consul

5. Run tests :

    ```shell
    ballerina init
    ballerina test consul --config ballerina.conf
    ```
