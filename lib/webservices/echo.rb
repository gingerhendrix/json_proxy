

np_namespace "echo" do |ns|
  
  ns.route 'echo', [:message] do |message|
    {:message => message}
  end
end
