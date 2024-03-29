if status is-interactive
    # Commands to run in interactive sessions can go here


	fish_vi_key_bindings
	# Emulates vim's cursor shape behavior
	# Set the normal and visual mode cursors to a block
	set fish_cursor_default block
	# Set the insert mode cursor to a line
	set fish_cursor_insert line
	# Set the replace mode cursor to an underscore
	set fish_cursor_replace_one underscore
	# The following variable can be used to configure cursor shape in
	# visual mode, but due to fish_cursor_default, is redundant here
	set fish_cursor_visual underscore
	set fish_vi_force_cursor

	starship init fish | source
end
