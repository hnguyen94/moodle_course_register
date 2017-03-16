# frozen_string_literal: true
require 'pry'
require 'pry-byebug'
require 'mechanize'
require 'dotenv/load'

agent = Mechanize.new
agent.user_agent_alias = 'Mac Safari'

# Log in
cookies_file = 'cookies.yml'

if File.exist? cookies_file
  agent.cookie_jar.load cookies_file
else
  login_page = agent.get('https://moodle.itech-bs14.de/login/index.php')
  login_form = login_page.form(action: 'https://moodle.itech-bs14.de/login/index.php')
  login_form.field_with(id: 'username').value = ENV['username']
  login_form.field_with(id: 'password').value = ENV['password']
  login_form.submit

  agent.cookie_jar.save(cookies_file, session: true)
end

ae_page = agent.get('https://moodle.itech-bs14.de/course/index.php?categoryid=5')

links = ae_page.search('.courses a')

href = links.map do |link|
  link.attribute('href').to_s
end

href.each do |link|
  modules = agent.get(link)
  check_in_form = modules.form(action: 'https://moodle.itech-bs14.de/enrol/index.php')

  if !check_in_form.nil?
    return check_in_form.submit if modules.search('.fstatic').count != 0
    check_in_form.field_with(name: 'enrolpassword').value = ENV['check_in_password']
    check_in_form.submit
  else
    next
    p 'Already checked in'
  end
end

# TODO: Check credentials
# lock_page = agent.get('https://moodle.itech-bs14.de/enrol/index.php?id=35')

# p 'Add start id'
# start_id = gets.chomp
# p 'Add end_id'
# end_id = gets.chomp

# user_name = homepage.search('.usertext').text
#
# if user_name != 0
# end
