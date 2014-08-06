# Grabby

Grabby is an early prototype that automatically discovers postential custom attributes to be reported
into New Relic Insights.  You then specify which attributes you want to collect, and then Grabby will report
them.

Grabby depends on a recent version of the New Relic Agent (3.9.1 or later) and any Rails application
v2 or later.

For more details, check out this quip doc: https://quip.com/tA39AH7cM8fK

Install the gem. 
```
gem 'newrelic_grabby', git: https://source.datanerd.us/cirne/grabby-gem
```

In NewRelic.yml, you need to explicitly turn on grabby for your desired environment (development, prod, etc)

```yaml
  grabby:
    enabled: true
```
