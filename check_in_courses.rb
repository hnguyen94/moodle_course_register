require 'pry'

require 'mechanize'
require 'logger'
require 'dotenv/load'

Logger.new('mechanize.log')

agent = Mechanize.new do |agent|
  agent.user_agent_alias = 'Mac Safari'
end

login_page = agent.get('https://moodle.itech-bs14.de/login/index.php')

login_form = login_page.form(action: 'https://moodle.itech-bs14.de/login/index.php')
login_form.field_with(id: 'username').value = ENV['username']
login_form.field_with(id: 'password').value = ENV['password']
page = login_form.submit


user_name = page.search('.usertext').text
p "Login successful! User: #{user_name}" unless user_name.empty?
