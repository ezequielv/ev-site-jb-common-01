if false then # NOTE: put here for historic purposes

#? # TODO: add source stackoverflow link
#+ require File.join(__dir__, 'locallib-all.rb')
require_relative 'locallib-all.rb'

# ref: https://jekyllrb.com/docs/plugins/generators/

module LocalGithubPagesCNAME
  cname_out_path = '/CNAME'

  class Generator < Jekyll::Generator
    def generate(site)
      Jekyll.logger.debug(
        "ev-local-hooks:",
        "running generator plugin LocalGithubPagesCNAME::Generator::generate()"
      )

      files_list = site.static_files
      # TODO: only do this if the file does not exist already

      cname_val = nil
      # config entry: JB.cname (string)
      update_cname(cname_val, site.try(:JB).try(:cname))
      # TODO: continue (detect github pages deployments, then check whether the url has '*.github.io' in it, for example)

      # TODO: generate the static file, if needed (check cname_val, too)
    end
  end
end

end # if true/false ...
