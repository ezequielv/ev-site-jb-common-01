# NOTE: the code below worked on 2020.12.04, but only in non-'--safe' mode, which would not need the patch anyway.
if false then # see comment above

# ref: jekyll source: [.rvm/gems/ruby-2.2.10/gems/jekyll-3.8.7/] lib/jekyll/tags/include.rb
#  .rvm/gems/ruby-2.2.10/gems/jekyll-3.8.7/lib/jekyll/tags/include.rb
require 'jekyll'
#require 'jekyll/tags'

module Jekyll
  module Tags

    Jekyll.logger.debug(
      "ev-override-includes:",
      "loading overrides for Jekyll.Tags.*. IncludeTag=#{IncludeTag}"
    )

    # ref: class IncludeTag < Liquid::Tag
    #+? prev: v1: IncludeTag.send :alias_method, :outside_site_source_orig?, :outside_site_source?

    # FIXME: this (new method) was not executed, so I don't know why:
    #  * is it because the method definition was not "injected" in the right (class) scope?
    #  * using '.' and '::' as a separator between 'IncludeTag' and the method name did not seem to make a difference;
    #- prev: v1: def IncludeTag.outside_site_source?(path, dir, safe)
    IncludeTag.class_exec {
      alias_method :outside_site_source_orig?, :outside_site_source?
      def outside_site_source?(path, dir, safe)
        Jekyll.logger.debug(
          "ev-override-includes:",
          "called IncludeTag::outside_site_source?(#{path}, #{dir}, #{safe})"
        )
        #+ outside_site_source_orig?(path, dir, false)
        #+ testing what would happen when 'safe' is 'true': outside_site_source_orig?(path, dir, true)
        outside_site_source_orig?(path, dir, false)
      end
    }

  end
end

end

# TODO: ts=2 ...
