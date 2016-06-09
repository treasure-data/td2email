# td2email

A sample app to send emails based on [Treasure Data](http://www.treasuredata.com) query results (leveraging [SendGrid](http://www.sendgrid.com)).

## What is this?

### Method 1

This is a little Sinatra app that bridges between Treasure Data's [HTTP PUT](http://docs.treasuredata.com/articles/result-into-web) result output functionality and SendGrid to send transactional emails.

So, it's like

```
 ---------------------   HTTP(S) PUT   ----------                            ----------      ----------
| Treasure Data table |-------------->| td2email |------------------------->| SendGrid |--->| Customer |
 ---------------------  abc.com/hello  ----------   render hello.markdown    ----------      ----------
```

### Method 2

This app is able to allow the following way:

```
 ---------------------   HTTP(S) PUT                     ----------                            ----------      ----------
| Treasure Data table |-------------------------------->| td2email |------------------------->| SendGrid |--->| Customer |
 ---------------------  abc.com/?email=...&template=...  ----------   render hello.markdown    ----------      ----------
```

## How does it work?

### Method 1

- This app assumes that the incoming Treasure Data payload has a column called `email` which has the email addresses you want to send messages to.
- The path of the app corresponds to the Markdown template under `/email_templates`. So, if you specify the path `/weekly_retention`, the template `/email_templates/weekly_retention.markdown` is rendered as HTML/text emails and sent out.
- For example, if your Treasure Data query result is

    |email|
    |----|
    |sada@example.com|
    |muga@domain.com|

    Then, if you specify `<THIS_APP's URL>/retention` as Treasure Data's HTTP PUT URL, it sends the email template found in `/email_templates/retention.markdown` to `sada@example.com` and `muga@domain.com`.

### Method 2

- This app assumes that the incoming Treasure Data parameter has 2 column called `email` and `template` which have the email addresses you want to send messages to and means the template name.
- The path of the app corresponds to the Markdown template under `/...&tempalte=email_templates`. So, if you specify the paramter `/...&template=weekly_retention`, the template `/email_templates/weekly_retention.markdown` is rendered as HTML/text emails and sent out.
- For example, if your Treasure Data query result is

    |name|number|
    |----|----|
    |Daniel|Three|

    Then, if you specify `<THIS_APP's URL>/?email=takahashi@example.com&template=retention_temp` as Treasure Data's HTTP PUT URL, it sends the email template found in `/email_templates/retention_temp.markdown` to `takahashi@example.com`.

- This app allow to embed custom variable in markdown.


## Easy Deploy on Heroku

[![Deploy](https://www.herokucdn.com/deploy/button.png)](https://heroku.com/deploy)

## License

Apache 2.0 License
