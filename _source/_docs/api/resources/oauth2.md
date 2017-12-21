---
layout: docs_page
title: OAuth 2.0
weight: 4
---
# OAuth 2.0 API

{% api_lifecycle ea %}

Okta is a standards-compliant [OAuth 2.0](http://oauth.net/documentation) authorization server and a certified [OpenID Connect Provider](http://openid.net/certification).

The OAuth 2.0 API provides API security via scoped access tokens, and OpenID Connect provides user authentication and an SSO layer which is lighter and easier to use than SAML.

To understand more about OAuth 2.0, OpenID Connect, and Okta:

Jakub.todo!

### Authorization Operations

Retrieve the information you need to obtain an authorization grant; obtain, validate, and revoke a token; or manage keys.

* [Obtain an Authorization Grant from a User](#obtain-an-authorization-grant-from-a-user)
* [Request a Token](#request-a-token)
* [Introspection Request](#introspection-request)
* [Revoke a Token](#revoke-a-token)
* [Get Keys](#get-keys)
* [Retrieve Authorization Server Metadata](#retrieve-authorization-server-metadata)
* [Retrieve OpenID Connect Metadata](#retrieve-authorization-server-openid-connect-metadata)

#### Obtain an Authorization Grant from a User
{:.api .api-operation}

{% api_operation get /oauth2/:authorizationServerId/v1/authorize %}

This is a starting point for OAuth 2.0 flows such as implicit and authorization code flows. This request authenticates the user and returns tokens along with an authorization grant to the client application as part of the response.

##### Request Parameters
{:.api .api-request .api-request-params}

| Parameter             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                              | Type  | DataType | Required | Default          |
|:----------------------|:---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:------|:---------|:---------|:-----------------|
|    [idp](idps.html)      | The Identity provider used to do the authentication. If omitted, use Okta as the identity provider.                                                                                                                                                                                                                                                                                                                                                      | Query | String   | FALSE    | Okta is the IDP. |
| sessionToken          | An Okta one-time session token. This allows an API-based user login flow (rather than Okta login UI). Session tokens can be obtained via the    [Authentication API](authn.html).                                                                                                                                                                                                                                                                           | Query | String   | FALSE    |                  |
| response_type         | Can be a combination of ``code``, ``token``, and ``id_token``. The chosen combination determines which flow is used; see this reference from the    [OAuth 2.0 specification](https://tools.ietf.org/html/rfc6749#section-3.1.1). The code response type returns an authorization code which can be later exchanged for an Access Token or a Refresh Token.                                                                                                 | Query | String   | TRUE     |                  |
| client_id             | Obtained during either    UI client registration or    [API client registration](oauth-clients.html). It is the identifier for the client and it must match what has been registered in Okta during client registration.                                                                                                                                                                                                                                       | Query | String   | TRUE     |                  |
| redirect_uri          | Specifies the callback location where the authorization code should be sent and it must match what has been registered in Okta during client registration.                                                                                                                                                                                                                                                                                               | Query | String   | TRUE     |                  |
| display               | Specifies how to display the authentication and consent UI. Valid values: ``page`` or ``popup``.                                                                                                                                                                                                                                                                                                                                                         | Query | String   | FALSE    |                  |
| max_age               | Specifies the allowable elapsed time, in seconds, since the last time the end user was actively authenticated by Okta.                                                                                                                                                                                                                                                                                                                                   | Query | String   | FALSE    |                  |
| response_mode         | Specifies how the authorization response should be returned.    [Valid values: ``fragment``, ``form_post``, ``query`` or ``okta_post_message``](#request-parameter-details). If ``id_token`` or ``token`` is specified as the *response_type*, then ``query`` isn&#8217;t allowed as a *response_mode*. Defaults to ``fragment`` in implicit and hybrid flows. Defaults to ``query`` in authorization code flow and cannot be set as ``okta_post_message``. | Query | String   | FALSE    | See Description. |
| scope                 | Can be a combination of reserved scopes and custom scopes. The combination determines the claims that are returned in the Access Token and ID Token. The ``openid`` scope has to be specified to get back an ID Token. If omitted, the default scopes configured in the Custom Authorization Server are used.                                                                                                                                            | Query | String   | TRUE     |                  |
| state                 | A client application provided state string that might be useful to the application upon receipt of the response. It can contain alphanumeric, comma, period, underscore and hyphen characters.                                                                                                                                                                                                                                                           | Query | String   | TRUE     |                  |
| prompt                | Can be either `none` or `login`. The value determines if Okta should not prompt for authentication (if needed), or force a prompt (even if the user had an existing session). Default: The default behavior is based on whether there&#8217;s an existing Okta session.                                                                                                                                                                              | Query | String   | FALSE    | See Description. |
| nonce                 | Specifies a nonce that is reflected back in the ID Token. It is used to mitigate replay attacks.                                                                                                                                                                                                                                                                                                                                                         | Query | String   | TRUE     |                  |
| code_challenge        | Specifies a challenge of    [PKCE](#request-parameter-details). The challenge is verified in the Token request.                                                                                                                                                                                                                                                                                                                                             | Query | String   | FALSE    |                  |
| code_challenge_method | Specifies the method that was used to derive the code challenge. Only S256 is supported.                                                                                                                                                                                                                                                                                                                                                                 | Query | String   | FALSE    |                  |
| login_hint            | A username to prepopulate if prompting for authentication.                                                                                                                                                                                                                                                                                                                                                                                               | Query | String   | FALSE    |                  |
| idp_scope             | A space delimited list of scopes to be provided to the Social Identity Provider when performing [Social Login](social_authentication.html). These scopes are used in addition to the scopes already configured on the Identity Provider.                                                                                                                                                                                                                 | Query | String   | FALSE    |                  |
| request | A JWT created by the client that enables requests to be passed as a single, self-contained parameter. | Query | JWT | FALSE    | See Description. |

##### Request Parameter Details

 * *idp*, *sessionToken* and *idp_scope* are Okta extensions to the [OIDC specification](http://openid.net/specs/openid-connect-core-1_0.html#Authentication).
    All other parameters comply with the [OIDC specification](http://openid.net/specs/openid-connect-core-1_0.html#Authentication) or [OAuth 2.0 specification](https://tools.ietf.org/html/rfc6749) and their behavior is consistent with the specification.
 * Each value for *response_mode* delivers different behavior:
    * ``fragment`` -- Parameters are encoded in the URL fragment added to the *redirect_uri* when redirecting back to the client.
    * ``query`` -- Parameters are encoded in the query string added to the *redirect_uri* when redirecting back to the client.
    * ``form_post`` -- Parameters are encoded as HTML form values that are auto-submitted in the User Agent.Thus, the values are transmitted via the HTTP POST method to the client
      and the result parameters are encoded in the body using the application/x-www-form-urlencoded format.
    * ``okta_post_message`` -- Uses [HTML5 Web Messaging](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) (for example, window.postMessage()) instead of the redirect for the authorization response from the authorization endpoint.
      ``okta_post_message`` is an adaptation of the [Web Message Response Mode](https://tools.ietf.org/html/draft-sakimura-oauth-wmrm-00#section-4.1).
      This value provides a secure way for a single-page application to perform a sign-in flow
      in a popup window or an iFrame and receive the ID token and/or access token back in the parent page without leaving the context of that page.
      The data model for the [postMessage](https://developer.mozilla.org/en-US/docs/Web/API/Window/postMessage) call is in the next section.
    * The `Referrer-Policy` header is automatically included in the request for `fragment` or `query`, and is set to `Referrer-Policy: no-referrer`.
 * Okta requires the OAuth 2.0 *state* parameter on all requests to the authorization endpoint in order to prevent cross-site request forgery (CSRF).
    The OAuth 2.0 specification [requires](https://tools.ietf.org/html/rfc6749#section-10.12) that clients protect their redirect URIs against CSRF by sending a value in the authorize request which binds the request to the user-agent&#8217;s authenticated state.
    Using the *state* parameter is also a countermeasure to several other known attacks as outlined in [OAuth 2.0 Threat Model and Security Considerations](https://tools.ietf.org/html/rfc6819).
 * [Proof Key for Code Exchange](https://tools.ietf.org/html/rfc7636) (PKCE) is a stronger mechanism for binding the authorization code to the client than just a client secret, and prevents [a code interception attack](https://tools.ietf.org/html/rfc7636#section-1) if both the code and the client credentials are intercepted (which can happen on mobile/native devices). The PKCE-enabled client creates a large random string as *code_verifier* and derives *code_challenge* from it using the method specified in *code_challenge_method*.
    Then the client passes the *code_challenge* and *code_challenge_method* in the authorization request for code flow. When a client tries to redeem the code, it must pass the *code_verifier*. Okta recomputes the challenge and returns the requested token only if it matches the *code_challenge* in the original authorization request. When a client, whose *token_endpoint_auth_method* is ``none``, makes a code flow authorization request, *code_challenge* is required.
    Since *code_challenge_method* only supports S256, this means that the value for *code_challenge* must be: `BASE64URL-ENCODE(SHA256(ASCII(*code_verifier*)))`. According to the [PKCE spec](https://tools.ietf.org/html/rfc7636), the *code_verifier* must be at least 43 characters and no more than 128 characters.
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

 * {% api_lifecycle beta %} A consent dialog is displayed depending on the values of three elements:
     * `prompt`, a query parameter used in requests to [`/oauth2/:authorizationServerId/v1/authorize`](/docs/api/resources/oauth2.html#obtain-an-authorization-grant-from-a-user)(Custom Authorization Server) or [`/oauth2/v1/authorize`](/docs/api/resources/oidc.html#authentication-request) (Okta Authorization Server)
     * `consent_method`, a property on [apps](/docs/api/resources/apps.html#settings-7)
     * `consent`, a property on [scopes](/docs/api/resources/oauth2.html#scopes-properties)

     | `prompt` Value    | `consent_method`                 | `consent`                   | Result       |
     |:------------------|:---------------------------------|:----------------------------|:-------------|
     | `CONSENT`         | `TRUSTED` or `REQUIRED`          | `REQUIRED`                  | Prompted     |
     | `CONSENT`         | `TRUSTED`                        | `IMPLICIT`                  | Not prompted |
     | `NONE`            | `TRUSTED`                        | `REQUIRED` or `IMPLICIT`    | Not prompted |
     | `NONE`            | `REQUIRED`                       | `REQUIRED`                  | Prompted     |
     | `NONE`            | `REQUIRED`                       | `IMPLICIT`                  | Not prompted | <!--If you change this, change the table in /oauth2.md too. Add 'LOGIN' to first three rows when supported -->

 > {% api_lifecycle beta %} Note: Apps created on `/api/v1/apps` default to `consent_method=TRUSTED`, while those created on `/api/v1/clients` default to `consent_method=REQUIRED`.

##### postMessage() Data Model

Use the postMessage() data model to help you when working with the *okta_post_message* value of the *response_mode* request parameter.

*message*:

Parameter         | Description                                                                                        | DataType  |
----------------- | -------------------------------------------------------------------------------------------------- | ----------|
id_token          | The ID Token JWT contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the `response_type` includes `id_token`. | String   |
access_token      | The *access_token* used to access `/oauth2/:authorizationServerId/v1/userinfo`. This is returned if the *response_type* included a token. <b>Important</b>: Unlike the ID Token JWT, the *access_token* structure is specific to Okta, and is subject to change. | String    |
state             | If the request contained a `state` parameter, then the same unmodified value is returned back in the response. | String    |
error             | The error-code string providing information if anything goes wrong.                                | String    |
error_description | Additional description of the error.                                                               | String    |

*targetOrigin*:

Specifies what the origin of *parentWindow* must be in order for the postMessage() event to be dispatched
(this is enforced by the browser). The *okta-post-message* response mode always uses the origin from the *redirect_uri*
specified by the client. This is crucial to prevent the sensitive token data from being exposed to a malicious site.

##### Response Parameters
{:.api .api-response .api-response-params}

The response depends on the response mode passed to the API. For example, a *fragment* response mode returns values in the fragment portion of a redirect to the specified *redirect_uri* while a *form_post* response mode POSTs the return values to the redirect URI.
Irrespective of the response mode, the contents of the response contains some of the following.

Parameter         | Description                                                                                        | DataType  |
----------------- | -------------------------------------------------------------------------------------------------- | ----------|
id_token          | The ID Token JWT contains the details of the authentication event and the claims corresponding to the requested scopes. This is returned if the *response_type* includes *id_token*.| String    |
access_token      | The *access_token* that is used to access the resource. This is returned if the *response_type* included a token. | String  |
token_type        | The token type is always `Bearer` and is returned only when *token* is specified as a *response_type*. | String |
code              | An opaque value that can be used to redeem tokens from [token endpoint](#request-a-token). The code has a lifetime of 60 seconds.| String    |
expires_in        | The number of seconds until the *access_token* expires. This is only returned if the response included an *access_token*. | String |
scope             | The scopes of the *access_token*. This is only returned if the response included an *access_token*. | String |
state             | The same unmodified value from the request is returned back in the response. | String |
error             | The error-code string providing information if anything went wrong. | String |
error_description | Further description of the error. | String |

##### Errors

These APIs are compliant with the OpenID Connect and OAuth 2.0 spec with some Okta specific extensions.

[OAuth 2.0 Spec error codes](https://tools.ietf.org/html/rfc6749#section-4.1.2.1)

| Error Id                  | Details                                                                                                                                                                                                          |
|:--------------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| unsupported_response_type | The specified response type is invalid or unsupported.                                                                                                                                                           |
| unsupported_response_mode | The specified response mode is invalid or unsupported. This error is also thrown for disallowed response modes. For example, if the query response mode is specified for a response type that includes id_token. |
| invalid_scope             | The scopes list contains an invalid or unsupported value.                                                                                                                                                        |
| server_error              | The server encountered an internal error.                                                                                                                                                                        |
| temporarily_unavailable   | The server is temporarily unavailable, but should be able to process the request at a later time.                                                                                                                |
| invalid_request           | The request is missing a necessary parameter or the parameter has an invalid value.                                                                                                                              |
| invalid_grant             | The specified grant is invalid, expired, revoked, or does not match the redirect URI used in the authorization request.                                                                                          |
| invalid_token             | The provided access token is invalid.                                                                                                                                                                            |
| invalid_client            | The specified client id is invalid.                                                                                                                                                                              |
| access_denied             | The server denied the request.                                                                                                                                                                                   |

[Open-ID Spec error codes](http://openid.net/specs/openid-connect-core-1_0.html#AuthError)

| Error Id           | Details                                                                                           |
|:-------------------|:--------------------------------------------------------------------------------------------------|
| login_required     | The request specified that no prompt should be shown but the user is currently not authenticated. |
| insufficient_scope | The access token provided does not contain the necessary scopes to access the resource.           |

##### Response Example (Success)
{:.api .api-response .api-response-example}

The request is made with a *fragment* response mode.

~~~
https://www.example.com/#
id_token=eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiIwMHVpZDRCeFh3Nkk2VFY0bTBnMyIsImVtYWlsIjoid2VibWFzdGVyQGNsb3VkaXR1ZG
UubmV0IiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInZlciI6MSwiaXNzIjoiaHR0cDovL3JhaW4ub2t0YTEuY29tOjE4MDIiLCJsb2dpbiI6ImFkbWluaXN
0cmF0b3IxQGNsb3VkaXR1ZGUubmV0IiwiYXVkIjoidUFhdW5vZldrYURKeHVrQ0ZlQngiLCJpYXQiOjE0NDk2MjQwMjYsImV4cCI6MTQ0OTYyNzYyNiwi
YW1yIjpbInB3ZCJdLCJqdGkiOiI0ZUFXSk9DTUIzU1g4WGV3RGZWUiIsImF1dGhfdGltZSI6MTQ0OTYyNDAyNiwiYXRfaGFzaCI6ImNwcUtmZFFBNWVIO
DkxRmY1b0pyX1EifQ.Btw6bUbZhRa89DsBb8KmL9rfhku--_mbNC2pgC8yu8obJnwO12nFBepui9KzbpJhGM91PqJwi_AylE6rp-ehamfnUAO4JL14Pke
mF45Pn3u_6KKwxJnxcWxLvMuuisnvIs7NScKpOAab6ayZU0VL8W6XAijQmnYTtMWQfSuaaR8rYOaWHrffh3OypvDdrQuYacbkT0csxdrayXfBG3UF5-ZA
lhfch1fhFT3yZFdWwzkSDc0BGygfiFyNhCezfyT454wbciSZgrA9ROeHkfPCaX7KCFO8GgQEkGRoQntFBNjluFhNLJIUkEFovEDlfuB4tv_M8BM75celd
y3jkpOurg
&access_token=eyJhbGciOiJSUzI1NiJ9.eyJ2ZXIiOjEsImlzcyI6Imh0dHA6Ly9yYWluLm9rdGExLmNvbToxODAyIiwiaWF0
IjoxNDQ5NjI0MDI2LCJleHAiOjE0NDk2Mjc2MjYsImp0aSI6IlVmU0lURzZCVVNfdHA3N21BTjJxIiwic2NvcGVzIjpbIm9wZW5pZCIsImVtYWlsIl0sI
mNsaWVudF9pZCI6InVBYXVub2ZXa2FESnh1a0NGZUJ4IiwidXNlcl9pZCI6IjAwdWlkNEJ4WHc2STZUVjRtMGczIn0.HaBu5oQxdVCIvea88HPgr2O5ev
qZlCT4UXH4UKhJnZ5px-ArNRqwhxXWhHJisslswjPpMkx1IgrudQIjzGYbtLFjrrg2ueiU5-YfmKuJuD6O2yPWGTsV7X6i7ABT6P-t8PRz_RNbk-U1GXW
IEkNnEWbPqYDAm_Ofh7iW0Y8WDA5ez1jbtMvd-oXMvJLctRiACrTMLJQ2e5HkbUFxgXQ_rFPNHJbNSUBDLqdi2rg_ND64DLRlXRY7hupNsvWGo0gF4WEU
k8IZeaLjKw8UoIs-ETEwJlAMcvkhoVVOsN5dPAaEKvbyvPC1hUGXb4uuThlwdD3ECJrtwgKqLqcWonNtiw
&token_type=Bearer&expires_in=3600&scope=openid+email&state=myState
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}

The requested scope is invalid:

~~~
https://www.example.com/#error=invalid_scope&error_description=The+requested+scope+is+invalid%2C+unknown%2C+or+malformed
~~~

#### Request a Token
{:.api .api-operation}

{% api_operation post /oauth2/:authorizationServerId/v1/token %}

This API returns Access Tokens, ID Tokens, and Refresh Tokens, depending on the request parameters.

##### Request Parameters
{:.api .api-request .api-request-params}

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                                                                                              | Type   |
|:----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| grant_type            | Can be one of the following: `authorization_code`, `password`, `refresh_token`, or `client_credentials`. Determines the mechanism Okta uses to authorize the creation of the tokens.                                                                                                                                                     | String |
| code                  | Required if *grant_type* is `authorization_code`. The value is what was returned from the                      [authorization endpoint](#obtain-an-authorization-grant-from-a-user). The code has a lifetime of 60 seconds.                                                                                                                                                                         | String |
| refresh_token         | Required if the *grant_type* is `refresh_token`. The value is what was returned from this endpoint via a previous invocation.                                                                                                                                                                                                            | String |
| username              | Required if the *grant_type* is `password`.                                                                                                                                                                                                                                                                                              | String |
| password              | Required if the *grant_type* is `password`.                                                                                                                                                                                                                                                                                              | String |
| scope                 | Optional.                 [ Different scopes and tokens](#response-parameters) are returned depending on the values of `scope` and `grant_type`.                                                                                                                                                                                                          | String |
| redirect_uri          | Required if *grant_type* is `authorization_code`. Specifies the callback location where the authorization was sent. This value must match the `redirect_uri` used to generate the original `authorization_code`.                                                                                                                         | String |
| code_verifier         | Required if *grant_type* is `authorization_code`  and `code_challenge` was specified in the original `/authorize` request. This value is the `code_verifier` for                      [PKCE](#request-parameter-details). Okta uses it to recompute the `code_challenge` and verify if it matches the original `code_challenge` in the authorization request. | String |
| client_id             | Required if client has a secret and client credentials are not provided in the Authorization header. This is used in conjunction with `client_secret` to authenticate the client application.                                                                                                                                            | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn&#8217;t specified. This client secret is used in conjunction with `client_id` to authenticate the client application.                                                                        | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.    [JWT Details](#token-authentication-methods)                                                                                                                                                                                     | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the    [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.                                                                                  | String |

{% api_lifecycle beta %} Note: Use the grant type `password` with scopes that require consent only if [the `consent_method`](/docs/api/resources/apps.html#settings-7) for the client is `TRUSTED`.
Requests for scopes that require consent using the `password` grant type receive a `consent_required` error response if `consent_method` is `REQUIRED`.

##### Refresh Tokens for Web and Native Applications

For web and native application types, an additional process is required:

1. Use the Okta Administration UI and check the **Refresh Token** checkbox under **Allowed Grant Types** on the client application page.
2. Pass the `offline_access` scope to your `/authorize` or `/token` request if you&#8217;re using the `password` grant type.

##### Token Authentication Methods
<!--If you change this section, change the section in oidc.md as well -->

If you authenticate a client with client credentials, provide the [`client_id` and `client_secret`](#request-parameters-1)
using either of the following methods:

* Provide  the `client_id` and `client_secret` in an Authorization header in the Basic auth scheme (`client_secret_basic`). For authentication with Basic auth, an HTTP header with the following format must be provided with the POST request:
  ~~~sh
  Authorization: Basic ${Base64(<client_id>:<client_secret>)}
  ~~~
* Provide `client_id` and `client_secret` as additional parameters to the POST body (`client_secret_post`)
* Provide `client_id` in a JWT that you sign with the `client_secret` using HMAC algorithms HS256, HS384, or HS512. Specify the JWT in `client_assertion` and the type, `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`, in `client_assertion_type` in the request.

Use only one of these methods in a single request or an error will occur.

>If the value returned by `token_endpoint_auth_method` in the [Dynamic Client Registration API](/docs/api/resources/oauth-clients.html#update-client-application) is not what you wish to use, you can change the value of a client app&#8217;s `token_endpoint_auth_method` with any of the values returned by `token_endpoint_auth_methods_support` (`client_secret_post`, `client_secret_basic`, or `client_secret_jwt`).

You can&#8217;t change this value in the Okta user interface.

##### Token Claims for Client Authentication with Client Secret JWT

If you use a JWT for client authentication (`client_secret_jwt`), use the following token claims:

| Token Claim | Description                                                                          | Type   |
|:------------|:-------------------------------------------------------------------------------------|:-------|
| exp         | Required. The expiration time of the token in seconds since January 1, 1970 UTC.     | Long   |
| iat         | Optional. The issuing time of the token in seconds since January 1, 1970 UTC.        | Long   |
| sub         | Required. The subject of the token. This value must be the same as the `client_id`.  | String |
| aud         | Required. The full URL of the endpoint you&#8217;re using the JWT to authenticate to.| String |
| iss         | Required. The issuer of the token. This value must be the same as the `client_id`.   | String |
| jti         | Optional. The identifier of the token.                                               | String |

Parameter Details

* If `jti` is specified, the token can only be used once. So, for example, subsequent token requests won&#8217;t succeed.
* The `exp` claim will fail the request if the expiration time is more than one hour in the future or has already expired.
* If `iat` is specified, then it must be a time before the request is received.


##### Response Parameters
{:.api .api-response .api-response-params}

Based on the grant type and in some cases scope specified in the request, the response contains different token sets.
Generally speaking, the scopes specified in a request are included in the Access Tokens in the response.

| Requested grant type | Requested scope                                                            | Tokens in the response                                                                   |
|:---------------------|:---------------------------------------------------------------------------|:-----------------------------------------------------------------------------------------|
| authorization_code   | None                                                                       | Access Token. Contains scopes requested in the `/authorize` endpoint.                    |
| authorization_code   | Any or no scopes plus `offline_access`                                     | Access Token, Refresh Token                                                              |
| authorization_code   | Any or no scopes plus `openid`                                             | Access Token, ID Token                                                                   |
| authorization_code   | Any or no scopes plus `openid` and `offline_access`                        | Access Token, ID Token, Refresh Token                                                    |
| refresh_token        | None                                                                       | Access Token, Refresh Token. Contains scopes used to generate the Refresh Token.         |
| refresh_token        | Subset of scopes used to generate Refresh Token excluding `offline_access` | Access Token. Contains specified scopes.                                                 |
| refresh_token        | Subset of scopes used to generate Refresh Token including `offline_access` | Access Token, Refresh Token                                                              |
| password             | None                                                                       | Access Token. Contains default scopes granted by policy.                                 |
| password             | Any or no scopes plus `offline_access`                                     | Access Token, Refresh Token. Contains specified scopes.                                  |
| password             | Any or no scopes plus `openid`                                             | Access Token, ID Token                                                                   |
| password             | Any or no scopes plus `openid` and `offline_access`                        | Access Token, ID Token, Refresh Token                                                    |
| client_credentials   | Any or no scope                                                            | Access Token. Contains default scopes granted by policy in addition to requested scopes. |

##### List of Errors

| Error Id               | Details                                                                                                                                                                                                    |
|:-----------------------|:-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client         | The specified client ID wasn&#8217;t found or authentication failed.                                                                                                                                       |
| invalid_request        | The request structure was invalid. E.g. the basic authentication header was malformed, or both header and form parameters were used for authentication or no authentication information was provided.      |
| invalid_grant          | The `code`, `refresh_token`, or `username` and `password` combination is invalid, or the `redirect_uri` does not match the one used in the authorization request, or the resource owner password is wrong. |
| unsupported_grant_type | The grant_type is not supported.                                                                                                                                                                           |
| invalid_scope          | The scopes list contains an invalid value.                                                                                                                                                                 |


##### Request Example: Resource Owner Password Credentials Flow
{:.api .api-request .api-request-example}

~~~sh
curl -X POST \
  "https://{yourOktaDomain}.com/oauth2/aus9s3ami4MRoqQR90h7/v1/token" \
  -H "Accept: application/json" \
  -H "Cache-Control: no-cache" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&username=dolores.abernathy%40${org}.com&
      password=<password>&scope=openid&client_id=<client_id>
      & client_secret=<client_secret>"
~~~

##### Response Example: Resource Owner Password Flow
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "access_token" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ2ZXIiOjEsImp0aSI6IkFULkpfUVlIMlJEckI5R
                      mxDd0hYVVI1WTIzcDg4U1JPS29jajJkd2kwZkhvTVEiLCJpc3MiOiJodHRwczovL3dlc3R3b3JsZC5
                      va3RhLmNvbS9vYXV0aDIvYXVzOXMzYW1pNE1Sb3FRUjkwaDciLCJhdWQiOiJodHRwczovL2hvc3Qud
                      2VzdHdvcmxkLmNvbSIsImlhdCI6MTQ5NDAyNjM1MywiZXhwIjoxNDk0MDMwMzM5LCJjaWQiOiJSMWt
                      yV1NobGZmdUhCbURPZHdZWiIsInVpZCI6IjAwdWFlM3VicDlBSVBTd0JSMGg3Iiwic2NwIjpbIm9wZ
                      W5pZCJdLCJzdWIiOiJkb2xvcmVzLmFiZXJuYXRoeUB3ZXN0d29ybGQuY29tIn0._tLmV0I4MIXCRaL
                      2D_M-TQuNM34GoIz1MeKJL_YPqXk",
    "token_type" : "Bearer",
    "expires_in" : 1800,
    "scope" : "openid",
    "id_token" : "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIwMHVhZTN1YnA5QUlQU3dCUjBoNyIsInZlc
                  iI6MSwiaXNzIjoiaHR0cHM6Ly93ZXN0d29ybGQub2t0YS5jb20vb2F1dGgyL2F1czlzM2FtaTRNUm9xUVI
                  5MGg3IiwiYXVkIjoiUjFrcldTaGxmZnVIQm1ET2R3WVoiLCJpYXQiOjE0OTQwMjYzNTMsImV4cCI6MTQ5N
                  DAzMDI0OSwianRpIjoiSUQuZXVsblJSXzFCWWJQRlZpaWEtYVQtUG4yMVM4R3VqeDJqc21xbGZwTVdvbyI
                  sImFtciI6WyJwd2QiXSwiaWRwIjoiMDBvODc0MGJzcGhNcEtEWGIwaDciLCJhdXRoX3RpbWUiOjE0OTQwM
                  jYzNTMsImF0X2hhc2giOiJmZnJRX25OeEpzME9oRDk3aF9XM0F3In0.dg9qhUlGO-1Gg5nnSAaZlBzYSgu
                  xuEHquhMP9oz8dHQ"
}
~~~

#### Response Example (Success)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
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

##### Response Example (Error)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 401 Unauthorized
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "error" : "invalid_client",
    "error_description" : "No client credentials found."
}
~~~

#### Introspection Request
{:.api .api-operation}

{% api_operation post /oauth2/*:authorizationServerId*/v1/introspect %}

The API takes an Access Token or Refresh Token, and returns a boolean indicating whether it is active or not.
If the token is active, additional data about the token is also returned. If the token is invalid, expired, or revoked, it is considered inactive.
An implicit client can only introspect its own tokens, while a confidential client may inspect all tokens.

>Note: ID Tokens are also valid, however, they are usually validated on the service provider or app side of a flow.

##### Request Parameters
{:.api .api-request .api-request-params}

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                       | Type   |
|:----------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| token                 | An Access Token or Refresh Token.                                                                                                                                                                                                                                 | String |
| token_type_hint       | A hint of the type of `token`. Valid values are `access_token`, `id_token` and `refresh_token`.                                                                                                                                                                   | Enum   |
| client_id             | Required if client has a secret and client credentials are not provided in the Authorization header. This is used in conjunction with `client_secret`  to authenticate the client application.                                                                    | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn&#8217;t specified. This client secret is used in conjunction with `client_id` to authenticate the client application. | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.    [JWT Details](#token-authentication-methods)                                                                                                              | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the    [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.           | String |

##### Response Parameters
{:.api .api-response .api-response-params}

Based on the type of token and whether it is active or not, the returned JSON contains a different set of information. Besides the claims in the token, the possible top-level members include:

| Parameter  | Description                                                                                                  | Type    |
|:-----------|:-------------------------------------------------------------------------------------------------------------|:--------|
| active     | Indicates whether the presented token is currently active.                                                   | Boolean |
| token_type | The type of the token. The value is always `Bearer`.                                                         | String  |
| scope      | A space-delimited list of scopes.                                                                            | String  |
| client_id  | The ID of the client associated with the token.                                                              | String  |
| username   | The username associated with the token.                                                                      | String  |
| exp        | The expiration time of the token in seconds since January 1, 1970 UTC.                                       | long    |
| iat        | The issuing time of the token in seconds since January 1, 1970 UTC.                                          | long    |
| nbf        | A timestamp in seconds since January 1, 1970 UTC when this token is not to be used before.                   | long    |
| sub        | The subject of the token.                                                                                    | String  |
| aud        | The audience of the token.                                                                                   | String  |
| iss        | The issuer of the token.                                                                                     | String  |
| jti        | The identifier of the token.                                                                                 | String  |
| device_id  | The ID of the device associated with the token                                                               | String  |
| uid        | The user ID. This parameter is returned only if the token is an access token and the subject is an end user. | String  |

For more information about token authentication, see [Token Authentication Methods](#token-authentication-methods).

##### List of Errors

| Error Id        | Details                                                                                                                                                                                               |
|:----------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client  | The specified client ID wasn&#8217;t found, or client authentication failed.                                                                                                                          |
| invalid_request | The request structure was invalid. E.g. the basic authentication header was malformed, or both header and form parameters were used for authentication or no authentication information was provided. |

##### Response Example (Success, Access Token)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "active" : true,
    "token_type" : "Bearer",
    "scope" : "openid email flights custom",
    "client_id" : "a9VpZDRCeFh3Nkk2VdYa",
    "username" : "john.doe@example.com",
    "exp" : 1451606400,
    "iat" : 1451602800,
    "sub" : "john.doe@example.com",
    "aud" : "https://api.example.com",
    "iss" : "https://{yourOktaDomain}.com/oauth2/orsmsg0aWLdnF3spV0g3",
    "jti" : "AT.7P4KlczBYVcWLkxduEuKeZfeiNYkZIC9uGJ28Cc-YaI",
    "uid" : "00uid4BxXw6I6TV4m0g3",
    "number_of_flights": 2,
    "flight_number": [
      "AX102",
      "CT508"
    ],
    "custom_claim": "CustomValue"
}
~~~

#### Response Example (Success, Refresh Token)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
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
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "active" : false
}
~~~

#### Response Example (Error)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 401 Unauthorized
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "error" : "invalid_client",
    "error_description" : "No client credentials found."
}
~~~

#### Revoke a Token
{:.api .api-operation}

{% api_operation post /oauth2/:authorizationServerId/v1/revoke %}

This API takes an Access Token or Refresh Token and revokes it. Revoked tokens are considered inactive at the introspection endpoint. A client can revoke only its own tokens.

##### Request Parameters
{:.api .api-request .api-request-params}

The following parameters can be posted as a part of the URL-encoded form values to the API.

| Parameter             | Description                                                                                                                                                                                                                                                       | Type   |
|:----------------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-------|
| token                 | An access token or refresh token.                                                                                                                                                                                                                                 | String |
| token_type_hint       | A hint of the type of `token`. Valid values are `access_token` and `refresh_token`.                                                                                                                                                                               | Enum   |
| client_id             | The client ID generated as a part of client registration. This is used in conjunction with the *client_secret* parameter to authenticate the client application.                                                                                                  | String |
| client_secret         | Required if the client has a secret and client credentials are not provided in the Authorization header, and if `client_assertion_type` isn&#8217;t specified. This client secret is used in conjunction with `client_id` to authenticate the client application. | String |
| client_assertion      | Required if the `client_assertion_type` is specified. Contains the JWT signed with the `client_secret`.    [JWT Details](#token-authentication-methods)                                                                                                              | String |
| client_assertion_type | Indicates a JWT is being used to authenticate the client. Per the    [Client Authentication spec](http://openid.net/specs/openid-connect-core-1_0.html#ClientAuthentication), the valid value is `urn:ietf:params:oauth:client-assertion-type:jwt-bearer`.           | String |

> Native applications should not provide -- and by default do not store -- `client_secret`
(see [Section 5.3.1 of the OAuth 2.0 spec](https://tools.ietf.org/html/rfc6819#section-5.3.1)).
They can omit `client_secret` from the above request parameters when revoking a token.

##### Response Parameters
{:.api .api-response .api-response-params}

A successful revocation is denoted by an empty response with an HTTP 200. Note that revoking an invalid expired, or revoked token is a success so information isn&#8217;t leaked.

A client may only revoke a token generated for that client.

For more information about token authentication, see [Token Authentication Methods](#token-authentication-methods).

##### List of Errors

| Error Id        | Details                                                                                                                                                                                               |
|:----------------|:------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| invalid_client  | The specified client id wasn&#8217;t found or client authentication failed.                                                                                                                           |
| invalid_request | The request structure was invalid. E.g. the basic authentication header was malformed, or both header and form parameters were used for authentication or no authentication information was provided. |


##### Response Example (Success)
{:.api .api-response .api-response-example}

~~~http
HTTP/1.1 200 OK
~~~

##### Response Example (Error)
{:.api .api-response .api-response-example}
~~~http
HTTP/1.1 401 Unauthorized
Content-Type: application/json;charset=UTF-8
~~~
~~~json
{
    "error" : "invalid_client",
    "error_description" : "No client credentials found."
}
~~~

#### Logout Request
{:.api .api-operation}

{% api_operation get /oauth2/*:authorizationServerId*/v1/logout %}

The API takes an ID Token and logs the user out of Okta if the subject matches the current Okta session. A `post_logout_redirect_uri` may be specified to redirect the User after the logout has been performed. Otherwise, the user is redirected to the Okta login page.

Use this operation to log out a User by removing their Okta browser session.

##### Request Parameters

The following parameters can be posted as a part of the URL-encoded form values to the API.

Parameter                | Description                                                                            | Type    | Required  |
-------------------------+----------------------------------------------------------------------------------------+---------+-----------|
id_token_hint            | A valid ID token with a subject matching the current session. | String | TRUE |
post_logout_redirect_uri | Callback location to redirect to after the logout has been performed. It must match the value preregistered in Okta during client registration. | String | FALSE |
state      | If the request contained a `state` parameter, then the same unmodified value is returned back in the response. | String | FALSE |

##### Request Examples

This request initiates a logout and will redirect to the Okta login page on success.

~~~sh
curl -v -X GET \
"https://{yourOktaDomain}.com/oauth2/*:authorizationServerId*/v1/logout?
  id_token_hint=${id_token_hint}
~~~

This request initiates a logout; it redirects to the `post_logout_redirect_uri` on success.

~~~sh
curl -v -X GET \
"https://{yourOktaDomain}.com/oauth2/:authorizationServerId/v1/logout?
  id_token_hint=${id_token_hint}&
  post_logout_redirect_uri=${post_logout_redirect_uri}&
  state=${state}
~~~

#### Get Keys
{:.api .api-operation}

{% api_operation get /oauth2/:authorizationServerId/v1/keys %}

Retrieve the public keys Okta uses to sign the tokens.

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

>Okta strongly recommends retrieving keys dynamically with the JWKS published in the discovery document.
It is safe to cache keys for performance.


Any of the keys listed are used to sign tokens. The order of keys in the result doesn&#8217;t indicate which keys are used.

Standard open-source libraries are available for every major language to perform [JWS](https://tools.ietf.org/html/rfc7515) signature validation.



#### Retrieve Authorization Server OpenID Connect Metadata
{:.api .api-operation}

{% api_operation get /oauth2/*:authorizationServerId*/.well-known/openid-configuration %}

This API endpoint returns OpenID Connect metadata that can be used by clients to programmatically configure their interactions with Okta.

> Note: Custom scopes and claims aren&#8217;t returned. To see your Custom Authorization Server&#8217;s custom scopes, use the [Get All Scopes API](#get-all-scopes), and to see its custom claims use [Get All Claims API](#get-all-claims).

This API doesn&#8217;t require any authentication and returns a JSON object with the following structure.

~~~json
{
    "issuer": "https://{yourOktaDomain}.com",
    "authorization_endpoint": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/authorize",
    "token_endpoint": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/token",
    "userinfo_endpoint": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/userinfo",
    "registration_endpoint": "https://{yourOktaDomain}.com/oauth2/v1/clients",
    "jwks_uri": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/keys",
    "response_types_supported": [
        "code",
        "id_token",
        "code id_token",
        "code token",
        "id_token token",
        "code id_token token"
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
    "code_challenge_methods_supported": [
        "S256"
    ],
    "introspection_endpoint": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/introspect",
    "introspection_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "none"
    ],
    "revocation_endpoint": "https://{yourOktaDomain}.com/oauth2/{authorizationServerId}/v1/revoke",
    "revocation_endpoint_auth_methods_supported": [
        "client_secret_basic",
        "client_secret_post",
        "client_secret_jwt",
        "none"
    ]
}
~~~


## Troubleshooting for API Access Management

If you run into trouble setting up an authorization server or performing
other tasks for API Access Management, use the following suggestions to resolve your issues.

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
          isn&#8217;t exercised within a specified time. Configure the specified time in an Access Policy, with a minimum of ten minutes.

    * Revocation happens when a configuration is changed or deleted:
        * User deactivation or deletion.
        * Configuration in the authorization server is changed or deleted.
        * The [client app](https://help.okta.com/en/prev/Content/Topics/Apps/Apps_App_Integration_Wizard.htm#OIDCWizard) is deactivated, changed, unassigned, or deleted.

### Subtle Behavior

Some behaviors aren&#8217;t obvious:

* A user must be assigned to the client in Okta for the client to get Access Tokens from that client.
You can assign the client directly (direct user assignment) or indirectly (group assignment).

* If you haven&#8217;t created a rule in a policy in the authorization server to allow the client, user, and
scope combination that you want, the request fails.
To resolve, create at least one rule in a policy in the authorization server for the relevant resource
that specifies client, user, and scope.

* OpenID Connect scopes are granted by default, so if you are requesting only those scopes ( `openid`, `profile`, `email`, `address`, `phone`, or `offline_access` ), you don&#8217;t need to define any scopes for them, but you need a policy and rule
in a Custom Authorization Server. The rule grants the OpenID Connect scopes by default, so they don&#8217;t need to be configured in the rule.
Token expiration times depend on how they are defined in the rules, and which policies and rules match the request.

* OpenID scopes can be requested with custom scopes. For example, a request can include `openid` and a custom scope.

* The evaluation of a policy always takes place during the initial authentication of the user (or of the client in case of client credentials flow). If the flow is not immediately finished, such as when a token is requested using `authorization_code` grant type, the policy is not evaluated again, and a change in the policy after the user or client is initially authenticated won&#8217;t affect the continued flow.



