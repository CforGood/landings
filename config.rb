###
# Blog settings
###

# Time.zone = "UTC"

# Remove .html extension from pages
activate :directory_indexes

# Blog Activation
activate :blog do |blog|
  # This will add a prefix to all links, template references and source paths
  # blog.prefix = "blog"

  # Matcher for blog source files
  blog.permalink = "/blog/{category}/:title.html"
  blog.sources = "articles/:year-:month-:day-:title.html"
  blog.layout = "layout"
  # blog.summary_separator = /(READMORE)/
  # blog.summary_length = 250
  # blog.year_link = "{year}.html"
  # blog.month_link = "{year}/{month}.html"
  # blog.day_link = "{year}/{month}/{day}.html"
  blog.default_extension = ".markdown"

  blog.tag_template = "tag.html"
  blog.taglink = "blog/categories/{tag}.html"

  blog.calendar_template = "calendar.html"

  blog.custom_collections = {
    category: {
      link: '/blog/categories/{category}.html',
      template: '/category.html'
    }
  }

  # Enable pagination
  blog.paginate = true
  blog.per_page = 3
  blog.page_link = "page/{num}"
end

page "/feed.xml", layout: false

###
# Compass
###

# Change Compass configuration
# compass_config do |config|
#   config.output_style = :compact
# end

# Auto-prefixing of CSS code with vendor prefix
activate :autoprefixer

###
# Page options, layouts, aliases and proxies
###

# Per-page layout changes:
#
# With no layout
# page "/path/to/file.html", layout: false
#
# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# A path which all have the same layout
# with_layout :admin do
#   page "/admin/*"
# end

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

###
# Helpers
###

# Automatic image dimensions on image_tag helper
# activate :automatic_image_sizes

# Reload the browser automatically whenever files change
# activate :livereload

# Methods defined in the helpers block are available in templates
helpers do
  def find_author(author_slug)
    author_slug = author_slug.downcase
    result = data.authors.select {|author| author.keys.first == author_slug }
    raise ArgumentError unless result.any?
    result.first
  end

  def articles_by_author(author)
    sitemap.resources.select do |resource|
    resource.data.author == author.name
    end.sort_by { |resource| resource.data.date }
  end

  def build_categories(articles)
    categories = []
    articles.each do |article|
      category = article.metadata[:page]['category']
      unless categories.include? category
        categories.push(category)
      end
    end
    return categories
  end

  def nav_active(path)
    current_page.path == path ? 'active' : nil
  end

  def hide_item(path)
    current_page.path == path ? 'hidden' : nil
  end
end


set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

# Build-specific configuration
configure :build do
  # For example, change the Compass output style for deployment
  # activate :minify_css

  # Minify Javascript on build
  # activate :minify_javascript

  # Enable cache buster
  # activate :asset_hash

  # Use relative URLs
  activate :relative_assets
  set :relative_links, true

  # Or use a different image path
  # set :http_prefix, "/Content/images/"
  require_relative "./lib/build_cleaner"
  activate :build_cleaner
end

after_configuration do
  sprockets.append_path 'vendor/javascripts'
end

# Deployment
activate :deploy do |deploy|
  deploy.method = :git
  deploy.build_before = true

  # Optional Settings
  # deploy.remote = 'custom-remote' # remote name or git url, default: origin
  # deploy.branch = 'custom-branch' # default: gh-pages
  # deploy.strategy = :submodule # commit strategy: can be :force_push or :submodule, default: :force_push
  # deploy.commit_message = 'custom-message' # commit message (can be empty), default: Automated commit at `timestamp` by middleman-deploy `version`
end