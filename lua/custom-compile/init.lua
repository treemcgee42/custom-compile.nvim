--- `formats` is an array of strings.
local generate_error_format = function(formats)
	-- Go through `formats`. If it matches on the the default ones (like "zig"), then replace it with the
	-- predefined format.
	for i, format in ipairs(formats) do
		if format == "zig" then
			-- Ideally this would work. Maybe it will for other langs?
			-- vim.cmd("compiler zig_build")
			-- print(vim.o.errorformat)
			-- formats[i] = vim.o.errorformat

			formats[i] = [[%f:%l:%c:\ %t%*[^:]:\ %m,%-G%.%#]]
		end
	end

	return table.concat(formats, ",") .. [[,%-G%.%#]]
end

local Plugin = {
	settings = nil,
	task_definitions = nil,
	default_task_idx = nil,
	task_names = nil,

	-- Methods
	do_task = nil,
	do_default_task = nil,
	list_tasks = nil,
	setup = nil
}

Plugin.do_task = function(task_idx)
	local definition = Plugin.task_definitions[task_idx]

	vim.cmd(
		string.format(
			"set errorformat=%s",
			generate_error_format(definition["error_formats"])
		)
	)

	vim.cmd(
		string.format(
			"set makeprg=%s",
			definition["program"]
		)
	)

	vim.cmd(
		string.format(
			"make %s",
			definition["args"]
		)
	)
end

Plugin.do_default_task = function()
	if not Plugin.default_task_idx then
		print("No default task set.")
		return
	end

	Plugin.do_task(Plugin.default_task_idx)
end

Plugin.list_tasks = function()
	vim.ui.select(
		Plugin.task_names,
		{ prompt = 'Select a task:' },
		function(name, idx)
			if not name then
				return
			end

			Plugin.do_task(idx)
		end
	)
end

Plugin.setup = function(opts)
	-- Default settings
	local settings = {
		definition_file = "./.nvim/custom-compile.lua",
		key_bindings = {
			do_default_task = "<Leader>B",
			list_taks = "<Leader>b"
		}
	}

	-- Overwrite default settings with user settings
	if opts then
		for k, v in pairs(opts) do
			settings[k] = v
		end
	end

	Plugin.settings = settings

	-- Get the table returned by the definition file. This definines all available tasks.
	-- TODO: validate `definitions` if not nil.
	local definitions = dofile(settings.definition_file)
	Plugin.task_definitions = definitions

	--- Create an array of task names. Each task in the `definitions` table has a `name` field.
	local task_names = {}
	local default_task_idx = nil
	for idx, definition in pairs(definitions) do
		table.insert(task_names, definition.name)
		if definition.default == true then
			default_task_idx = idx
		end
	end
	Plugin.task_names = task_names
	Plugin.default_task_idx = default_task_idx

	-- Register key bindings.

	vim.keymap.set("n", settings.key_bindings.do_default_task, Plugin.do_default_task)
	vim.keymap.set("n", settings.key_bindings.list_taks, Plugin.list_tasks)
end

return Plugin
