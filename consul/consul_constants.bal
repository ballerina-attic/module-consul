//
// Copyright (c) 2018, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

//Consul API endpoint
@final string SERVICE_ENDPOINT = "/v1/catalog/service/";
@final string CHECK_BY_STATE = "/v1/health/state/";
@final string REGISTER_SERVICE_ENDPOINT = "/v1/agent/service/register";
@final string REGISTER_CHECK_ENDPOINT = "/v1/agent/check/register";
@final string KEY_ENDPOINT = "/v1/kv/";

//string constants
@final string CONSUL_TOKEN_HEADER = "X-Consul-Token";
