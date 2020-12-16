# done: move functions from reposetup and 'common_functions.sh'
# done: source this file from 'common_functions.sh' using either a symlink or a relative path (as that file will be moved to 'modules/pub/.../', so a symlink might be a better way to go about it)
# done: move some/all of the files under 'hooks/common' to a directory under 'modules/pub/...'

# conditional initialisation {{{
: "${g_prgname:=${0##*/}}"
if [ -z "${g_prgpath}" ] ; then
	g_prgpath="${0%/*}" \
		&& [ "${g_prgpath}" != "$0" ] \
		|| g_prgpath="${PWD}"
fi
# }}}

f_echo_to_stdout()
{
	echo "${g_prgname}:" "$@" 1>&2
}

f_info()
{
	f_echo_to_stdout '[info]' "$@"
}

f_debug_enabled()
{
	[ -n "${g_debug_flag}" ]
}

f_debug()
{
	[ -n "${g_debug_flag}" ] || return 0
	f_echo_to_stdout '[debug]' "$@"
}

f_error()
{
	f_echo_to_stdout "ERROR:" "$@"
	return 1
}

f_abort()
{
	f_error "$@" "-- aborting" || exit $?
}

# defaults {{{
unset \
	g_dryrun_flag \
	g_debug_flag \
	# end
# }}}

f_cmd_run()
{
	f_info "cmd_run: about to run${g_dryrun_flag:+ (dry run)}: '$*'"
	[ -n "${g_dryrun_flag}" ] \
		|| "$@"
}

# args: SRC DST
f_cmd_ln_s()
{
	f_cmd_run ln -sv "$@"
}

f_ln_all_src_to_single_dst()
{
	local \
		l_opt_onlysrcexisting=0 \
		l_arg_full \
		l_arg_key \
		l_arg_val \
		l_dst \
		l_src_now \
		l_rc \
		# end

	while [ $# -gt 0 ] ; do
		l_arg_full="$1"
		l_arg_key="${l_arg_full%%=*}"
		l_arg_val="${l_arg_full#*=}"

		case "${l_arg_key}" in
			--only-src-existing )
				l_opt_onlysrcexisting=1 ;;

			-- )
				shift
				break
				;;

			-* )
				f_error "f_ln_all_src_to_single_dst(): unrecognised/unsupported option: '${l_arg_full}'" \
					|| return $?
				;;

			* )
				break ;;
		esac

		shift
	done

	l_dst="$1"
	[ -n "${l_dst}" ] \
		|| f_error "f_ln_all_src_to_single_dst(): must specify a destination" \
		|| return $?
	shift

	if [ ${l_opt_onlysrcexisting} -ne 0 ] ; then
		l_rc=0
		for l_src_now in "$@" ; do
			[ -e "${l_src_now}" ] \
				|| continue
			f_cmd_ln_s "${l_src_now}" "${l_dst}" \
				|| f_error "failed to symlink '${l_src_now}' -> '${l_dst}'. continuing src list processing." \
				|| l_rc=$?
		done
		return ${l_rc}
	else
		f_cmd_ln_s "$@" "${l_dst}"
		return $?
	fi
}

f_cmd_git_gen()
{
	#+ prev: v1: f_cmd_run git "$@"
	f_cmd_run "${g_cmd_git_exec:=git}" "$@"
}

# }}}

