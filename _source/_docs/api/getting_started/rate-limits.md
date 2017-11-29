---
layout: docs_page
title: Rate Limiting at Okta
weight: 3
redirect_from:
  - "/docs/getting_started/design_principles.html#rate-limiting"
excerpt: Understand rate limits at Okta and learn how to design for efficient use of resources
---

# Rate Limiting at Okta

The number of API requests for an organization is limited for all APIs in order to protect the service for all users.

Okta has two types of rate limits:  org-wide rate limits that vary by API
endpoint, and concurrent rate limits on the number of simultaneous transactions regardless of endpoint. These two types of limits are evaluated separately and reported in headers that are returned with each response.

## Org-Wide Rate Limits

API rate limits apply per minute or per second to the endpoints in an org.

If an org-wide rate limit is exceeded, an HTTP 429 Status Code is returned.
You can anticipate hitting the rate limit by checking [Okta's rate limiting headers](#check-your-rate-limits-with-oktas-rate-limit-headers).

When reading the following tables, remember that a more specific limit is considered separately from a more general limit on the same base URI. For example, when you are updating an application, the rate limit for creating or listing an application is not also applied.

### Okta API Endpoints and Per Minute Limits

| Action | Okta API Endpoint                                             | Per Minute Limit |
|:---------|:--------------------------------------------------------------|:-----------------------|
| Create or list applications | `/api/v1/apps`                                        |   100 |
| Get, update, or delete an application | `/api/v1/apps/{id}`                |   500 |
| Authenticate different end users | `/api/v1/authn`                             |   500 |
| Creating or listing groups | `/api/v1/groups`                                     |   500 |
| Get, update, or delete a group | `/api/v1/groups/{id}`                       | 1000 |
| Get log data | `/api/v1/logs`                                                              |     60 |
| Get session information | `/api/v1/sessions`                                    |   750 |
| Create or list users | `/api/v1/users`                                                 |   600 |
| Get a user | `/api/v1/users/{id}`                                                       |  2000 |
| Create, update, or delete a user | `/api/v1/users/{id}`                      |   600 |
| All actions | `/api/v1/`              |  1200 |

### Okta API Endpoints and Per-Second Limits
Two org-wide rate limits are on a per-second basis instead of per minute:

| Okta API Endpoint                           | Per Second Limit |
|:--------------------------------------------------------------------|-------:|
| Generate or refresh an OAuth 2.0 token | `/oauth2/v1/token`                            |      4 |
| All other OpenID Connect operations from Okta authentication server  `/oauth2/v1`   |    40 |
| Authenticate the same user | `/api/v1/authn/`           |      1 |

### Okta Home Page Endpoints and Per-Minute Limits

The following endpoints are used by the Okta home page for authentication and sign on, and have org-wide rate limits:

| Okta Home Page Endpoints                 | Per-Minute Limit |
|:-----------------------------------------|------:|
| `/app/{app}/{key}/sso/saml`              |   750 |
| `/app/office365/{key}/sso/wsfed/active`  |  2000 |
| `/app/office365/{key}/sso/wsfed/passive` |   250 |
| `/app/template_saml_2_0/{key}/sso/saml`  |  2500 |
| `/login/do-login`                        |   200 |
| `/login/login.htm`                       |   850 |
| `/login/sso_iwa_auth`                    |   500 |

### Okta Rate Limits for All Other Endpoints
Finally, for all  endpoints not listed in the tables above, the API rate limit is a combined 10,000 requests per minute. 

## Concurrent Rate Limits

Okta also enforces concurrent rate limits, which are distinct from [the org-wide, per-minute API rate limits](#org-wide-rate-limits).

For concurrent rate limits, traffic is measured in three different areas. Counts in one area aren't included in counts for the other two:

* For agent traffic, Okta has set the limit based on typical org usage. This limit varies from agent to agent.
* For Office365 traffic, the limit is 75 concurrent transactions per org.
* For all other traffic including API requests, the limit is 75 concurrent transactions per org.

Any request that would cause Okta to exceed the concurrent limit returns an HTTP 429 error, and the first error every 60 seconds is written to the log.
Reporting concurrent rate limits once a minute keeps log volume manageable. 

>Important: Operations rarely hit the concurrent rate limit: even very large bulk loads rarely use more than 10 threads at a time. If you hit concurrent rate limits, check the information in [Best Practices for Rate Limits](#best-practices-for-rate-limits) for solutions before requesting a rate limit increase.

## Check Your Rate Limits with Okta's Rate Limit Headers

Okta provides three headers in each response to report on both concurrent and org-wide rate limits. 

For org-wide rate limits, the three headers show the limit that is being enforced, when it resets, and how close you are to hitting the limit:
* `X-Rate-Limit-Limit` - the rate limit ceiling that is applicable for the current request.
* `X-Rate-Limit-Remaining` - the number of requests left for the current rate-limit window.
* `X-Rate-Limit-Reset` - the time at which the rate limit will reset, specified in UTC epoch time.

For example:

~~~ http
HTTP/1.1 200 OK
X-Rate-Limit-Limit: 20
X-Rate-Limit-Remaining: 15
X-Rate-Limit-Reset: 1366037820
~~~

The best way to be sure about org-wide rate limits is to check the relevant headers in the response. The System Log doesn't report every
API request. Rather, it typically reports completed or attempted real-world events such as configuration changes, user logins, or user lockouts.
The System Log doesn’t report the rate at which you’ve been calling the API.

Instead of the accumulated counts for time-based rate limits, when a request exceeds the limit for concurrent requests,
`X-Rate-Limit-Limit`, `X-Rate-Limit-Remaining`, and `X-Rate-Limit-Reset` report the concurrent values. 

The three headers behave a little differently for concurrent rate limits: when the number of unfinished requests is below the concurrent rate limit, request headers only report org-wide rate limits.
When you exceed a concurrent rate limit threshold, the headers report that the limit has been exceeded. When you drop back down below the concurrent rate limit, the headers  switch back to reporting the time-based rate limits.
Additionally, the `X-Rate-Limit-Reset` time for concurrent rate limits is only a suggestion. There's no guarantee that enough requests will complete to stop exceeding the concurrent rate limit at the time indicated.

### Example Rate Limit Header with Org-Wide Rate Limit  

This example shows the relevant portion of a rate limit header being returned with  for a request that hasn't exceeded the org-wide rate limit for the `/api/v1/users` endpoint:

~~~http
HTTP/1.1 200 
Date: Tue, 27 Sep 2017 21:33:25 GMT
X-Rate-Limit-Limit: 600
X-Rate-Limit-Remaining: 598
X-Rate-Limit-Reset: 1605463000
~~~

The following example show a rate limit header being returned for a request that has exceeded the rate limit for the `/api/v1/users` endpoint:

~~~http
HTTP/1.1 200 
Date: Tue, 27 Sep 2017 21:33:25 GMT
X-Rate-Limit-Limit: 600
X-Rate-Limit-Remaining: 0
X-Rate-Limit-Reset: 1605463723
~~~

### Example Rate Limit Header with Concurrent Rate Limit  

This example shows the relevant portion of a rate limit header being returned with the error for a request that exceeded the concurrent rate limit. If the rate limit wasn't being exceeded, the headers woul contain information about the org-wide rate limit. You won't ever see non-error concurrent rate limits in the headers.

~~~http
HTTP/1.1 429 
Date: Tue, 26 Sep 2017 21:33:25 GMT
X-Rate-Limit-Limit: 0
X-Rate-Limit-Remaining: 0
X-Rate-Limit-Reset: 1506461721
~~~

The first two header values are always `0` for concurrent rate limit errors.
The third header reports an estimated time interval when the concurrent rate limit may be resolved. It is not a guarantee.

The error condition resolves itself as soon as there is another concurrent thread available. No intervention is required.


### Example Error Response Events for Concurrent Rate Limit

~~~json
{
    "eventId": "tevEVgTHo-aQjOhd1OZ7QS3uQ1506395956000",
    "sessionId": "102oMlafQxwTUGJMLL8FhVNZA",
    "requestId": "reqIUuPHG7ZSEuHGUXBZxUXEw",
    "published": "2017-09-26T03:19:16.000Z",
    "action": {
      "message": "Too many concurrent requests in flight",
      "categories": [],
      "objectType": "core.concurrency.org.limit.violation",
      "requestUri": "/report/system_log"
    },
    "actors": [
      {
        "id": "00uo7fD8dXTeWU3g70g3",
        "displayName": "Test User",
        "login": "test-user@test.net",
        "objectType": "User"
      },
      {
        "id": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_0) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36",
        "displayName": "CHROME",
        "ipAddress": "127.0.0.1",
        "objectType": "Client"
      }
    ],
    "targets": []
  }
~~~

### Example Error Response in System Log API (Beta) for Concurrent Rate Limit

~~~json
{
        "actor": {
            "alternateId": "test.user@test.com",
            "detailEntry": null,
            "displayName": "Test User",
            "id": "00u1qqxig80SMWArY0g7",
            "type": "User"
        },
        "authenticationContext": {
            "authenticationProvider": null,
            "authenticationStep": 0,
            "credentialProvider": null,
            "credentialType": null,
            "externalSessionId": "trs2TSSLkgWR5iDuebwuH9Vsw",
            "interface": null,
            "issuer": null
        },
        "client": {
            "device": "Unknown",
            "geographicalContext": null,
            "id": null,
            "ipAddress": "4.15.16.10",
            "userAgent": {
                "browser": "UNKNOWN",
                "os": "Unknown",
                "rawUserAgent": "Apache-HttpClient/4.5.2 (Java/1.7.0_76)"
            },
            "zone": "null"
        },
        "debugContext": {
            "debugData": {
                "requestUri": "/api/v1/users"
            }
        },
        "displayMessage": "Too many requests in flight",
        "eventType": "core.concurrency.org.limit.violation",
        "legacyEventType": "core.concurrency.org.limit.violation",
        "outcome": null,
        "published": "2017-09-26T20:21:32.783Z",
        "request": {
            "ipChain": [
                {
                    "geographicalContext": null,
                    "ip": "4.15.16.10",
                    "source": null,
                    "version": "V4"
                },
                {
                    "geographicalContext": null,
                    "ip": "52.22.142.162",
                    "source": null,
                    "version": "V4"
                }
            ]
        },
        "securityContext": {
            "asNumber": null,
            "asOrg": null,
            "domain": null,
            "isProxy": null,
            "isp": null
        },
        "severity": "INFO",
        "target": null,
        "transaction": {
            "detail": {},
            "id": "Wcq2zDtj7xjvEu-gRMigPwAACYM",
            "type": "WEB"
        },
        "uuid": "dc7e2385-74ba-4b77-827f-fb84b37a4b3b",
        "version": "0"
    }
~~~

## Request Debugging

If you exceed rate limits, you can debug your requests to find out why.
The request ID is  present in every API response and can be used for debugging. This value can be used to correlate events from the [Events API](/docs/api/resources/events.html) as well as the System Log events.

The following header is set in each response:

`X-Okta-Request-Id` - The unique identifier for the API request

~~~ http
HTTP/1.1 200 OK
X-Okta-Request-Id: reqVy8wsvmBQN27h4soUE3ZEnA
~~~

## Best Practices for Rate Limits

You can avoid exceeding rate limits by following Okta's recommended best practices:

* [Data Import](#data-import)
* [Throttling](#throttling)
* [Normal API Usage](#normal-api-usage)
* [Caching](#caching)

### Data Import

When you are importing data or doing other bulk operations, follow these guidelines:

* Add records serially rather than asynchronously to avoid hitting concurrent rate limits.
* What else?
* What else?

### Throttling

Need content. Throttling requests?

### Normal API Usage

Need content

### Caching

Need content. 
