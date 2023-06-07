### file regex matching ###
# usage match <regex> [directory]
function match
	if test \( -n "$argv[2]" \) -a \( -d "$argv[2]" \)
		string match -r "$argv[2]/$argv[1]" $argv[2]/*
	else
		string match -r "$argv[1]" *
	end
end
