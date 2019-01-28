---
layout: docs_page
title: Webfinger
---

# WebFinger API

The `https://{yourOktaDomain}/.well-known/webfinger` API allows a client application to determine the IdP that a given username (or identifier) would be routed to, based on your org's Identity Provider Routing Rules (IdP Discovery Policy). If a rule is configured to match on a user attribute, or if a user's shortname is provided (e.g. `joe.stormtrooper`), the API call will cross-reference all users in the org to find the appropriate match.

## Finding a User's IdP 

{% api_operation get /.well-known/webfinger %}

Fetch IdP to be used for a particular user. You must supply a `resource` query paramter.

### Request Parameters
{:.api .api-request .api-request-params}

The table below summarizes the supported query parameters:

| Parameter      | Description                                                             | Param Type | DataType | Required |
| :------------- | :---------------------------------------------------------------------- | :--------- | :------- | :------- |
| resource       | User's login value prefixed with `okta:acct:`                           | URL        | String   | TRUE     |
| rel            | Allows you to limit the result to certain IdPs                          | URL        | Array    | FALSE    |

>Note: Valid values for rel are `http://openid.net/specs/connect/1.0/issuer` and `okta:idp`, the first value being an Okta org, and the second being any configurable IdP.

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}/.well-known/webfinger?q=okta:acct:joe.stormtrooper%40example.com"
~~~

#### Response Example
{:.api .api-response .api-response-example}

In this example, there is already a rule configured that has a user identifier condition which says that users with the domain `example.com` should be routed to a configured SAML IdP.

~~~json
{
    "subject": "okta:acct:joe.stormtrooper@example.com",
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

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}/.well-known/webfinger?q=okta:acct:joe.stormtrooper%example.com&rel=http%3A%2F%2Fopenid.net%2Fspecs%2Fconnect%2F1.0%2Fissuer"
~~~

>Note: This request looks similar to the previous one, but it includes a `rel` parameter which limits the results to a particular set of IdPs.

#### Response Example
{:.api .api-response .api-response-example}

In this example, there is already a rule configured that has a user identifier condition which says that users with the domain `example.com` should be routed to a configured SAML IdP. However, we supplied a `rel` parameter of `http://openid.net/specs/connect/1.0/issuer` which limited the result to Okta

~~~json
{
    "subject": "okta:acct:joe.stormtrooper@saml.com",
    "links": [
        {
            "rel": "https://openid.net/specs/connect/1.0/issuer",
            "href": "https://{yourOktaDomain}/sso/idps/OKTA",
            "titles": {
                "und": "{subdomain}"
            },
            "properties": {
                "okta:idp:type": "OKTA"
            }
        }
    ]
}
~~~