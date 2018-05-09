The authorization model in ASP.NET Core got a big overhaul with the introduction of policy-based authorization. Authorization now uses requirements and handlers, which are decoupled from your controllers and loosely coupled to your data models. The result is a more modular, more testable authorization framework that fits into the modern ASP.NET Core approach nicely.

It’s still possible to do the role-based authorization most ASP.NET devs are familiar with, but that’s only the tip of the iceberg! In this post, I’ll walk you through some of the awesome new features, and how you can combine them with Okta for powerful, scalable authorization!

_Just getting started with authentication in ASP.NET Core? Check out our [quick start documentation](/quickstart/#/okta-sign-in-page/dotnet/aspnetcore)!_

## Role-Based Authorization in ASP.NET Core

If you’re familiar with roles in ASP.NET 4.x, you’ll find that the new features start from a familiar place. Specifically, a user can have several roles and you define what roles are required to perform a certain action, or access to specific sections or resources, within your application. You can specify what roles are authorized to access to a specific resource by using the `[Authorize]` attribute. It can be declared in such a way that the authorization could be evaluated at controller level, action level, or even at a global level.

Let’s take [Slack](https://slack.com) as an example. (Slack is a real-time communication platform that was built to reinvent corporate communication. Our team is obsessed!) With Slack, users can chat, call share and send files, and also create and join both public and private channels.

Imagine you’re building a Slack clone for your company. You could have a `ChannelAdministrationController` to manage channels, which is restricted to users that have either a `WorkspaceAdministrator` or `ChannelAdministrator` role. Any other user that attempts to invoke any action of the controller will be unauthorized and the action will be not invoked.

```cs
[Authorize(Roles = "WorkspaceAdministrator, ChannelAdministrator")]
public class ChannelAdministrationController: Controller
{
}
```

This familiar syntax still works in ASP.NET Core, as I mentioned above. It was maintained by the ASP.NET Core team for backward compatibility, but the real improvement comes with the new policy-based model. If you’re ready to try the new hotness, it’s pretty easy to refactor your code and express your role requirement using the new model!

## Policy-Based Authorization in ASP.NET Core

The policy-based model consists of three main concepts: policies, requirements and handlers.

A policy is composed by one or more requirements
A requirement is a collection of data parameters used by the policy to evaluate the user Identity
A handler is the responsible of evaluating the properties of the requirements to determine if the user is authorized to access to a specific resource
Let’s talk about the policy-based model here for a moment. If you were to express the previous example in a policy-based format, you would follow these steps.

First, you have to register your policy in the `ConfigureServices()` method of the `Startup` class, as part of the authorization service configuration.

```cs
public void ConfigureServices(IServiceCollection services)
{
    services.AddMvc();

    services.AddAuthorization(options =>
    {
        options.AddPolicy("RequireElevatedRights", policy => policy.RequireRole("WorkspaceAdministrator", "ChannelAdministrator"));
    });
}
```

Then, instead of specifying roles in the `[Authorize]` attribute, specify the policy you want to assert:

```cs
[Authorize(Policy = "RequireElevatedRights")]
public class ChannelAdministrationController: Controller
{
}
```

And that’s all!

As you can see, the name of the policy is `RequireElevatedRights` and any user with either “WorkspaceAdministrator” or “ChannelAdministrator” role will be authorized to invoke any action of the `ChannelAdministrationController`. This accomplishes the same thing (requiring a particular role to access the controller’s actions), but now the configuration is decoupled from the controller itself.

You didn’t have to write any requirements or handlers, but the `RequireRole()` method uses them under the hood. If you’re curious, check out the [ASP.NET Core Security module source code](https://github.com/aspnet/Security) to see how this is implemented.

### Claims-Based Authorization via Policies
Role-based authorization in ASP.NET Core is simple, but limited. Imagine you want to validate a user based on other characteristics such as date of birth or employee number? Of course, creating a role for each of these possibilities is clearly not a solution.

ASP.NET Core bases the identity of a user on claims. A claim is a key-value pair which represents characteristics of a subject, such as, name, age, passport number, nationality, company, etc; and a subject can have multiple of these. A claim is issued by a trusted party and it tells you about who the subject is and not what a subject can do.

Referring back to the Slack example, let’s say there is a channel called Employees. You’d want this channel to be only accessible for those users that have an employee ID, and not accessible to guests or freelancers.

To do this, you’d have to register a new policy in the `ConfigureServices()` method of the `Startup` class, as part of the authorization service configuration:

```cs
public void ConfigureServices(IServiceCollection services)
{
  services.AddMvc();

  services.AddAuthorization(options =>
  {
      options.AddPolicy("EmployeesOnly", policy => policy.RequireClaim("EmployeeId"));
  });
}
```

In this case, the `EmployeesOnly` policy checks if the subject has an employee ID claim. You can restrict access to a controller by requiring this policy:

```cs
[Authorize(Policy = "EmployeesOnly")]
public class EmployeeChannelController : Controller
{
}
```

If you decide to refactor your code or infrastructure and need to update how the policy works “under the hood”, you can simply edit the policy definition instead of modifying each controller that uses the policy.

### Complex Authorization with Custom Policies

Now, you are ready to solve for even more complicated scenarios! If your authorization needs don’t fit into a simple role- or claims-based approach, you can build your own authorization requirements and handlers that work with the policy model.

Let’s suppose you have a Happy Hour channel for employees to discuss their favorite beers. You might want to require employees to be over 21 to access the channel due to the drinking laws in some countries.

Now, suppose you have a date of birth claim, you can use this info to define an “Over21Only” policy. To do this, you have to create a “MinimumAgeRequirement” and the handler with the logic to validate if the employee is meeting the minimum age requirement.

```cs
public class MinimumAgeRequirement: IAuthorizationRequirement
{
    public MinimumAgeRequirement(int age)
    {
        MinimumAge = age;
    }

    Public int MinimumAge { get; set; }
}
```

Any requirement must implement the empty marker `IAuthorizationRequirement` interface.
In the case of this requirement, the age has to be injected in the constructor.

The `MinimumAgeRequirement` class acts as a “model” for the requirement, but it does not actually contain the authorization logic. As I mention above, you’ll need a handler:

```cs
public class MinimumAgeRequirement: IAuthorizationRequirement
{
    public MinimumAgeRequirement(int age)
    {
        MinimumAge = age;
    }

    Public int MinimumAge { get; set; }
}
```

Any requirement must implement the empty marker `IAuthorizationRequirement` interface.
For this requirement, the age has to be injected in the constructor.

The requirement class acts as a “model” for the requirement, but it does not actually contain the authorization logic. For that, you’ll to create a handler and implement the `HandleRequirementAsync()` method.

```cs
public class MinimumAgeHandler : AuthorizationHandler<MinimumAgeRequirement>
{
    protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, MinimumAgeRequirement requirement)
    {
        if (!context.User.HasClaim(c => c.Type ==  ClaimTypes.DateOfBirth))
        {
            return Task.CompletedTask;
        }

        var dateOfBirth = Convert.ToDateTime(context.User.FindFirst(c => c.Type == ClaimTypes.DateOfBirth).Value);

        var userAge = DateTime.Today.Year - dateOfBirth.Year;

        if (dateOfBirth > DateTime.Today.AddYears(-userAge))
        {
            userAge--;
        }

        if (userAge >= requirement.MinimumAge)
        {
            context.Succeed(requirement);
        }
        return Task.CompletedTask;
    }
}
```

The logic here is easy to read, the only way to succeed and authorize an employee is by evaluating that they have an `DateOfBirth` claim and that it meets the minimum age required.

But you may ask, why didn’t it fail when it didn’t find the `DateOfBirth` claim? You may end up having multiple handlers for a requirement, and you’d want the requirement to succeed if any of the handlers succeeded.

For this reason, the typical pattern is to return from the handler without explicitly failing, unless you want to guarantee a failure regardless of any other handlers. Of course, if the handler succeeds, it should indicate success!

The next step is to register your policy in the Authorization service configuration in the ConfigureServices method of the Startup class.

Also, you have to register the handler to be injected later on by the framework:

```cs
public void ConfigureServices(IServiceCollection services)
{
  services.AddAuthorization(options =>
  {
      options.AddPolicy("Over21Only",
                        policy => policy.Requirements.Add(new MinimumAgeRequirement(21)));
  });

  // existing code above
    services.AddSingleton<IAuthorizationHandler, MinimumAgeHandler>();
}
```

Finally, you can add this policy in any action or resource that needs to be restricted by this requirement:

```cs
[Authorize(Policy = "EmployeesOnly")]
[Authorize(Policy = "Over21Only")]
public class HappyHourChannelController : Controller
{
}
```

This approach is better than the role-based approach because the security code is self-documented and you can rapidly check what a policy implies.

It’s also more flexible, as you can change easily what is the minimum age required because the logic is encapsulated in a single place. You can go further, and make a separated library with your company requirements and reuse it in all the applications of the company. Also, you can write your unit tests for your different handlers. Isn’t it awesome?!

Note: Check out the [unit tests written by the ASP.NET Core Team](https://github.com/aspnet/Security/tree/dev/test/Microsoft.AspNetCore.Authorization.Test).

## Authorization in ASP.NET Core with Okta

Now let's look at how easy it isuse Okta with the policy-based approach.

To easily get started, clone the [ASP.NET Core Example Repository](https://github.com/oktadeveloper/okta-aspnetcore-mvc-example) that already has the authentication piece built in.

```sh
git clone https://github.com/oktadeveloper/okta-aspnetcore-mvc-example.git
```

### Create an Okta Application

You’ll also need to set up your application in Okta. Start by creating a [forever-free developer account](https://developer.okta.com/signup/), or logging in if you already have one. Once you're at the dashboard in the Okta developer console, create an application with the following settings:

* Application type: Web
* Allowed grant types: Authorization Code
* Login redirect URI: `http://localhost:5000/authorization-code/callback`
* Logout redirect URI: `http://localhost:5000/signout-callback-oidc`

{% img blog/policy-based-authz-core/app-general-settings.png alt:"Application general settings tab" width:"800" %}{: .center-image }

Change the `appsettings.json` file in the cloned project to add your:

* Okta domain (https://dev-XXXXXX.oktapreview.com)
* Client ID for your application
* Client secret for your application
* API Token for your application

You can get your Okta domain from the developer dashboard on the top right corner.

{% img blog/policy-based-authz-core/okta-dashboard-org-url.png alt:"Your Okta Domain" width:"800" %}{: .center-image }

The client ID and secret you get from the application settings page.

{% img blog/policy-based-authz-core/app-client-credentials.png alt:"Application client credentials" width:"800" %}{: .center-image }

Finally, setup an API token, by hovering over the **API** menu item and chosing **Tokens** from the drop down menu. Then click the **Create Token** button and name it the same as your application name. Click the **Next** button and copy the token from the box and put it in your settings, then click *OK, got it** to finish.

> Note: You won't be able to retrieve this again but if you lose it, you can just create a new one and change it in your settings.

Run the app and if everything is set up okay, you should see the app running, be able to log in, and log out.

{% img blog/policy-based-authz-core/app-running-init.png alt:"Initial Application Running" width:"800" %}{: .center-image }


