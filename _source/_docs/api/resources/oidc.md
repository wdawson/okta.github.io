---
layout: docs_page
title: OpenID Connect
---

# OpenID Connect API

{% api_lifecycle ea %}

Okta is a standards-compliant [OAuth 2.0](http://oauth.net/documentation) authorization server and a certified [OpenID Connect Provider](http://openid.net/certification).

The OAuth 2.0 API provides API security via scoped access tokens, and OpenID Connect provides user authentication and an SSO layer which is lighter and easier to use than SAML.

To understand more about OAuth 2.0, OpenID Connect, and Okta:

Jakub.todo

## Getting Started

If you are new to OAuth 2.0 and OpenID Connect, you should probably start by reading the [Authentication Overview](/_authentication-guide/auth-overview/index.html) before experimenting with the Postman collection.

<!-- This Postman collection needs to be updated!

If you are familiar with
[the OpenID Connect spec](http://openid.net/specs/openid-connect-core-1_0.html), you may want to experiment with the Postman collection now:

[![Run in Postman](https://run.pstmn.io/button.svg)](https://app.getpostman.com/run-collection/fd92d7c1ab0fbfdecab2) -->

You can also view the video [Getting Started with the Okta API and OpenID Connect](https://www.youtube.com/watch?v=fPW66abobMI).

## Endpoints

* `/authorize`
* `/token`
* `/introspect`
* `/revoke`
* `/logout`
* `/keys`
* `/userinfo`
* `/.well-known/oauth-authorization-server`
* `/.well-known/openid-configuration`

### /authorize
{:.api .api-operation}

{% api_operation get /oauth2/v1/authorize %}

{% api_operation get /oauth2/**${authorizationServerId}**/v1/authorize %}

> This endpoint's URL namespace will vary depending on whether you are using a custom authorization server or not. For more information, see (jakub.todo).

This is a starting point for OpenID Connect flows such as implicit and authorization code flows. This request
authenticates the user and returns tokens along with an authorization grant to the client application as a part
of the response.

#### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                                                                                                                                                                                                                                                                                                                                                                             | Param Type | DataType | Required | Default          |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|:---------|:---------|:-----------------|
|    [idp](idps.html)      | Identity provider (default is Okta)                                                                                                                                                                                                                                                                                                                                                                     | Query      | String   | FALSE    | Okta is the IDP. |
| sessionToken          | Okta one-time sessionToken. This allows an API-based user login flow (rather than Okta login UI). Session tokens can be obtained via the    [Authentication API](authn.html).                                                                                                                                                                                                                              | Query      | String   | FALSE    |                  |
| response_type         | Any combination of `code`, `token`, and `id_token`. The combination determines the    [flow](http://openid.net/specs/openid-connect-core-1_0.html#Authentication). The `code` response type returns an authorization code, which the client can use to obtain an Access Token or a Refresh Token.                                                                                                          | Query      | String   | TRUE     |                  |
| client_id             | Obtained during either  UI client registration or    [Dynamic Client Registration API](oauth-clients.html). It identifies the client and must match the value preregistered in Okta.                                                                                                                                                                                                                        | Query      | String   | TRUE     |
| redirect_uri          | Callback location where the authorization code should be sent. It must match the value preregistered in Okta during client registration.                                                                                                                                                                                                                                                                | Query      | String   | TRUE     |
| display               | How to display the authentication and consent UI. Valid values: `page` or `popup`.                                                                                                                                                                                                                                                                                                                      | Query      | String   | FALSE    |                  |
| max_age               | Allowable elapsed time, in seconds, since the last time the end user was actively authenticated by Okta.                                                                                                                                                                                                                                                                                                | Query      | String   | FALSE    |                  |
| response_mode         | How the authorization response should be returned.    [Valid values: `fragment`, `form_post`, `query` or `okta_post_message`](#parameter-details). If `id_token` or `token` is specified as the response type, then `query` isn't allowed as a response mode. Defaults to `fragment` in implicit and hybrid flow. Defaults to `query` in authorization code flow and cannot be set as `okta_post_message`. | Query      | String   | FALSE    | See Parameter Details. |
| scope                 | `openid` is required. Other  [scopes](/standards/OIDC/index.html#scopes) may also be included.                                                                                                                                                                                                                                                                                                         | Query      | String   | TRUE     |
| state                 | A value to be returned in the token. The client application can use it to remember the state of its interaction with the end user at the time of the authentication call. It can contain alphanumeric, comma, period, underscore and hyphen characters.                                                                                                                                                 | Query      | String   | TRUE     |
| prompt                | Either *none* or `login`. If `none`,  do not prompt for authentication, and return an error if the end user is not already authenticated. If `login`, force a prompt (even if the user had an existing session). Default: depends on whether an Okta session exists.                                                                                                                                     | Query      | String   | FALSE    | See Parameter Details. |
| nonce                 | A value that must be returned in the ID Token. It is used to mitigate replay attacks.                                                                                                                                                                                                                                                                                                                   | Query      | String   | TRUE     |
| code_challenge        | A challenge of    [PKCE](#parameter-details). The challenge is verified in the Access Token request.                                                                                                                                                                                                                                                                                                       | Query      | String   | FALSE    |
| code_challenge_method | Method used to derive the code challenge. Must be `S256`.                                                                                                                                                                                                                                                                                                                                               | Query      | String   | FALSE    |
| login_hint            | A username to prepopulate if prompting for authentication.                                                                                                                                                                                                                                                                                                                                              | Query      | String   | FALSE    |
| idp_scope             | A space delimited list of scopes to be provided to the Social Identity Provider when performing  [Social Login](social_authentication.html). These scopes are used in addition to the scopes already configured on the Identity Provider.                                                                                                                                                                | Query      | String   | FALSE    |
| request | A JWT created by the client that enables requests to be passed as a single, self-contained parameter. | Query | JWT | FALSE    | See Description. |

#### Parameter Details

 * `idp`, `sessionToken` and `idp_scope` are Okta extensions to [the OpenID specification](http://openid.net/specs/openid-connect-core-1_0.html#Authentication).
    All other parameters comply with the OpenID Connect specification and their behavior is consistent with the specification.
 * Each value for `response_mode` delivers different behavior:
    * `fragment` -- Parameters are encoded in the URL fragment added to the *redirect_uri* when redirecting back to the client.
    * `query` -- Parameters are encoded in the query string added to the *redirect_uri* when redirecting back to the client.
    * `form_post` -- Parameters are encoded as HTML form values that are auto-submitted in the User Agent. Thus, the values are transmitted via the HTTP POST method to the client
      and the result parameters are encoded in the body using the application/x-www-form-urlencoded format.
    * `okta_post_message` -- Uses [HTML5 Web Messaging](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) (for example, window.postMessage()) instead of the redirect for the authorization response from the authentication endpoint.
      `okta_post_message` is an adaptation of the [Web Message Response Mode](https://tools.ietf.org/html/draft-sakimura-oauth-wmrm-00#section-4.1).
      This value provides a secure way for a single-page application to perform a sign-in flow
      in a popup window or an iFrame and receive the ID Token and/or access token back in the parent page without leaving the context of that page.
      The data model for the [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) call is in the next section.
    * The `Referrer-Policy` header is automatically included in the request for `fragment` or `query`, and is set to `Referrer-Policy: no-referrer`.

 * Okta requires the OAuth 2.0 `state` parameter on all requests to the authentication endpoint in order to prevent cross-site request forgery (CSRF).
 The OAuth 2.0 specification [requires](https://tools.ietf.org/html/rfc6749#section-10.12) that clients protect their redirect URIs against CSRF by sending a value in the authorize request which binds the request to the user-agent's authenticated state.
 Using the `state` parameter is also a countermeasure to several other known attacks as outlined in [OAuth 2.0 Threat Model and Security Considerations](https://tools.ietf.org/html/rfc6819).

 * [Proof Key for Code Exchange](https://tools.ietf.org/html/rfc7636) (PKCE) is a stronger mechanism for binding the authorization code to the client than just a client secret, and prevents [a code interception attack](https://tools.ietf.org/html/rfc7636#section-1) if both the code and the client credentials are intercepted (which can happen on mobile/native devices). The PKCE-enabled client creates a large random string as code_verifier and derives code_challenge from it using code_challenge_method. It passes the code_challenge and code_challenge_method in the authorization request for code flow. When a client tries to redeem the code, it must pass the code_verifer. Okta recomputes the challenge and returns the requested token only if it matches the code_challenge in the original authorization request. When a client, whose `token_endpoint_auth_method` is `none`, makes a code flow authorization request, the `code_challenge` parameter is required.

* About the `request` parameter:
  * You must sign the JWT using the app's client secret.
  * The JWT can't be encrypted.
  * Okta supports these signing algorithms: [HS256](https://tools.ietf.org/html/rfc7518#section-5.2.3), [HS384](https://tools.ietf.org/html/rfc7518#section-5.2.4), and [HS512](https://tools.ietf.org/html/rfc7518#section-5.2.5).
  * We recommend you don't duplicate any request parameters in both the JWT and the query URI itself. However, you can do so with `state`, `nonce`, `code_challenge`, and `code_challenge_method`.
  * Okta validates the `request` parameter in the following ways:
    1. `iss` is required and must  be the `client_id`.
    2. `aud` is required and must be same value as the authorization server issuer that mints the ID token or access token. This value is published in metadata for Okta Authorization Server and Custom Authorization Server.
    3. JWT lifetime is evaluated using the `iat` and `exp` claims if present. If the JWT is expired or not yet valid, Okta returns an `invalid_request_object`  error.
    4. Okta rejects the JWT if the `jti` claim is present and it has already been processed.

#### postMessage() Data Model

Use the postMessage() data model to help you when working with the `okta_post_message` value of the `response_mode` request parameter.

`message`:

| Parameter         | Description                                                                                                                                                                                                                                                                                                   | DataType |
|:------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------|
| id_token          | The ID Token JWT contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the `response_type` includes `id_token`.                                                                                                                          | String   |
| access_token      | The `access_token` used to access the  [`/oauth2/v1/userinfo`](/docs/api/resources/oidc.html#get-user-information) endpoint. This is returned if the `response_type` included a token. <b>Important</b>: Unlike the ID Token JWT, the `access_token` structure is specific to Okta, and is subject to change. | String   |
| state             | If the request contained a `state` parameter, then the same unmodified value is returned back in the response.                                                                                                                                                                                                | String   |
| error             | The error-code string providing information if anything goes wrong.                                                                                                                                                                                                                                           | String   |
| error_description | Additional description of the error.                                                                                                                                                                                                                                                                          | String   |

`targetOrigin`:

Specifies what the origin of `parentWindow` must be in order for the postMessage() event to be dispatched
(this is enforced by the browser). The `okta-post-message` response mode always uses the origin from the `redirect_uri`
specified by the client. This is crucial to prevent the sensitive token data from being exposed to a malicious site.

#### Response Parameters

The method of returning the response depends on the response type passed to the API. For example, a `fragment` response mode returns values in the fragment portion of a redirect to the specified `redirect_uri` while a `form_post` response mode POSTs the return values to the redirect URI.
Irrespective of the response type, the contents of the response are as described in the table.

| Parameter         | Description                                                                                                                                                                                                                                                          | DataType |
|:------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------|
| id_token          | JWT that contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the `response_type` includes `id_token`.                                                                                         | String   |
| access_token      | Used to access the  [`/oauth2/v1/userinfo`](/docs/api/resources/oidc.html#get-user-information) endpoint. This is returned if `response_type` includes `token`. Unlike the ID Token JWT, the `access_token` structure is specific to Okta, and is subject to change.  | String   |
| token_type        | The token type is always `Bearer` and is returned only when `token` is specified as a `response_type`.                                                                                                                                                               | String   |
| code              | An opaque value that can be used to redeem tokens from  the [token endpoint](#token-request). `code` is returned if the `response_type` includes `code`. The code has a lifetime of 60 seconds.                                                                                                                                                                             | String   |
| expires_in        | Number of seconds until the `access_token` expires. This is only returned if the response included an `access_token`.                                                                                                                                                | String   |
| scope             | Scopes specified in the `access_token`. Returned only if the response includes an `access_token`.                                                                                                                                                                    | String   |
| state             | The unmodified `state` value from the request.                                                                                                                                                                                                                       | String   |
| error             | Error-code (if something went wrong).                                                                                                                                                                                                                                | String   |
| error_description | Description of the error.                                                                                                                                                                                                                                            | String   |

##### Possible Errors

These APIs are compliant with the OpenID Connect and OAuth 2.0 spec with some Okta specific extensions.

[OAuth 2.0 Spec error codes](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)

| Error Id                  | Details                                                                                                                                                                                                          |
|:--------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unsupported_response_type | The specified response type is invalid or unsupported.                                                                                                                                                           |
| unsupported_response_mode | The specified response mode is invalid or unsupported. This error is also thrown for disallowed response modes. For example, if the query response mode is specified for a response type that includes `id_token`. |
| invalid_scope             | The scopes list contains an invalid or unsupported value.                                                                                                                                                        |
| server_error              | The server encountered an internal error.                                                                                                                                                                        |
| temporarily_unavailable   | The server is temporarily unavailable, but should be able to process the request at a later time.                                                                                                                |
| invalid_request           | The request is missing a necessary parameter or the parameter has an invalid value.                                                                                                                              |
| invalid_grant             | The specified grant is invalid, expired, revoked, or does not match the redirect URI used in the authorization request.                                                                                          |
| invalid_token             | The provided Access Token is invalid.                                                                                                                                                                            |
| invalid_client            | The specified client id is invalid.                                                                                                                                                                              |
| access_denied             | The server denied the request.                                                                                                                                                                                   |

[Open-ID Spec error codes](http://openid.net/specs/openid-connect-core-1_0.html#AuthError)

| Error Id           | Details                                                                                           |
|:-------------------|:--------------------------------------------------------------------------------------------------|
| login_required     | The request specified that no prompt should be shown but the user is currently not authenticated. |
| insufficient_scope | The Access Token provided does not contain the necessary scopes to access the resource.           |

#### Request Examples

This request initiates the authorization code flow, as signaled by `response_type=code`. The request returns an authorization code that you can use as the `code` parameter in a token request.

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}.com/oauth2/v1/authorize?
  client_id=${client_id}&
  response_type=code&
  response_mode=form_post&
  scope=openid offline_access&
  redirect_uri=${redirect_uri}&
  state=${state}&
  nonce=${nonce}"
~~~
This request does the same thing, but uses the `request` parameter to deliver a signed (HS256) JWT that contains all the query parameters:

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}.com/oauth2/v1/authorize?
  request=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJPa3RhIiwiaWF0IjoxNTEyNTE2MjIxLCJleHAiOjE1NDQwNTIyMjEsImF1ZCI6Ind3dy5leGFtcGxlLmNvbSIsInN1YiI6InNqYWNrc29uQGV4YW1wbGUuY29tIiwiRW1haWwiOiJzamFja3NvbkBleGFtcGxlLmNvbSIsInJlc3BvbnNlX3R5cGUiOiJjb2RlIiwicmVzcG9uc2VfbW9kZSI6ImZvcm1fcG9zdCIsInJlZGlyZWN0X3VyaSI6Im15UmVkaXJlY3RVUkkuY29tIiwic3RhdGUiOiJteVN0YXRlIiwibm9uY2UiOiJteU5vbmNlIiwic2NvcGUiOiJvcGVuaWQgb2ZmbGluZV9hY2Nlc3MifQ.TjPy2_nUerULClavBNHcpnO_Pd1DxNEjQCeSW45ALJg"
  ~~~

This request initiates the implicit flow, that is, it obtains an ID Token and optionally an Access Token directly from the authorization server. We use the same request as the first example, but with `response_type=id_token` or `response_type=id_token token`:

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}.com/oauth2/v1/authorize?
  client_id=${client_id}&
  response_type=id_token token&
  response_mode=form_post&
  scope=openid offline_access&
  redirect_uri=${redirect_uri}&
  state=${state}&
  nonce=${nonce}"
~~~

#### Response Example (Success)

~~~json
{
  "access_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2ZXIiOjEsImp0aSI6IkFULm43cUkyS2hnbjFSZkUwbllQbFJod0N6UmU5eElIOUQ1cXFQYzNBNTQzbDQiLCJpc3MiOiJodHRwczovL21pbG  xpd2F5cy5va3RhLmNvbS9vYXV0aDIvYXVzOXVnbGRjbTJ0SFpqdjQwaDciLCJhdWQiOiJodHRwczovL21pbGxpd2F5cy5va3RhLmNvbSIsImlhdCI6MTQ4OTY5Nzk0NSwiZXhwIjoxNDk1MjIxMTQ1LCJjaWQiOiJBeD  VYclI0YU5Ea2pDYWNhSzdobiIsInVpZCI6IjAwdTljcDFqY3R3Ymp0a2tiMGg3Iiwic2NwIjpbIm9wZW5pZCIsIm9mZmxpbmVfYWNjZXNzIl0sInN1YiI6ImZvcmQucHJlZmVjdEBtaWxsaXdheXMuY29tIn0.hb3oS9  2Nb7QmLz2R99SfB_qqTP9GsMCtc2umA2sJwe4",
  "token_type": "Bearer",
  "expires_in": 3600,
  "scope": "openid offline_access",
  "refresh_token": "IJFLydLpLZ7-9spMSePkqgBSTnjBluJIJi6HESG84cE",
  "id_token": "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMHU5Y3AxamN0d2JqdGtrYjBoNyIsInZlciI6MSwiaXNzIjoiaHR0cHM6Ly9taWxsaXdheXMub2t0YS5jb20vb2F1dGgyL2F1czl1Z2  xkY20ydEhaanY0MGg3IiwiYXVkIjoiQXg1WHJSNGFORGtqQ2FjYUs3aG4iLCJpYXQiOjE0ODk2OTc5NDUsImV4cCI6MTQ5NTIyMTE3NSwianRpIjoiSUQuNEVvdWx5WnM4MU9aaVdqQWNHQWdadmg0eUFScUdacjIwWF  RLdW1WRDRNMCIsImFtciI6WyJwd2QiXSwiaWRwIjoiMDBvOWNwMWpjNmhjc0dWN2kwaDciLCJub25jZSI6ImNjYmJmNDNkLTc5MTUtNDMwMC05NTZkLWQxYjc1ODk1YWNiNyIsImF1dGhfdGltZSI6MTQ4OTY5NjAzNy  wiYXRfaGFzaCI6IlRoaHNhUFd6bVlKMVlmcm1kNDM1Q0EifQ._uLqItzLzKb6m6G2-Jqs6OmrG_iWMg0P6UKQqzVggPc"
}
~~~

#### Response Example (Error)

The requested scope is invalid:

~~~
https://www.example.com/#error=invalid_scope&error_description=The+requested+scope+is+invalid%2C+unknown%2C+or+malformed
~~~

### Token Request
{:.api .api-operation}

{% api_operation post /oauth2/v1/token %}

The API returns Access Tokens, ID Tokens, and Refresh Tokens, depending on the request parameters.

>Because this endpoint works with the [Okta Authorization Server](/standards/OAuth/index.html#authorization-servers), you don't need an authorization server ID.

#### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                                                                                      | Type   |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| grant_type            | Can be one of the following: `authorization_code`, `password`, or `refresh_token`. Determines the mechanism Okta uses to authorize the creation of the tokens.                                                                                                                                                                   | String |
| code                  | Required if `grant_type` is `authorization_code`. The value is what was returned from the          [authentication endpoint](#authentication-request). The code has a lifetime of 60 seconds.                                                                                                                                                                                 | String |
| refresh_token         | Required if `grant_type` is `refresh_token`. The value is what was returned from this endpoint via a previous invocation.                                                                                                                                                                                                        | String |
| username              | Required if the grant_type is `password`.                                                                                                                                                                                                                                                                                        | String |
| password              | Required if the grant_type is `password`.                                                                                                                                                                                                                                                                                        | String |
| scope                 | Required if `password` is the `grant_type`. This is a list of scopes that the client wants to be included in the Access Token. For the `refresh_token` grant type, these scopes have to be subset of the scopes used to generate the Refresh Token in the first place.                                                           | String |
| redirect_uri          | Required if `grant_type` is `authorization_code`. Specifies the callback location where the authorization was sent. This value must match the `redirect_uri` used to generate the original `authorization_code`.                                                                                                                 | String |
| code_verifier         | Required if `grant_type` is `authorization_code`  and `code_challenge` was specified in the original `/authorize` request. This value is the code verifier for                        [PKCE](#parameter-details). Okta uses it to recompute the `code_challenge` and verify if it matches the original `code_challenge` in the authorization request.   | String |
| client_id             | Required if client has a secret and client credentials are not provided in the Authorization header. This is used in conjunction with `client_secret`  to authenticate the client application.                                                                                                                                   | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn't specified. This client secret is used in conjunction with `client_id` to authenticate the client application.                                                                | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.  [JWT Details](#token-authentication-methods)                                                                                                                                                                            | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the  [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.                                                                          | String |

##### Refresh Tokens for Web and Native Applications

For web and native application types, an additional process is required:

1. Use the Okta Administration UI and check the **Refresh Token** checkbox under **Allowed Grant Types** on the client application page.
2. Pass the `offline_access` scope to your `/authorize` or `/token` request if you're using the `password` grant type.

For more information about token authentication, see [Token Authentication Methods](#token-authentication-methods).


#### Response Parameters

Based on the `grant_type` and sometimes `scope`, the response contains different token sets.
Generally speaking, the scopes specified in a request are included in the Access Tokens in the response.

| Requested grant type | Requested scope                                     | Response tokens                                                   |
|:---------------------|:----------------------------------------------------|:------------------------------------------------------------------|
| authorization_code   | None                                                | Access Token. Contains scopes requested in `/authorize` endpoint. |
| authorization_code   | Any scopes except `offline_access` or `openid`      | Access Token                                                      |
| authorization_code   | Any or no scopes plus `offline_access`              | Access Token, Refresh Token                                       |
| authorization_code   | Any or no scopes plus `openid`                      | Access Token, ID Token                                            |
| authorization_code   | Any or no scopes plus `offline_access` and `openid` | Access Token, Refresh Token, ID Token                             |
| refresh_token        | None                                                | Access Token, Refresh Token. Contains scopes used to generate the Refresh Token.     |
| refresh_token        | Any scopes except `offline_access`                  | Access Token                                                      |
| refresh_token        | Any or no scopes plus `offline_access`              | Access Token, Refresh Token                                       |
| password             | Any or no scopes except `offline_access`            | Access Token                                                      |
| password             | Any or no scopes plus `offline_access`              | Access Token, Refresh Token                                       |
| password             | Any or no scopes plus `openid`                      | Access Token, ID Token                                            |
| password             | Any or no scopes plus `offline_access` and `openid` | Access Token, Refresh Token, ID Token                             |

#### List of Errors

| Error Id               | Details                                                                                                                                                                                                    |
|:-----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client         | The specified client id wasn't found.                                                                                                                                                                |
| invalid_request        | The request structure was invalid. For example: the basic authentication header is malformed; both header and form parameters were used for authentication; or no authentication information was provided. |
| invalid_grant          | The `code`, `refresh_token`, or `username` and `password` combination is invalid, or the `redirect_uri` does not match the one used in the authorization request.                                          |
| unsupported_grant_type | The `grant_type` isn't `authorization_code`, `refresh_token`, or `password`.                                                                                                                         |
| invalid_scope          | The scopes list contains an invalid or unsupported value.                                                                                                                                                  |

#### Response Example (Success)

~~~json
{
    "access_token" : "eyJhbGciOiJSUzI1NiJ9.eyJ2ZXIiOjEsImlzcyI6Imh0dHA6Ly9yYWluLm9rdGExLmNvbToxODAyIiwiaWF0IjoxNDQ5Nj
                      I0MDI2LCJleHAiOjE0NDk2Mjc2MjYsImp0aSI6IlVmU0lURzZCVVNfdHA3N21BTjJxIiwic2NvcGVzIjpbIm9wZW5pZCIsI
                      mVtYWlsIl0sImNsaWVudF9pZCI6InVBYXVub2ZXa2FESnh1a0NGZUJ4IiwidXNlcl9pZCI6IjAwdWlkNEJ4WHc2STZUVjRt
                      MGczIn0.HaBu5oQxdVCIvea88HPgr2O5evqZlCT4UXH4UKhJnZ5px-ArNRqwhxXWhHJisslswjPpMkx1IgrudQIjzGYbtLF
                      jrrg2ueiU5-YfmKuJuD6O2yPWGTsV7X6i7ABT6P-t8PRz_RNbk-U1GXWIEkNnEWbPqYDAm_Ofh7iW0Y8WDA5ez1jbtMvd-o
                      XMvJLctRiACrTMLJQ2e5HkbUFxgXQ_rFPNHJbNSUBDLqdi2rg_ND64DLRlXRY7hupNsvWGo0gF4WEUk8IZeaLjKw8UoIs-E
                      TEwJlAMcvkhoVVOsN5dPAaEKvbyvPC1hUGXb4uuThlwdD3ECJrtwgKqLqcWonNtiw",
    "token_type" : "Bearer",
    "expires_in" : 3600,
    "scope"      : "openid email",
    "refresh_token" : "a9VpZDRCeFh3Nkk2VdY",
    "id_token" : "eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwMHVpZDRCeFh3Nkk2VFY0bTBnMyIsImVtYWlsIjoid2VibWFzdGVyQGNsb3VkaXR1ZG
                  UubmV0IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInZlciI6MSwiaXNzIjoiaHR0cDovL3JhaW4ub2t0YTEuY29tOjE4MDIiLCJsb
                  2dpbiI6ImFkbWluaXN0cmF0b3IxQGNsb3VkaXR1ZGUubmV0IiwiYXVkIjoidUFhdW5vZldrYURKeHVrQ0ZlQngiLCJpYXQiOjE0
                  NDk2MjQwMjYsImV4cCI6MTQ0OTYyNzYyNiwiYW1yIjpbInB3ZCJdLCJqdGkiOiI0ZUFXSk9DTUIzU1g4WGV3RGZWUiIsImF1dGh
                  fdGltZSI6MTQ0OTYyNDAyNiwiYXRfaGFzaCI6ImNwcUtmZFFBNWVIODkxRmY1b0pyX1EifQ.Btw6bUbZhRa89DsBb8KmL9rfhku
                  --_mbNC2pgC8yu8obJnwO12nFBepui9KzbpJhGM91PqJwi_AylE6rp-ehamfnUAO4JL14PkemF45Pn3u_6KKwxJnxcWxLvMuuis
                  nvIs7NScKpOAab6ayZU0VL8W6XAijQmnYTtMWQfSuaaR8rYOaWHrffh3OypvDdrQuYacbkT0csxdrayXfBG3UF5-ZAlhfch1fhF
                  T3yZFdWwzkSDc0BGygfiFyNhCezfyT454wbciSZgrA9ROeHkfPCaX7KCFO8GgQEkGRoQntFBNjluFhNLJIUkEFovEDlfuB4tv_M
                  8BM75celdy3jkpOurg"
}
~~~

#### Response Example (Error)

~~~http
HTTP/1.1 401 Unauthorized
Content-Type: application/json;charset=UTF-8
{
    "error" : "invalid_client",
    "error_description" : "No client credentials found."
}
~~~

