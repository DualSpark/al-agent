

execute "logging" do
  command "logger -p mail.info testing from #{node['hostname']} by #{Includer.logging_by}"
end
