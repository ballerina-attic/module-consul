# Ballerina Consul Connector Test

The Consul connector allows you to register services and checks, deregister the services and checks, create, read and 
delete keys, list the details of the services, list the details of checks in a given state such as passing, warning, 
or critical etc.

## Compatibility
| Ballerina Language Version | Consul API version  |
| -------------------------- | ------------------- |
|  1.0.0                     | v1                  |


### Running tests

1. Install the consul server. You can download consul API ver 1.0.0 from [https://releases.hashicorp.com/consul/1.0.0/](https://releases.hashicorp.com/consul/1.0.0/). 

2. Enable ACLs on the consul server. You can make use of the config.json from [https://www.consul.io/docs/acl/acl-legacy.html#bootstrapping-acls](https://www.consul.io/docs/acl/acl-legacy.html#bootstrapping-acls)  

3. Obtain the ACL token (required when the ACL bootstrap is enabled in the Consul agent) using the following curl command:
   ```shell
   curl -X PUT http://localhost:8500/v1/acl/bootstrap
   ```
   or you can simple make use of the `acl_master_token` provided in the config.json.

4. Create `ballerina.conf` file in `module-consul`, with following keys and provide values for the variables.

    ```.conf
    URI=""
    ACL_TOKEN=""
    ```

5. Navigate to the folder module-consul

6. Run tests :

    ```shell
    ballerina init
    ballerina test consul --config ballerina.conf
    ```
