# source this file like this:
# . "${0%/*}/../common/common_functions.sh" || exit $?

[ -n "${g_prgname}" ] || g_prgname="${0}"

# boilerplate {{{
# orig: . "${0%/*}/sh_functions.sh" || exit $?
. "${0%/*}/../common/local-bin-dir/sh_functions.sh" || exit $?
# }}}

#? prev: v1: (using 'sh_functions.sh' now): f_echo_to_stderr()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	echo "${g_prgname}:" "$@" 1>&2
#? prev: v1: (using 'sh_functions.sh' now): }
#? prev: v1: (using 'sh_functions.sh' now): 
#? prev: v1: (using 'sh_functions.sh' now): f_error()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	f_echo_to_stderr 'ERROR:' "$@"
#? prev: v1: (using 'sh_functions.sh' now): 	return 1
#? prev: v1: (using 'sh_functions.sh' now): }
#? prev: v1: (using 'sh_functions.sh' now): 
#? prev: v1: (using 'sh_functions.sh' now): f_abort()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	f_error "$@" "-- aborting" || exit $?
#? prev: v1: (using 'sh_functions.sh' now): }
#? prev: v1: (using 'sh_functions.sh' now): 
#? prev: v1: (using 'sh_functions.sh' now): f_info()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	f_echo_to_stderr '[info]' "$@"
#? prev: v1: (using 'sh_functions.sh' now): }
#? prev: v1: (using 'sh_functions.sh' now): 
#? prev: v1: (using 'sh_functions.sh' now): # TODO: make conditional (use global variable)
#? prev: v1: (using 'sh_functions.sh' now): f_debug()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	f_echo_to_stderr '[debug]' "$@"
#? prev: v1: (using 'sh_functions.sh' now): }

#? f_cd_required()
#? { #...?
#? }

f_standard_preconditions_check()
{
	[ -n "${JEKYLLDEPLOY_HOOKS_BASE_DIR}" -a -d "${JEKYLLDEPLOY_HOOKS_BASE_DIR}/" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_SOURCE_DIR}" -a -d "${JEKYLLDEPLOY_HOOKS_SOURCE_DIR}/" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_ADJUST_LAST_MODIFIED}" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_BUILD_ONLY}" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_HOOK_ID}" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_TARGET_BRANCH}" ] \
		&& [ -n "${JEKYLLDEPLOY_HOOKS_GIT_REMOTE_NAME}" ] \
		|| f_abort "one or more of the required 'JEKYLLDEPLOY_HOOKS_*' variables is unset or has an invalid value"
}

f_cd_to_basedir()
{
	[ -n "${JEKYLLDEPLOY_HOOKS_BASE_DIR}" ] \
		|| f_error "variable JEKYLLDEPLOY_HOOKS_BASE_DIR needs to be set" \
		|| return $?
	cd "${JEKYLLDEPLOY_HOOKS_BASE_DIR}"
}

f_cd_to_sourcedir()
{
	[ -n "${JEKYLLDEPLOY_HOOKS_SOURCE_DIR}" ] \
		|| f_error "variable JEKYLLDEPLOY_HOOKS_SOURCE_DIR needs to be set" \
		|| return $?
	cd "${JEKYLLDEPLOY_HOOKS_SOURCE_DIR}"
}

f_standard_init()
{
	# IDEA: abstract "*_standard_*()" error handling into a function that the user can override: f_standard_handleerror "$?" "error message (several args...)"
	f_standard_preconditions_check \
		|| f_abort "f_standard_preconditions_check failed"
	: "${JEKYLLDEPLOY_HOOKS_SITECONTENT_PREV_DIR:=${JEKYLLDEPLOY_HOOKS_BASE_DIR}/_site-prev}" \
		&& : "${JEKYLLDEPLOY_HOOKS_SITECONTENT_BUILD_DIR:=${JEKYLLDEPLOY_HOOKS_BASE_DIR}/_site}" \
		&& [ "${JEKYLLDEPLOY_HOOKS_SITECONTENT_PREV_DIR}" != "${JEKYLLDEPLOY_HOOKS_SITECONTENT_BUILD_DIR}" ] \
		&& : "${JEKYLLDEPLOY_HOOKS_GIT_EXEC:=git}" \
		&& : "${g_cmd_git_exec:=${JEKYLLDEPLOY_HOOKS_GIT_EXEC}}" \
		# end
}

#? prev: v1: (using 'sh_functions.sh' now): f_cmd_run()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	[ -n "${1}" ] \
#? prev: v1: (using 'sh_functions.sh' now): 		|| f_error "cmd_run: has to specify a non-empty command" \
#? prev: v1: (using 'sh_functions.sh' now): 		|| return $?
#? prev: v1: (using 'sh_functions.sh' now): 	f_debug "about to run: '$*'"
#? prev: v1: (using 'sh_functions.sh' now): 	"$@"
#? prev: v1: (using 'sh_functions.sh' now): }
#? prev: v1: (using 'sh_functions.sh' now): 
#? prev: v1: (using 'sh_functions.sh' now): # placeholder to abstract passing certain fixed options
#? prev: v1: (using 'sh_functions.sh' now): f_run_git()
#? prev: v1: (using 'sh_functions.sh' now): {
#? prev: v1: (using 'sh_functions.sh' now): 	f_cmd_run "${JEKYLLDEPLOY_HOOKS_GIT_EXEC}" "$@"
#? prev: v1: (using 'sh_functions.sh' now): }

# MAYBE: call f_standard_preconditions_check() here?
#  examples:
#   f_standard_preconditions_check || f_abort "pre-condition checks failed" # force abort
#   f_standard_preconditions_check || return $? # rely on the "check failed error policy" function (would not get to the 'return' if it aborted)
