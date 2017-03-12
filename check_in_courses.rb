require 'mechanize'
require 'dotenv/load'

agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

begin
  retries ||= 0
  # retries += 1
  p retries
  login_page = agent.get('https://moodle.itech-bs14.de/login/index.php')

  login_form = login_page.form(action: 'https://moodle.itech-bs14.de/login/index.php')
  login_form.field_with(id: 'username').value = ENV['username']
  login_form.field_with(id: 'password').value = ENV['username']
  login_form.submit
rescue => error

  # retry if retries < 3
end

# agent.visited?
