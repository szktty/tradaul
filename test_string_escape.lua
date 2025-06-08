print("Testing string escape processing")

-- Test if our string parser correctly handles escape sequences
local str = "x \\v\\f = 1"
print("String with escapes:", str)

-- This should work - the string should contain actual control characters
local chunk, err = load(str)
if chunk then
    print("Load successful")
else
    print("Load failed:", err)
end