---
layout: docs_page
title: Webfinger
---

# WebFinger API

The `webfinger` API allows you to query Okta regarding which IdP an individual user should be routed to, based on the configured rules in the IdP Discovery Policy.

## Finding a User's IdP 

{% api_operation get /.well-known/webfinger %}

| Parameter      | Description                                                             | Param Type | DataType | Required |
| :------------- | :---------------------------------------------------------------------- | :--------- | :------- | :------- |
| resource       | User's login value prefixed with `okta:acct:`                           | URL        | String   | TRUE     |
| relArray       | Allows you to prefer certain IdPs                                       | URL        | Array    | FALSE    |
| requestContext | Either an Okta state token or an Okta application's embed link          | URL        | String   | FALSE    |

>Note: Valid values for relArray are `http://openid.net/specs/connect/1.0/issuer` and `okta:idp`. The first value being an Okta org and the second being any configurable IdP.

##### Request Example
{:.api .api-request .api-request-example}

In this example, there is already a rule configured that has a user identifier condition, which says that users with the domain `deathstar.com` should be routed to a configured SAML IdP.

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}/.well-known/webfinger?q=okta:acct:joe.stormtrooper%40deathstar.com"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~json
{
    "subject": "okta:acct:joe.stormtrooper@deathstar.com",
    "links": [
        {
            "rel": "okta:idp",
            "href": "https://{yourOktaDomain}/sso/idps/0oas562BigqDJl70T0g3",
            "titles": {
                "und": "MySamlIdp"
            },
            "properties": {
                "okta:idp:metadata": "https://{yourOktaDomain}/api/v1/idps/0oas562BigqDJl70T0g3/metadata.xml",
                "okta:idp:type": "SAML2",
                "okta:idp:id": "0oas562BigqDJl70T0g3"
            }
        }
    ]
}
~~~

##### Request Example
{:.api .api-request .api-request-example}

In this example, there is already a rule configured that has an application condition which says if the user is targeting a specific app instance, route them to a configured Facebook IdP.

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}/.well-known/webfinger?q=okta:acct:joe.stormtrooper%deathstar.com&requestContext=%2Fhome%2Foidc_client%2F0oas72uoTu9yhcHQr0g3%2FalnivcK7lCqtQ1jOE0g3"
~~~

>Note: This request looks similar to the previous one, but it includes a `requestContext` which is an app's embed link.

##### Response Example
{:.api .api-response .api-response-example}

~~~json
{
    "subject": "okta:acct:joe.stormtrooper@facebook.com",
    "links": [
        {
            "rel": "okta:idp",
            "href": "https://{yourOktaDomain}/sso/idps/0oas63QWgtXYyTVsg0g3",
            "titles": {
                "und": "Facebook IdP"
            },
            "properties": {
                "okta:idp:type": "FACEBOOK",
                "okta:idp:id": "0oas63QWgtXYyTVsg0g3"
            }
        }
    ]
}
~~~
