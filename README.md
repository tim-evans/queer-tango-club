## api.queertangoclub.nyc

Backend for queertangoclub.nyc.

## Installation

The installation assumes that you're developing on a Mac computer. Before starting, install XCode from the App store and run the following command using Terminal.app:

```bash
xcode-select --install
```

After this, we can start installing the rest of the dependencies. Install [Homebrew](http://brew.sh/), which provides a set of packages that we'll use later:

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Install [RVM](https://rvm.io/) for the version of ruby we're using for this application:

```bash
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s --ruby=2.2.2
```

If you already have RVM installed, make sure you're using Ruby version 2.2.2 for this project, otherwise you may have some issues running the app.

Before we continue, let's install [Bundler](http://bundler.io/), which will help us manage our dependencies.

```bash
gem install bundler
```

We then need to install a few packages to get the application working.

First, let's install the libraries database we're using, Postgres:

```bash
brew install postgres
```

Following that, install the rest of our dependencies:

```bash
bundle install
```

Then, let’s install the database. The easiest way to install it is using [Postgres.app](http://postgresapp.com/). Install Postgres.app from the website, then continue below.

```bash
rake db:create db:migrate
```

## Running

```bash
rails s
```

## Deployment

We’re using Heroku to host our application.
