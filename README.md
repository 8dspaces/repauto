## Repauto

Making your test results visible. Here is the talk about it on [SeleniumConf 2015](http://year-2015.seleniumconf.org/).

<a href="http://www.youtube.com/watch?feature=player_embedded&v=fNfcd40g_xU
" target="_blank"><img src="http://img.youtube.com/vi/fNfcd40g_xU/0.jpg"
alt="The Talk" width="240" height="180" border="10" /></a>

[Get Started](https://github.com/xiaoxinghu/repauto/wiki/Getting-Started).

## pre-request

- bundler
- node.js
- bower
- mongodb

## install necessary things

You have to have ruby 2+ on your system. Check it with

    ruby --version

To install bundler:

    gem install bundler

To install node.js

    brew install node

To install bower

    npm install -g bower

To setup mongodb

    brew install mongodb

Follow the [instructions](https://docs.mongodb.org/getting-started/shell/tutorial/install-mongodb-on-os-x/) for details.

## setup the website

`cd` to the project folder, and do the following.

    bundle install
    rake bower:install

To run the website.

    rails server

or `rails s` for short.

Now you are able to access it through `http://localhost:3000`.

## deployment for production

### nginx + passenger

[instructions](https://medium.com/@samx18/deploy-a-rails-app-locally-on-os-x-using-passenger-with-nginx-in-under-5-minutes-be0381e90f5f)

### envrionment

Generate secret key. Under the root folder of the project.

    echo SECRET_KEY_BASE=`rake secret` > .env.production

Deployment for production.

    RAILS_ENV=production rake report:deploy

## diagnostic

Check the log files when you think something went wrong.
The log files are located in `log` folder directly in the root folder.
They are separated by environment (i.e. development, production, test).
The file `cron_error_log.log` and `cron_log.log` are for background tasks like syncing.

**Notice** that when you run the website on in development, the logs are output directly to `STDOUT`.


## tweaking

### update background syncing schedule

Modify the schedule file `config/schedule.rb`.

Then update the schedule:

    whenever --update-crontab

To list all jobs.

    crontab -l

### manually sync data

To manually sync data to database

    RAILS_ENV=production rake data:msync

To sync only one project

    RAILS_ENV=production rake data:msync[FP5]

The sync task will sync with test runs which happened within last 24 hours, to sync all, which will take significant amount of time (don't do this), you can:

    RAILS_ENV=production rake data:sync_all

In case this document is out dated. To see an up to date command list.

    rake -T report

This rake task will turn off the background syncing task first, then do the syncing, and turn the background task back on when finished.

