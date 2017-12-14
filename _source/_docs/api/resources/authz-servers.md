---
layout: docs_page
title: Authorization Servers
---

# Authorization Server Configuration API

Use the following operations for Custom Authorization Servers:

* [Create Authorization Server](#create-authorization-server)
* [List Authorization Servers](#list-authorization-servers)
* [Get Authorization Server](#get-authorization-server)
* [Update Authorization Server](#update-authorization-server)
* [Delete Authorization Server](#delete-authorization-server)
* [Activate Authorization Server](#activate-authorization-server)
* [Deactivate Authorization Server](#deactivate-authorization-server)

#### Using the Default Authorization Server

Okta provides a pre-configured Custom Authorization Server with the name `default`.
This default authorization server includes a basic access policy and rule, which you can edit to control access. 
It allows you to specify `default` instead of the `authorizationServerId` in requests to it:

* `https://{yourOktaDomain}.com/api/v1/authorizationServers/default`  vs 
* `https://{yourOktaDomain}.com/api/v1/authorizationServers/:authorizationServerId` for other Customer Authorization Servers

#### Create Authorization Server
{:.api .api-operation}

{% api_operation post /api/v1/authorizationServers %} 

Creates a new Custom Authorization Server with key rotation mode as `AUTO`

##### Request Parameters
{:.api .api-request .api-request-params}

[Authorization Server Properties](#authorization-server-properties)

##### Response Parameters
{:.api .api-request .api-response-params}

The [Custom Authorization Server](#authorization-server-object) you just created.

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{ "name": "Sample Authorization Server",
      "description": "Sample Authorization Server description",
      "audiences": [
        "https://test.com"
      ]
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers"
~~~

##### Response Example
{:.api .api-response .api-response-example}

The [Custom Authorization Server](#authorization-server-object) you just created.

#### List Authorization Servers
{:.api .api-operation}

{% api_operation GET /api/v1/authorizationServers %}

Lists all Custom Authorization Servers in this org

##### Request Parameters
{:.api .api-request .api-request-params}

None

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers"
~~~

##### Response Example
{:.api .api-response .api-response-example}

The [Custom Authorization Server](#authorization-server-object) in this org.

#### Get Authorization Server
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/:authorizationServerId %}

Returns the Custom Authorization Server identified by *authorizationServerId*.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                                              | Type   | Required |
|:----------------------|:-------------------------------------------------------------------------|:-------|:---------|
| authorizationServerId | Custom Authorization Server ID. You can find the ID in the Okta user interface. | String | True     |

##### Response Parameters
{:.api .api-request .api-response-params}

The [Custom Authorization Server](#authorization-server-object) you requested.

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/aus5m9r1o4AsDJLe50g4"
~~~

##### Response Example
{:.api .api-response .api-response-example}

The [Custom Authorization Server](#authorization-server-object) you requested by *:authorizationServerId*.

#### Update Authorization Server
{:.api .api-operation}

{% api_operation put /api/v1/authorizationServers/:authorizationServerId %}

Updates authorization server identified by *authorizationServerId*.

>Switching between rotation modes won&#8217;t change the active signing key.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter   | Description                                                                                                     | Type                                                                                                    | Required |
|:------------|:----------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|:---------|
| name        | The name of the authorization server                                                                            | String                                                                                                  | TRUE     |
| description | The description of the authorization server                                                                     | String                                                                                                  | FALSE    |
| audiences   | The list of audiences this Custom Authorization Server can issue tokens to, currently Okta only supports one audience. | Array                                                                                                   | TRUE     |
| credentials | The credentials signing object with the `rotationMode` of the authorization server                              |     [Authorization server credentials object](oauth2.html#authorization-server-credentials-signing-object)  | FALSE    |

##### Response Parameters
{:.api .api-request .api-response-params}

The [Custom Authorization Server](#authorization-server-object) you updated

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -X PUT \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "Authorization: SSWS ${api_token}" \
  -d '{
    "name": "New Authorization Server",
    "description": "Authorization Server New Description",
    "audiences": [
      "https://api.new-resource.com"
    ]
}'   "https://${org}/api/v1/authorizationServers/aus1rqsshhhRoat780g7" \
~~~

##### Response Example
{:.api .api-response .api-response-example}

The [Custom Authorization Server](#authorization-server-object) you updated

#### Delete Authorization Server
{:.api .api-operation}

{% api_operation delete /api/v1/authorizationServers/:authorizationServerId %}

Deletes the Custom Authorization Server identified by *authorizationServerId*.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                  | Type   | Required |
|:----------------------|:---------------------------------------------|:-------|:---------|
| authorizationServerId | The ID of a Custom Authorization Server to delete | String | TRUE     |

##### Response Parameters
{:.api .api-request .api-response-params}

None

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -X DELETE \
  -H 'Accept: application/json' \
  -H 'Content-Type: application/json' \
  -H "Authorization: SSWS ${api_token}" \
"https://${org}/api/v1/authorizationServers/aus1rqsshhhRoat780g7" \
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http 
HTTP/1.1 204: No content
~~~

#### Activate Authorization Server
{:.api .api-operation}

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/lifecycle/activate %} 

Make a Custom Authorization Server available for clients

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                    | Type   | Required |
|:----------------------|:-----------------------------------------------|:-------|:---------|
| authorizationServerId | The ID of a Custom Authorization Server to activate | String | TRUE     |

##### Response Parameters
{:.api .api-request .api-response-params}

None.

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/aus1sb3dl8L5WoTOO0g7/lifecycle/activate"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http 
HTTP/1.1 204: No content
~~~

#### Deactivate Authorization Server
{:.api .api-operation}

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/lifecycle/deactivate %} 

Make a Custom Authorization Server unavailable to clients. An inactive Custom Authorization Server can be returned to `ACTIVE` status.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                      | Type   | Required |
|:----------------------|:-------------------------------------------------|:-------|:---------|
| authorizationServerId | The ID of a Custom Authorization Server to deactivate | String | TRUE     |

##### Response Parameters
{:.api .api-request .api-response-params}

None.

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/aus1sb3dl8L5WoTOO0g7/lifecycle/deactivate"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http 
HTTP/1.1 204: No content
~~~

### Policy Operations

* [Get All Policies](#get-all-policies)
* [Get a Policy](#get-a-policy)
* [Create a Policy](#create-a-policy)
* [Update a Policy](#update-a-policy)
* [Delete a Policy](#delete-a-policy)

#### Get All Policies
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/policies %}

Returns all the policies for a specified Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/policies"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the policies](#policies-object) defined in the specified Custom Authorization Server

#### Get a Policy

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/policies/:policyId %}

Returns the policies defined in the specified Custom Authorization Server ID

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| policyId              | ID of a policy                | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/policies/00p5m9xrrBffPd9ah0g4"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the policy](#policies-object) you requested

#### Create a Policy

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/policies %}

Create a policy for a Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

[Policy Object](#policies-object)

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
  -d '{
    "type": "OAUTH_AUTHORIZATION_POLICY",
    "status": "ACTIVE",
    "name": "Default Policy",
    "description": "Default policy description",
    "priority": 1,
    "conditions": {
        "clients": {
            "include": [
                "ALL_CLIENTS"
            ]
        }
    }
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/policies"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the policy](#policies-object) you created

#### Update a Policy

{% api_operation put /api/v1/authorizationServers/:authorizationServerId/policies/:policyId %}

Change the configuration of a policy specified by the *policyId*

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| policyId              | ID of a policy                | String | True     |


##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X PUT \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d `{
  "type": "OAUTH_AUTHORIZATION_POLICY",
  "id": "00p5m9xrrBffPd9ah0g4",
  "status": "ACTIVE",
  "name": "default",
  "description": "default policy",
  "priority": 1,
  "system": false,
  "conditions": {
     "clients": {
       "include": [
          "ALL_CLIENTS"
          ]
       }
   }
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/policies/00p5m9xrrBffPd9ah0g4"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the policy](#policies-object) you updated

#### Delete a Policy

{% api_operation DELETE /api/v1/authorizationServers/:authorizationServerId/policies/:policyId %}

Delete a policy specified by the *policyId*


##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| policyId              | ID of a policy                | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X DELETE \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/policies/00p5m9xrrBffPd9ah0g4"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~json 
Status 204: No content
~~~

### Scope Operations

* [Get All Scopes](#get-all-scopes)
* [Get a Scope](#get-a-scope)
* [Create a Scope](#create-a-scope)
* [Update a Scope](#update-a-scope)
* [Delete a Scope](#delete-a-scope)

#### Get All Scopes
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/scopes %}

Get the scopes defined for a specified Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/scopes"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the scopes](#scopes-object) defined in the specified Custom Authorization Server


#### Get a Scope

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/scopes/:scopeId %}

Get a scope specified by the *scopeId*

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| scopeId               | ID of a scope                 | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/scopes/scpanemfdtktNn7w10h7"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the scope](#scopes-object) you requested

#### Create a Scope

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/scopes %}

Create a scope for a Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d `{
  "description": "Drive car",
  "name": "car:drive"
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/scopes"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the scope](#scopes-object) you created

#### Update a Scope

{% api_operation put /api/v1/authorizationServers/:authorizationServerId/scopes/:scopeId %}

Change the configuration of a scope specified by the *scopeId*

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| scopeId               | ID of a scope                 | String | True     |


##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X PUT \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d `{
  "description": "Order car",
  "name": "car:order"
     }'
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/scopes/scpanemfdtktNn7w10h7"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the scope](#scopes-object) you updated

#### Delete a Scope

{% api_operation DELETE /api/v1/authorizationServers/:authorizationServerId/scopes/:scopeId %}

Delete a scope specified by the *scopeId*


##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| scopeId               | ID of a scope                 | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X DELETE \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/scopes/00p5m9xrrBffPd9ah0g4"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http 
HTTP/1.1 204: No content
~~~

### Claim Operations

* [Get All Claims](#get-all-claims)
* [Get a Claims](#get-a-claim)
* [Create a Claims](#create-a-claim)
* [Update a Claims](#update-a-claim)
* [Delete a Claims](#delete-a-claim)

#### Get All Claims
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/claims %}

Get the claims defined for a specified a Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/claims"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the claims](#claims-object) defined in the specified Custom Authorization Server


#### Get a Claim

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/claims/:claimId %}

Returns the claim specified by the *claimId*

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |
| claimId               | ID of a claim                 | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/claims/scpanemfdtktNn7w10h7"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the claim](#claims-object) you requested

#### Create a Claim

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/claims %}

Creates a claim for a Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of a Custom Authorization Server | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d `{
     "name": "carDriving",
     "status": "ACTIVE",
     "claimType": "RESOURCE",
     "valueType": "EXPRESSION",
     "value": "\"driving!\"",
     "conditions": {
       "scopes": [
         "car:drive"
         ]
       }
    }' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/claims"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the claim](#claims-object) you created

#### Update a Claim

{% api_operation put /api/v1/authorizationServers/:authorizationServerId/claims/:claimId %}

Change the configuration of a claim specified by the *claimId*

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of an Authorization server | String | True     |
| claimId               | ID of a claim                 | String | True     |


##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X PUT \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d `{
     "name": "carDriving",
     status": "ACTIVE",
     "claimType": "RESOURCE",
     "valueType": "EXPRESSION",
     "value": "\"driving!\"",
     "alwaysIncludeInToken": "true",
     "system": "false",
     "conditions": {
       "scopes": [
         "car:drive"
         ]
       }
    }'
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/claims/oclain6za1HQ0noop0h7"
~~~

##### Response Example
{:.api .api-response .api-response-example}

Returns [the claim](#claims-object) you updated

#### Delete a Claim

{% api_operation DELETE /api/v1/authorizationServers/:authorizationServerId/claims/:claimId %}

Delete a claim specified by the *claimId*


##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                   | Type   | Required |
|:----------------------|:------------------------------|:-------|:---------|
| authorizationServerId | ID of an Authorization server | String | True     |
| claimId               | ID of a claim                 | String | True     |

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X DELETE \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/claims/oclain6za1HQ0noop0h7"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http 
HTTP/1.1 204: No content
~~~

### Authorization Server Key Store Operations

* [Get Authorization Server Keys](#get-authorization-server-keys)
* [Rotate Authorization Server Keys](#rotate-authorization-server-keys)

#### Get Authorization Server Keys
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/:authorizationServerId/credentials/keys %}

Returns the current keys in rotation for a Custom Authorization Server.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description | Type | Required |
|:----------------------|:------------|:-----|:---------|
| authorizationServerId | description | type | True     |

##### Response Parameters
{:.api .api-response .api-res-params}

Returns the [keys](#authorization-server-certificate-key-object) defined for a Custom Authorization Server

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
"https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
  "keys": [
   {
      "status": "ACTIVE",
      "alg": "RS256",
      "e": "AQAB",
      "n": "g0MirhrysJMPm_wK45jvMbbyanfhl-jmTBv0o69GeifPaISaXGv8LKn3-CyJvUJcjjeHE17KtumJWVxUDRzFqtIMZ1ctCZyIAuWO0nLKilg7_EIDXJrS8k14biqkPO1lXGFwtjo3zLHeFSLw6sWf-CEN9zv6Ff3IAXb-RMYpfh-bVrWHH2PJr5HLJuIJIOLWxIgWsWCxjLW-UKI3la-gsahqTnm_r1LSCSYr6N4C-fh--w2_BW8DzTHalBYe76bNr0d7AqtR4tGazmrvc79Wa2bjyxmhhN1u9jSaZQqq-3VZEod8q35v1LoXniJQ4a2W8nDVqb6h4E8MUKYOpljTfQ",
      "kid": "RQ8DuhdxCczyMvy7GNJb4Ka3lQ99vrSo3oFBUiZjzzc",
      "kty": "RSA",
      "use": "sig",
      "_links": {
        "self": {
          "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/RQ8DuhdxCczyMvy7GNJb4Ka3lQ99vrSo3oFBUiZjzzc",
          "hints": {
            "allow": [
              "GET"
            ]
          }
        }
      }
    },
    {
      "status": "NEXT",
      "alg": "RS256",
      "e": "AQAB",
      "n": "l1hZ_g2sgBE3oHvu34T-5XP18FYJWgtul_nRNg-5xra5ySkaXEOJUDRERUG0HrR42uqf9jYrUTwg9fp-SqqNIdHRaN8EwRSDRsKAwK
            3HIJ2NJfgmrrO2ABkeyUq6rzHxAumiKv1iLFpSawSIiTEBJERtUCDcjbbqyHVFuivIFgH8L37-XDIDb0XG-R8DOoOHLJPTpsgH-rJe
            M5w96VIRZInsGC5OGWkFdtgk6OkbvVd7_TXcxLCpWeg1vlbmX-0TmG5yjSj7ek05txcpxIqYu-7FIGT0KKvXge_BOSEUlJpBhLKU28
                               OtsOnmc3NLIGXB-GeDiUZiBYQdPR-myB4ZoQ",
      "kid": "Y3vBOdYT-l-I0j-gRQ26XjutSX00TeWiSguuDhW3ngo",
      "kty": "RSA",
      "use": "sig",
      "_links": {
        "self": {
          "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/Y3vBOdYT-l-I0j-gRQ26XjutSX00TeWiSguuDhW3ngo",
          "hints": {
            "allow": [
              "GET"
            ]
          }
        }
      }    
    },
    {
      "status": "EXPIRED",
      "alg": "RS256",
      "e": "AQAB",
      "n": "lC4ehVB6W0OCtNPnz8udYH9Ao83B6EKnHA5eTcMOap_lQZ-nKtS1lZwBj4wXRVc1XmS0d2OQFA1VMQ-dHLDE3CiGfsGqWbaiZFdW7U
            GLO1nAwfDdH6xp3xwpKOMewDXbAHJlXdYYAe2ap-CE9c5WLTUBU6JROuWcorHCNJisj1aExyiY5t3JQQVGpBz2oUIHo7NRzQoKimvp
            dMvMzcYnTlk1dhlG11b1GTkBclprm1BmOP7Ltjd7aEumOJWS67nKcAZzl48Zyg5KtV11V9F9dkGt25qHauqFKL7w3wu-DYhT0hmyFc
            wn-tXS6e6HQbfHhR_MQxysLtDGOk2ViWv8AQ",
      "kid": "h5Sr3LXcpQiQlAUVPdhrdLFoIvkhRTAVs_h39bQnxlU",
      "kty": "RSA",
      "use": "sig",
      "_links": {
        "self": {
          "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/h5Sr3LXcpQiQlAUVPdhrdLFoIvkhRTAVs_h39bQnxlU",
          "hints": {
            "allow": [
              "GET"
            ]
          }
        }
      }
    },
  ]
}
~~~

* The listed `ACTIVE` key is used to sign tokens issued by the authorization server.
* The listed `NEXT` key is the next key that the authorization server will use to sign tokens when keys are rotated. The NEXT key might not be listed if it has not been generated yet.
* The listed `EXPIRED` key is the previous key that the authorization server used to sign tokens. The EXPIRED key might not be listed if no key has expired or the expired key has been deleted.

#### Rotate Authorization Server Keys
{:.api .api-operation}

{% api_operation post /api/v1/authorizationServers/:authorizationServerId/credentials/lifecycle/keyRotate %}

Rotates the current keys for a Custom Authorization Server. If you rotate keys, the `ACTIVE` key becomes the `EXPIRED` key, the `NEXT` key becomes the `ACTIVE` key, and the Custom Authorization Server immediately issues tokens signed with the new active key.

>Authorization server keys can be rotated in both *MANUAL* and *AUTO* mode, however, it is recommended to rotate keys manually only when the authorization server is in *MANUAL* mode.
>If keys are rotated manually, any intermediate cache should be invalidated and keys should be fetched again using the [get keys](oauth2.html#get-keys) endpoint.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter | Description                                             | Type   | Required |
|:----------|:--------------------------------------------------------|:-------|:---------|
| use       | Acceptable usage of the certificate. Can be only `sig`. | String | False    |

##### Response Parameters
{:.api .api-response .api-res-params}

Returns the [keys](#authorization-server-certificate-key-object) defined for a Custom Authorization Server

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: SSWS ${api_token}" \
-d '{
  "use": "sig"
}' "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/lifecycle/keyRotate"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
  "keys": [
             {
               "status": "ACTIVE",
               "alg": "RS256",
               "e": "AQAB",
               "n": "g0MirhrysJMPm_wK45jvMbbyanfhl-jmTBv0o69GeifPaISaXGv8LKn3-CyJvUJcjjeHE17KtumJWVxUDRzFqtIMZ1ctCZyIAuWO0nLKilg7_EIDXJrS8k14biqkPO1lXGFwtjo3zLHeFSLw6sWf-CEN9zv6Ff3IAXb-RMYpfh-bVrWHH2PJr5HLJuIJIOLWxIgWsWCxjLW-UKI3la-gsahqTnm_r1LSCSYr6N4C-fh--w2_BW8DzTHalBYe76bNr0d7AqtR4tGazmrvc79Wa2bjyxmhhN1u9jSaZQqq-3VZEod8q35v1LoXniJQ4a2W8nDVqb6h4E8MUKYOpljTfQ",
               "kid": "Y3vBOdYT-l-I0j-gRQ26XjutSX00TeWiSguuDhW3ngo",
               "kty": "RSA",
               "use": "sig",
               "_links": {
                 "self": {
                   "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/Y3vBOdYT-l-I0j-gRQ26XjutSX00TeWiSguuDhW3ngo",
                   "hints": {
                     "allow": [
                       "GET"
                     ]
                   }
                 }
               }
    },
             {
               "status": "NEXT",
               "alg": "RS256",
               "e": "AQAB",
               "n": "l1hZ_g2sgBE3oHvu34T-5XP18FYJWgtul_nRNg-5xra5ySkaXEOJUDRERUG0HrR42uqf9jYrUTwg9fp-SqqNIdHRaN8EwRSDRsKAwK
                     3HIJ2NJfgmrrO2ABkeyUq6rzHxAumiKv1iLFpSawSIiTEBJERtUCDcjbbqyHVFuivIFgH8L37-XDIDb0XG-R8DOoOHLJPTpsgH-rJe
                     M5w96VIRZInsGC5OGWkFdtgk6OkbvVd7_TXcxLCpWeg1vlbmX-0TmG5yjSj7ek05txcpxIqYu-7FIGT0KKvXge_BOSEUlJpBhLKU28
                     OtsOnmc3NLIGXB-GeDiUZiBYQdPR-myB4ZoQ",
               "kid": "T5dZ1dYT-l-I0j-gRQ82XjutSX00TeWiSguuDhW3zdf",
               "kty": "RSA",
               "use": "sig",
               "_links": {
                 "self": {
                 "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/T5dZ1dYT-l-I0j-gRQ82XjutSX00TeWiSguuDhW3zdf",
                 "hints": {
                   "allow": [
                     "GET"
                   ]
                 }
               }
             }      
    },
    {
      "status": "EXPIRED",
      "alg": "RS256",
      "e": "AQAB",
      "n": "lC4ehVB6W0OCtNPnz8udYH9Ao83B6EKnHA5eTcMOap_lQZ-nKtS1lZwBj4wXRVc1XmS0d2OQFA1VMQ-dHLDE3CiGfsGqWbaiZFdW7U
            GLO1nAwfDdH6xp3xwpKOMewDXbAHJlXdYYAe2ap-CE9c5WLTUBU6JROuWcorHCNJisj1aExyiY5t3JQQVGpBz2oUIHo7NRzQoKimvp
            dMvMzcYnTlk1dhlG11b1GTkBclprm1BmOP7Ltjd7aEumOJWS67nKcAZzl48Zyg5KtV11V9F9dkGt25qHauqFKL7w3wu-DYhT0hmyFc
            wn-tXS6e6HQbfHhR_MQxysLtDGOk2ViWv8AQ",
      "kid": "RQ8DuhdxCczyMvy7GNJb4Ka3lQ99vrSo3oFBUiZjzzc",
      "kty": "RSA",
               "use": "sig",
               "_links": {
                 "self": {
                 "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausnsopoM6vBRB3PD0g3/credentials/keys/RQ8DuhdxCczyMvy7GNJb4Ka3lQ99vrSo3oFBUiZjzzc",
                 "hints": {
                   "allow": [
                     "GET"
                   ]
                 }
               }
             }      
    }
  ]
}
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 400 Bad Request
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
  "errorCode": "E0000001",
  "errorSummary": "Api validation failed: rotateKeys",
  "errorLink": "E0000001",
  "errorId": "oaeprak9qKHRlaWiclJ4oPJRQ",
  "errorCauses": [
    {
      "errorSummary": "Invalid value specified for key 'use' parameter."
    }
  ]
}
~~~