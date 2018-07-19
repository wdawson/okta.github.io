---
layout: quickstart_partial
exampleDescription: ASP.NET 4.x Web API implicit example
---

## Okta ASP.NET 4.x Web API Quickstart

If you want a full, working example, head over to the [ASP.NET web API example](https://github.com/oktadeveloper/okta-aspnet-webapi-example) repository and follow the instructions in that readme.
// TODO: create/update the test project

### Create a new Web API project

If you don't already have a Web API project, create a new ASP.NET (.NET Framework) project and choose the Web API template. Choose **No Authentication**.

### Install required packages

First, install these packages with NuGet:

* [Okta.AspNet](https://nuget.org/packages/Okta.AspNet)
* [Microsot.Owin.Host.SystemWeb](https://www.nuget.org/packages/Microsoft.Owin.Host.SystemWeb) 4.0.0 or higher


### Configure the middleware

If you don't already have a `Startup.cs` file (OWIN Startup class), create one by right-clicking on your project and choosing **Add** - **Class**. Pick the **OWIN Startup** template and name the new class `Startup`.

Make sure you have these `using` statements at the top of your `Startup.cs` file:

```csharp
using Microsoft.Owin;
using Okta.AspNet;
using Owin;
using System.Configuration;
```

Add the following code to your `Configuration` method:

```csharp
public void Configuration(IAppBuilder app)
{
    app.UseOktaWebApi(new OktaWebApiOptions()
    {
        OktaDomain = ConfigurationManager.AppSettings["okta:OktaDomain"],
        ClientId = ConfigurationManager.AppSettings["okta:ClientId"]
    });
}
```

### Additional middleware configuration

The `OktaWebApiOptions` class configures the Okta middleware. You can see all the available options in the [project's GitHub](https://github.com/okta/okta-aspnet/blob/master/README.md).

### Configure the project

Open the `Web.config` file and add your Okta configuration to the `<appSettings>` section.
Check out the [project's GitHub](https://github.com/okta/okta-aspnet/blob/master/README.md) to see more details about this step.

### Protect application resources

Use the `[Authorize]` attribute on API controllers or actions to require an authenticated user. For example, create an `/api/messages` route in a new API controller that returns secret messages if a token is present:

```csharp
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Web.Http;

[Authorize]
public class MessagesController : ApiController
{
    [HttpGet]
    [Route("~/api/messages")]
    public IEnumerable<string> Get()
    {
        var principal = RequestContext.Principal.Identity as ClaimsIdentity;

        var login = principal.Claims
            .SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier)
            ?.Value;

        return new string[]
        {
            $"For {login ?? "your"} eyes only",
            "Your mission, should you choose to accept it..."
        };
    }
}
```

### That's it!

The Okta middleware automatically validates tokens and populates `HttpContext.User` with a limited set of user information.

If you want to do more with the user, you can use the [Okta .NET SDK](https://github.com/okta/okta-sdk-dotnet) to get or update the user's details stored in Okta.

> Note: If your client application is running on a different server (or port) than your ASP.NET Core server, you'll need to add [CORS middleware](https://docs.microsoft.com/en-us/aspnet/core/security/cors) to the pipeline as well.
