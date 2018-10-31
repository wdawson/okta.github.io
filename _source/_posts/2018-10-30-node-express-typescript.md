---
layout: blog_post
title: "How to Use TypeScript to Build a Node.js API with Express"
author: reverentgeek
description: "This tutorial walks you through building a simple and secure Node.js application using TypeScript, Express, and Okta."
tags: [authentication, typescript, web, express, node]
tweets:
- "Can you build a Node.js application using TypeScript? @reverentgeek shows you how!"
- "A quick introduction to building a Node.js application using TypeScript"
- "Build a Node.js application using TypeScript and Express"
image: blog/node-express-typescript/node-express-typescript.jpg
---

As a Web developer, I long stopped resisting JavaScript, and have grown to appreciate its flexibility and ubiquity. Language features added to ES2015 and beyond have significantly improved its utility and reduced common frustrations of writing applications.

However, building JavaScript applications _at scale_ remains a challenge. Larger JavaScript projects demand tools such as ESLint to catch common mistakes, and greater discipline to saturate the code base with useful tests. As with any software project, a healthy team culture that includes a peer review process can improve quality and guard against issues that can creep into a project.

## The case for TypeScript

It appears more and more teams are turning to TypeScript to supplement their JavaScript projects. The primary goal of TypeScript is to catch more errors before they go into production and make it easier to work with your code base. 

TypeScript is not a different language. It's a flexible _superset_ of JavaScript with ways to describe optional data types. All "standard" and valid JavaScript is also valid TypeScript. You can dial in as much or little as you desire. 

As soon as you add the TypeScript compiler or a TypeScript plugin to your favorite code editor, there are immediate safety and productivity benefits. TypeScript can alert you to misspelled functions and properties, detect passing the wrong types of arguments or the wrong number of arguments to functions, and provide smarter autocomplete suggestions.

### TypeScript and Node.js

I give talks and write articles that help people learn Node.js. With higher frequency, people ask, "Can I use TypeScript with Node.js?"

Yes! TypeScript supports Node.js, and Node.js projects can benefit from its features.

This tutorial is designed to show you how to build a new Node.js application using TypeScript and Express.

## Guitar Inventory Web Application

Among guitar players, there's a joke everyone understands.

> Q: "How many guitars do you _need_?"

> A: "_n_ + 1. Always one more."

In this tutorial, you are going to create a new Node.js application to keep track of an inventory of guitars. Here is a list of technologies used in this example.

