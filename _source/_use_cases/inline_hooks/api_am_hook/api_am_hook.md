---
layout: docs_page
title: API Access Management Inline Hook
excerpt: Customize tokens returned by Okta API Access Management process flow.
---

# API Access Management Inline Hook

{% api_lifecycle ea %}

This page provides reference documentation for:

- JSON objects contained in the outbound request from Okta to your external service

- JSON objects you can include in your response

This information is specific to the API Access Management Inline Hook, one type of inline hook supported by Okta.

## See Also

For a general introduction to Okta inline hooks, see [Inline Hooks](/use_cases/inline_hooks).

For setup steps for the API Acccess Management Inline Hook, see [API Acess Management Inline Hook Setup](/use_cases/inline_hooks/api_am_hook/api_am_setup.md).

For information on the API for registering external service endpoints with Okta, see [Inline Hooks API](/docs/api/resources/inline-hooks.md).

## About

This type of inline hook is triggered when OAuth 2.0 and OpenID tokens are minted by your Okta custom Authorization Server. Before sending the token to the requestor, Okta calls out to your external service. Your service can respond with commands to add additional custom claims to the token before Okta sends it to the requestor.

This capability can be used to add sensitive user data to tokens without having to store that data in Okta user profiles. For example, tokens minted for a medical app can be augmented with medical data, without that data needing to be stored in Okta user profiles.

This inline hook works only with custom Authorization Servers, not with the Okta default Authoritzation Server.

You cannot use this inline hook to overwrite claims in tokens, only to add new ones.

## Objects in the Request from Okta

For the API Access Management Inline Hook, the outbound call from Okta to your external service will include the following objects in its JSON payload:

### data.access

Provides information on the properties of the access token that Okta has generated, including the existing claims it contains.

