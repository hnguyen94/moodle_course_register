require 'pry'
require 'mechanize'
require 'dotenv/load'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

cookies_file = 'cookies.yml'

if File.exist?('cookies.yaml')
  agent.cookie_jar.load('cookies.yaml')
else
  login_page = agent.get('https://moodle.itech-bs14.de/login/index.php')
  login_form = login_page.form(action: 'https://moodle.itech-bs14.de/login/index.php')
  login_form.field_with(id: 'username').value = ENV['username']
  login_form.field_with(id: 'password').value = ENV['password']
  login_form.submit

  agent.cookie_jar.save(cookies_file, session: true)
end

my_courses = agent.get('https://moodle.itech-bs14.de/course/view.php?id=94')

pp my_courses

# user_name = homepage.search('.usertext').text
#
# if user_name != 0
# end
