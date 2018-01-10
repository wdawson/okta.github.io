---
layout: docs_page
title: Authorization Servers
---

# Authorization Servers

Authorization Servers generate OAuth 2.0 and OpenID Connect tokens, including access tokens and ID tokens. The Okta API gives you the ability to configure and manage authorization servers and the security policies that are attached to them. The following configuration operations can be found on this page:

* [Authorization Server Operations](#authorization-server-operations)
* [Policy Operations](#policy-operations)
* [Scope Operations](#scope-operations)
* [Claim Operations](#claim-operations)
* [Key Store Operations](#key-store-operations)

This page also has information about the [OAuth 2.0 Objects](#oauth-20-objects) related to these operations.

### Authorization Server Operations

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
* `https://{yourOktaDomain}.com/api/v1/authorizationServers/${authorizationServerId}` for other Customer Authorization Servers

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

{% api_operation get /api/v1/authorizationServers/${authorizationServerId} %}

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

The [Custom Authorization Server](#authorization-server-object) you requested by *${authorizationServerId}*.

#### Update Authorization Server
{:.api .api-operation}

{% api_operation put /api/v1/authorizationServers/${authorizationServerId} %}

Updates authorization server identified by *authorizationServerId*.

>Switching between rotation modes won&#8217;t change the active signing key.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter   | Description                                                                                                     | Type                                                                                                    | Required |
|:------------|:----------------------------------------------------------------------------------------------------------------|:--------------------------------------------------------------------------------------------------------|:---------|
| audiences   | The list of audiences this Custom Authorization Server can issue tokens to, currently Okta only supports one audience. | Array                                                                                                   | TRUE     |
| credentials | The credentials signing object with the `rotationMode` of the authorization server                              |[Authorization server credentials object](oauth2.html#signing-credentials-object)  | FALSE    |
| description | The description of the authorization server                                                                     | String                                                                                                  | FALSE    |
| name        | The name of the authorization server                                                                            | String                                                                                                  | TRUE     |

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

{% api_operation delete /api/v1/authorizationServers/${authorizationServerId} %}

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

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/lifecycle/activate %}

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

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/lifecycle/deactivate %}

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

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/policies %}

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

Returns [the policies](#policy-object) defined in the specified Custom Authorization Server

#### Get a Policy

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/policies/:policyId %}

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

Returns [the policy](#policy-object) you requested

#### Create a Policy

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/policies %}

Create a policy for a Custom Authorization Server

##### Request Parameters
{:.api .api-request .api-request-params}

[Policy Object](#policy-object)

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

Returns [the policy](#policy-object) you created

#### Update a Policy

{% api_operation put /api/v1/authorizationServers/${authorizationServerId}/policies/:policyId %}

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

Returns [the policy](#policy-object) you updated

#### Delete a Policy

{% api_operation DELETE /api/v1/authorizationServers/${authorizationServerId}/policies/:policyId %}

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

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/scopes %}

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

Returns [the scopes](#scope-object) defined in the specified Custom Authorization Server


#### Get a Scope

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/scopes/:scopeId %}

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

Returns [the scope](#scope-object) you requested

#### Create a Scope

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/scopes %}

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

Returns [the scope](#scope-object) you created

#### Update a Scope

{% api_operation put /api/v1/authorizationServers/${authorizationServerId}/scopes/:scopeId %}

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

Returns [the scope](#scope-object) you updated

#### Delete a Scope

{% api_operation DELETE /api/v1/authorizationServers/${authorizationServerId}/scopes/:scopeId %}

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
* [Get a Claim](#get-a-claim)
* [Create a Claim](#create-a-claim)
* [Update a Claim](#update-a-claim)
* [Delete a Claim](#delete-a-claim)

#### Get All Claims
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/claims %}

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

Returns [the claims](#claim-object) defined in the specified Custom Authorization Server


#### Get a Claim

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/claims/:claimId %}

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

Returns [the claim](#claim-object) you requested

#### Create a Claim

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/claims %}

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

Returns [the claim](#claim-object) you created

#### Update a Claim

{% api_operation put /api/v1/authorizationServers/${authorizationServerId}/claims/:claimId %}

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

Returns [the claim](#claim-object) you updated

#### Delete a Claim

{% api_operation DELETE /api/v1/authorizationServers/${authorizationServerId}/claims/:claimId %}

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

### Key Store Operations

* [Get Authorization Server Keys](#get-authorization-server-keys)
* [Rotate Authorization Server Keys](#rotate-authorization-server-keys)

#### Get Authorization Server Keys
{:.api .api-operation}

{% api_operation get /api/v1/authorizationServers/${authorizationServerId}/credentials/keys %}

Returns the current keys in rotation for a Custom Authorization Server.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description | Type | Required |
|:----------------------|:------------|:-----|:---------|
| authorizationServerId | description | type | True     |

##### Response Parameters
{:.api .api-response .api-res-params}

Returns the [keys](#certificate-json-web-key-object) defined for a Custom Authorization Server

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

{% api_operation post /api/v1/authorizationServers/${authorizationServerId}/credentials/lifecycle/keyRotate %}

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

Returns the [keys](#certificate-json-web-key-object) defined for a Custom Authorization Server

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

## OAuth 2.0 Objects

* [Authorization Server Object](#authorization-server-object)
* [Policy Object](#policy-object)
* [Rule Object](#rule-object)
* [Scope Object](#scope-object)
* [Claim Object](#claim-object)
* [Condition Object](#condition-object)
* [Signing Credentials Object](#signing-credentials-object)

### Authorization Server Object

~~~json
{
  "id": "ausain6z9zIedDCxB0h7",
  "name": "Sample Authorization Server",
  "description": "Authorization Server Description",
  "audiences": "https://api.resource.com",
  "issuer": "https://{yourOktaDomain}.com/oauth2/ausain6z9zIedDCxB0h7",
  "status": "ACTIVE",
  "created": "2017-05-17T22:25:57.000Z",
  "lastUpdated": "2017-05-17T22:25:57.000Z",
  "credentials": {
    "signing": {
      "rotationMode": "AUTO",
      "lastRotated": "2017-05-17T22:25:57.000Z",
      "nextRotation": "2017-08-15T22:25:57.000Z",
      "kid": "WYQxoK4XAwGFn5Zw5AzLxFvqEKLP79BbsKmWeuc5TB4"
    }
  },
  "_links": {
      "scopes": {
        "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/scopes",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      },
      "claims": {
        "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/claims",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      },
      "policies": {
        "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/policies",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      }
    },
    "self": {
      "href": "https:{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7",
      "hints": {
        "allow": [
          "GET",
          "DELETE",
          "PUT"
        ]
      }
    },
    "metadata": [
      {
        "name": "oauth-authorization-server",
        "href": "https:{yourOktaDomain}.com/oauth2/ausain6z9zIedDCxB0h7/.well-known/oauth-authorization-server",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      },
      {
        "name": "openid-configuration",
        "href": "{yourOktaDomain}.com/oauth2/ausain6z9zIedDCxB0h7/.well-known/openid-configuration",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      }
    ],
    "rotateKey": {
      "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/credentials/lifecycle/keyRotate",
      "hints": {
        "allow": [
          "POST"
        ]
      }
    },
    "deactivate": {
          "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/lifecycle/deactivate",
          "hints": {
            "allow": [
              "POST"
        ]
      }
    }
  }
}
~~~

#### Authorization Server Properties

| Property   | Description                                                                                                          | Type                                                                    | Required for create or update |
|:------------|:---------------------------------------------------------------------------------------------------------------------|:------------------------------------------------------------------------|:------------------------------|
| audiences   | The recipients that the tokens are intended for. This becomes the `aud` claim in an Access Token.                    | Array                                                                   | True                          |
| credentials | Keys used to sign tokens.                                                                                            | [Credentials Object](#signing-credentials-object) | False                         |
| description | The description of a Custom Authorization Server                                                                          | String                                                                  | True                          |
| issuer      | The complete URL for a Custom Authorization Server. This becomes the `iss` claim in an Access Token.                      | String                                                                  | False                         |
| name        | The name of a Custom Authorization Server                                                                                 | String                                                                  | True                          |
| status      | Indicates whether a Custom Authorization Server is `ACTIVE` or `INACTIVE`.                                                | Enum                                                                    | False                         |
| _links      | List of discoverable resources related to a Custom Authorization Server                                                   |Links                                                                  | False                         |

### Policy Object

~~~json
{
    "type": "OAUTH_AUTHORIZATION_POLICY",
    "id": "00palyaappA22DPkj0h7",
    "status": "ACTIVE",
    "name": "Vendor2 Policy",
    "description": "Vendor2 policy description",
    "priority": 1,
    "system": false,
    "conditions": {
      "clients": {
        "include": [
          "ALL_CLIENTS"
        ]
      }
    },
    "created": "2017-05-26T19:43:53.000Z",
    "lastUpdated": "2017-06-07T15:28:17.000Z",
    "_links": {
      "self": {
        "href": "{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/policies/00palyaappA22DPkj0h7",
        "hints": {
          "allow": [
            "GET",
            "PUT",
            "DELETE"
          ]
        }
      },
      "deactivate": {
        "href": "{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/policies/00palyaappA22DPkj0h7/lifecycle/deactivate",
        "hints": {
          "allow": [
            "POST"
          ]
        }
      },
      "rules": {
        "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/ausain6z9zIedDCxB0h7/policies/00palyaappA22DPkj0h7/rules",
        "hints": {
          "allow": [
            "GET"
          ]
        }
      }
    }
  }
~~~

#### Policy Properties

| Property   | Description                                                                                                         | Type                                      | Required for create or update            |
|:------------|:--------------------------------------------------------------------------------------------------------------------|:------------------------------------------|:-----------------------------------------|
| created     | Timestamp when the policy was created                                                                               | DateTime                                  | System                                   |
| conditions  | Specifies the clients that the policy will be applied to.                                                           |[Condition Object](#condition-object) | False                                    |
| description | Description of the policy                                                                                           | String                                    | True                                     |
| id          | ID of the policy                                                                                                    | String                                    | True except for create or get all claims |
| lastUpdated | Timestamp when the policy was last updated                                                                          | DateTime                                  | System                                   |
| name        | Name of the policy                                                                                                  | String                                    | True                                     |
| priority    | Specifies the order in which this policy is evaluated in relation to the other policies in a Custom Authorization Server              | Integer                                   | True                                     |
| status      | Specifies whether requests have access to this policy. Valid values: `ACTIVE` or `INACTIVE`                         | Enum                                    | True                                     |
| system      | Specifies whether Okta created this policy (`true`) or not (`false`).                                               | Boolean                                   | True                                     |
| type        | Indicates that the policy is an authorization server policy (`OAUTH_AUTHORIZATION_POLICY`)                          | String                                    | False                                    |
| _links      | List of discoverable resources related to the policy                                                                | Links                                     | System                                   |

### Rule Object

~~~json
{
  "type": "RESOURCE_ACCESS",
  "status": "ACTIVE",
  "name": "Default rule",
  "system": false,
  "conditions": {
    "people": {
      "users": {
        "include": [],
        "exclude": []
      },
      "groups": {
        "include": [
          "EVERYONE"
        ],
          "exclude": []
    }
    "scopes": {
      "include": [{
        "name": "*",
        "access": "ALLOW"
      }]
    },
  "token": {
    "accessTokenLifetimeMinutes": 60,
    "refreshTokenLifetimeMinutes": 0,
    "refreshTokenWindowMinutes": 10080
  }
}
~~~

#### Rule Properties

| Property  | Description                                                                                   | Type                                     | Required for create or update            |
|:-----------|:----------------------------------------------------------------------------------------------|:-----------------------------------------|:-----------------------------------------|
| conditions | Specifies the people, groups, grant types and scopes the rule will be applied to              |[Condition Object](#condition-object)  | False                                    |
| id         | ID of the rule                                                                                | String                                   | True except for create or get all claims |
| name       | Name of the rule                                                                              | String                                   | True                                     |
| status     | Specifies whether requests have access to this claim. Valid values: `ACTIVE` or `INACTIVE`    | Enum                                     | True                                     |
| system     | Specifies whether the rule was created by Okta or not                                         | Boolean                                  | True                                     |
| token      | Specifies lifetime durations for the token minted                                             | Integer                                  | System generated                         |

Token limits:

* accessTokenLifetimeMinutes: minimum 5 minutes, maximum 1 day
* refreshTokenLifetimeMinutes: minimum Access Token lifetime
* refreshTokenWindowMinutes: minimum 10 minutes, maximum 90 days

### Scope Object

~~~json
[
  {
    "id": "scpainazg3Ekay92V0h7",
    "name": "car:drive",
    "description": "Drive car",
    "system": false,
    "default": false,
    "displayName": "Saml Jackson",
    "consent": "REQUIRED"
  }
]
~~~

#### Scope Properties

| Property                            | Description                                                                                       | Type    | Default    | Required for create or update |
|:-------------------------------------|:--------------------------------------------------------------------------------------------------|:--------|:-----------|:------------------------------|
| consent {% api_lifecycle beta %}     | Indicates whether a consent dialog is needed for the scope. Valid values: `REQUIRED`, `IMPLICIT`. | Enum    | `IMPLICIT` | FALSE                         |
| default                              | Whether the scope is a default scope                                                              | Boolean |            | FALSE                         |
| description                          | Description of the scope                                                                          | String  |            | FALSE                         |
| displayName {% api_lifecycle beta %} | Name of the end user displayed in a consent dialog                                                | String  |            | FALSE                         |
| id                                   | ID of the scope                                                                                   | String  |            | FALSE                         |
| name                                 | Name of the scope                                                                                 | String  |            | TRUE                          |
| system                               | Whether Okta created the scope                                                                    | Boolean |            | FALSE                         |

* {% api_lifecycle beta %} A consent dialog is displayed depending on the values of three elements:
    * `prompt`, a query parameter used in requests to [`/oauth2/${authorizationServerId}/v1/authorize`](/docs/api/resources/oauth2.html#obtain-an-authorization-grant-from-a-user)(custom authorization server) or [`/oauth2/v1/authorize`](/docs/api/resources/oidc.html#authentication-request) (Org authorization server)
    * `consent_method`, a property on [apps](/docs/api/resources/apps.html#settings-7)
    * `consent`, a property on scopes as listed in the table above

    | `prompt` Value    | `consent_method`                 | `consent`                   | Result       |
    |:------------------|:---------------------------------|:----------------------------|:-------------|
    | `CONSENT`         | `TRUSTED` or `REQUIRED`          | `REQUIRED`                  | Prompted     |
    | `CONSENT`         | `TRUSTED`                        | `IMPLICIT`                  | Not prompted |
    | `NONE`            | `TRUSTED`                        | `REQUIRED` or `IMPLICIT`    | Not prompted |
    | `NONE`            | `REQUIRED`                       | `REQUIRED`                  | Prompted     |
    | `NONE`            | `REQUIRED`                       | `IMPLICIT`                  | Not prompted | <!--If you change this, change the table in /oauth2.md too. Add 'LOGIN' to first three rows when supported -->

> {% api_lifecycle beta %} Note: Apps created on `/api/v1/apps` default to `consent_method=TRUSTED`, while those created on `/api/v1/clients` default to `consent_method=REQUIRED`.

### Claim Object

~~~json
[
  {
    "id": "oclain6za1HQ0noop0h7",
    "name": "sub",
    "status": "ACTIVE",
    "claimType": "RESOURCE",
    "valueType": "EXPRESSION",
    "value": "(appuser != null) ? appuser.userName : app.clientId",
    "alwaysIncludeInToken": "TRUE"
    "conditions": {
      "scopes": []
    },
    "system": true
  },
  {
    "id": "oclain9m7hFik68qr0h7",
    "name": "carDriving",
    "status": "ACTIVE",
    "claimType": "IDENTITY",
    "valueType": "EXPRESSION",
    "value": "\"drivePlease\"",
    "alwaysIncludeInToken": "TRUE"
    "conditions": {
      "scopes": [
        "car:drive"
      ]
    },
    "system": false
  }
]
~~~

#### Claim Properties

| Property            | Description                                                                                                                                                                                                                                      | Type                                                 | Required for create or update            |
|:---------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------------------------------------------------|:-----------------------------------------|
| alwaysIncludeInToken | Specifies whether to include claims in tokens[Details](#details-for-alwaysincludeintoken)                                                                                                                                                      | Boolean                                              | False                                    |
| claimType            | Specifies whether the claim is for an Access Token (`RESOURCE`) or ID Token (`IDENTITY`)                                                                                                                                                         | Enum                                                 | True                                     |
| conditions           | Specifies the scopes for this claim                                                                                                                                                                                                              |[Condition Object](#condition-object)              | False                                    |
| groupFilterType      | Specifies the type of group filter if `valueType` is `GROUPS`.[Details](#details-for-groupfiltertype)                                                                                                                                           | Enum                                                 | False                                    |
| id                   | ID of the claim                                                                                                                                                                                                                                  | String                                               | True except for create or get all claims |
| name                 | Name of the claim                                                                                                                                                                                                                                | String                                               | True                                     |
| status               | Specifies whether requests have access to this claim. Valid values: `ACTIVE` or `INACTIVE`                                                                                                                                                       | Enum                                                 | True                                     |
| system               | Specifies whether Okta created this claim                                                                                                                                                                                                        | Boolean                                              | System                                   |
| valueType            | Specifies whether the claim is an Okta EL expression (`EXPRESSION`), a set of groups (`GROUPS`), or a system claim (`SYSTEM`)                                                                                                                    | Enum                                                 | True                                     |
| value                | Specifies the value of the claim. This value must be a string literal if `valueType` is `GROUPS`, and the string literal is matched with the selected `groupFilterType`. The value must be an Okta EL expression if `valueType` is `EXPRESSION`. | String                                               | True                                     |

##### Details for `groupFilterType`

If `valueType` is `GROUPS`, then the groups returned are filtered according to the value of `groupFilterType`:

* `STARTS_WITH`: Group names start with `value` (not case sensitive). For example, if `value` is `group1`, then `group123` and `Group123` are included.
* `EQUALS`: Group name is the same as `value` (not case sensitive). For example, if `value` is `group1`, then `group1` and `Group1` are included, but `group123` isn&#8217;t.
* `CONTAINS`: Group names contain `value` (not case sensitive). For example, if `value` is `group1`, then `MyGroup123` and `group1` are included.
* `REGEX`: Group names match the REGEX expression in `value` (case sensitive). For example if `value` is `/^[a-z0-9_-]{3,16}$/`, then any group name that has at least 3 letters, no more than 16, and contains lower case letters, a hyphen, or numbers.

If you have complex filters for groups, you can [create a groups whitelist](/docs/how-to/creating-token-with-groups-claim.html) to put them all in a claim.

##### Details for `alwaysIncludeInToken`

* Always `TRUE` for Access Token
* If `FALSE` for an ID Token claim, the claim won&#8217;t be included in the ID Token if ID token is requested with Access Token or `authorization_code`, instead the client has to use Access Token to get the claims from the UserInfo endpoint.

### Condition Object

Example from a Rule Object
~~~json
  "conditions": {
    "people": {
      "users": {
        "include": [],
        "exclude": []
      },
      "groups": {
        "include": [
          "EVERYONE"
        ],
        "exclude": []
      }
    "scopes": {
      "include": [{
        "name": "*",
        "access": "ALLOW"
      }]
  }
~~~

Example from a Policy Object
~~~json
"conditions": {
  "clients": {
    "include": [
      "ALL_CLIENTS"
    ]
  }
}
~~~

#### Condition Properties

| Property  | Description                                                                                                                                                                          | Type                          | Required for create or update |
|:-----------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------------------------------|:------------------------------|
| clients    | For policies, specifies which clients are included or excluded in the policy.                                                                                                         | `include` and `exclude` lists | True                          |
| grant_type | Can be one of the following: `authorization_code`, `password`, `refresh_token`, or `client_credentials`. Determines the mechanism Okta uses to authorize the creation of the tokens. | Enum                          | True                          |
| people     | For rules, specifies which users and groups are included or excluded in the rule.                                                                                                     | `include` and `exclude` lists | True                          |
| scopes     | Array of scopes this condition includes or excludes.                                                                                                                                  | `include` and `exclude` lists | True                          |

### Signing Credentials Object

~~~json
{
    "credentials": {
      "signing": {
        "rotationMode": "AUTO",
        "lastRotated": "2017-05-17T22:25:57.000Z",
        "nextRotation": "2017-08-15T22:25:57.000Z",
        "kid": "WYQxoK4XAwGFn5Zw5AzLxFvqEKLP79BbsKmWeuc5TB4"
        "use": "sig"
      }
    }
}
~~~


#### Signing Credentials Properties

| ------------- | ------------------------------------------------------------------------------------------------------------------------ | ---------- | ---------- | ---------- |
| Property      | Description                                                                                                              | DataType   | Required   | Updatable  |
|:--------------|:-------------------------------------------------------------------------------------------------------------------------|:-----------|:-----------|:-----------|
| kid           | The ID of the JSON Web Key used for signing tokens issued by the authorization server.                                             | String     | FALSE      | FALSE      |
| lastRotated   | The timestamp when the authorization server started to use the `kid` for signing tokens.                                  | String     | FALSE      | FALSE      |
| nextRotation  | The timestamp when authorization server will change key for signing tokens. Only returned when `rotationMode` is `AUTO`.  | String     | FALSE      | FALSE      |
| rotationMode  | The key rotation mode for the authorization server. Can be `AUTO` or `MANUAL`.                                            | Enum       | FALSE      | TRUE       |

### Certificate JSON Web Key Object

This object defines a [JSON Web Key](https://tools.ietf.org/html/rfc7517) for an application's signature or encryption credential.

~~~json
{
    "keys": [
        {
            "status": "ACTIVE",
            "alg": "RS256",
            "e": "AQAB",
            "n": "mZXlEiDy[...]Isor9Q",
            "kid": "WYQxoK4XAwGFn5Zw5AzLxFvqEKLP79BbsKmWeuc5TB4",
            "kty": "RSA",
            "use": "sig"
            "_links": {
              "self": {
                "href": "https://{yourOktaDomain}.com/api/v1/authorizationServers/default/credentials/keys/Vy8zLvevjtTVBAXC138BCq4HQ_vj_RzaTXtlr7ekxfY",
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

#### Key Properties

| Property  | Description                                                                            | Type   |
|:----------|:---------------------------------------------------------------------------------------|:-------|
| alg       | The algorithm used with the key. Valid value: `RS256`                                  | String |
| e         | RSA key value (exponent) for key blinding.                                             | String |
| kid       | Unique identifier for the certificate.                                                 | String |
| kty       | Cryptographic algorithm family for the certificate&#8217;s key pair. Valid value: `RSA`| String |
| n         | RSA key value (modulus) for key blinding.                                              | String |
| status    | `ACTIVE`, `NEXT`, or `EXPIRED`                                                         | Enum   |
| use       | How the key is used. Valid value: `sig`                                                | String |