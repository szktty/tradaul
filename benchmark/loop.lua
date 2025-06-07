-- Loop performance - basic arithmetic operations
print("=== Loop Test ===")
local start = os.clock()
local sum = 0
for i = 1, 1000000 do
    sum = sum + i * 2 - 1
end
local elapsed = os.clock() - start
print("Loop sum = " .. sum .. " in " .. elapsed .. " seconds")