print('Testing escape sequence parsing')

-- Test the individual escape sequences
print("Testing \\v:", string.byte('\v'))
print("Testing \\f:", string.byte('\f'))
print("Testing \\t:", string.byte('\t'))
print("Testing \\r:", string.byte('\r'))
print("Testing \\0:", string.byte('\0'))

-- Build the problematic string step by step
local str1 = "x = 1"
print("Simple assignment:", str1)
local chunk1 = load(str1)
if chunk1 then
    print("  Load successful")
    chunk1()
    print("  x =", x)
else
    print("  Load failed")
end

-- Try with whitespace
local str2 = "x\v\f=\t\r1"
print("With control chars:", str2)
local chunk2 = load(str2)
if chunk2 then
    print("  Load successful")
    chunk2()
    print("  x =", x)
else
    print("  Load failed")
end