# td2email

A sample app to send emails based on [Treasure Data](http://www.treasuredata.com) query results (leveraging [SendGrid](http://www.sendgrid.com)).

## What is this?

This is a little Sinatra app that bridges between Treasure Data's [HTTP PUT](http://docs.treasuredata.com/articles/result-into-web) result output functionality and SendGrid to send transactional emails.

So, it's like

```
 ---------------------   HTTP(S) PUT   ----------                            ----------      ----------
| Treasure Data table |-------------->| td2email |------------------------->| SendGrid |--->| Customer |
 ---------------------  abc.com/hello  ----------   render hello.markdown    ----------      ----------
```

## How does it work?

- This app assumes that the incoming Treasure Data payload has a column called `email` which has the email addresses you want to send messages to.
- The path of the app corresponds to the Markdown template under `/email_templates`. So, if you specify the path `/weekly_retention`, the template `/email_templates/weekly_retention.markdown` is rendered as HTML/text emails and sent out.
- For example, if your Treasure Data query result is
    
    |email|
    |----|
    |sada@example.com|
    |muga@domain.com|
    
    Then, if you specify `<THIS_APP's URL>/retention` as Treasure Data's HTTP PUT URL, it sends the email template found in `/email_templates/retention.markdown` to `sada@example.com` and `muga@domain.com`.

## Easy Deploy on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## License

Apache 2.0 License
