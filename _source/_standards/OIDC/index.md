---
layout: docs_page
title: OpenID Connect and Okta
excerpt: This simple identity layer on top of the OAuth 2.0 protocol makes identity management easier.
icon: /assets/img/icons/openid.svg
---

# OpenID Connect and Okta

OpenID Connect is a simple identity layer on top of the OAuth 2.0 protocol, which allows computing clients to verify the identity of an end user based on the authentication performed by an authorization server, as well as to obtain basic profile information about the end user in an interoperable manner.
In technical terms, OpenID Connect specifies a RESTful HTTP API, using JSON as a data format.

OpenID Connect allows a range of clients to request and receive information about authenticated sessions and end users, including
web-based clients, mobile apps, and JavaScript clients.
The [specification suite](http://openid.net/connect/) is extensible, supporting optional features such as encryption of identity data, discovery of OpenID Providers, and session management.

Okta is [certified for OpenID Connect](http://openid.net/certification/) for Basic, Implicit, Hybrid, and Publishing Configuration Information (Config OP).

## Authentication Basics with OAuth 2.0 and OpenID Connect

OAuth 2.0 is an authorization framework for delegated access to APIs, and OpenID Connect is an SSO protocol for authenticating end users and asserting their identity.
OpenID Connect extends OAuth 2.0:

* Provides a signed [*id_token*](#id-token) for the client and [a UserInfo endpoint](/docs/api/resources/oidc.html#openid-connect-discovery-document) from which you can retrieve user attributes.
* Provides access to the [Okta Authorization Server](#authorization-servers).
* Provides a standard set of scopes and claims for identities including profile, email, address, and phone.

{% img openID_overview.png alt:"OpenID Architecture Diagram" %}

Okta is the identity provider responsible for verifying the identity of users and applications that exist in an organization’s directory,
and issuing ID Tokens upon successful authentication of those users and applications.

The basic authentication flow with Okta as your identity provider:

1. The application sends a request to Okta.
2. Okta authenticates the client.
3. Okta authenticates the user.
4. Okta approves or denies the requested scopes.
5. Okta mints a token and sends it in the response.
6. The application validates the ID Token’s integrity. For more information, see [Validating ID Tokens](/docs/api/resources/oidc.html#validating-id-tokens).

> Important: Okta uses public key cryptography to sign tokens and verify that they are valid.
See the last section of [Validating ID Tokens](/docs/api/resources/oidc.html#validating-id-tokens) for more information on the necessary logic
you must have in your application to ensure it’s always updated with the latest keys.

## Authorization Servers

Okta provides two types of authorization servers:

* The Okta Authorization Server requires no configuration, and supports SSO use cases.
* The Custom Authorization Server is configurable. It supports the use of OpenID Connect with Okta's API Access Management,
an Okta feature that helps you secure access to your API.

## Dynamic Client Registration

Okta provides [dynamic client registration](/docs/api/resources/oauth-clients.html), operations to register and manage
client applications for use with Okta's OAuth 2.0 and OpenID Connect endpoints.
You can also perform these operations in the [Apps API](/docs/api/resources/apps.html).


## More Information

For more information about Okta and OpenID Connect, see:

* [Okta's API Access Management Introduction](/use_cases/api_security/)
* [API for OpenID Connect](/docs/api/resources/oidc.html)
