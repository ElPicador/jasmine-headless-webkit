require 'tilt/template'

module Jasmine::Headless
  class CoffeeTemplate < Tilt::Template
    def prepare ; end

    def evaluate(scope, locals, &block)
      begin
        cache = Jasmine::Headless::CoffeeScriptCache.new(file)
        source = cache.handle
        if cache.cached?
          %{<script type="text/javascript" src="#{cache.cache_file}"></script>
            <script type="text/javascript">
              window.CSTF['#{File.split(cache.cache_file).last}'] = '#{file}';
            </script>}
        else
          %{<script type="text/javascript">#{source}</script>}
        end
      rescue CoffeeScript::CompilationError => ne
        puts "[%s] %s: %s" % [ 'coffeescript'.color(:red), file.color(:yellow), "#{ne.message}".color(:white) ]
        raise ne
      rescue StandardError => e
        puts "[%s] Error in compiling file: %s" % [ 'coffeescript'.color(:red), file.color(:yellow) ]
        raise e
      end
    end
  end
end

