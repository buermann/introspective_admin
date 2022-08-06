if Rails::VERSION::MAJOR > 5
  Rails.autoloaders.main.ignore(
    "app/admin",
    "app/assets",
    "app/javascripts",
    "app/views"
  )
end
