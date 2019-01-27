begin
  require 'pycall'
  PyCall.init 'python3' # use python3, default is python2
  require 'pycall/import'
  include PyCall::Import
rescue => e
  puts "#{e}\nPyCall init failed.\nTo use PyCall, you need to install python3 first!"
end
