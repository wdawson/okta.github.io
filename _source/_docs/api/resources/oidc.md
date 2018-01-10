---
layout: docs_page
title: OpenID Connect
---

# OpenID Connect & OAuth 2.0 API

Okta is a standards-compliant [OAuth 2.0](http://oauth.net/documentation) authorization server and a certified [OpenID Connect Provider](http://openid.net/certification).

OpenID Connect extends OAuth 2.0. The OAuth 2.0 API provides API security via scoped access tokens, and OpenID Connect provides user authentication and an SSO layer.

This page contains detailed information about the OAuth 2.0 / OpenID Connect endpoints that Okta exposes on its authorization servers. For higher-level information about how to use this endpoints, see the [Okta Authentication Guide](/authentication-guide).

## Endpoints

| Endpoint | Description |
|----------------------------------------------------------------------------------|---------------------------------------------------------------------------|
| [/authorize](#authorize) | Used to interact with the resource owner and obtain an authorization grant. |
| [/token](#token) | Used to obtain an access and/or ID token by presenting an authorization grant or refresh token. |
| [/introspect](#introspect) | Returns information about a token. |
| [/revoke](#revoke) | Revokes an access or refresh token. |
| [/logout](#logout) | Ends the session associated with the given ID token. |
| [/keys](#keys) | Returns public keys used to sign responses. |
| [/userinfo](#userinfo) | Returns claims about the authenticated end user. |
| [/.well-known/oauth-authorization-server](#well-knownoauth-authorization-server) | Returns OAuth 2.0 metadata related to the specified authorization server. |
| [/.well-known/openid-configuration](#well-knownopenid-configuration) | Returns OpenID Connect metadata related to the specified authorization server. |

### Composing Your Base URL
All of the OAuth 2.0 endpoints on this page are directed to an authorization server, but which authorization server they go to depends on your use case. Your two options are:

1\. Okta is your authorization server. This is for the use case where your users are all part of your Okta organization and you would just like to offer them single sign-on with an ID Token. In this case we refer to the "Okta Org Authorization Server" In this case your full URL looks like this:

`https://{yourOktaDomain}.com/oauth2/v1/authorize`

2\. You are using a Custom Authorization Server inside Okta. This is for use cases where Okta is the identity platform for your application or API, so your users will be logging in to something other than Okta. In this case your requests are sent to the Custom Authorizations Server, and your full URL looks like this:

`https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/authorize`

If you have a developer account, you can use the `default` authorization server that was created along with your account, in which case the full URL looks like this:

`https://{yourOktaDomain}.com/oauth2/default/v1/authorize`

### /authorize
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/authorize %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

This is a starting point for OpenID Connect flows such as implicit and authorization code flows. This request
authenticates the user and returns tokens along with an authorization grant to the client application as a part
of the response.

#### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                                                                                                                                                                                                                                                                                                                                                                             | Param Type | DataType | Required |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|:---------|:---------
| client_id             | Obtained during either   UI client registration or     [Dynamic Client Registration API](oauth-clients.html). It identifies the client and must match the value preregistered in Okta.                                                                                                                                                                                                                        | Query      | String   | TRUE     |
| code_challenge        | A challenge for [PKCE](#parameter-details). The challenge is verified in the access token request.                                                                                                                                                                                                                                                                                                       | Query      | String   | FALSE    |
| code_challenge_method | Method used to derive the code challenge. Valid value: `S256`                                                                                                                                                                                                                                                                                                                                               | Query      | String   | FALSE    |
| display               | How to display the authentication and consent UI. Valid values: `page` or `popup`                                                                                                                                                                                                                                                                                                                      | Query      | String   | FALSE    |
| idp_scope             | A space delimited list of scopes to be provided to the Social Identity Provider when performing   [Social Login](social_authentication.html). These scopes are used in addition to the scopes already configured on the Identity Provider.                                                                                                                                                                 | Query      | String   | FALSE    |
|    [idp](idps.html)       | Identity provider (default is Okta)                                                                                                                                                                                                                                                                                                                                                                      | Query      | String   | FALSE    |
| login_hint            | A username to prepopulate if prompting for authentication.                                                                                                                                                                                                                                                                                                                                              | Query      | String   | FALSE    |
| max_age               | Allowable elapsed time, in seconds, since the last time the end user was actively authenticated by Okta.                                                                                                                                                                                                                                                                                                | Query      | String   | FALSE    |
| nonce                 | A value that must be returned in the ID token. It is used to mitigate replay attacks.                                                                                                                                                                                                                                                                                                                   | Query      | String   | TRUE     |
| prompt                | Either *none* or `login`. If `none`,  do not prompt for authentication, and return an error if the end user is not already authenticated. If `login`, force a prompt (even if the user had an existing session). Default: depends on whether an Okta session exists.                                                                                                                                    | Query      | String   | FALSE    |
| redirect_uri          | Callback location where the authorization code should be sent. It must match the value preregistered in Okta during client registration.                                                                                                                                                                                                                                                                | Query      | String   | TRUE     |
| response_type         | Any combination of `code`, `token`, and `id_token`. The combination determines the     [flow](http://openid.net/specs/openid-connect-core-1_0.html#Authentication). The `code` response type returns an authorization code, which the client can use to obtain an access or refresh token.                                                                                                                  | Query      | String   | TRUE     |
| response_mode         | How the authorization response should be returned.     [Valid values: `fragment`, `form_post`, `query` or `okta_post_message`](#parameter-details). If `id_token` or `token` is specified as the response type, then `query` isn't allowed as a response mode. Defaults to `fragment` in implicit and hybrid flow. Defaults to `query` in authorization code flow and cannot be set as `okta_post_message`.  | Query      | String   | FALSE    |
| request               | A JWT created by the client that enables requests to be passed as a single, self-contained parameter.                                                                                                                                                                                                                                                                                                   | Query | JWT | FALSE    |
| scope                 | `openid` is required. Other   [scopes](#access-token-scopes-and-claims) may also be included.                                                                                                                                                                                                                                                                                                           | Query      | String   | TRUE     |
| sessionToken          | Okta one-time session token. This allows an API-based user login flow (rather than Okta login UI). Session tokens can be obtained via the     [Authentication API](authn.html).                                                                                                                                                                                                                              | Query      | String   | FALSE    |
| state                 | A value to be returned in the token. The client application can use it to remember the state of its interaction with the end user at the time of the authentication call. It can contain alphanumeric, comma, period, underscore and hyphen characters.                                                                                                                                                 | Query      | String   | TRUE     |

#### Parameter Details

 * `idp`, `sessionToken` and `idp_scope` are Okta extensions to [the OpenID specification](http://openid.net/specs/openid-connect-core-1_0.html#Authentication).
    All other parameters comply with the OpenID Connect specification and their behavior is consistent with the specification.
 * Each value for `response_mode` delivers different behavior:
    * `fragment` -- Parameters are encoded in the URL fragment added to the *redirect_uri* when redirecting back to the client.
    * `query` -- Parameters are encoded in the query string added to the *redirect_uri* when redirecting back to the client.
    * `form_post` -- Parameters are encoded as HTML form values that are auto-submitted in the User Agent. Thus, the values are transmitted via the HTTP POST method to the client
      and the result parameters are encoded in the body using the application/x-www-form-urlencoded format.
    * `okta_post_message` -- Uses [HTML5 Web Messaging](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) (for example, window.postMessage()) instead of the redirect for the authorization response from the `/authorize` endpoint.
      `okta_post_message` is an adaptation of the [Web Message Response Mode](https://tools.ietf.org/html/draft-sakimura-oauth-wmrm-00#section-4.1).
      This value provides a secure way for a single-page application to perform a sign-in flow
      in a popup window or an iFrame and receive the ID token and/or access token back in the parent page without leaving the context of that page.
      The data model for the [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) call is in the next section.
    * The `Referrer-Policy` header is automatically included in the request for `fragment` or `query`, and is set to `Referrer-Policy: no-referrer`.

 * Okta requires the OAuth 2.0 `state` parameter on all requests to the `/authorize` endpoint in order to prevent cross-site request forgery (CSRF).
 The OAuth 2.0 specification [requires](https://tools.ietf.org/html/rfc6749#section-10.12) that clients protect their redirect URIs against CSRF by sending a value in the authorize request which binds the request to the user-agent's authenticated state.
 Using the `state` parameter is also a countermeasure to several other known attacks as outlined in [OAuth 2.0 Threat Model and Security Considerations](https://tools.ietf.org/html/rfc6819).

 * Proof Key for Code Exchange (PKCE) is a stronger mechanism for binding the authorization code to the client than just a client secret. You can read more about this [here](/authentication-guide/implementing-authentication/auth-code-pkce).

* About the `request` parameter:
  * You must sign the JWT using the app's client secret.
  * The JWT can't be encrypted.
  * Okta supports these signing algorithms: [HS256](https://tools.ietf.org/html/rfc7518#section-5.2.3), [HS384](https://tools.ietf.org/html/rfc7518#section-5.2.4), and [HS512](https://tools.ietf.org/html/rfc7518#section-5.2.5).
  * We recommend you don't duplicate any request parameters in both the JWT and the query URI itself. However, you can do so with `state`, `nonce`, `code_challenge`, and `code_challenge_method`.
  * Okta validates the `request` parameter in the following ways:
    1. `iss` is required and must  be the `client_id`.
    2. `aud` is required and must be same value as the authorization server issuer that mints the ID or access token. This value is published in the metadata for your authorization server.
    3. JWT lifetime is evaluated using the `iat` and `exp` claims if present. If the JWT is expired or not yet valid, Okta returns an `invalid_request_object`  error.
    4. Okta rejects the JWT if the `jti` claim is present and it has already been processed.

#### postMessage() Data Model

Use the postMessage() data model to help you when working with the `okta_post_message` value of the `response_mode` request parameter.

`message`:

| Parameter         | Description                                                                                                                                                                                                                                                                                                   | DataType |
|:------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------|
| access_token      | The `access_token` used to access the   [`/oauth2/v1/userinfo`](#userinfo) endpoint. This is returned if the `response_type` included a token. <b>Important</b>: Unlike the ID token JWT, the `access_token` structure is specific to Okta, and is subject to change.                                           | String   |
| error             | The error-code string providing information if anything goes wrong.                                                                                                                                                                                                                                           | String   |
| error_description | Additional description of the error.                                                                                                                                                                                                                                                                          | String   |
| id_token          | The ID token JWT contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the `response_type` includes `id_token`.                                                                                                                          | String   |
| state             | If the request contained a `state` parameter, then the same unmodified value is returned back in the response.                                                                                                                                                                                                | String   |

`targetOrigin`:

Specifies what the origin of `parentWindow` must be in order for the postMessage() event to be dispatched
(this is enforced by the browser). The `okta-post-message` response mode always uses the origin from the `redirect_uri`
specified by the client. This is crucial to prevent the sensitive token data from being exposed to a malicious site.

#### Response Properties

The method of returning the response depends on the response type passed to the API. For example, a `fragment` response mode returns values in the fragment portion of a redirect to the specified `redirect_uri` while a `form_post` response mode POSTs the return values to the redirect URI.
Irrespective of the response type, the contents of the response are as described in the table.

| Property         | Description                                                                                                                                                                                                                                                          | DataType |
|:------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------|
| access_token      | Used to access the   [`/oauth2/v1/userinfo`](#userinfo) endpoint. This is returned if `response_type` includes `token`. Unlike the ID token JWT, the `access_token` structure is specific to Okta, and is subject to change.                                           | String   |
| code              | An opaque value that can be used to redeem tokens from   the [token endpoint](#token). `code` is returned if the `response_type` includes `code`. The code has a lifetime of 60 seconds.                                                                       | String   |
| error             | Error-code (if something went wrong).                                                                                                                                                                                                                                | String   |
| error_description | Description of the error.                                                                                                                                                                                                                                            | String   |
| expires_in        | Number of seconds until the `access_token` expires. This is only returned if the response included an `access_token`.                                                                                                                                                | String   |
| id_token          | JWT that contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the `response_type` includes `id_token`.                                                                                         | String   |
| scope             | Scopes specified in the `access_token`. Returned only if the response includes an `access_token`.                                                                                                                                                                    | String   |
| state             | The unmodified `state` value from the request.                                                                                                                                                                                                                       | String   |
| token_type        | The token type is always `Bearer` and is returned only when `token` is specified as a `response_type`.                                                                                                                                                               | String   |

##### Possible Errors

These APIs are compliant with the OpenID Connect and OAuth 2.0 spec with some Okta specific extensions.

[OAuth 2.0 Spec error codes](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)

| Error Id                  | Details                                                                                                                                                                                                            |
|:--------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| access_denied             | The server denied the request.                                                                                                                                                                                     |
| invalid_client            | The specified client ID is invalid.                                                                                                                                                                                |
| invalid_grant             | The specified grant is invalid, expired, revoked, or does not match the redirect URI used in the authorization request.                                                                                            |
| invalid_request           | The request is missing a necessary parameter or the parameter has an invalid value.                                                                                                                                |
| invalid_scope             | The scopes list contains an invalid or unsupported value.                                                                                                                                                          |
| invalid_token             | The provided access token is invalid.                                                                                                                                                                              |
| server_error              | The server encountered an internal error.                                                                                                                                                                          |
| temporarily_unavailable   | The server is temporarily unavailable, but should be able to process the request at a later time.                                                                                                                  |
| unsupported_response_type | The specified response type is invalid or unsupported.                                                                                                                                                             |
| unsupported_response_mode | The specified response mode is invalid or unsupported. This error is also thrown for disallowed response modes. For example, if the query response mode is specified for a response type that includes `id_token`. |

[Open-ID Spec error codes](http://openid.net/specs/openid-connect-core-1_0.html#AuthError)

| Error Id           | Details                                                                                           |
|:-------------------|:--------------------------------------------------------------------------------------------------|
| insufficient_scope | The access token provided does not contain the necessary scopes to access the resource.           |
| login_required     | The request specified that no prompt should be shown but the user is currently not authenticated. |

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

This request initiates the implicit flow, that is, it obtains an ID token and optionally an access token directly from the authorization server. We use the same request as the first example, but with `response_type=id_token` or `response_type=id_token token`:

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

### /token
{:.api .api-operation}

{% api_operation post ${baseUrl}/v1/token %}

The API returns access tokens, ID tokens, and refresh tokens, depending on the request parameters.

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

#### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                                                                                      | Type   |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| code                  | Required if `grant_type` is `authorization_code`. The value is what was returned from the           [authorization endpoint](#authorization). The code has a lifetime of 60 seconds.                                                                                                                                              | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.   [JWT details here](#token-authentication-methods).                                                                                                                                                                              | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the   [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.                                                                           | String |
| client_id             | Required if client has a secret and client credentials are not provided in the Authorization header. This is used in conjunction with `client_secret`  to authenticate the client application.                                                                                                                                   | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn't specified. This client secret is used in conjunction with `client_id` to authenticate the client application.                                                                      | String |
| code_verifier         | Required if `grant_type` is `authorization_code`  and `code_challenge` was specified in the original `/authorize` request. This value is the code verifier for                         [PKCE](#parameter-details). Okta uses it to recompute the `code_challenge` and verify if it matches the original `code_challenge` in the authorization request.   | String |
| grant_type            | Can be one of the following: `authorization_code`, `password`, or `refresh_token`. Determines the mechanism Okta uses to authorize the creation of the tokens.                                                                                                                                                                   | String |
| password              | Required if the grant_type is `password`.                                                                                                                                                                                                                                                                                        | String |
| redirect_uri          | Required if `grant_type` is `authorization_code`. Specifies the callback location where the authorization was sent. This value must match the `redirect_uri` used to generate the original `authorization_code`.                                                                                                                 | String |
| refresh_token         | Required if `grant_type` is `refresh_token`. The value is what was returned from this endpoint via a previous invocation.                                                                                                                                                                                                        | String |
| scope                 | Required if `password` is the `grant_type`. This is a list of scopes that the client wants to be included in the access token. For the `refresh_token` grant type, these scopes have to be subset of the scopes used to generate the refresh token in the first place.                                                           | String |
| username              | Required if the grant_type is `password`.                                                                                                                                                                                                                                                                                        | String |

##### Refresh Tokens for Web and Native Applications

For web and native application types, an additional process is required:

1. Use the Okta Administration UI and check the **Refresh Token** checkbox under **Allowed Grant Types** on the client application page.
2. Pass the `offline_access` scope to your `/authorize` or `/token` request if you're using the `password` grant type.

For more information about token authentication, see [Token Authentication Methods](#token-authentication-methods).

#### Response Properties

Based on the `grant_type` and sometimes `scope`, the response contains different token sets.
Generally speaking, the scopes specified in a request are included in the access tokens in the response.

| Requested grant type | Requested scope                                     | Response tokens                                                   |
|:---------------------|:----------------------------------------------------|:------------------------------------------------------------------|
| authorization_code   | None                                                | Access token. Contains scopes requested in `/authorize` endpoint. |
| authorization_code   | Any scopes except `offline_access` or `openid`      | Access token                                                      |
| authorization_code   | Any or no scopes plus `offline_access`              | Access token, refresh token                                       |
| authorization_code   | Any or no scopes plus `openid`                      | Access token, ID token                                            |
| authorization_code   | Any or no scopes plus `offline_access` and `openid` | Access token, refresh token, ID token                             |
| refresh_token        | None                                                | Access token, refresh token. Contains scopes used to generate the refresh token.     |
| refresh_token        | Any scopes except `offline_access`                  | Access token                                                      |
| refresh_token        | Any or no scopes plus `offline_access`              | Access token, refresh token                                       |
| password             | Any or no scopes except `offline_access`            | Access token                                                      |
| password             | Any or no scopes plus `offline_access`              | Access token, refresh token                                       |
| password             | Any or no scopes plus `openid`                      | Access token, ID token                                            |
| password             | Any or no scopes plus `offline_access` and `openid` | Access token, refresh token, ID token                             |

#### List of Errors

| Error Id               | Details                                                                                                                                                                                                    |
|:-----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client         | The specified client id wasn't found.                                                                                                                                                                |
| invalid_grant          | The `code`, `refresh_token`, or `username` and `password` combination is invalid, or the `redirect_uri` does not match the one used in the authorization request.                                          |
| invalid_request        | The request structure was invalid. For example: the basic authentication header is malformed; both header and form parameters were used for authentication; or no authentication information was provided. |
| invalid_scope          | The scopes list contains an invalid or unsupported value.                                                                                                                                                  |
| unsupported_grant_type | The `grant_type` isn't `authorization_code`, `refresh_token`, or `password`.                                                                                                                         |

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


### /introspect
{:.api .api-operation}

{% api_operation post ${baseUrl}/v1/introspect %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

This endpoint takes an access or refresh token, and returns a boolean indicating whether it is active or not.
If the token is active, additional data about the token is also returned. If the token is invalid, expired, or revoked, it is considered inactive.

> Note: [ID tokens](#id-token) are also valid, however, they are usually validated on the service provider or app side of a flow.

#### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                       | Type   |
|:----------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| client_id             | Required if client has a secret and client credentials are not provided in the Authorization header. This is used in conjunction with `client_secret`  to authenticate the client application.                                                                    | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn't specified. This client secret is used in conjunction with `client_id` to authenticate the client application.       | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.     [JWT details here](#token-authentication-methods).                                                                                                               | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the     [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.            | String |
| token                 | An access token, ID token, or refresh token.                                                                                                                                                                                                                      | String |
| token_type_hint       | Indicates the type of `token` being passed. Valid values are `access_token`, `id_token` and `refresh_token`.                                                                                                                                                      | String (Enum)|

##### Token Authentication Methods

If you authenticate a client with client credentials, provide the [`client_id` and `client_secret`](#request-parameters-1)
using either of the following methods:

* Provide `client_id` and `client_secret`
  in an Authorization header in the Basic auth scheme (`client_secret_basic`). For authentication with Basic auth, an HTTP header with the following format must be provided with the POST request:
  ~~~sh
  Authorization: Basic ${Base64(<client_id>:<client_secret>)}
  ~~~
* Provide the `client_id` and `client_secret`
  as additional parameters to the POST body (`client_secret_post`)
* Provide `client_id` in a JWT that you sign with the `client_secret`
  using HMAC algorithms HS256, HS384, or HS512. Specify the JWT in `client_assertion` and the type, `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`, in `client_assertion_type` in the request.

Use only one of these methods in a single request or an error will occur.

##### Token Claims for Client Authentication with Client Secret JWT

If you use a JWT for client authentication (`client_secret_jwt`), use the following token claims:

| Token Claims | Description                                                                           | Type   |
|:-------------|:--------------------------------------------------------------------------------------|:-------|
| aud          | Required. The full URL of the resource you're using the JWT to authenticate to.       | String |
| exp          | Required. The expiration time of the token in seconds since January 1, 1970 UTC.      | Integer |
| jti          | Optional. The identifier of the token.                                                | String |
| iat          | Optional. The issuing time of the token in seconds since January 1, 1970 UTC.         | Integer |
| iss          | Required. The issuer of the token. This value must be the same as the `client_id`.    | String |
| sub          | Required. The subject of the token. This value must be the same as the `client_id`.   | String |

Parameter Details

* If `jti` is specified, the token can only be used once. So, for example, subsequent token requests won't succeed.
* The `exp` claim will fail the request if the expiration time is more than one hour in the future or has already expired.
* If `iat` is specified, then it must be a time before the request is received.

#### Response Properties

Based on the type of token and whether it is active or not, the returned JSON contains a different set of information. Besides the claims in the token, the possible top-level members include:

| Property  | Description                                                                                                  | Type    |
|:-----------|:-------------------------------------------------------------------------------------------------------------|:--------|
| active     | Indicates whether the token is active or not.                                                                | String (Boolean) |
| aud        | The audience of the token.                                                                                   | String  |
| client_id  | The ID of the client associated with the token.                                                              | String  |
| device_id  | The ID of the device associated with the token                                                               | String  |
| exp        | The expiration time of the token in seconds since January 1, 1970 UTC.                                       | Integer    |
| iat        | The issuing time of the token in seconds since January 1, 1970 UTC.                                          | Integer    |
| iss        | The issuer of the token.                                                                                     | String  |
| jti        | The identifier of the token.                                                                                 | String  |
| nbf        | A timestamp in seconds since January 1, 1970 UTC when this token is not be used before.                      | Integer    |
| scope      | A space-delimited list of scopes.                                                                            | String  |
| sub        | The subject of the token.                                                                                    | String  |
| token_type | The type of token. The value is always `Bearer`.                                                         | String  |
| uid        | The user ID. This parameter is returned only if the token is an access token and the subject is an end user. | String  |
| username   | The username associated with the token.                                                                      | String  |

#### List of Errors

| Error Id        | Details                                                                                                                                                                                                       |
|:----------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client  | The specified `client_id` wasn't found.                                                                                                                                                                 |
| invalid_request | The request structure was invalid. For example, the basic authentication header was malformed, or both header and form parameters were used for authentication or no authentication information was provided. |

#### Response Example (Success, Access Token)

~~~json
{
    "active" : true,
    "token_type" : "Bearer",
    "scope" : "openid profile",
    "client_id" : "a9VpZDRCeFh3Nkk2VdYa",
    "username" : "john.doe@example.com",
    "exp" : 1451606400,
    "iat" : 1451602800,
    "sub" : "john.doe@example.com",
    "aud" : "https://{yourOktaDomain}.com",
    "iss" : "https://{yourOktaDomain}.com/oauth2/orsmsg0aWLdnF3spV0g3",
    "jti" : "AT.7P4KlczBYVcWLkxduEuKeZfeiNYkZIC9uGJ28Cc-YaI",
    "uid" : "00uid4BxXw6I6TV4m0g3"
}
~~~

#### Response Example (Success, Refresh Token)

~~~json
{
    "active" : true,
    "token_type" : "Bearer",
    "scope" : "openid profile email",
    "client_id" : "a9VpZDRCeFh3Nkk2VdYa",
    "username" : "john.doe@example.com",
    "exp" : 1451606400,
    "sub" : "john.doe@example.com",
    "device_id" : "q4SZgrA9sOeHkfst5uaa"
}
~~~

#### Response Example (Success, Inactive Token)

~~~json
{
    "active" : false
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

### /revoke
{:.api .api-operation}


{% api_operation post ${baseUrl}/v1/revoke %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

The API takes an access or refresh token and revokes it. Revoked tokens are considered inactive at the introspection endpoint. A client may only revoke its own tokens.

#### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                                     | Type   |
|:----------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| client_id             | The client ID generated as a part of client registration. This is used in conjunction with the `client_secret` parameter to authenticate the client application.                                                                                                                | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn't specified. This client secret is used in conjunction with the `client_id` parameter to authenticate the client application. | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.        [JWT Details](#token-authentication-methods)                                                                                                                           | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the           [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.                         | String |
| token                 | An access or refresh token.                                                                                                                                                                                                                                               | String |
| token_type_hint       | A hint of the type of `token`. Valid values are `access_token` and `refresh_token`.                                                                                                                                                                                             | String (Enum)   |

A client may only revoke a token generated for that client.

For more information about token authentication, see [Token Authentication Methods](#token-authentication-methods).

#### Response Properties

A successful revocation is denoted by an empty response with an HTTP 200. Note that revoking an invalid, expired, or revoked token will still be considered a success as to not leak information

#### List of Errors

| Error Id        | Details                                                                                                                                                                                               |
|:----------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client  | The specified `client_id` wasn't found.                                                                                                                                                         |
| invalid_request | The request structure was invalid. E.g. the basic authentication header was malformed, or both header and form parameters were used for authentication or no authentication information was provided. |

#### Response Example (Success)

~~~http
HTTP/1.1 200 OK
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

### /logout
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/logout %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

The API takes an ID token and logs the user out of the Okta session if the subject matches the current Okta session. A `post_logout_redirect_uri` may be specified to redirect the User after the logout has been performed. Otherwise, the user is redirected to the Okta login page.

Use this operation to log out a user by removing their Okta browser session.

#### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter                | Description                                                                                                                                     | Type   | Required |
|:-------------------------|:------------------------------------------------------------------------------------------------------------------------------------------------|:-------|:---------|
| id_token_hint            | A valid ID token with a subject matching the current session.                                                                                   | String | TRUE     |
| post_logout_redirect_uri | Callback location to redirect to after the logout has been performed. It must match the value preregistered in Okta during client registration. | String | FALSE    |
| state                    | If the request contained a `state` parameter, then the same unmodified value is returned back in the response.                                  | String | FALSE    |

#### Request Examples

This request initiates a logout and will redirect to the Okta login page on success.

~~~sh
curl -v -X GET \
"https://{yourOktaDomain}.com/oauth2/v1/logout?
  id_token_hint=${id_token_hint}
~~~

This request initiates a logout and will redirect to the `post_logout_redirect_uri` on success.

~~~sh
curl -v -X GET \
"https://{yourOktaDomain}.com/oauth2/v1/logout?
  id_token_hint=${id_token_hint}&
  post_logout_redirect_uri=${post_logout_redirect_uri}&
  state=${state}
~~~

### /keys
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/keys %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

Returns the JSON Web Key Set (JWKS), which contains the keys used to sign the tokens that you receive from your authorization server. If automatic key rotation is disabled, provide the `client_id` to fetch public keys for your app. Otherwise, this endpoint returns the public keys automatically rotated.

Any of the two or three keys listed are used to sign tokens. The order of keys in the result doesn't indicate which keys are used.

Standard open-source libraries are available for every major language to perform [JWS](https://tools.ietf.org/html/rfc7515) signature validation.

>Okta strongly recommends retrieving keys dynamically with the JWKS published in the discovery document.

>Okta also recommends caching or persisting downloaded keys to improve performance by eliminating multiple API requests. If the client application is pinned to a signing key, the verification fails when Okta rotates the key automatically. Pinned client applications must periodically check the cached Okta signing keys.

#### Request Parameters
{:.api .api-request .api-request-params}

| Parameter | Description                 | Param Type | DataType | Required | Default |
|:----------|:----------------------------|:-----------|:---------|:---------|:--------|
| client_id | Your app's client ID. | Query      | String   | FALSE    | null    |


#### Response Properties

JWK properties can be found [here](/docs/api/resources/authz-servers#key-properties).

#### Response Example
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Cache-Control → max-age=3832304, must-revalidate
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
  "keys": [
    {
      "alg": "RS256",
      "e": "AQAB",
      "n": "iKqiD4cr7FZKm6f05K4r-GQOvjRqjOeFmOho9V7SAXYwCyJluaGBLVvDWO1XlduPLOrsG_Wgs67SOG5qeLPR8T1zDK4bfJAo1Tvbw
            YeTwVSfd_0mzRq8WaVc_2JtEK7J-4Z0MdVm_dJmcMHVfDziCRohSZthN__WM2NwGnbewWnla0wpEsU3QMZ05_OxvbBdQZaDUsNSx4
            6is29eCdYwhkAfFd_cFRq3DixLEYUsRwmOqwABwwDjBTNvgZOomrtD8BRFWSTlwsbrNZtJMYU33wuLO9ynFkZnY6qRKVHr3YToIrq
            NBXw0RWCheTouQ-snfAB6wcE2WDN3N5z760ejqQ",
      "kid": "U5R8cHbGw445Qbq8zVO1PcCpXL8yG6IcovVa3laCoxM",
      "kty": "RSA",
      "use": "sig"
    },
    {
      "alg": "RS256",
      "e": "AQAB",
      "n": "l1hZ_g2sgBE3oHvu34T-5XP18FYJWgtul_nRNg-5xra5ySkaXEOJUDRERUG0HrR42uqf9jYrUTwg9fp-SqqNIdHRaN8EwRSDRsKAwK
            3HIJ2NJfgmrrO2ABkeyUq6rzHxAumiKv1iLFpSawSIiTEBJERtUCDcjbbqyHVFuivIFgH8L37-XDIDb0XG-R8DOoOHLJPTpsgH-rJe
            M5w96VIRZInsGC5OGWkFdtgk6OkbvVd7_TXcxLCpWeg1vlbmX-0TmG5yjSj7ek05txcpxIqYu-7FIGT0KKvXge_BOSEUlJpBhLKU28
            OtsOnmc3NLIGXB-GeDiUZiBYQdPR-myB4ZoQ",
      "kid": "Y3vBOdYT-l-I0j-gRQ26XjutSX00TeWiSguuDhW3ngo",
      "kty": "RSA",
      "use": "sig"
    },
    {
      "alg": "RS256",
      "e": "AQAB",
      "n": "lC4ehVB6W0OCtNPnz8udYH9Ao83B6EKnHA5eTcMOap_lQZ-nKtS1lZwBj4wXRVc1XmS0d2OQFA1VMQ-dHLDE3CiGfsGqWbaiZFdW7U
            GLO1nAwfDdH6xp3xwpKOMewDXbAHJlXdYYAe2ap-CE9c5WLTUBU6JROuWcorHCNJisj1aExyiY5t3JQQVGpBz2oUIHo7NRzQoKimvp
            dMvMzcYnTlk1dhlG11b1GTkBclprm1BmOP7Ltjd7aEumOJWS67nKcAZzl48Zyg5KtV11V9F9dkGt25qHauqFKL7w3wu-DYhT0hmyFc
            wn-tXS6e6HQbfHhR_MQxysLtDGOk2ViWv8AQ",
      "kid": "h5Sr3LXcpQiQlAUVPdhrdLFoIvkhRTAVs_h39bQnxlU",
      "kty": "RSA",
      "use": "sig"
    }
  ]
}
~~~



#### Alternative Validation

You can use an [introspection request](#introspect) for validation.

### /userinfo
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/userinfo %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

Returns any claims for the currently logged-in user, as per the [OIDC userinfo spec](http://openid.net/specs/openid-connect-core-1_0.html#UserInfo).

You must include the `access_token` returned from the [authorization endpoint](#authorize) as an authorization header parameter.

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X POST \
-H "Authorization: Bearer ${access_token}" \
"https://{yourOktaDomain}.com/oauth2/v1/userinfo"
~~~

#### Response Properties
{:.api .api-response .api-response-example}

Returns a JSON document with claims about the currently authenticated end user.

#### Response Example (Success)
{:.api .api-response .api-response-example}
~~~json
{
  "sub": "00uid4BxXw6I6TV4m0g3",
  "name" :"John Doe",
  "nickname":"Jimmy",
  "given_name":"John",
  "middle_name":"James",
  "family_name":"Doe",
  "profile":"https://profile.wordpress.com/john.doe",
  "zoneinfo":"America/Los_Angeles",
  "locale":"en-US",
  "updated_at":1311280970,
  "email":"john.doe@example.com",
  "email_verified":true,
  "address" : { "street_address": "123 Hollywood Blvd.", "locality": "Los Angeles", "region": "CA", "postal_code": "90210", "country": "US" },
  "phone_number":"+1 (425) 555-1212"
}
~~~

The claims in the response are identical to those returned for the requested scopes in the `id_token` JWT, except for the `sub` claim which is always present.
See [Scope-Dependent Claims](#scope-dependent-claims-not-always-returned) for more information about individual claims.

#### Response Example (Error)
{:.api .api-response .api-response-example}
~~~http
HTTP/1.1 401 Unauthorized​
Expires: 0​
WWW-Authenticate: Bearer error="invalid_token", error_description="The access token is invalid"​
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}
~~~http
HTTP/1.1 403 Forbidden​
Expires: 0​
WWW-Authenticate: Bearer error="insufficient_scope", error_description="The access token must provide access to at least one of these scopes - profile, email, address or phone"
~~~

### /.well-known/oauth-authorization-server
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/.well-known/oauth-authorization-server %}

> This endpoint's base URL namespace will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

Returns OAuth 2.0 metadata related to your authorization server. This information can be used by clients to programmatically configure their interactions with Okta. Custom scopes and custom claims aren't returned.

> This API doesn't require any authentication.

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -X GET \
  'https://{yourOktaDomain}.com/oauth2/default/.well-known/oauth-authorization-server?client_id=0oabzljih3rnr6aGt0h7' \
~~~

#### Response Properties
{:.api .api-response .api-response-example}

| Property  | Description                                                                                                   | Type    |
|:-----------|:-------------------------------------------------------------------------------------------------------------|:--------|
| issuer     | The complete URL for a Custom Authorization Server. This becomes the `iss` claim in an Access Token. In the context of this document, this is your authorizations server's [base URL](#composing-your-base-url). | String |
| authorization endpoint | URL of the authorization server's [authorization endpoint](#authorize). | String |
| token_endpoint | URL of the authorization server's [token endpoint](#token).| String |
| registration_endpoint | URL of the authorization server's [OAuth 2.0 Dynamic Client Registration endpoint](/docs/api/resources/oauth-clients.html#register-new-client) | String |
| jwks_uri | URL of the authorization server's JSON Web Key Set document. | String |
| response_types_supported | JSON array containing a list of the OAuth 2.0 "response_type" values that this authorization server supports.  Can be a combination of `code`, `token`, and `id_token`. | Array |
| response_modes_supported | JSON array containing a list of the OAuth 2.0 "response_mode" values that this authorization server supports. More information [here](#request-parameter-details). | Array |
| grant_types_supported | JSON array containing a list of the OAuth 2.0 grant type values that this authorization server supports. | Array |
| subject_types_supported | JSON array containing a list of the Subject Identifier types that this OP supports. Valid types include `pairwise` and `public`. More info [here](https://openid.net/specs/openid-connect-core-1_0.html#SubjectIDTypes). | Array |
| scopes_supported | JSON array containing a list of the OAuth 2.0 "scope" values that this authorization server supports. | Array |
| token_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this token endpoint. | Array |
| claims_supported | A list of the claims supported by this authorization server. | Array |
| code_challenge_methods_supported| JSON array containing a list of [PKCE code challenge](/authentication-guide/implementing-authentication/auth-code-pkce) methods supported by this authorization server. | Array |
| introspection_endpoint | URL of the authorization server's OAuth 2.0 [introspection endpoint](#introspect). | String |
| introspection_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this introspection endpoint. More info [here](https://www.iana.org/assignments/oauth-parameters/oauth-parameters.xhtml#token-introspection-response). | Array |
| revocation_endpoint | URL of the authorization server's OAuth 2.0 [revocation endpoint](#revoke). | String |
| revocation_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this revocation endpoint. More info [here](https://www.iana.org/assignments/oauth-parameters/oauth-parameters.xhtml#token-introspection-response). | Array |
| end_session_endpoint | URL of the authorization server's OAuth 2.0 [logout endpoint](#logout). | String |
| request_parameter_supported | Indicates if [Request Parameters](#request-parameter-details) are supported by this authorization server. | String (Boolean) |
| request_object_signing_alg_values_supported | The signing algorithms that this authorization server supports for signed requests. | Array |


#### Response Example (Success)
{:.api .api-response .api-response-example}

~~~json
{
    "issuer": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}"",
    "authorization_endpoint": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/authorize",
    "token_endpoint": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/token",
    "registration_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/clients",
    "jwks_uri": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/keys",
    "response_types_supported": [
        "code",
        "token",
        "code token"
    ],
    "response_modes_supported": [
        "query",
        "fragment",
        "form_post",
        "okta_post_message"
    ],
    "grant_types_supported": [
        "authorization_code",
        "implicit",
        "refresh_token",
        "password"
        "client_credentials"
    ],
    "subject_types_supported": [
        "public"
    ],
    "scopes_supported": [
        "offline_access",
    ],
    "token_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ],
    "claims_supported": [
       "ver",
       "jti",
       "iss",
       "aud",
       "iat",
       "exp",
       "cid",
       "uid",
       "scp",
       "sub"
  ],
    "code_challenge_methods_supported": [
        "S256"
    ],
    "introspection_endpoint": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/introspect",
    "introspection_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ],
    "revocation_endpoint": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/revoke",
    "revocation_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ]
    "end_session_endpoint": "https://{yourOktaDomain}.com/oauth2/${authorizationServerId}/v1/logout",
    "request_parameter_supported": true,
    "request_object_signing_alg_values_supported": [
        "HS256",
        "HS384",
        "HS512"
    ]
}
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}
~~~http
HTTP/1.1 404 Not Found
{
    "errorCode": "E0000007",
    "errorSummary": "Not found: Resource not found: ${authorizationServerId} (AuthorizationServer)",
    "errorLink": "E0000007",
    "errorId": "oaeQdc5IvrlSGGnewf-cqqDqA",
    "errorCauses": []
}
~~~

### /.well-known/openid-configuration
{:.api .api-operation}

{% api_operation get ${baseUrl}/v1/.well-known/openid-configuration %}

> This endpoint's base URL will vary depending on whether you are using a custom authorization server or not. For more information, see [Composing Your Base URL](#composing-your-base-url).

Returns OpenID Connect metadata related to your authorization server. This information can be used by clients to programmatically configure their interactions with Okta. Custom scopes and custom claims aren't returned.

> This API doesn't require any authentication.

#### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -X GET \
  'https:/{yourOktaDomain}.com/oauth2/${authorizationServerId}/.well-known/openid-configuration?client_id=0oabzljih3rnr6aGt0h7' \
~~~

#### Response Properties
{:.api .api-response .api-response-example}

| Property  | Description                                                                                                   | Type    |
|:-----------|:-------------------------------------------------------------------------------------------------------------|:--------|
| issuer     | The authorization server's issuer identifier. In the context of this document, this is your authorizations server's [base URL](#composing-your-base-uRL). | String |
| authorization endpoint | URL of the authorization server's [authorization endpoint](#authorize). | String |
| token_endpoint | URL of the authorization server's [token endpoint](#token).| String |
| registration_endpoint | URL of the authorization server's [OAuth 2.0 Dynamic Client Registration endpoint](/docs/api/resources/oauth-clients.html#register-new-client) | String |
| jwks_uri | URL of the authorization server's JSON Web Key Set document. | String |
| response_types_supported | JSON array containing a list of the OAuth 2.0 "response_type" values that this authorization server supports.  Can be a combination of `code`, `token`, and `id_token`. | Array |
| response_modes_supported | JSON array containing a list of the OAuth 2.0 "response_mode" values that this authorization server supports. More information [here](#request-parameter-details). | Array |
| grant_types_supported | JSON array containing a list of the OAuth 2.0 grant type values that this authorization server supports. | Array |
| subject_types_supported | JSON array containing a list of the Subject Identifier types that this OP supports. Valid types include `pairwise` and `public`. More info [here](https://openid.net/specs/openid-connect-core-1_0.html#SubjectIDTypes). | Array |
| scopes_supported | JSON array containing a list of the OAuth 2.0 "scope" values that this authorization server supports. | Array |
| token_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this token endpoint. | Array |
| claims_supported | A list of the claims supported by this authorization server. | Array |
| code_challenge_methods_supported| JSON array containing a list of [PKCE code challenge](/authentication-guide/implementing-authentication/auth-code-pkce) methods supported by this authorization server. | Array |
| introspection_endpoint | URL of the authorization server's OAuth 2.0 [introspection endpoint](#introspect). | String |
| introspection_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this introspection endpoint. More info [here](https://www.iana.org/assignments/oauth-parameters/oauth-parameters.xhtml#token-introspection-response). | Array |
| revocation_endpoint | URL of the authorization server's OAuth 2.0 [revocation endpoint](#revoke). | String |
| revocation_endpoint_auth_methods_supported | JSON array containing a list of client authentication methods supported by this revocation endpoint. More info [here](https://www.iana.org/assignments/oauth-parameters/oauth-parameters.xhtml#token-introspection-response). | Array |
| end_session_endpoint | URL of the authorization server's OAuth 2.0 [logout endpoint](#logout). | String |
| request_parameter_supported | Indicates if [Request Parameters](#request-parameter-details) are supported by this authorization server. | String (Boolean) |
| request_object_signing_alg_values_supported | The signing algorithms that this authorization server supports for signed requests. | Array |

#### Response Example (Success)
{:.api .api-response .api-response-example}

~~~json
{
    "issuer": "https://{yourOktaDomain}.com",
    "authorization_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/authorize",
    "token_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/token",
    "userinfo_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/userinfo",
    "registration_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/clients",
    "jwks_uri": "https://{yourOktaDomain}.com/oauth2/v1/keys",
    "response_types_supported": [
        "code",
        "code id_token",
        "code token",
        "code id_token token",
        "id_token",
        "id_token token"
    ],
    "response_modes_supported": [
        "query",
        "fragment",
        "form_post",
        "okta_post_message"
    ],
    "grant_types_supported": [
        "authorization_code",
        "implicit",
        "refresh_token",
        "password"
    ],
    "subject_types_supported": [
        "public"
    ],
    "id_token_signing_alg_values_supported": [
        "RS256"
    ],
    "scopes_supported": [
        "openid",
        "email",
        "profile",
        "address",
        "phone",
        "offline_access",
        "groups"
    ],
    "token_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ],
    "claims_supported": [
        "iss",
        "ver",
        "sub",
        "aud",
        "iat",
        "exp",
        "jti",
        "auth_time",
        "amr",
        "idp",
        "nonce",
        "name",
        "nickname",
        "preferred_username",
        "given_name",
        "middle_name",
        "family_name",
        "email",
        "email_verified",
        "profile",
        "zoneinfo",
        "locale",
        "address",
        "phone_number",
        "picture",
        "website",
        "gender",
        "birthdate",
        "updated_at",
        "at_hash",
        "c_hash"
    ],
    "introspection_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/introspect",
    "introspection_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ],
    "revocation_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/revoke",
    "revocation_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ],
    "end_session_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/logout"
    "request_parameter_supported": true,
    "request_object_signing_alg_values_supported": [
        "HS256",
        "HS384",
        "HS512"
    ]
}
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}
~~~http
~~~http
HTTP/1.1 404 Not Found
{
    "errorCode": "E0000007",
    "errorSummary": "Not found: Resource not found: ${authorizationServerId} (AuthorizationServer)",
    "errorLink": "E0000007",
    "errorId": "oaeQdc5IvrlSGGnewf-cqqDqA",
    "errorCauses": []
}
~~~

## Tokens

This section contains detailed information about the objects that are inputted to, or outputted from, the OAuth 2.0 endpoints.

* [Access Token](#access-token)
* [ID Token](#id-token)

### Access Token

An access token is a JSON web token (JWT) encoded in base64URL format that contains [a header](#jwt-header), [payload](#jwt-payload), and [signature](#jwt-signature). A resource server can authorize the client to access particular resources based on the [scopes and claims](#scopes-and-claims) in the access token.

The lifetime of access token can be configured in the [Access Policies](#access-policies). If the client that
issued the token is deactivated, the token is immediately and permanently invalidated. Reactivating the
client does not make the token valid again.

#### JWT Header


~~~json
{
  "alg": "RS256",
  "kid": "45js03w0djwedsw"
}
~~~


#### JWT Payload


~~~json
{
  "ver": 1,
  "jti": "AT.0mP4JKAZX1iACIT4vbEDF7LpvDVjxypPMf0D7uX39RE",
  "iss": "https://{yourOktaDomain}.com/oauth2/0oacqf8qaJw56czJi0g4",
  "aud": "https://api.you-company.com",
  "sub": "00ujmkLgagxeRrAg20g3",
  "iat": 1467145094,
  "exp": 1467148694,
  "cid": "nmdP1fcyvdVO11AL7ECm",
  "uid": "00ujmkLgagxeRrAg20g3",
  "scp": [
    "openid",
    "email",
    "flights",
    "custom"
  ],
  "number_of_flights": 2,
  "flight_number": [
    "AX102",
    "CT508"
  ],
  "custom_claim": "CustomValue"
}
~~~


#### JWT Signature

This is a digital signature Okta generates using the public key identified by the `kid` property in the header section.

#### Access Token Scopes and Claims

Access tokens include reserved scopes and claims, and can optionally include custom scopes and claims.

Scopes are requested in the request parameter, and the Authorization Server uses the [Access Policies](#access-policies) to decide if they can be granted or not. If any of the requested scopes are rejected by the Access Policies, the request will be rejected.

Based on the granted scopes, claims are added into the access token returned from the request.

##### Reserved Scopes and Claims

Okta defines a number of reserved scopes and claims which can't be overridden.

* [Reserved scopes](#reserved-scopes)
* [Reserved claims in the header section](#reserved-claims-in-the-header-section)
* [Reserved claims in the payload section](#reserved-claims-in-the-payload-section)

###### Reserved scopes

Reserved scopes: `openid`, `profile`, `email`, `address`, `phone`, `offline_access`, and `groups` are available to ID tokens and
access tokens, using either the Okta Org Authorization Server or a Custom Authorization Server. For details, see [Scopes](#access-token-scopes-and-claims).
All of these scopes except `groups` and `offline_access` are defined in the OpenID Connect specification.

###### Reserved claims in the header section

The header only includes the following reserved claims:

| Property     | Description                                                                      | DataType     | Example    |
| :----------- | :------------------------------------------------------------------------------- | :----------- | :----------|
| alg          | Identifies the digital signature algorithm used. This is always be RS256.        | String       | "RS256"    |
| kid          | Identifies the `public-key` used to sign the `access_token`. The corresponding `public-key` can be found as a part of the [metadata](/docs/api/resources/oauth2.html#retrieve-authorization-server-metadata) `jwks_uri` value. | String       | "a5dfwef1a-0ead3f5223_w1e" |

###### Reserved claims in the payload section

The payload includes the following reserved claims:

|--------------+-------------------+----------------------------------------------------------------------------------+--------------|--------------------------|
| Property     |  Description                                                                      | DataType     | Example                  |
|--------------+---------+----------+----------------------------------------------------------------------------------+--------------|--------------------------|
| aud     | Identifies the audience(resource URI) that this access token is intended for. | String    | "http://api.example.com/api"     |
| cid     | Client ID of your application that requests the access token.  | String    | "6joRGIzNCaJfdCPzRjlh"     |
| exp     | The time the access token expires, represented in Unix time (seconds).   | Integer    | 1311280970     |
| iat     | The time the access token was issued, represented in Unix time (seconds).   | Integer    | 1311280970     |
| iss     | The Issuer Identifier of the response. This value will be the unique identifier for the Authorization Server instance.   | String    | "https://{yourOktaDomain}.com/oauth2/0oacqf8qaJw56czJi0g4"     |
| jti     | A unique identifier for this access token for debugging and revocation purposes.   | String    |  "AT.0mP4JKAZX1iACIT4vbEDF7LpvDVjxypPMf0D7uX39RE"  |
| scp     | Array of scopes that are granted to this access token.   | Array    | [ "openid", "custom" ]     |
| sub     | The subject. A name for the user or a unique identifier for the client.  | String    |  "john.doe@example.com"     |
| uid     | A unique identifier for the user. It will not be included in the access token if there is no user bound to it.  | String    |   "00uk1u7AsAk6dZL3z0g3"     |
| ver     | The semantic version of the access token.   |  Integer   |  1    |

##### Custom Scopes and Claims

The admin can configure custom scopes and claims, and a groups claim, for the Custom Authorization Server. The admin can also configure a groups claim for the Okta Org Authorization Server.

###### Custom scopes

If the request that generates the access token contains any custom scopes, those scopes will be part of the *scp* claim together with the scopes provided from the [OIDC specification](http://openid.net/specs/openid-connect-core-1_0.html). The form of these custom scopes must conform to the [OAuth 2.0 specification](https://tools.ietf.org/html/rfc6749#section-3.3).

> Scope names can contain the characters < (less than) or > (greater than), but not both characters.

###### Custom claims

Custom claims are associated with scopes. In general, if one of the associated scopes is granted to a token, the custom claim is added into it.
However, the specifics depend on which claims are requested, whether the request is to the Okta Org Authorization Server or a Custom Authorization Server, and some configuration choices.

####### Quick reference: which token has which claims?

Okta defines two types of reserved (non-custom) claims, [base](#base-claims-always-present) and [scope-dependent claims](#scope-dependent-claims-not-always-returned).
Base claims are always returned, and scope-dependent claims are returned depending on the scope requested.
Custom claims are configured in the Custom Authorization Server, and returned depending on whether it matches a scope in the request, and also depending on the token type, authorization server type, and the token and claim configuration set in the authorization server:

* Base claims are always returned in ID tokens and access tokens for both authorization server types (Okta Org Authorization Server or Custom Authorization Server).
* Scope-dependent claims are returned in tokens depending on the response type for either authorization server type. See [the second table in the Scope-Dependent Claims topic](#scope-dependent-claims-not-always-returned) for details.
* Custom claims require configuration in the Custom Authorization Server. You can specify that claims are to be returned in each token (ID or access) always, or only when requested. Assuming a claim matches a requested scope,
    it is returned to the ID token if there is no access token requested.

The full set of claims for requested scopes is available via the `/oauth2/v1/userinfo` endpoint. Call this endpoint using the access token.

####### Custom claim configuration

Define custom claims in [the Okta user interface](https://help.okta.com/en/prod/Content/Topics/Security/API_Access.htm?Highlight=custom%20claim) or using [the OAuth 2.0 API](/docs/api/resources/authz-servers#get-a-claim).

A custom claim can be configured in the following ways:

* Choose whether the claim is included in the ID token or the access token.
* Choose whether the claim is always included in a token, or only when the claim is specified.
* Define the scopes that this claim is included in: either any scope or a list of scopes that you define.
* Disable the claim. This is often used for testing.
* Define the claim value, using [Okta's Expression Language](/reference/okta_expression_language/) or a group filter.
    * Example of expressions: `"user.region"`, the value of the custom field `"region"` on the user's profile. You can create expressions to reference application groups.
    * Example of a set of Okta groups specified by `groupFilterType`: If the token recipient wanted to display a badge for all current customers, you could specify a `groupFilterType` that start with "Customer" (`STARTS_WITH=Customer`). See [`groupFilterType`](/docs/api/resources/oauth2.html#details-for-groupfiltertype) for details.
        Notice that you can use the group filter (`valueType` is `GROUP`) for Okta groups. For application groups, `valueType` must be `EXPRESSION`.

  The expression is evaluated at runtime, and if the evaluated result is null, that custom claim isn't added into the ID token or access token.
  The datatype of a claim depends on the type of value. The datatype is:
    * An array if the claim value is a group filter.
    * The same datatype as the evaluated result if the claim value is an expression.

>*Note:* For the custom claim with group filter, its value has a limit of 100. If more than 100 groups match the filter, then the request fails. Expect that this limit may change in the future.

### ID Token

OpenID Connect introduces an ID token
which is a JSON web token (JWT) that contains information about an authentication event
and claims about the authenticated user.

Clients can use any of the following sequences of operations to obtain an ID token:
* [Authorization code](/authentication-guide/implementing-authentication/auth-code) or [Authorization code with PKCE](/authentication-guide/implementing-authentication/auth-code-pkce) -- the client obtains an authorization code from the authorization server's `/authorize` endpoint and uses it to obtain an ID token and an access
token from the authorization server's `/token` endpoint.
* [Implicit flow](/authentication-guide/implementing-authentication/implicit) -- the client obtains an ID token and optionally an access token directly from the authorization server's `/authorize` endpoint.

Clients should always [validate ID tokens](/authentication-guide/tokens/validating-id-tokens) to ensure their integrity.

The ID tokens returned by the `/authorize` endpoint (implicit flow) or the `/token` endpoint (authorization code flow)
are identical, except that in the implicit flow, the `nonce` parameter is required (and hence must have been included
in the request), and the `at_hash` parameter is required if the response includes [an access token](#access-token) but prohibited if the
response does not include an access token.

The ID Token consists of three period-separated, base64URL-encoded JSON segments: [a header](#id-token-header), [the payload](#id-token-payload), and [the signature](#id-token-signature).

#### ID Token Header

~~~json
{
  "alg": "RS256",
  "kid": "45js03w0djwedsw"
}
~~~

#### ID Token Payload

~~~json
{
  "ver": 1,
  "sub": "00uid4BxXw6I6TV4m0g3",
  "iss": "https:{myOktaDomain.com}",
  "aud": "uAaunofWkaDJxukCFeBx",
  "iat": 1449624026,
  "exp": 1449627626,
  "amr": [
    "pwd"
  ],
  "jti": "ID.4eAWJOCMB3SX8XewDfVR",
  "auth_time": 1449624026,
  "at_hash": "cpqKfdQA5eH891Ff5oJr_Q",
  "name" :"John Doe",
  "nickname":"Jimmy",
  "preferred_username": "john.doe@example.com",
  "given_name":"John",
  "middle_name":"James",
  "family_name":"Doe",
  "profile":"https://profile.wordpress.com/john.doe",
  "zoneinfo":"America/Los_Angeles",
  "locale":"en-US",
  "updated_at":1311280970,
  "email":"john.doe@example.com",
  "email_verified":true,
  "address" : { "street_address": "123 Hollywood Blvd.",
      "locality": "Los Angeles",
      "region": "CA",
      "postal_code": "90210",
      "country": "US"
    },
  "phone_number":"+1 (425) 555-1212"
}
~~~

#### ID Token Signature

This is the digital signature that Okta signs, using the public key identified by the `kid` property in the header section.

#### ID Token Claims

The header and payload sections contain claims.

##### Claims in the header section

Claims in the header are always returned.

| ------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------| ------------- | -------------------------- |
| Property      | Description                                                                                                                                                                                                  | DataType      | Example                    |
|:--------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------|:---------------------------|
| alg           | Identifies the digital signature algorithm used. This is always be RS256.                                                                                                                                    | String        | "RS256"                    |
| kid           | Identifies the public key used to verify the ID token. The corresponding public key can be found as a part of the   [well-known configuration's](/#well-knownopenid-configuration) `jwks_uri` value.           | String        | "a5dfwef1a-0ead3f5223_w1e" |

##### Claims in the payload section

Claims in the payload are either base claims, independent of scope (always returned), or dependent on scope (not always returned).

###### Base claims (always present)

| ------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------   | --------- | --------------------------------------------------- |
| Property      | Description                                                                                                                                                                | DataType  | Example                                             |
|:--------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:----------|:----------------------------------------------------|
| amr           | JSON array of strings that are identifiers for     [authentication methods](http://self-issued.info/docs/draft-jones-oauth-amr-values-00.html) used in the authentication.     | Array     | [ "pwd", "mfa", "otp", "kba", "sms", "swk", "hwk" ] |
| aud           | Identifies the audience that this ID token is intended for. It must be one of the OAuth 2.0 client IDs of your application.                                                | String    | "6joRGIzNCaJfdCPzRjlh"                              |
| auth_time     | The time the end user was authenticated, represented in Unix time (seconds).                                                                                               | Integer   | 1311280970                                          |
| exp           | The time the ID token expires, represented in Unix time (seconds).                                                                                                         | Integer   | 1311280970                                          |
| iat           | The time the ID token was issued, represented in Unix time (seconds).                                                                                                      | Integer   | 1311280970                                          |
| idp           | The id of the Identity Provider that the user authenticated to Okta with. (Used for Social Auth and Inbound SAML). If the IdP is an Okta org, the value is the Okta OrgId.           | String    | "00ok1u7AsAkrwdZL3z0g3"                             |
| iss           | The Issuer Identifier of the response.                                                                                                                                     | String    | "https://{yourOktaDomain}.com"                         |
| jti           | A unique identifier for this ID token for debugging and revocation purposes.                                                                                               | String    | "Tlenfse93dgkaksginv"                               |
| sub           | The subject. A unique identifier for the user.                                                                                                                             | String    | "00uk1u7AsAk6dZL3z0g3"                              |
| ver           | The semantic version of the ID Token.                                                                                                                                      | Integer   | 1                                                   |

###### Scope-dependent claims (not always returned)

| ------------------ | ----------------- | --------------------------------------------------------------------------------                                                                                                                                                   | -------------  | --------------------------                                                                                                      |
| Property           | Required Scope    | Description                                                                                                                                                                                                                        | DataType       | Example                                                                                                                         |
|:-------------------|:------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:---------------|:--------------------------------------------------------------------------------------------------------------------------------|:--|
| family_name        | profile           | Surname(s) or last name(s) of the user. Note that in some cultures, people can have multiple family names or no family name; all can be present, with the names being separated by space characters.                               | String         | "Doe"                                                                                                                           |
| given_name         | profile           | Given name(s) or first name(s) of the user. Note that in some cultures, people can have multiple given names; all can be present, with the names being separated by space characters.                                              | String         | "John"                                                                                                                          |
| locale             | profile           | Language and   [ISO 3166‑1](http://www.iso.org/iso/country_codes) country code in uppercase, separated by a dash.                                                                                                                     | String         | "en-US"                                                                                                                         |
| middle_name        | profile           | Middle name(s) of the user. Note that in some cultures, people can have multiple middle names; all can be present, with the names being separated by space characters. Also note that in some cultures, middle names are not used. | String         | "James"                                                                                                                         |
| name               | profile           | User's full name in displayable form including all name parts, possibly including titles and suffixes, ordered according to the user's locale and preferences.                                                         | String         | "John Doe"                                                                                                                      |
| nickname           | profile           | Casual name of the user that may or may not be the same as the given_name.                                                                                                                                                         | String         | "Jimmy"                                                                                                                         |
| preferred_username | profile           | The chosen login (username) for the end user. By default this is the Okta username.                                                                                                                                                | String         | "john.doe@example.com"                                                                                                          |
| preferred_username | profile           | The Okta login (username) for the end user.                                                                                                                                                                                        | String         | "john.doe@example.com"                                                                                                          |
| profile            | profile           | URL of the user's profile page.                                                                                                                                                                                              | String         | "https://profile.wordpress.com/john.doe"                                                                                         |
| zoneinfo           | profile           | String representing the user's time zone.                                                                                                                                                                                    | String         | "America/Los_Angeles"                                                                                                           |

Be aware of the following before you work with scope-dependent claims:

* To protect against arbitrarily large numbers of groups matching the group filter, the groups claim has a limit of 100.
If more than 100 groups match the filter, then the request fails. Expect that this limit may change in the future.
For more information about configuring an app for OpenID Connect, including group claims, see [OpenID Connect Wizard](https://help.okta.com/en/prod/Content/Topics/Apps/Apps_App_Integration_Wizard.htm).
* **Important:** Scope-dependent claims are returned differently depending on the values in `response_type` and the scopes requested:

    | Response Type             | Claims Returned in ID Token                                                                        | Claims Returned from the Userinfo Endpoint  |
    |:--------------------------|:---------------------------------------------------------------------------------------------------|:--------------------------------------------|
    | `code `                   | N/A                                                                                                | N/A                                         |
    | `token`                   | N/A                                                                                                | N/A                                         |
    | `id_token`                | Claims associated with requested scopes.                                                           | N/A                                         |
    | `id_token` `code `        | Claims associated with requested scopes.                                                           | N/A                                         |
    | `id_token` `token`        | `email` if email scope is requested; `name` and `preferred_username` if profile scope is requested | Claims associated with the requested scopes |
    | `code` `id_token` `token` | `email` if email scope is requested; `name` and `preferred_username` if profile scope is requested | Claims associated with the requested scopes |

* The full set of claims for the requested scopes is available via the [/oauth2/v1/userinfo](#userinfo) endpoint. Call this endpoint using the access token.

## Troubleshooting

If you run into trouble setting up an authorization server or performing other tasks for OAuth 2.0/OIDC, use the following suggestions to resolve your issues.

### Start with the System Log

The system log contains detailed information about why a request was denied and other useful information.

### Limits

* Scopes are unique per authorization server.

* The `audiences` value you specify is an array of String. If the string contains ":" it must be a valid URI.

* Tokens can expire, be explicitly revoked at the endpoint, or implicitly revoked by a change in configuration.

* Token revocation can be implicit in two ways: token expiration or a change to the source.
    * Expiration happens at different times:
        * ID Token expires after one hour.
        * Access Token expiration is configured in a policy, but is always between five minutes and one day.
        * Refresh Token expiration depends on two factors: 1) Expiration is configured in an Access Policy, no limits,
          but must be greater than or equal to the Access Token lifetime, and 2) Revocation if the Refresh Token
          isn't exercised within a specified time. Configure the specified time in an Access Policy, with a minimum of ten minutes.

    * Revocation happens when a configuration is changed or deleted:
        * User deactivation or deletion.
        * Configuration in the authorization server is changed or deleted.
        * The [client app](https://help.okta.com/en/prev/Content/Topics/Apps/Apps_App_Integration_Wizard.htm#OIDCWizard) is deactivated, changed, unassigned, or deleted.

### Subtle Behavior

Some behaviors aren't obvious:

* A user must be assigned to the client in Okta for the client to get Access Tokens from that client.
You can assign the client directly (direct user assignment) or indirectly (group assignment).

* If you haven't created a rule in a policy in the authorization server to allow the client, user, and
scope combination that you want, the request fails.
To resolve, create at least one rule in a policy in the authorization server for the relevant resource
that specifies client, user, and scope.

* OpenID Connect scopes are granted by default, so if you are requesting only those scopes ( `openid`, `profile`, `email`, `address`, `phone`, or `offline_access` ), you don't need to define any scopes for them, but you need a policy and rule
in a Custom Authorization Server. The rule grants the OpenID Connect scopes by default, so they don't need to be configured in the rule.
Token expiration times depend on how they are defined in the rules, and which policies and rules match the request.

* OpenID scopes can be requested with custom scopes. For example, a request can include `openid` and a custom scope.

* The evaluation of a policy always takes place during the initial authentication of the user (or of the client in case of client credentials flow). If the flow is not immediately finished, such as when a token is requested using `authorization_code` grant type, the policy is not evaluated again, and a change in the policy after the user or client is initially authenticated won't affect the continued flow.