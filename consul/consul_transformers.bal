// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
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

package consul;

transformer <json jsonStatus, CatalogService catalogService> convertToCatalogService() {
    catalogService.id = jsonStatus.ID != null ? jsonStatus.ID.toString() : "";
    catalogService.node = jsonStatus.Node != null ? jsonStatus.Node.toString() : "";
    catalogService.address = jsonStatus.Address != null ? jsonStatus.Address.toString() : "";
    catalogService.datacenter = jsonStatus.Datacenter != null ? jsonStatus.Datacenter.toString() : "";
    catalogService.taggedAddresses = jsonStatus.TaggedAddresses != null ? jsonStatus.TaggedAddresses.toString() : "";
    catalogService.nodeMeta = jsonStatus.NodeMeta != null ? jsonStatus.NodeMeta.toString() : "";
    catalogService.serviceId = jsonStatus.ServiceID != null ? jsonStatus.ServiceID.toString() : "";
    catalogService.serviceName = jsonStatus.ServiceName != null ? jsonStatus.ServiceName.toString() : "";
    catalogService.serviceTags = jsonStatus.ServiceTags != null ?
                                 convertToArray(jsonStatus.ServiceTags) : [];
    catalogService.serviceAddress = jsonStatus.ServiceAddress != null ? jsonStatus.ServiceAddress.toString() : "";
    catalogService.servicePort = jsonStatus.ServicePort != null ? <int, convertToInt()>jsonStatus.ServicePort : 0;
    catalogService.serviceEnableTagOverride = jsonStatus.ServiceEnableTagOverride != null ? <boolean,
                                                                                            convertToBoolean()>jsonStatus.ServiceEnableTagOverride : false;
    catalogService.createIndex = jsonStatus.CreateIndex != null ? <int, convertToInt()>jsonStatus.CreateIndex : 0;
    catalogService.modifyIndex = jsonStatus.ModifyIndex != null ? <int, convertToInt()>jsonStatus.ModifyIndex : 0;
}

function convertToHealthClients (json jsonStatuses) returns HealthCheck[] {
    HealthCheck[] healthCheck = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        healthCheck[i] = <HealthCheck, convertHealthClient()>jsonStatus;
        i = i + 1;
    }
    return healthCheck;
}

function convertToCatalogServices (json jsonStatuses) returns CatalogService[] {
    CatalogService[] catalogService = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        catalogService[i] = <CatalogService, convertToCatalogService()>jsonStatus;
        i = i + 1;
    }
    return catalogService;
}

transformer <json jsonStatus, HealthCheck healthCheck> convertHealthClient() {
    healthCheck.node = jsonStatus.Node != null ? jsonStatus.Node.toString() : "";
    healthCheck.checkId = jsonStatus.CheckID != null ? jsonStatus.CheckID.toString() : "";
    healthCheck.name = jsonStatus.Name != null ? jsonStatus.Name.toString() : "";
    healthCheck.status = jsonStatus.Status != null ? jsonStatus.Status.toString() : "";
    healthCheck.notes = jsonStatus.Notes != null ? jsonStatus.Notes.toString() : "";
    healthCheck.output = jsonStatus.Output != null ? jsonStatus.Output.toString() : "";
    healthCheck.serviceId = jsonStatus.ServiceID != null ? jsonStatus.ServiceID.toString() : "";
    healthCheck.serviceName = jsonStatus.ServiceName != null ? jsonStatus.ServiceName.toString() : "";
    healthCheck.serviceTags = jsonStatus.ServiceTags != null ?
                              convertToArray(jsonStatus.ServiceTags) : [];
    healthCheck.definition = jsonStatus.Definition != null ? jsonStatus.Definition.toString() : "";
    healthCheck.createIndex = jsonStatus.CreateIndex != null ? <int, convertToInt()>jsonStatus.CreateIndex : 0;
    healthCheck.modifyIndex = jsonStatus.ModifyIndex != null ? <int, convertToInt()>jsonStatus.ModifyIndex : 0;
}

function convertToValues (json jsonStatuses) returns Value[] {
    Value[] values = [];
    int i = 0;
    foreach jsonStatus in jsonStatuses {
        values[i] = <Value, convertValues()>jsonStatus;
        i = i + 1;
    }
    return values;
}

transformer <json jsonStatus, Value value> convertValues() {
    value.lockIndex = jsonStatus.LockIndex != null ? <int, convertToInt()>jsonStatus.LockIndex : 0;
    value.key = jsonStatus.Key != null ? jsonStatus.Key.toString() : "";
    value.flags = jsonStatus.Flags != null ? <int, convertToInt()>jsonStatus.Flags : 0;
    value.value = jsonStatus.Value != null ? jsonStatus.Value.toString() : "";
    value.createIndex = jsonStatus.CreateIndex != null ? <int, convertToInt()>jsonStatus.CreateIndex : 0;
    value.modifyIndex = jsonStatus.ModifyIndex != null ? <int, convertToInt()>jsonStatus.ModifyIndex : 0;
}

transformer <json jsonVal, int intVal> convertToInt() {
    intVal =? <int>jsonVal.toString();
}

transformer <json jsonVal, boolean booleanVal> convertToBoolean() {
    booleanVal = <boolean>jsonVal.toString();
}

function convertToArray (json jsonValues) returns string[] {
    string[] serviceTags = [];
    int i = 0;
    foreach jsonVal in jsonValues {
        serviceTags[i] = jsonVal.toString();
        i = i + 1;
    }
    return serviceTags;
}

