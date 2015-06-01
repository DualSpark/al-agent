

execute "logging" do
  command "logger -p mail.info testing from #{node['hostname']} by #{Includer.logging_by}"
  command "logger -p mail.info testing from #{node['hostname']} by logging_by_2 #{node.run_state['logging_by_2']}"
end
