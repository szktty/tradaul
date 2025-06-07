-- Table operations - indexing performance
print("=== Table Test ===")
local start = os.clock()
local t = {}
for i = 1, 100000 do
    t[i] = i * i
end
local tableSum = 0
for i = 1, 100000 do
    tableSum = tableSum + t[i]
end
local elapsed = os.clock() - start
print("Table operations in " .. elapsed .. " seconds")