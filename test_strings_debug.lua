print('testing strings and string library')

local maxi = math.maxinteger
local mini = math.mininteger

print("maxi:", maxi)
print("mini:", mini)

local function checkerror (msg, f, ...)
  local s, err = pcall(f, ...)
  assert(not s and string.find(err, msg))
end

print("checkerror function defined")

-- Test string comparisons
assert('alo' < 'alo1')
print("First assertion passed")