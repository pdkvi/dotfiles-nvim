" what's going on here is a total disaster!
" TODO: rewrite

function! CppIndent()
	let l:prenum = prevnonblank(v:lnum - 1)
	let l:preprenum = prevnonblank(l:prenum - 1)

	" --- templates
	if match(getline(v:lnum), '^\s*template') != -1
		if match(getline(l:prenum), '^\s*namespace.*{\s*$') != -1
			return indent(l:prenum)
		endif

		if match(getline(l:preprenum), '^\s*namespace.*$') != -1
			if match(getline(l:prenum), '{') != -1
				return indent(l:prenum)
			endif
		endif
	endif

	if match(getline(l:prenum), '^\s*template') != -1
		if match(getline(v:lnum), '^\s*<') != -1
			return indent(l:prenum)
		endif
	endif

	if match(getline(v:lnum), '^\s*typename') != -1
		if match(getline(l:prenum), '\(template\s*<\|<\)\s*$') != -1
			return indent(l:prenum) + shiftwidth()
		endif
	endif

	if match(getline(l:prenum), ',\s*$') != -1
		if cindent(v:lnum) > cindent(l:prenum)
			return cindent(v:lnum)
		endif

		return indent(l:prenum)
	endif

	if match(getline(v:lnum), '^\s*>') != -1
		return indent(l:prenum) - shiftwidth()
	endif
	" --- templates

	" --- lambdas
	if match(getline(v:lnum), '^\s*{') != -1
		return indent(l:prenum)
	endif
	" --- lambdas

	return cindent(v:lnum)
endfunction

set indentexpr=CppIndent()
