local modules = { "build", "configure" }
for i, _ in ipairs(modules) do
	modules[i] = "cmake." .. modules[i]
end

return modules
