# ref: https://jekyllrb.com/docs/plugins/hooks/
#  Jekyll::Hooks.register :pages, :post_render do |page|
#    # code to call after Jekyll renders a page
#  end

# prev: v1: # NOTE: superseded by '_plugins/plugin-generator-github-pages-cname.rb'
# prev: v1: if false then
if true then

#? # TODO: add source stackoverflow link
#+ require File.join(__dir__, 'locallib-all.rb')
require_relative 'locallib-all.rb'

require 'jekyll'

#-? this_module_id = '_plugins/hook-github-pages-cname.rb'

module LocalHooks
  # module alias
  cn = LocalGithubPagesCNAME

  # TODO: make this more sophisticated, if needed (based on the source root, for example)
  def self.this_module_id(f)
    # v1: f
    File.basename(f)
  end

  Jekyll.logger.debug(
    "ev-local-hooks:",
    "defining hooks in ".concat(this_module_id(__FILE__))
  )

  if false then
  Jekyll::Hooks.register :site, :post_write do |site|
    # TODO: get source name from runtime instead
    Jekyll.logger.debug(
      "ev-local-hooks:",
      "running hook for :site, :post_write in #{this_module_id(__FILE__)}"
    )
    # prev: v1: conditionally generate the 'CNAME' file

    # if site. ...
  end
  end # if true/false ...

  if true then
  Jekyll::Hooks.register :site, :after_init do |site|
    Jekyll.logger.debug(
      "ev-local-hooks:",
      "running [JB.cname optional setting] hook for :site, :after_init in #{this_module_id(__FILE__)}"
    )

    config = site.config

    Jekyll.logger.debug(
      "ev-local-hooks:",
      #- prev: v1: "site.config.JB : #{site.config.JB}"
      #? "site.config[:JB] : #{site.config[:JB]}"
      "config['JB'] : #{config['JB']}"
    )

    #? if site.try(:JB).try(:cname) then
    #- prev: v1: if cn.cname_set?(site.try(:JB).try(:cname)) then
    if cn.cname_set?(config.dig('JB', 'cname')) then
      Jekyll.logger.debug(
        "ev-local-hooks:",
        "(already set) config['JB']['cname'] : #{config['JB']['cname']}"
      )
      return
    end

    cname_val = cn.detect_cname(site)
    # write it to the config entry
    if cn.cname_set?(cname_val) then
      Jekyll.logger.debug(
        "ev-local-hooks:",
        "detected cname : #{cname_val}"
      )
      #? site.JB.cname = cname_val
      #- prev: v1: site.JB.cname = cname_val
      config['JB']['cname'] = cname_val
    end

    Jekyll.logger.debug(
      "ev-local-hooks:",
      #- prev: v1: "site.JB.cname : #{site.try(:JB).try(:cname)}"
      "config['JB']['cname'] : #{config.dig('JB', 'cname')}"
    )

    # TODO: consume the value from a liquid-generated/processed CNAME file
  end
  end # if true/false ...

end

end # if true/false ...

