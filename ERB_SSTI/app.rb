# mirth-4.rb
# Data persistence with YAML store:
# Use YAML to save the birthdays that
# can be reused when the server restarts

require 'socket'
require 'erb'
require 'uri'

# Require the library to use YAML::Store
require 'yaml/store'

server = TCPServer.new(1337)

# Attain file store from a YAML file 
store = YAML::Store.new("mirth.yml")

header = <<HTML
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Bootstrap demo</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-Zenh87qX5JnK2Jl0vWa8Ck2rdkQ2Bzep5IDxbcnCeuOxjzrPF/et3URy9Bv1WTRi" crossorigin="anonymous">
  </head>
  <body>
    <div>
HTML

footer = <<HTML
</div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-OERcA2EqjJCMA+/3y+gxIOqMEjwtxJY7qPCqsdltbNJuaOe923+mo//f6V8Qbsw3" crossorigin="anonymous"></script>
  </body>
</html>
HTML

loop do
  client = server.accept

  request_line = client.readline
  method_token, target, version_number = request_line.split

  case [method_token, target]
  when ["GET", "/show/birthdays"]
  when ["POST", "/add/birthday"]
  else
    response_status_code = "200 OK"
    
    all_headers = {}
    while true
      line = client.readline
      break if line == "\r\n"
      header_name, value = line.split(": ")
      all_headers[header_name] = value
    end
    body = client.read(all_headers['Content-Length'].to_i)

    require 'uri' 
    data = URI.decode_www_form(body).to_h

    template = <<-EOF
      <div class="container">
      <div class="row h-100 d-flex justify-content-center mt-5">
          <h3>Repport issue</h3>
          <form method="post" action="">
              <textarea name="review" class="form-control mb-3"></textarea>
              <div class="input-group">
                  <input type="email" class="form-control" name="email" placeholder="Your email"/>
                  <button class="btn btn-primary" type="submit">Send mail</button>
              </div>
          </form>
      </div>
      <p>Issue sucessfuly submitted by: #{data["email"]}</p>
      <p>Review text \n #{data["review"]}</p>
    </div>
    EOF


    form = ERB.new(template, safe_level = 4)

    response_message =  header + form.result(binding) + footer
    content_type = "text/html"
  end

  http_response = <<~MSG
    #{version_number} #{response_status_code}
    Content-Type: #{content_type}; charset=#{response_message.encoding.name}
    Location: /show/birthdays
    
    #{response_message}
  MSG

  client.puts http_response
  client.close
end