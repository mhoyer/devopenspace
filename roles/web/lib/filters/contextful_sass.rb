class ContextfulSass < Nanoc::Filters::Sass
  identifier :contextful_sass
  type :text

  def run(content, params={ })
    params[:custom] = ::Nanoc::Context.new(assigns)

    # HACK: Without this the super filter won't be able to load files.
    Nanoc::Filters::Sass.current = self

    super(content, params)
  end
end
