require 'rainpress'
require 'closure-compiler'

class Minifier < Nanoc::Filter
  identifier :minify
  type       :text

  def run(content, params = {})
    case params[:type]
      when :css
        Rainpress.compress(content)
      when :js
        Closure::Compiler.new.compile(content)
      when :html
        closure_for_html_compressor = File.dirname(configatron.tools.htmlcompressor) + '/compiler.jar'
        verbose(false) { cp Closure::COMPILER_JAR, closure_for_html_compressor }

        begin
          cmd = ['java', '-jar', configatron.tools.htmlcompressor,
                 '--compress-js', '--js-compressor', 'closure',
                 '--closure-opt-level', 'simple']

          compressed = IO.popen(cmd, 'r+') do |io|
            io.write content
            io.close_write
            io.read
          end

          raise "HTML Compressor failed" unless $?.success?
          compressed
        ensure
          verbose(false) { rm closure_for_html_compressor }
        end
      else
        content
    end
  end
end
