## queertangoclub.nyc

Site for queertangoclub.nyc. This provides integration with Stripe as a payment processor for tickets and lists historical events on the site.

## Installation

The easiest installation path is to install [Postgres.app](http://postgresapp.com/) and [Tokaido.app](https://github.com/tokaido/tokaidoapp/releases).

After installing these, you can launch the application by selecting the folder using Tokaido.

## Configuration

We use dotenv to store configuration variables in our application. To setup your .env credentials correctly, you'll need the following variables in `.env` in the root folder of the application:

```
STRIPE_KEY=xxx
STRIPE_SECRET=xxx
MAPBOX_TOKEN=xxx
AWS_ACCESS_KEY_ID=xxx
AWS_SECRET_ACCESS_KEY=xxx
S3_BUCKET_NAME=xxx
CLOUDFRONT_URL=xxx
```

Please ask a member of the website team for a list of these variables. These should be kept private and they should *never* be published, since some of these tie directly to a bank account. Keep it secret, keep it safe.

## Deployment

We’re using Heroku to host our application.

To deploy to heroku, you'll need to install the [heroku toolbelt](https://toolbelt.heroku.com/). Once this is done, follow the steps outlined in [this tutorial](https://devcenter.heroku.com/articles/collab) from Heroku to get everything up and running.
