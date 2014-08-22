# Grabby

Grabby is an early prototype that automatically discovers postential custom attributes to be reported
into New Relic Insights.  You then specify which attributes you want to collect, and then Grabby will report
them.

Grabby is available only to a handful of adventurous New Relic customers as an early prototype.  It is unclear
whether this will ultimately become a shipping, supported feature.

Grabby depends on a recent version of the New Relic Agent (3.9.1 or later) and any Rails application
v2 or later.

For more details, check out this quip doc: https://quip.com/tA39AH7cM8fK

Install the gem. 
```
gem 'newrelic_grabby', git: 'git@github.com:newrelic/Grabby.git'
```

In your rails app's <conde>config/newrelic.yml</code>, you will need to explicitly turn on 
grabby for your desired environment (development, prod, etc).

```yaml
  grabby:
    enabled: true
```

Run your app.  Look to stdout for [grabby] messages. I'll move this to the agent log when things
get a little more stable.

You will need to turn on a discovery session to have grabby report possible attributes for collection.
To do this, add <code>?grabby_start=true</code> to your url params.  This is a short term hack.  

Whichever process receives this http request will start discovering instance variables and their attributes.  
For details on how this works, go to the quip doc.

After exercising your app, go to insights: <code>/accounts/:account_id/auto_instrument</code> to see the 
attributes you can collect from your app's agents.  Select which ones you want to collect.

Restart your agent, look for grabby messages in the log, and then look for custom attributes in your
Transaction and PageView events.  Voila!
