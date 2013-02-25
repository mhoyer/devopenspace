output_style          = :compressed if configatron.roles.web.app.compress_output
line_comments         = :false if configatron.roles.web.app.compress_output
sass_options          = {
                          :cache_location => "tmp/sass-cache",
                          :debug_info => true
                        }

# Input paths.
project_path          = File.dirname(__FILE__)
sass_dir              = "content/assets/css"
images_dir            = ""

# Output paths.
css_dir               = "build/bin/assets/css"
generated_images_path = "build/bin/assets/images/sprites"
http_path             = configatron.roles.web.deployment.base_href
http_stylesheets_path = http_path + "assets/css"
http_images_path      = http_path + "assets/images"

# Disable asset cache buster.
asset_cache_buster do
  nil
end

# All CSS in vendor is automatically Sass-ified to tmp/vendor.
additional_import_paths = ['vendor', 'tmp/vendor']
