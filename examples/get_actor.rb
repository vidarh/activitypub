
require 'pp'
$: << File.expand_path(__FILE__ + "/../../lib")
require 'activitypub'

acct = ARGV.shift || "vidar@galaxybound.com"

puts "Trying webfinger for #{acct} (to choose your own account, provide it as an argument)"
puts

wf = ActivityPub.webfinger(acct)
if !wf
  puts "Unable to find #{acct}"
  exit(1)
end

PP.pp wf
puts
puts "Enter to continue"
gets

href = wf.activitypub
if !href
  puts "Unable to find a link to the actor"
  exit(2)
end

puts "Trying to retrieve the Actor from #{href}"
puts

ob = href.get
PP.pp(ob)
#puts ob.to_json
puts
puts "Enter to continue"
gets

puts "Trying to retrieve outbox"
ob = ob.outbox.get
PP.pp(ob)
puts
puts "Enter to continue"
gets

puts
puts "PAGE: #{ob.first}"
ob = ob.first.get
PP.pp(ob)

# For now, this will let you iterate through the collection.
# while ob && ob.orderedItems.length > 0
#   PP.pp ob.id
#   ob = ob.next&.get
# end
