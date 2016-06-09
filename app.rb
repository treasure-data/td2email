require 'sinatra'
require 'json'
require 'sendgrid-ruby'
require 'redcarpet'
require 'redcarpet/render_strip'
require 'erb'
require 'tilt'

put '/' do
  email = params[:email]
  template = params[:template]
  begin
    payload = JSON.parse(request.body.read)
    payload = Hash[payload['column_names'].zip(payload['data'].transpose)]
    template_markdown = create_template(template, payload)
    if email && template_markdown
      send_email(email, template_markdown)
    end
  end
  rescue => e
    STDERR.puts e.backtrace
  end
end

put '/:template' do
  template = params[:template]
  begin
    payload = JSON.parse(request.body.read)
    # payload is formatted like
    # { "column_names": ["foo", "bar"],
    #   "data": [[1,2,3], ['a', 'b', 'c']],
    #   "column_type": ["long", "string"]
    # }
    # See http://docs.treasuredata.com/articles/result-into-web
    payload = Hash[payload['column_names'].zip(payload['data'].transpose)]
    emails = payload["email"]
    if emails
      send_emails(emails, template)
    end
  rescue => e
    STDERR.puts e.backtrace
  end
end

SENDGRID_CLIENT = SendGrid::Client.new(api_user: ENV['SENDGRID_USERNAME'], api_key: ENV['SENDGRID_PASSWORD'])
MD2HTML = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
MD2TEXT = Redcarpet::Markdown.new(Redcarpet::Render::StripDown)

helpers do

def create_template(template, payload)
  template_path = "email_templates/#{template}.markdown"
  template_markdown = nil
  if File.exist?(template_path)
    template_markdown = Tilt::StringTemplate.new(template_path)
                        .render(Object.new, payload)
    puts template_markdown
  end
  return template_markdown
end

def send_emails(emails, template)
  template_path = "email_templates/#{template}.markdown"

  if File.exist?(template_path)
    template_markdown = File.new(template_path).read
    emails.each do |email|
      send_email(email, template_markdown)
    end
  end
end

def send_email(email, markdown)
  mail = SendGrid::Mail.new
  mail.to = email
  mail.from = 'kiyoto@treasure-data.com' #your email
  mail.subject = "We haven't heard from you!"
  mail.text =  MD2TEXT.render(markdown)
  mail.html = MD2HTML.render(markdown)
  puts SENDGRID_CLIENT.send(mail)
end

end
