#!/usr/bin/env ruby
require 'watir-webdriver'

def log (message) puts "  #{message}" end
def success (message) puts "+ #{message}" end
def fail (message) puts "- #{message}" end
def notify (message)
  success message.upcase
  system 'osascript -e \'Display notification "Bürgerbot" with title "%s"\'' % message
rescue StandardError => e
end

def appointment_available?
  url = 'http://service.berlin.de/terminvereinbarung/termin/tag.php?termin=1&dienstleister%5B%5D=122210&dienstleister%5B%5D=122217&dienstleister%5B%5D=122219&dienstleister%5B%5D=122227&dienstleister%5B%5D=122231&dienstleister%5B%5D=122238&dienstleister%5B%5D=122243&dienstleister%5B%5D=122252&dienstleister%5B%5D=122260&dienstleister%5B%5D=122262&dienstleister%5B%5D=122254&dienstleister%5B%5D=122271&dienstleister%5B%5D=122273&dienstleister%5B%5D=122277&dienstleister%5B%5D=122280&dienstleister%5B%5D=122282&dienstleister%5B%5D=122284&dienstleister%5B%5D=122291&dienstleister%5B%5D=122285&dienstleister%5B%5D=122286&dienstleister%5B%5D=122296&dienstleister%5B%5D=150230&dienstleister%5B%5D=122301&dienstleister%5B%5D=122297&dienstleister%5B%5D=122294&dienstleister%5B%5D=122312&dienstleister%5B%5D=122314&dienstleister%5B%5D=122304&dienstleister%5B%5D=122311&dienstleister%5B%5D=122309&dienstleister%5B%5D=317869&dienstleister%5B%5D=324433&dienstleister%5B%5D=325341&dienstleister%5B%5D=324434&dienstleister%5B%5D=324435&dienstleister%5B%5D=122281&dienstleister%5B%5D=324414&dienstleister%5B%5D=122283&dienstleister%5B%5D=122279&dienstleister%5B%5D=122276&dienstleister%5B%5D=122274&dienstleister%5B%5D=122267&dienstleister%5B%5D=122246&dienstleister%5B%5D=122251&dienstleister%5B%5D=122257&dienstleister%5B%5D=122208&dienstleister%5B%5D=122226&anliegen%5B%5D=120686&herkunft=%2Fterminvereinbarung%2F'
  puts '-'*80
  log 'Trying again'
  $browser.goto url
  log 'Page loaded'
  link = $browser.element css: '.calendar-month-table:first-child td.buchbar a'
  if link.exists?
    link.click
    notify 'An appointment is available.'
    log 'Enter y to keep searching or anything else to quit.'
    return gets.chomp.downcase != 'y'
  else
    fail 'No luck this time.'
    return false
  end
rescue StandardError => e
  fail 'Error encountered.'
  puts e.inspect
  return false
end

$browser = Watir::Browser.new
until appointment_available?
  log 'Sleeping.'
  sleep 30
end