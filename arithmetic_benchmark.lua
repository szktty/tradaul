-- Arithmetic-heavy benchmark to test sync optimizations
print("=== Arithmetic Benchmark ===")
local start = os.clock()

local result = 0
for i = 1, 100000 do
    result = result + i * 2
    result = result - i / 3
    result = result % 1000
    if i % 2 == 0 then
        result = result | 1
    else
        result = result & 0xFFFF
    end
end

local elapsed = os.clock() - start
print("Result: " .. result .. " in " .. elapsed .. " seconds")