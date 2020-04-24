SimpleCov.start 'rails' do
  add_group "Models", "app/models"
  add_group "Controllers", "app/controllers"

  add_filter "app/mailers"
  add_filter "app/jobs"
  add_filter "app/channels"
end