# from https://stackoverflow.com/a/36861807/2733708
require 'jekyll-watch'
module Jekyll
  module Watcher
    # replace old method by new method
    # new method is now :custom_excludes
    # overridden method is now :old_custom_excludes
    alias_method :old_custom_excludes, :custom_excludes
    def custom_excludes(options)
      # if we have an "exclude_from_watch" variable in configuration
      if options['exclude_from_watch'] then
        # merge exclude and exclude_from_watch
        (options['exclude'] << options['exclude_from_watch']).flatten!
      end
      # pass the new option array to overridden method
      old_custom_excludes(options)
    end
  end
end

# DEBUG: puts "hello from modules/pub/ev-site-jb-common-01/_plugins/jekyll-watcher-override.rb"
# TODO: ts=2 ...
