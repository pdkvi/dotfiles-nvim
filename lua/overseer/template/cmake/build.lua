return
{
	name = "cmake-build",

	params = function()
		return
		{
			build_dir =
			{
				type = "string",
				default = "build"
			}
		}
	end,

	builder = function(params)
		return
		{
			cmd = { "cmake", "--build", params.build_dir}
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
