---
layout: docs_page
title: OAuth 2.0 and Okta
excerpt: The next evolution of the OAuth protocol focuses on client developer simplicity.
icon: /assets/img/icons/oauth.svg
---
# OAuth 2.0 and Okta

OAuth 2.0 is the next evolution of the OAuth protocol and is not backwards compatible with OAuth 1.0.
OAuth 2.0 focuses on client developer simplicity while providing specific authorization flows for web applications, desktop applications, mobile phones, and living room devices.


Okta is a fully standards-compliant [OAuth 2.0](http://oauth.net/documentation) Authorization Server and a certified [OpenID Provider](http://openid.net/certification).
The OAuth 2.0 APIs provide API security via scoped access tokens, and OpenID Connect provides user authentication and an SSO layer which is lighter and easier to use than SAML.
The specification and associated RFCs are developed by [the IETF OAuth WG](https://tools.ietf.org/wg/oauth/).
[The main framework](https://tools.ietf.org/html/rfc6749) and [Bearer Token Usage](https://tools.ietf.org/html/rfc6750) were published in 2012.
Other documents are still being worked on within the OAuth working group.

There are several use cases and Okta product features built on top of the OAuth 2.0 APIs:

* Social Authentication -- {% api_lifecycle ea %}
* OpenID Connect
* API Access Management -- {% api_lifecycle ea %}

It's important to understand which use case you are targeting and build your application according to the correct patterns for that use case.
The OAuth 2.0 APIs each have several different [query params](/docs/api/resources/oauth2.html#obtain-an-authorization-grant-from-a-user) which dictate which type of flow you are using and the mechanics of that flow.

At the very basic level, the main API endpoints are:

* [Authorize](/docs/api/resources/oauth2.html#obtain-an-authorization-grant-from-a-user) endpoint initiates an OAuth 2.0 request.
* [Token](/docs/api/resources/oauth2.html#revoke-a-token) endpoint redeems an authorization grant (returned by the [Authorize](/docs/api/resources/oauth2.html#obtain-an-authorization-grant-from-a-user) endpoint) for an access token.

## Getting Started

If you are new to OAuth 2.0, read this topic before experimenting with the Postman collection. If you are familiar with the
flows defined by [the OAuth 2.0 spec](http://oauth.net/documentation), you may want to experiment with the Postman collection first:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/4adca9a35eab5716d9f6)

In addition to the information in this topic, see:

* [Okta's API Access Management Introduction](/use_cases/api_security/)
* [OAuth 2.0 API](/docs/api/resources/oauth2.html)
* [Help for configuring API Access Management in the Okta UI](/docs/how-to/set-up-auth-server.html)

## Basic Flows

1. Browser/Single-Page Application

    * Optimized for browser-only [Public Clients](https://tools.ietf.org/html/rfc6749#section-2.1)
    * Uses [Implicit Flow](https://tools.ietf.org/html/rfc6749#section-4.2)
    * Access token returned directly from authorization request (Front-channel only)
    * Does not support refresh tokens
    * Assumes Resource Owner and Public Client are on the same device

    {% img browser_spa_implicit_flow.png alt:"Browser/Single-Page Application" %}

2. Native Application

    * Installed on a device or computer, such as mobile applications or installed desktop applications
    * Uses [Authorization Code Grant Flow](https://tools.ietf.org/html/rfc6749#section-4.1)
    * Can use custom redirect URIs like `myApp://oauth:2.0:native`

    {% img native_auth_flow.png alt:"Native Application Flow" %}

    > Note: For native applications, the client_id and client_secret are embedded in the source code of the application; in this context, the client secret isn't treated as a secret.
    Therefore native apps should make use of Proof Key for Code Exchange (PKCE) to mitigate authorization code interception.
    For more information, see the PKCE note in [Parameter Details](/docs/api/resources/oauth2.html#request-parameter-details).

    &nbsp;

3. Web Application

    * Server-side app with an end user
    * Uses [Authorization Code Grant Flow](https://tools.ietf.org/html/rfc6749#section-4.1)
    * Assumes Resource Owner and Client are on separate devices
    * Most secure flow as tokens never pass through user-agent

    {% img web_app_flow.png alt:"Web Application Flow" %}

4. Service Application

    * Server-side app with no end user, such as an on-prem agent
    * Uses [Client Credentials Flow](https://tools.ietf.org/html/rfc6749#section-4.4)
    * Optimized for [Confidential Clients](https://tools.ietf.org/html/rfc6749#section-2.1) acting on behalf of itself or a user
    * Back-channel only flow to obtain an access token using the Client’s credentials

    {% img service_app_flow.png alt:"Service Application Flow" %}.


    > Note: The OAuth 2.0 specification mandates that clients implement CSRF protection for their redirection URI endpoints.
    This is what the `state` parameter is used for in the flows described above; the client should send a state value in on the authorization request,
    and it must validate that returned "state" parameter from the Authorization Server matches the original value.

## Custom User Experience

By default, the Authorization Endpoint displays the Okta login page and authenticates users if they don't have an existing session.
If you prefer to use a fully customized user experience, you can instead authenticate the user via the [Authentication API](/docs/api/resources/authn.html).
This authentication method produces a `sessionToken` which can be passed into the Authorize Endpoint, and the user won't see an Okta login page.



## Validating Access Tokens

For more information on validating access tokens, see our [Authentication Guide](/authentication-guide/tokens/validating-access-tokens).

## Refresh Token

A Refresh Token is an opaque string. It is a long-lived token that the client can use to obtain a new Access Token without re-obtaining authorization from the resource owner. The new Access Token must have the same or subset of the scopes associated with the Refresh Token.
A Refresh Token will be returned if 'offline_access' scope is requested using authorization_code, password, or refresh_token grant type.


The lifetime of a Refresh Token is configured in [Access Policies](#access-policies), the minimum value is 24 hours. The refresh token can also expire after a period if no clients redeem it for an Access Token. The period should be equal to or larger than 10 minutes. If the token's lifetime is set to unlimited, the Authorization Server will not check if clients use it or not.

### Refresh Token Revocation

Refresh Tokens can be revoked explicitly by making a [Revocation Request](/docs/api/resources/oauth2.html#revoke-a-token). Additionally, all Refresh Tokens associated with an entity are revoked when the entity is deactivated, deleted, or otherwise modified in a way that invalidates the associated Refresh Tokens. Such ways includes:

* The User is Suspended or Deactivated
* The Client App is Deactivated or Deleted
* The Authorization Server's Resource URI is modified, or the Authorization Server is deleted.

No other modifications affect existing tokens.

## ID Token

A Custom Authorization Server can issue an ID token to the client, as in OpenID Connect, but with the following differences:

* The ID token can't contain OIDC reserved scopes or a `groups` claim. To obtain a claim with group information, administrators must define a custom claim with a group filter and associate it with a scope.
* The custom properties in the app user profile are not included in the Id Token by default, even if profile scope is granted. To obtain a claim for a custom property, administrators must define a custom claim with an Okta Expression Language expression and associate it with a scope.

The lifetime of an ID token is one hour. If the client that issued the token is deactivated, the token is
immediately and permanently invalidated. Reactivating the client does not make the token valid again.

The validation steps for [OpenID Connect with the Okta Authorization Server](/docs/api/resources/oidc.html#validating-id-tokens) can also be applied to ID tokens for
OAuth 2.0 (Custom Authorization Server), except the public keys should be retrieved via the [Get Keys endpoint](/docs/api/resources/oauth2.html#get-keys).

## Requesting a Token

You can request a token with the endpoint [`/oauth2/:authorizationServerId/v1/token`](/docs/api/resources/oauth2.html#request-a-token).

The grant type and scope in your request, as well as configurations set in the Custom Authorization Server, determine which
tokens are returned and what they contain. For details, see [Response Parameters](/docs/api/resources/oauth2.html#response-parameters-1) and [Custom claim configuration](#custom-claim-configuration).

## Access Policies

Access policies define which scopes and claims can be granted to a request and the lifetime of the granted tokens.

### Policies

The admin defines Policies for the OAuth 2.0 clients which are ordered numerically by priority. This priority determines the order in which they are searched for a client match. The highest priority policy has a priorityOrder of 1.

For example, assume the following conditions are in effect.

- Policy A has priority 1 and applies to client C;
- Policy B has priority 2 and applies to all the clients;

Because Policy A has a higher priority, the requests coming from client C are evaluted by Policy A first. Policy B will not be evaluated if one of Rules in policy A matches the requests.

### Rules

In a policy the administrators can define several rules with people, scope, and grant type conditions.

#### Scope condition

The scope condition identifies scopes that are included or excluded to match the claims the token will contain.
Scopes are not ordered.

#### Grant type condition

The grant type condition identifies how the authorization grant is presented to Okta:
via an authorization code, password credentials, refresh token, or client credentials.

#### People condition

The people condition identifies users and groups that are included or excluded to match the user the token is requested for.
Rules are ordered numerically by priority. This priority determines the order in which they are searched for a user/group match.
The highest priority rule has a priorityOrder of 1.

For example, assume the following conditions are in effect:

- Rule A has priority 1 and one people condition to include user U;
- Rule B has priority 2 and one people condition to include all the users assigned to the client;

Because Rule A has a higher priority, the requests for user U are evaluated in Rule A, and Rule B is not evaluated.

The actions in a rule define the lifetime of the Access Token and Refresh Token.

## Authorization Servers

At its core, an authorization server is simply an engine for minting OpenID Connect or OAuth 2.0 tokens.

Okta provides two types of authorization servers:

* Okta Authorization Server:
Use the Okta Authorization Server to perform SSO with Okta or sign in users for apps displayed on the Okta home page.
Okta hosts and manages the Okta Authorization Server. It can't be configured,
though you can add a [groups claim](/standards/OIDC/index.html#scope-dependent-claims-not-always-returned)
and [app-user profile attributes](/docs/api/resources/apps.html#application-user-properties) to a client.
The Access Token minted by the Okta Authorization Server is consumed by Okta APIs. The Access Token audience is always Okta specific, so the token can't be validated by your applications.

    >Note: The Okta Authorization Server doesn't require that the API Access Management feature be enabled.

* Custom Authorization Server:
Use a Custom Authorization Server to secure your APIs.
Custom Authorization Servers are hosted on Okta, and created and configured by an org administrator.
You can create and configure Custom Authorization Servers using the Okta Admin UI or the [Custom Authorization Server API](/docs/api/resources/oauth2.html#authorization-server-operations).
The Access Token minted by a Custom Authorization Server is consumed by your APIs.
You can specify the audience to make sure that the Access Token is for your APIs.
Also, custom scopes can be configured to support the authorization for your APIs.

     >Note: Custom Authorization Servers are available as part of the [API Access Management](/use_cases/api_access_management/index.html) feature.

| Feature                                  | Okta Authorization Server | Custom Authorization Server |
|:-----------------------------------------|:--------------------------|:----------------------------|
| Hosted by Okta                           | &#10004;                  | &#10004;                    |
| Add groups claim                         | &#10004;                  | &#10004;                    |
| Add user-profile attributes              | &#10004;                  | &#10004;                    |
| Manage resources outside Okta            |                           | &#10004;                    |
| Requires API Access Management           |                           | &#10004;                    |
| Org Admin creates one or more            |                           | &#10004;                    |
| Validate the Access Token in custom code |                           | &#10004;                    |
| Custom Scopes                            |                           | &#10004;                    |
| Custom Claims                            |                           | &#10004;                    |
| Custom Access Policies and Rules         |                           | &#10004;                    |

To configure a Custom Authorization Server, sign in to your org and navigate to **API** > **Authorization Servers** > **Add Authorization Server** or use the [Custom Authorization Server API](/docs/api/resources/oauth2.html#authorization-server-operations).

If you use a Custom Authorization Server, we recommend that you use it instead of the Okta Authorization Server for
any platform use cases (perform SSO or secure your API access).
Doing so will make it easier to consume enhancements to the API Access Management product and features.

Okta provides a pre-configured Custom Authorization Server with the name `default`.
This default authorization server includes a basic access policy and rule, which you can edit to control access.
It allows you to specify `default` instead of the `authorizationServerId` in requests to it:

* `https://{yourOktaDomain}.com/api/v1/authorizationServers/default`  vs
* `https://{yourOktaDomain}.com/api/v1/authorizationServers/:authorizationServerId` for other Customer Authorization Servers

## OpenID Connect and Authorization Servers

You can use the [OpenID Connect API](/docs/api/resources/oidc.html) without API Access Management (Custom Authorization Server).
However, you can also use OpenID Connect with a Custom Authorization Server:

* `/oauth2/v1/userinfo` for OpenID Connect without API Access Management
* `/oauth2/:authorizationServerId/v1/userinfo` for OpenID Connect with API Access Management's Custom Authorization Server.

You can't mix tokens between different authorization servers. By design, authorization servers don't have trust relationships with each other.

## Claims

Tokens issued by Okta contain claims, which are statements about a subject (user).
For example, the claim can be about a name, identity, key, group, or privilege.
The claims in a security token are dependent upon the type of token, the type of credential used to authenticate the user, and the application configuration.

The claims requested by the `profile`, `email`, `address`, and `phone` scope values are returned from the UserInfo Endpoint, as described in [the OpenID spec Section 5.3.2](http://openid.net/specs/openid-connect-core-1_0.html#UserInfoResponse), when a `response_type` value is used that results in an Access Token being issued. However, when no Access Token is issued (which is the case for the `response_type` value `id_token`), the resulting Claims are returned in the ID Token.

## Scopes

OpenID Connect uses scope values to specify what access privileges are being requested for Access Tokens.
The scopes associated with Access Tokens determine which claims are available when they are used
to access [the OIDC `userinfo` endpoint](#userinfo). The following scopes are supported:

| -------------  | -------------------------------------------------------------------------------                               | -------------- |
| Property       | Description                                                                                                   | Required       |
|:---------------|:--------------------------------------------------------------------------------------------------------------|:---------------|
| openid         | Identifies the request as an OpenID Connect request.                                                          | Yes            |
| profile        | Requests access to the end user's default profile claims.                                               | No             |
| email          | Requests access to the `email` and `email_verified` claims.                                                   | No             |
| phone          | Requests access to the `phone_number` and `phone_number_verified` claims.                                     | No             |
| address        | Requests access to the `address` claim.                                                                       | No             |
| groups         | Requests access to the `groups` claim.                                                                        | No             |
| offline_access | Requests a Refresh Token, used to obtain more access tokens without re-prompting the user for authentication. | No             |

### Scope Values

* `openid` is required for any OpenID request connect flow. If no openid scope value is present, the request may
  be a valid OAuth 2.0 request, but it's not an OpenID Connect request.
* `profile` requests access to these default profile claims: `name`, `family_name`, `given_name`, `middle_name`, `nickname`, `preferred_username`, `profile`,  
`picture`, `website`, `gender`, `birthdate`, `zoneinfo`,`locale`, and `updated_at`.
* `offline_access` can only be requested in combination with a `response_type` containing `code`. If the `response_type` does not contain `code`, `offline_access` will be ignored.
* For more information about `offline_access`, see the [OIDC spec](http://openid.net/specs/openid-connect-core-1_0.html#OfflineAccess).
