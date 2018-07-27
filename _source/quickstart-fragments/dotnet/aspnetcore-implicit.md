---
layout: quickstart_partial
exampleDescription: ASP.NET Core 2.0 API implicit example
---

## Okta ASP.NET Core Web API Quickstart

If you want a full, working example, head over to the [ASP.NET Core WEB API example] repository.

### Create a new project

If you don't already have an ASP.NET Core 2.0 project, create one using `dotnet new mvc` or the ASP.NET Core Web Application template in Visual Studio. Choose **No Authentication** if necessary.

Install these packages in the new project:
* [Microsoft.AspNetCore.All] it includes all the dependecies you need (and more!). 
* [Okta.AspNetCore]

### Configure the middleware

Make sure you have these `using` statements at the top of your `Startup.cs` file:

```csharp
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Okta.AspNetCore;
```

Replace the `ConfigureServices` method with the following code block and configure it using the information from your Okta application:

```csharp
public void ConfigureServices(IServiceCollection services)
{
    services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultSignInScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddOktaWebApi(new OktaWebApiOptions()
    {
        ClientId = Configuration["Okta:ClientId"],
        OktaDomain = Configuration["Okta:OktaDomain"],
    });

    services.AddMvc();
}
```

Then, in the `Configure` method, add this line **above** the `UseMvc` line:

```csharp
app.UseAuthentication();
```

### Protect application resources

Use the `[Authorize]` attribute on controllers or actions to require an authenticated user. For example, create an `/api/messages` route in a new controller that returns secret messages if a token is present:

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

[Produces("application/json")]
[Authorize]
public class MessagesController : Controller
{
    [HttpGet]
    [Route("~/api/messages")]
    public IEnumerable<dynamic> Get()
    {
        var principal = HttpContext.User.Identity as ClaimsIdentity;

        var login = principal.Claims
            .SingleOrDefault(c => c.Type == ClaimTypes.NameIdentifier)
            ?.Value;

        return new dynamic[]
        {
            new { Date = DateTime.Now, Text = "I am a Robot." },
            new { Date = DateTime.Now, Text = "Hello, world!" },
        };
    }
}
```

### That's it!

The Okta middleware automatically validates tokens and populates `HttpContext.User` with a limited set of user information.

If you want to do more with the user, you can use the [Okta .NET SDK] to get or update the user's details stored in Okta.

> Note: If your client application is running on a different server (or port) than your ASP.NET Core server, you'll need to add [CORS middleware](https://docs.microsoft.com/en-us/aspnet/core/security/cors) to the pipeline as well.


[ASP.NET Core WEB API example]: https://github.com/okta/samples-aspnetcore/resource-server
[Microsoft.AspNetCore.All]: https://www.nuget.org/packages/Microsoft.AspNetCore.All 
[Okta.AspNetCore]: https://www.nuget.org/packages/Okta.AspNetCore
[Okta .NET SDK]: https://github.com/okta/okta-sdk-dotnet