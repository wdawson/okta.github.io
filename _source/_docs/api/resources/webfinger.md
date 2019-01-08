---
layout: docs_page
title: Webfinger
---

# WebFinger API

The `webfinger` API allows you to query Okta regarding which IdP an individual user should be routed to, based on configured IdP routing policies.

## Querying Routing for a User 

{% api_operation post /.well-known/webfinger %}

Text description. Describe query options. Mention that there's no need for SSWS token.

##### Request Example
{:.api .api-request .api-request-example}

~~~sh
curl -v -X GET \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
"https://{yourOktaDomain}/.well-known/webfinger?q=bob@thebuilder.com"
~~~

##### Response Example
{:.api .api-response .api-response-example}

~~~json
sample JSON listing here of what the endpoint would return for bob the builder.
~~~

