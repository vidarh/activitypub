
require 'webfinger'
require 'faraday'
require 'pp'
$: << File.expand_path(__FILE__ + "/../../lib")
require 'activitypub/types'
require 'activitypub/base'

acct = ARGV.shift || "vidar@galaxybound.com"

puts "Trying webfinger for #{acct} (to choose your own account, provide it as an argument)"
puts

wf = WebFinger.discover!(acct)
if !wf
  puts "Unable to find #{acct}"
  exit(1)
end

PP.pp wf
puts
puts "Enter to continue"
gets

link = wf["links"].find{ _1["rel"] == "self" && _1["type"] == "application/activity+json" }
if !link || !link["href"]
  puts "Unable to find a link to the actor"
  exit(2)
end

href = link["href"]

puts "Trying to retrieve the Actor from #{href}"
puts

response = Faraday.get(href,{}, {"Accept": "application/activity+json"})
if response.status != 200
  PP.pp response
  exit(3)
end

ob = ActivityPub.from_json(response.body)
PP.pp(ob)
puts
puts "Enter to continue"
gets

puts "Trying to retrieve outbox"
response = Faraday.get(ob.outbox, {}, {"Accept": "application/activity+json"})
if response.status != 200
  PP.pp response
  exit(4)
end

ob = ActivityPub.from_json(response.body)
PP.pp(ob)
