module Items
  class CompassUrls
    include Compass::SassExtensions::Functions::Urls
  end

  def i(identifier, rep = :default)
    context = options[:custom]

    item = context.items.find! identifier.value
    if (rep.respond_to? :value)
      rep = rep.value
    end
    path = item.rep_named(rep.to_sym).raw_path

    # Raise unmet dependency error unless all reps are compiled
    uncompiled = item.reps.find { |r| !r.compiled? }
    raise Nanoc::Errors::UnmetDependency.new(uncompiled) if uncompiled

    Sass::Script::String.new(path, :string)
  end

  def image_url(path, only_path = Sass::Script::Bool.new(false), cache_buster = Sass::Script::Bool.new(true))
    # If the path is in build/*, we need to strip the output directory.
    if path.value =~ %r|^build/bin|
      url = path.value.sub %r|^build/bin|, ''

      return Sass::Script::String.new("url('#{url}')")
    end

    path = path.value.sub %r|^content/assets/images/|, ''
    path = ::Sass::Script::String.new path

    CompassUrls.new.image_url(path, only_path, cache_buster)
  end
end

module Sass::Script::Functions
  include Items

  declare :i, :args => [:identifier]
  declare :i, :args => [:identifier, :rep]

  # Hack to ensure previous API declarations (by Compass or whatever)
  # don't take precedence.
  [:image_url].each do |method|
    defined?(@signatures) && @signatures.delete(method)
  end

  declare :image_url, [:path]
  declare :image_url, [:path, :only_path]
  declare :image_url, [:path, :only_path, :cache_buster]
end
