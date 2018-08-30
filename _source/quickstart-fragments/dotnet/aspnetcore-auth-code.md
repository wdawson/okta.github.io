---
layout: quickstart_partial
exampleDescription: ASP.NET Core authorization code example
---

## Okta ASP.NET Core Quickstart

Now that your users can sign in, let's add authentication to your server.

> If you would prefer to download a complete sample application instead, please visit the [ASP.NET Core Examples GitHub](https://github.com/okta/samples-aspnetcore) and follow those instructions.

### Create a new project

If you don't already have an ASP.NET Core 2.0 project, create one using `dotnet new mvc` or the ASP.NET Core Web Application template in Visual Studio. Choose **No Authentication** as the authentication type.


### Configure the application in Okta

Sign in to your Okta developer account (or [create one](https://developer.okta.com/signup/)). Create or update an application in Okta with these settings:

* **Application type:** Web
* **Allowed grant types:** Authorization Code
* **Login redirect URI:** http://localhost:8080/authorization-code/callback
* **Logout redirect URI:** http://localhost:8080/signout-callback-oidc

If you are creating an Okta application from scratch, click **Done** to see the full settings page and make sure the settings match the values above.

Scroll to the bottom of the Okta application page to find the client ID and client secret. 

Use these values to replace the placeholders in the `appsettings.json` file:

```
"Okta": {
    "ClientId": "{ClientId}",
    "ClientSecret": "{ClientSecret}",
    "OktaDomain": "https://{yourOktaDomain}.com"
}
```

### Configure the middleware

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

Replace the `ConfigureServices` method with the code below, for more configuration options visit the [Okta ASP.NET middleware GitHub](https://github.com/okta/okta-aspnet).
```csharp
public void ConfigureServices(IServiceCollection services)
{
    var oktaMvcOptions = new OktaMvcOptions();
    Configuration.GetSection("Okta").Bind(oktaMvcOptions);
    oktaMvcOptions.Scope = new List<string> { "openid", "profile", "email" };
    oktaMvcOptions.GetClaimsFromUserInfoEndpoint = true;

    services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultSignInScheme = CookieAuthenticationDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = OktaDefaults.MvcAuthenticationScheme;
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

The [ASP.NET Core examples GitHub](https://github.com/okta/samples-aspnetcore) has more examples of authenticating and interacting with the user's information (claims).

If you want to do more with the user, you can use the [Okta .NET SDK](https://github.com/okta/okta-sdk-dotnet) to get or update the user's details stored in Okta.
