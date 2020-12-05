#  NOTE: see https://stackoverflow.com/questions/2206714/can-a-ruby-script-tell-what-directory-it-s-in
#  for ideas on how to get the current script's directory.

if !Object.respond_to?(:try) then
  Jekyll.logger.debug(
    "ev-local-hooks:",
    "monkey-patching Object: adding try(label) method"
  )
  Object.class_exec {
    # ref: https://stackoverflow.com/a/25583830
    def try(*a, &b)
      if a.empty? && block_given?
	yield self
      else
	public_send(*a, &b) if respond_to?(a.first)
      end
    end
  }
end

if !Hash.respond_to?(:dig) then
  # example: hash_instance.dig(:key_level_1, :key_level_2)
  # ref: https://stackoverflow.com/a/1820492
  # NOTE: according to a comment under https://stackoverflow.com/a/33691198
  #  there is a gem with Hash::dig() and Array::dig():
  #  https://rubygems.org/gems/ruby_dig
  class Hash
    def dig(*path)
      path.inject(self) do |location, key|
	location.respond_to?(:keys) ? location[key] : nil
      end
    end
  end
end
# MAYBE: add Hash.set_multi(val, *path) (creates a hash if an element with the corresponding key did not exist)
# MAYBE: add hash_set_multi(...) instead? (pretty specific use-case -> not worthy of a base class instance method?)

module LocalGithubPagesCNAME
  def self.cname_set?(cname_current)
    # for now, empty strings are a valid value, and nil is ignored.
    !cname_current.nil?
  end

  # returns the value that needs to be assigned back to the variable passed in as 'cname_current'.
  # example: cname = cn.update_cname(cname, 'new_value')
  def self.update_cname(cname_current, cname_val)
    #? prev: v1: # for now, empty strings are a valid value, and nil is ignored.
    #? prev: v1: # NOTE: matches when cname_current.nil?, too
    #? prev: v1: return cname_current if !cname_current.to_s.empty?
    #? prev: v1: # NOTE: ignores cname_val.nil?
    #? prev: v1: cname_current = cname_val.to_s.downcase if !cname_val.nil?
    return cname_current if cname_set?(cname_current)
    # MAYBE: attempt to use cname_val as a URI, and if the URI(cname_current).host is empty, then use the value as is
    #-? re-assigns local symbol to a new object, leaving caller's referenced object unchanged: cname_current = cname_val.to_s.downcase if cname_set?(cname_val)
    #? if cname_set?(cname_val) then
    #?   cname_current.replace(cname_val.to_s.downcase)
    #? end
    #- does_not_replace_a_nil_object: cname_current.replace(cname_val.to_s.downcase) if cname_set?(cname_val)
    cname_val.to_s.downcase if cname_set?(cname_val)
  end

  def self.detect_cname(site)
    config = site.config

    #- prev: v1: cached_prod_url = site.try(:production_url)
    #? cached_prod_url = config[:production_url]
    cached_prod_url = config['production_url']

    cname_candidate = nil
    # TODO: make more sophisticated, if needed.
    #? cname_candidate = [
    #?   #- prev: v1: site.try(:JB).try(:cname),
    #?   config.dig(:JB, :cname),
    #?   (URI(cached_prod_url).host if !cached_prod_url.nil?),
    #? ].find { | v |
    #?   #- prev: v1: update_cname(cname_candidate, v)
    #?   cname_candidate = update_cname(cname_candidate, v)
    #? }
    [
      config.dig('JB', 'cname'),
      (URI(cached_prod_url).host if !cached_prod_url.nil?),
    ].find { | v |
      Jekyll.logger.debug(
        "ev-local-hooks:",
        "detect_cname(): candidates.find(): processing item. cname_candidate=#{cname_candidate}; v=#{v};"
      )
      #- prev: v1: update_cname(cname_candidate, v)
      cname_candidate = update_cname(cname_candidate, v)
    }
    Jekyll.logger.debug(
      "ev-local-hooks:",
      "detect_cname(): about to return. cname_candidate=#{cname_candidate}"
    )
    cname_candidate
  end
end
