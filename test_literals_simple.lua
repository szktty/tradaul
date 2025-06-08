print('testing scanner')

local debug = require "debug"

local function dostring (x) return assert(load(x), "")() end

print("Testing the problematic string...")
-- This is the string that was failing before
local test_str = "x \\v\\f = \\t\\r 'a\\0a' \\v\\f\\f"
print("String to load:", test_str)

local chunk, err = load(test_str)
if chunk then
    print("Load successful")
    chunk()
    print("x =", x)
    print("string.len(x) =", string.len(x))
    assert(x == 'a\0a' and string.len(x) == 3)
    print("Assertion passed!")
else
    print("Load failed:", err)
end