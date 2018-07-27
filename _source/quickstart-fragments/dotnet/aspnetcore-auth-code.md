---
layout: quickstart_partial
exampleDescription: ASP.NET Core 2.0 MVC authorization code example
---

## Okta ASP.NET Core MVC Quickstart

If you want a full, working example, head over to the [ASP.NET Core MVC example] repository.

### Create a new project

If you don't already have an ASP.NET Core 2.0 project, create one using `dotnet new mvc` or the ASP.NET Core Web Application template in Visual Studio. Choose **No Authentication** as the authentication type.

Install these packages in the new project:
* [Microsoft.AspNetCore.All] it includes all the dependencies you need (and more!). 
* [Okta.AspNetCore]

### Add a Startup class

Make sure you have these `using` statements at the top of your `Startup.cs` file:

```csharp
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Okta.AspNetCore;
```

Replace the `ConfigureServices` method with the following code block and configure it using the information from your Okta application:

```csharp
// This method gets called by the runtime. Use this method to add services to the container.
public void ConfigureServices(IServiceCollection services)
{
    var oktaMvcOptions = new OktaMvcOptions();
    Configuration.GetSection("Okta").Bind(oktaMvcOptions);

    services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = OpenIdConnectDefaults.AuthenticationScheme;
    })
    .AddCookie()
    .AddOktaMvc(oktaMvcOptions);

    services.AddMvc();
}
```

Then, in the `Configure` method, add this line **above** the `UseMvc` line:

```csharp
app.UseAuthentication();
```

### Additional middleware configuration

The `OktaMvcOptions` class configures the Okta middleware. You can see all the available options in the [project's GitHub].

### Secure your application

Use the `[Authorize]` attribute on controllers or actions to require a logged-in user:

```csharp
[Authorize]
public IActionResult Protected()
{
    // Only for logged-in users!
    return View();
}
```

Alternatively, you can create actions to log the user in (or out):

```csharp
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication.OpenIdConnect;
using Microsoft.AspNetCore.Mvc;

public class AccountController : Controller
{
    public IActionResult Login()
    {
        if (!HttpContext.User.Identity.IsAuthenticated)
        {
            return Challenge(OpenIdConnectDefaults.AuthenticationScheme);
        }

        return RedirectToAction("Index", "Home");
    }

    [HttpPost]
    public IActionResult Logout()
    {
        return new SignOutResult(new[] { OpenIdConnectDefaults.AuthenticationScheme, CookieAuthenticationDefaults.AuthenticationScheme });
    }
}
```

### Run the project

Start the project in Visual Studio, or with this command:

```bash
dotnet run
```

Open `http://localhost:8080` in a private or incognito window in your browser. Try navigating to a route that has the `[Authorize]` attribute, or to the `/Account/Login` action. You'll be redirected to the Okta Sign-In page.

### That's it!

ASP.NET Core automatically populates `HttpContext.User` with the information Okta sends back about the user. You can check whether the user is logged in with `User.Identity.IsAuthenticated` in your actions or views, and see all of the user's claims in `User.Claims`.


The [ASP.NET Core MVC example] has more examples of authenticating and interacting with the user's information (claims).

If you want to do more with the user, you can use the [Okta .NET SDK] to get or update the user's details stored in Okta.

[ASP.NET Core MVC example]: https://github.com/okta/samples-aspnetcore/okta-hosted-login
[project's GitHub]: https://github.com/okta/okta-aspnet/blob/master/README.md
[Okta .NET SDK]: https://github.com/okta/okta-sdk-dotnet
[Microsoft.AspNetCore.All]: https://www.nuget.org/packages/Microsoft.AspNetCore.All
[Okta.AspNetCore]: https://www.nuget.org/packages/Okta.AspNetCore
