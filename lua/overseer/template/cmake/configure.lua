return
{
	name = "cmake-configure",

	params = function()
		-- local path = vim.env.PATH
		-- local dirs = vim.split(path, ":", { trimempty = true, plain = true })
		--
		-- local choices = {}
		-- for _, dir in ipairs(dirs) do
		-- 	local compilers = vim.fs.find(
		-- 		{ "g++", "clang++" },
		-- 		{ path = dir, limit = math.huge, type = "link" }
		-- 	)
		--
		-- 	for _, compiler in ipairs(compilers) do
		-- 		local compiler_name = vim.fs.basename(compiler)
		-- 		local compiler_path = vim.fs.dirname(compiler)
		--
		-- 		choices[#choices+1] = compiler_name .. " from " .. compiler_path
		-- 		vim.notify(choices[#choices])
		-- 	end
		-- end

		return
		{
			build_dir =
			{
				type = "string",
				default = "build"
			}
			-- kit =
			-- {
			-- 	type = "enum",
			-- 	choices = choices
			-- },
		}
	end,

	builder = function(params)
		return
		{
			cmd = { "cmake", "-GNinja", "-DCMAKE_EXPORT_COMPILE_COMMANDS=1", "-B", params.build_dir}
		}
	end,

	condition =
	{
		callback = function(search)
			local file = io.open(search.dir .. "/CMakeLists.txt", "r")
			if file == nil then return false end

			io.close(file)
			return true
		end
	}
}