* [Node.js](https://nodejs.org)
* [TypeScript](https://www.typescriptlang.org/)
* [Express](https://expressjs.com/)
* [PostgreSQL](https://www.postgresql.org/)
* [EJS](https://github.com/mde/ejs)
* [Vue](https://vuejs.org/)
* [Materialize](https://materializecss.com/)
* [Axios](https://github.com/axios/axios)
* [Okta](https://www.npmjs.com/package/@okta/oidc-middleware)

## Create the Node.js project

Open up a terminal (Mac/Linux) or a command prompt (Windows) and type the following command:

```
node --version
```

If you get an error, or the version of Node.js you have is less than version 8, you'll need to install Node.js. On Mac or Linux, I recommend you first install [nvm](https://github.com/creationix/nvm) and use nvm to install Node.js. On Windows, I recommend you use [Chocolatey](https://chocolatey.org/).

After ensuring you have a recent version of Node.js installed, create a folder for your project.

```bash
mkdir guitar-inventory
cd guitar-inventory
```

Use `npm` to initialize a `package.json` file.

```bash
npm init -y
```

### Hello, world!

In this sample application, [Express](https://expressjs.com/) is used to serve web pages and implement an API. Dependencies are installed using `npm`. Add Express to your project with the following command.

```bash
npm install express
```

Next, open the project in your editor of choice.

> If you don't already have a favorite code editor, I use and recommend [Visual Studio Code](https://code.visualstudio.com/). VS Code has exceptional support for JavaScript and Node.js, such as smart code completing and debugging, and there's a vast library of free extensions contributed by the community.


Create a folder named `src`. In this folder, create a file named `index.js`. Open the file and add the following JavaScript.

```javascript
const express = require( "express" );
const app = express();
const port = 8080; // default port to listen

// define a route handler for the default home page
app.get( "/", ( req, res ) => {
    res.send( "Hello world!" );
} );

// start the Express server
app.listen( port, () => {
    console.log( `server started at http://localhost:${ port }` );
} );
```

Next, update `package.json` to instruct `npm` on how to run your application. Change the `main` property value to point to `src/index.js`, and add a `start` script to the `scripts` object.

```json
  "main": "src/index.js",
  "scripts": {
    "start": "node .",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
```

Now, from the terminal or command line, you can launch the application.

```bash
npm run start
```

If all goes well, you should see this message written to the console.

```
server started at http://localhost:8080
```

Launch your browser and navigate to <a href="http://localhost:8080" target="_blank">http://localhost:8080</a>. You should see the text "Hello world!"

{% img blog/node-express-typescript/hello-world.jpg alt:"Hello World" width:"500" %}{: .center-image }

> Note: To stop the web application, you can go back to the terminal or command prompt and press `CTRL+C`.

## How to set up a Node.js project to use TypeScript

The first step is to add the TypeScript compiler. You can install the compiler as a developer dependency using the `--save-dev` flag.

```bash
npm install --save-dev typescript
```

The next step is to add a `tsconfig.json` file to your project. This file instructs TypeScript how to compile (transpile) your TypeScript code into plain JavaScript. Create a file named `tsconfig.json` in the root folder of your project, and add the following configuration.

```javascript
{
    "compilerOptions": {
        "module": "commonjs",
        "esModuleInterop": true,
        "target": "es6",
        "noImplicitAny": true,
        "moduleResolution": "node",
        "sourceMap": true,
        "outDir": "dist",
        "baseUrl": ".",
        "paths": {
            "*": [
                "node_modules/*"
            ]
        }
    },
    "include": [
        "src/**/*"
    ]
}
```

Based on this `tsconfig.json` file, the TypeScript compiler will (attempt to) compile any files ending with `.ts` it finds in the `src` folder, and store the results in a folder named `dist`. Node.js uses the CommonJS module system, so the value for the `module` setting is `commonjs`. Also, the target version of JavaScript is ES6 (ES2015), which is compatible with modern versions of Node.js.

It's also a great idea to create a `tslint.json` file that instructs TypeScript how to lint your code. If you're not familiar with linting, it is a code analysis tool to alert you to potential problems in your code beyond syntax issues.

```javascript
{
    "defaultSeverity": "error",
    "extends": [
        "tslint:recommended"
    ],
    "jsRules": {},
    "rules": {
        "trailing-comma": [ false ]
    },
    "rulesDirectory": []
}
```

Next, update your `package.json` to change `main` to point to the new `dist` folder created by the TypeScript compiler. Also, add a couple of scripts to execute TSLint and the TypeScript compiler just before starting the Node.js server.

```
  "main": "dist/index.js",
  "scripts": {
    "prebuild": "tslint -c tslint.json -p tsconfig.json --fix",
    "build": "tsc",
    "prestart": "npm run build",
    "start": "node .",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
```

Finally, change the extension of the `src/index.js` file from `.js` to `.ts`, the TypeScript extension, and run the start script. 

```bash
npm run start
```

> Note: You can run TSLint and the TypeScript compiler without starting the Node.js server using `npm run build`.

### TypeScript errors

Oh no! Right away, you may see some errors logged to the console like these.

```bash

ERROR: /Users/reverentgeek/Projects/guitar-inventory/src/index.ts[12, 5]: Calls to 'console.log' are not allowed.

src/index.ts:1:17 - error TS2580: Cannot find name 'require'. Do you need to install type definitions for node? Try `npm i @types/node`.

1 const express = require( "express" );
                  ~~~~~~~

src/index.ts:6:17 - error TS7006: Parameter 'req' implicitly has an 'any' type.

6 app.get( "/", ( req, res ) => {
                  ~~~
```

The two most common errors you may see are syntax errors and missing type information. TSLint considers using `console.log` to be an issue for production code. The best solution is to replace uses of console.log with a logging framework such as [winston](https://www.npmjs.com/package/winston). For now, add the following comment to `src/index.ts` to disable the rule.

```javascript
app.listen( port, () => {
    // tslint:disable-next-line:no-console
    console.log( `server started at http://localhost:${ port }` );
} );
```

TypeScript prefers to use the `import` module syntax over `require`, so you'll start by changing the first line in `src/index.ts` from:

```javascript
const express = require( "express" );
```

to:

```javascript
import express from "express";
```

### Getting the right types

To assist TypeScript developers, library authors and community contributors publish companion libraries called [TypeScript declaration files](http://www.typescriptlang.org/docs/handbook/declaration-files/consumption.html). Declaration files are published to the [DefinitelyTyped](https://github.com/DefinitelyTyped/DefinitelyTyped) open source repository, or sometimes found in the original JavaScript library itself.

Update your project so that TypeScript can use the type declarations for Node.js and Express.

```bash
npm install --save-dev @types/node @types/express
```

Next, rerun the start script and verify there are no more errors.

```bash
npm run start
```

## A Better User Interface

Your Node.js application is off to a great start, but is not very pretty, yet. This step uses [Materialize](https://materializecss.com/), a modern CSS framework based on Google's Material Design, and [Embedded JavaScript Templates](https://www.npmjs.com/package/ejs) (EJS) to create a better UI.

First, install EJS as a dependency.

```bash
npm install ejs
```

Next, make a new folder under `/src` named `views`. In the `/src/views` folder, create a file named `index.ejs`. Add the following code to `/src/views/index.ejs`.

```html
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>Guitar Inventory</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/1.0.0/css/materialize.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
</head>
<body>
    <div class="container">
        <h1 class="header">Guitar Inventory</h1>
        <a class="btn" href="/guitars"><i class="material-icons right">arrow_forward</i>Get started!</a>
    </div>
</body>
</html>
```

Update `/src/index.ts` with the following code.

```javascript
import express from "express";
import path from "path";
const app = express();
const port = 8080; // default port to listen

// Configure Express to use EJS
app.set( "views", path.join( __dirname, "views" ) );
app.set( "view engine", "ejs" );

// define a route handler for the default home page
app.get( "/", ( req, res ) => {
    // render the index template
    res.render( "index" );
} );

// start the express server
app.listen( port, () => {
    // tslint:disable-next-line:no-console
    console.log( `server started at http://localhost:${ port }` );
} );
```

Now run the application and navigate to http://localhost:8080.

```bash
npm run start
```

{% img blog/node-express-typescript/guitar-inventory-home-v2.jpg alt:"Guitar Inventory home page" width:"500" %}{: .center-image }

The home page is starting to look better!

## A Better Way to Manage Configuration Settings

Node.js applications typically use environment variables for configuration. However, managing environment variables can be a chore. A popular module for managing application configuration data is [dotenv](https://www.npmjs.com/package/dotenv).

Install `dotenv` as a project dependency.

```bash
npm install dotenv
```
Create a file named `.env` in the root folder of the project, and add the following code. 

```bash
# Set to production when deploying to production
NODE_ENV=development

# Node.js server configuration
SERVER_PORT=8080
```

> Note: When using a source control system such as `git`, **do not** add the `.env` file to source control. Each environment requires a custom `.env` file. It is recommended you document the values expected in the `.env` file in the project README or a separate `.env.sample` file.

Now, update `src/index.ts` to use `dotenv` to configure the application server port value.

```javascript
import dotenv from "dotenv";
import express from "express";
import path from "path";

// initialize configuration
dotenv.config();

// port is now available to the Node.js runtime 
// as if it were an environment variable
const port = process.env.SERVER_PORT;

const app = express();

// Configure Express to use EJS
app.set( "views", path.join( __dirname, "views" ) );
app.set( "view engine", "ejs" );

// define a route handler for the default home page
app.get( "/", ( req, res ) => {
    // render the index template
    res.render( "index" );
} );

// start the express server
app.listen( port, () => {
    // tslint:disable-next-line:no-console
    console.log( `server started at http://localhost:${ port }` );
} );
```

You will use the `.env` for much more configuration information as the project grows.

## Easily add authentication to Node and Express

Adding user registration and login (authentication) to any application is not a trivial task. The good news is Okta makes this step very easy. To begin, create a free developer account with Okta. First, navigate to [developer.okta.com](https://developer.okta.com/) and click the **Create Free Account** button, or click the [Sign Up](https://developer.okta.com/signup/) button.

{% img blog/node-express-typescript/add-application-00.jpg alt:"Sign up for free account" width:"800" %}{: .center-image }

After creating your account, click the **Applications** link at the top, and then click **Add Application**.

{% img blog/node-express-typescript/add-application-01.jpg alt:"Create application" width:"500" %}{: .center-image }

Next, choose a **Web Application** and click **Next**.

{% img blog/node-express-typescript/add-application-02.jpg alt:"Create a web application" width:"800" %}{: .center-image }

Enter a name for your application, such as *Guitar Inventory*. Verify the port number is the same as configured for your local web application. Then, click **Done** to finish creating the application.

{% img blog/node-express-typescript/add-application-03.jpg alt:"Application settings" width:"800" %}{: .center-image }

After creating the application, click on the application's **General** tab, and find near the bottom of the page a section titled "Client Credentials." You need both the **Client ID** and **Client secret** values.

{% img blog/node-express-typescript/add-application-04.jpg alt:"Client credentials" width:"800" %}{: .center-image }

Copy and paste the following code into your `.env` file.

```bash
# Okta configuration
OKTA_ORG_URL=https://dev-123456.oktapreview.com
OKTA_CLIENT_ID=
OKTA_CLIENT_SECRET=
```

Copy the **Client ID** and **Client secret** values and paste them into your `.env` file. Last, you need to replace the value of `dev-123456` in the `OKTA_ORG_URL` to match the ID for your account. You can find this ID in the URL of your Okta management console. 

{% img blog/node-express-typescript/okta-instance-id.jpg alt:"Client credentials" width:"500" %}{: .center-image }

### Enable self-service registration

One of the great features of Okta is allowing users of your application to sign up for an account. By default, this feature is disabled, but you can easily enable it. First, click on the **Users** menu and select **Registration**.

{% img blog/node-express-typescript/self-service-registration-01.jpg alt:"User registration" width:"500" %}{: .center-image }

1. Click on the **Edit** button.
2. Change **Self-service registration** to *Enabled*.
3. Click the **Save** button at the bottom of the form.

{% img blog/node-express-typescript/self-service-registration-02.jpg alt:"Enable self-registration" width:"800" %}{: .center-image }

## Create the API

The next step is to add the API to the Guitar Inventory application. Before moving on, you need a way to store data.

### Create a PostgreSQL database

This tutorial uses [PostgreSQL](https://www.postgresql.org/). To make things easier, use [Docker](https://www.docker.com) to set up an instance of PostgreSQL. If you don't already have Docker installed, you can follow the [install guide](https://docs.docker.com/install/#supported-platforms).

Once you have Docker installed, run the following command to download the latest PostgreSQL container.

```bash
docker pull postgres:latest
```

Now, run this command to create an instance of a PostgreSQL database server. Feel free to change the administrator password value.

```bash
docker run -d --name guitar-db -p 5432:5432 -e 'POSTGRES_PASSWORD=p@ssw0rd42' postgres
```

Here is a quick explanation of the previous Docker parameters.

| parameter | description |
|:----------|:------------|
|-d         |This launches the container in daemon mode, so it runs in the background.|
|--name|This gives your Docker container a friendly name, which is useful for stopping and starting containers|
|-p|This maps the host (your computer) port 5432 to the container's port 5432. PostgreSQL, by default, listens for connections on TCP port 5432.|
|-e|This sets an environment variable in the container. In this example, the administrator password is `p@ssw0rd42`. You can change this value to any password you desire.|
|postgres|This final parameter tells Docker to use the postgres image.|

### Install dependencies

Node.js applications typically rely on environment variables for configuration. [Dotenv](https://www.npmjs.com/package/dotenv) is a module designed to load environment variables from a file named `.env`.

Install `dotenv` and the PostgreSQL client module using the following command.

```bash
npm install pg pg-promise
```
Install the following development dependencies used to build and run the application.

```bash
npm install --save-dev ts-node shelljs fs-extra nodemon rimraf
```

Install the necessary TypeScript declarations.

```bash
npm install --save-dev @types/dotenv @types/fs-extra @types/pg @types/shelljs
```

### Database configuration settings

Add the following settings to the end of the `.env` file. 

```bash
# Postgres configuration
PGHOST=localhost
PGUSER=postgres
PGDATABASE=postgres
PGPASSWORD=p@ssw0rd42
PGPORT=5432
```
*Note: If you changed the database administrator password, be sure to replace the default `p@ssw0rd42` with that password in this file.*

### Add a database build script

You need a build script to initialize the PostgreSQL database. This script should read in a `.pgsql` file and execute the SQL commands against the local database.

First, create a new folder in the project named `tools`. In this folder, create two files: `initdb.ts` and `initdb.pgsql`. Copy and paste the following code into `initdb.ts`.

```javascript
import dotenv from "dotenv";
import fs from "fs-extra";
import { Client } from "pg";

const init = async () => {
    // read environment variables
    dotenv.config();
    // create an instance of the PostgreSQL client
    const client = new Client();
    try {
        // connect to the local database server
        await client.connect();
        // read the contents of the initdb.pgsql file
        const sql = await fs.readFile( "./tools/initdb.pgsql", { encoding: "UTF-8" } );
        // split the file into separate statements
        const statements = sql.split( /;\s*$/m );
        for ( const statement of statements ) {
            if ( statement.length > 3 ) {
                // execute each of the statements
                await client.query( statement );
            }
        }
    } catch ( err ) {
        console.log( err );
        throw err;
    } finally {
        // close the database client
        await client.end();
    }
};

init().then( () => {
    console.log( "finished" );
} ).catch( () => {
    console.log( "finished with errors" );
} );
```

Next, copy and paste the following code into `initdb.pgsql`.

```sql
-- Drops guitars table
DROP TABLE IF EXISTS guitars;

-- Creates guitars table
CREATE TABLE IF NOT EXISTS guitars (
    id INT NOT NULL PRIMARY KEY GENERATED ALWAYS AS IDENTITY
    , user_id varchar(50) NOT NULL
    , brand varchar(50) NOT NULL
    , model varchar(50) NOT NULL
    , year smallint NULL 
    , color varchar(50) NULL
);
```

### Add an asset build script

The TypeScript compiler does the work of generating the JavaScript files and copies them to the `dist` folder. However, it does not copy the other types of files the project needs to run. To accomplish this, create a build script that copies all the other files to the `dist` folder.

Create a file in the `tools` folder named `copyAssets.ts`. Copy the following code into this file.

```javascript
import * as shell from "shelljs";

// Copy all of the database files
shell.cp( "-R", "src/db/sql", "dist/db/" );

// Copy all the view templates and assets in the public folder
shell.cp( "-R", [ "src/views", "src/public" ], "dist/" );
```

### Update npm scripts

Update the `scripts` in `package.json` to the following code.

```javascript
  "scripts": {
    "clean": "rimraf dist/*",
    "copy-assets": "ts-node tools/copyAssets",
    "prebuild": "tslint -c tslint.json -p tsconfig.json --fix",
    "build": "tsc && npm run copy-assets",
    "dev:build": "npm run build && node dist/index.js",
    "dev": "nodemon --watch src -e ts,ejs --exec npm run dev:build",
    "prestart": "npm run build",
    "start": "node .",
    "initdb": "ts-node tools/initdb",
    "test": "echo \"Error: no test specified\" && exit 1"
  },
```

If you are not familiar with using `npm` scripts, they can be very powerful and useful to any Node.js project. 
