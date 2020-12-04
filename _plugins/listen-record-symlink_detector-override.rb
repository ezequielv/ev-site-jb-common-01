require 'listen/record'
require 'listen/record/symlink_detector'

module Listen
  # NOTE: fix #1: make the error message shorter (1-line), so it can be "grepped"-out with a command like this: {{{
  #   $ bundle exec jekyll serve 2>&1 | grep -vie '\berror:.*already watched through' -e '^[[:blank:]]*$' ; echo "rc: $?"
  #
  #-? # NOTE: idea from https://stackoverflow.com/a/35634142/2733708 {{{
  #-? Record::SymlinkDetector::SYMLINK_LOOP_ERROR = Record::SymlinkDetector::SYMLINK_LOOP_ERROR.dup if Record::SymlinkDetector::SYMLINK_LOOP_ERROR.frozen?
  #-? # }}}
  # NOTE: simple implementation based on an idea from https://stackoverflow.com/a/3377188/2733708 {{{
  Record::SymlinkDetector.send(:remove_const, "SYMLINK_LOOP_ERROR")
  # }}}

  #+/- Record::SymlinkDetector::SYMLINK_LOOP_ERROR = 'ERROR: dir "%s" already watched through "%s"'.freeze
  Record::SymlinkDetector::SYMLINK_LOOP_ERROR = <<-EOS.freeze

  ERROR: dir '%s' already watched through '%s'
  EOS
  # }}}
end
