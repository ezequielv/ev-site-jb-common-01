" pre-condition checks {{{
if v:version < 700
	finish
endif
" }}}

" conditional initialisation {{{
let s:reload_flag = get(g:, 'ev_blog_common_localrc_reload', 0)

" NOTE: defined early so that it can be used as early as possible by this
" script.
let s:debug_flag = get(g:, 'ev_blog_common_localrc_debug', 0)
if s:debug_flag
	function! s:debugmsg(s)
		echomsg '[debug] ' . a:s
		return !0
	endfunction
else
	function! s:debugmsg(...)
	endfunction
endif

if (! exists('s:source_file_this')) || s:reload_flag
	let s:source_file_this = expand('<sfile>')
endif
if (! exists('s:source_dir_this')) || s:reload_flag
	let s:source_dir_this = fnamemodify(s:source_file_this, ':h')
endif

" build on top of the "common" pre and post '.local-pre.vimrc' files

if (! exists('s:commonfiles_rootdir')) || s:reload_flag
	let s:commonfiles_rootdir = s:source_dir_this . '/common/src/jb-common-01'
endif

if (! exists('s:commonfiles_localrcpre_pref')) || s:reload_flag
	let s:commonfiles_localrcpre_pref = 
				\	fnamemodify(s:source_file_this, ':t:r') .
				\	'-'
endif
if (! exists('s:commonfiles_localrcpre_suff')) || s:reload_flag
	let s:commonfiles_localrcpre_suff =
				\	'.' .
				\	fnamemodify(s:source_file_this, ':e')
endif

" prev: v1: if (! exists('s:commonfiles_localrcpre_pre_filename')) || s:reload_flag
" prev: v1: 	let s:commonfiles_localrcpre_pre_filename =
" prev: v1: 				\	s:commonfiles_localrcpre_pref .
" prev: v1: 				\	'pre' .
" prev: v1: 				\	s:commonfiles_localrcpre_suff
" prev: v1: endif
" prev: v1: if (! exists('s:commonfiles_localrcpre_post_filename')) || s:reload_flag
" prev: v1: 	let s:commonfiles_localrcpre_post_filename =
" prev: v1: 				\	s:commonfiles_localrcpre_pref .
" prev: v1: 				\	'post' .
" prev: v1: 				\	s:commonfiles_localrcpre_suff
" prev: v1: endif

" compatibility section {{{
if exists('*fnameescape')
	let s:fnameescape = function('fnameescape')
elseif (! exists('*s:fnameescape')) || s:reload_flag
	function! s:fnameescape(s)
		return escape(a:s, '\ ')
	endfunction
endif
" }}}

" functions {{{
function! s:source_opt(fname)
	call s:debugmsg('attempting to detect vim script file: ' . a:fname)
	if filereadable(a:fname)
		call s:debugmsg(' found. sourcing . . .')
		execute 'source ' . s:fnameescape(a:fname)
		return !0
	endif
	return 0
endfunction

function! s:source_part(partid)
	if empty(a:partid)
		return 0
	endif

	for l:base_dir in [
				\		s:source_dir_this,
				\		s:commonfiles_rootdir,
				\	]
		if s:source_opt(
					\		l:base_dir . '/' .
					\		s:commonfiles_localrcpre_pref .
					\		a:partid .
					\		s:commonfiles_localrcpre_suff
					\	)
			return !0
		endif
	endfor
	return 0
endfunction
" }}}

" }}}

" source parts, in order {{{

" be aware that the '.local-pre.vimrc' script executes 'call
" localrc#load('.local-pre.vimrc')', which in turn navigates the directory
" tree upwards, and "sources" files top-to-bottom in the tree (see ':h
" localrc-usage').
"
" example: running ':e' in a buffer already containing the '[blog-tech]/modules/pub/ev-site-jb-common-01/.gitignore' file.
"  (note: forced reloading by previously executing
"   :let g:ev_blog_common_localrc_reload=1
"  )
"
"  [debug] attempting to detect and source file: [blog-tech]/.local-pre-pre.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/common/src/jb-common-01/.local-pre-pre.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/.local-pre-local.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/common/src/jb-common-01/.local-pre-local.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/.local-pre-post.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/common/src/jb-common-01/.local-pre-post.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/modules/pub/ev-site-jb-common-01/.local-pre-pre.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/modules/pub/ev-site-jb-common-01/.local-pre-local.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/modules/pub/ev-site-jb-common-01/common/src/jb-common-01/.local-pre-local.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/modules/pub/ev-site-jb-common-01/.local-pre-post.vimrc
"  [debug] attempting to detect and source file: [blog-tech]/modules/pub/ev-site-jb-common-01/common/src/jb-common-01/.local-pre-post.vimrc
"  "[blog-tech]/modules/pub/ev-site-jb-common-01/.gitignore" 25L, 346C

for s:tmp_partid in [ 'pre', 'local', 'post' ]
	call s:source_part(s:tmp_partid)
endfor
" }}}