| Property | Description                        | Data Type                    |
|----------|------------------------------------|------------------------------|
| claims   | Claims included in the token.      | [claims](#claims) object     |
| lifetime | Lifetime of the token.             | [lifetime](#lifetime) object |
| scopes   | The scopes contained in the token. | [scopes](#scopes) object     |

#### claims

| Property | Description                                                                   | Data Type |
|----------|-------------------------------------------------------------------------------|-----------|
| ver      | The semantic version of the access token.                                     | Number    |
| jti      | Unique identifier for this JWT.                                               | String    |
| iss      | The URL of the authorization server that issued the token.                    | String    |
| aud      | The audience of the token.                                                    | String    |
| cid      | Client ID of the client that requested the access token.                      | String    |
| uid      | A unique identifier for the user (not included if token not bound to a user). | String    |

#### lifetime

| Property   | Description                                                            | Data Type |
|------------|------------------------------------------------------------------------|-----------|
| expiration | The expiration time of the token in seconds since January 1, 1970 UTC. | Number    |

#### scopes

| Property | Description | Data Type |
|----------|-------------|-----------|
|          |             |           |

### data.identity

Provides information on the properties of the ID token that Okta has generated, including the existing claims it contains.

| Property | Description                   | Data Type                    |
|----------|-------------------------------|------------------------------|
| claims   | Claims included in the token. | [claims](#claims) object     |
| lifetime | Lifetime of the token.        | [lifetime](#lifetime) object |

## Objects in Response You Send

For the API Access Management Inline hook, the `commands`, `error`, and `debugContext` objects that you can return in the JSON payload of your response are defined as follows:

### commands

The `commands` object is where you can provide commands to Okta. It is an array, allowing you to send mutlitple commands. In each array element, there needs to be a `type` property and `value` property. The `type` property is where you specify which of the supported commands you wish to execute, and `value` is where you supply an operand for that command.

In the case of the API Access Managment hook type, the `value` property is itself a nested object, in which you specify a particular operation, a path to act on, and a value.

| Property | Description                                                              | Data Type       |
|----------|--------------------------------------------------------------------------|-----------------|
| type     | One of the [supported commands](#supported-commands).                    | String          |
| value    | Operand to pass to the command. It specifies a particular op to perform. | [value](#value) |

#### List of Supported Commands

The following commands are supported for the API Access Management Inline Hook type:

| Command                 | Description             |
|-------------------------|-------------------------|
| com.okta.identity.patch | Modify an ID token.     |
| com.okta.access.patch   | Modify an access token. |

#### value

| Property | Description                                                                                                                                                                                                       | Data Type |
|----------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------|
| op       | The name of one of the [supported ops](#list-of-supported-ops).                                                                                                                                                   | String    |
| path     | Location within the token to apply the operation, specified as a slash-delimited path. When adding a claim, this will always begin with `/claims/`,  and be followed by the name of the new claim you are adding. | String    |
| value    | Value to set the claim to.                                                                                                                                                                                        | Number    |

#### List of Supported Ops

| Op  | Description  |
|-----|--------------|
| add | Add a claim. | 

> Note: The `add` operation can only be used to add new claims to a token, not to overwrite the value of a claim already included in the token.

### error

When you return an error object, it should have the following structure:

| Property     | Description                          | Data Type                   |
|--------------|--------------------------------------|-----------------------------|
| errorCode    | A unique code.                       |                             |
| errorSummary | Human-readable summary of the error. |                             |
| errorCauses  | Additional information on the error. | [errorCauses](#errorCauses) |

#### errorCauses

| Property     | Description | Data Type |
|--------------|-------------|-----------|
| errorSummary |             |           |
| reason       |             |           |
| locationType |             |           |
| location     |             |           |
| domain       |             |           |

### debugContext

This object is user-defined.

## Sample Listing of JSON Payload of Request

```JSON
{  
   "source":"https://{yourOktaDomain}/oauth2/default/v1/authorize",
   "eventId":"3OWo4oo-QQ-rBWfRyTmQYw",
   "eventTime":"2019-01-15T23:20:47.000Z",
   "data":{  
      "context":{  
         "request":{  
            "id":"reqv66CbCaCStGEFc8AdfS0ng",
            "method":"GET",
            "url":{  
               "value":"https://{yourOktaDomain}/oauth2/default/v1/authorize?scope=openid+profile+email&response_type=token+id_token&redirect_uri=https%3A%2F%2Fhttpbin.org%2Fget&state=foobareere&nonce=asf&client_id=customClientIdNative"
            },
            "ipAddress":"127.0.0.1"
         },
         "protocol":{  
            "type":"OAUTH2.0",
            "request":{  
               "scope":"openid profile email",
               "state":"foobareere",
               "redirect_uri":"https://httpbin.org/get",
               "response_mode":"fragment",
               "response_type":"token id_token",
               "client_id":"customClientIdNative"
            },
            "issuer":{  
               "uri":"https://{yourOktaDomain}/oauth2/default"
            },
            "client":{  
               "id":"customClientIdNative",
               "name":"Native client",
               "type":"PUBLIC"
            }
         },
         "session":{  
            "id":"102Qoe7t5PcRnSxr8j3I8I6pA",
            "userId":"00uq8tMo3zV0OfJON0g3",
            "login":"administrator1@clouditude.net",
            "createdAt":"2019-01-15T23:17:09.000Z",
            "expiresAt":"2019-01-16T01:20:46.000Z",
            "status":"ACTIVE",
            "lastPasswordVerification":"2019-01-15T23:17:09.000Z",
            "amr":[  
               "PASSWORD"
            ],
            "idp":{  
               "id":"00oq6kcVwvrDY2YsS0g3",
               "type":"OKTA"
            },
            "mfaActive":false
         },
         "user":{  
            "id":"00uq8tMo3zV0OfJON0g3",
            "passwordChanged":"2018-09-11T23:19:12.000Z",
            "profile":{  
               "login":"administrator1@clouditude.net",
               "firstName":"Add-Min",
               "lastName":"O'Cloudy Tud",
               "locale":"en",
               "timeZone":"America/Los_Angeles"
            },
            "_links":{  
               "groups":{  
                  "href":"https://{yourOktaDomain}/00uq8tMo3zV0OfJON0g3/groups"
               },
               "factors":{  
                  "href":"https://{yourOktaDomain}/api/v1/users/00uq8tMo3zV0OfJON0g3/factors"
               }
            }
         },
         "policy":{  
            "id":"00pq8lGaLlI8APuqY0g3",
            "rule":{  
               "id":"0prq8mLKuKAmavOvq0g3"
            }
         }
      },
      "identity":{  
         "claims":{  
            "sub":"00uq8tMo3zV0OfJON0g3",
            "name":"Add-Min O'Cloudy Tud",
            "email":"webmaster@clouditude.net",
            "ver":1,
            "iss":"https://{yourOktaDomain}/oauth2/default",
            "aud":"customClientIdNative",
            "jti":"ID.YxF2whJfB3Eu4ktG_7aClqtCgjDq6ab_hgpiV7-ZZn0",
            "amr":[  
               "pwd"
            ],
            "idp":"00oq6kcVwvrDY2YsS0g3",
            "nonce":"asf",
            "preferred_username":"administrator1@clouditude.net",
            "auth_time":1547594229
         },
         "token":{  
            "lifetime":{  
               "expiration":3600
            }
         }
      },
      "access":{  
         "claims":{  
            "ver":1,
            "jti":"AT.W-rrB-z-kkZQmHW0e6VS3Or--QfEN_YvoWJa46A7HAA",
            "iss":"https://{yourOktaDomain}/oauth2/default",
            "aud":"api://default",
            "cid":"customClientIdNative",
            "uid":"00uq8tMo3zV0OfJON0g3",
            "sub":"administrator1@clouditude.net",
            "firstName":"Add-Min",
            "preferred_username":"administrator1@clouditude.net"
         },
         "token":{  
            "lifetime":{  
               "expiration":3600
            }
         },
         "scopes":{  
            "openid":{  
               "id":"scpq7bW1cp6dcvrz80g3",
               "action":"GRANT"
            },
            "profile":{  
               "id":"scpq7cWJ81CIP5Qkr0g3",
               "action":"GRANT"
            },
            "email":{  
               "id":"scpq7dxsoz6LQlRj00g3",
               "action":"GRANT"
            }
         }
      }
   },
   "eventTypeVersion":"1.0",
   "cloudEventVersion":"0.1",
   "contentType":"application/json",
   "eventType":"com.okta.oauth2.tokens.transform"
}
```

## Sample Listing of JSON Payload of Response

```JSON
{"commands":
[{
    "type": "com.okta.identity.patch",
    "value":
    [
        {
        "op": "add",
        "path": "/claims/extPatientId",
        "value": "1234"
        }
    ]
    },
    {
    "type": "com.okta.access.patch",
    "value":


    [
        {
        "op": "add",
        "path": "/claims/external_guid",
        "value": "F0384685-F87D-474B-848D-2058AC5655A7"
        }
    ]
    }
]}
```

