-- String operations - string concatenation
print("=== String Test ===")
local start = os.clock()
local str = ""
for i = 1, 10000 do
    str = str .. "a"
end
local elapsed = os.clock() - start
print("String concat (" .. #str .. " chars) in " .. elapsed .. " seconds")