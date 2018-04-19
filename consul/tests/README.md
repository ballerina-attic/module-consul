# Ballerina Consul Endpoint Test

The Consul Endpoint allows you to access the Consul REST API through ballerina. The following section provide you the 
details on how to use Ballerina Consul Endpoint.
## Compatibility
| Language Version        | Endpoint Version          | Consul API version  |
| ------------- |:-------------:| -----:|
| 0.970.0-beta1-SNAPSHOT	 | 0.6 | v1 |


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
    ballerina test consul
   ```