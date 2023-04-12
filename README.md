# README

This application requires the following:

* Ruby version: 3.0.1
* Rails version: 7.0.2

## Configuration

Before setting the app, please make sure to configure the .env file. Otherwise the setup will not work. This is the data required foor .env:

```
# The database details
MYSQL_DATABASE=
MYSQL_USERNAME=
MYSQL_PASSWORD=
MYSQL_HOST=
DB_POOL=

# The port where the application should run
PORT = 3000
$ The base URL, for local development use the default values
BASE_URL = http://localhost:$PORT

# The details of the admin account
ADMIN_FIRST_NAME=
ADMIN_LAST_NAME=
ADMIN_EMAIL=
ADMIN_PASSWORD=
```

To setup the app: 

```
  bin/setup
```

To run the server:

```
  bin/dev
```

An admin user will be created automatically on setup based on the data you have provided in the .env file. Admin users can send email invites to any email-id. The emails in local dev are in the `tmp/mail` folder. The file will have the name of the invite receiver.

Receiver can only sign up using the link provided in the mail.