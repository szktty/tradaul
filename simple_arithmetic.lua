-- Simple arithmetic benchmark
print("=== Simple Arithmetic Benchmark ===")
local start = os.clock()

local result = 0
for i = 1, 200000 do
    result = result + i * 2
    result = result - i / 3
    result = result % 1000
end

local elapsed = os.clock() - start
print("Result: " .. result .. " in " .. elapsed .. " seconds")