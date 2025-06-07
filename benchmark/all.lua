-- All benchmarks runner
-- Load and run all benchmark files

-- Fibonacci benchmark
function fib(n)
    if n <= 1 then
        return n
    else
        return fib(n-1) + fib(n-2)
    end
end

print("=== Fibonacci Test ===")
local start = os.clock()
local result = fib(30)
local elapsed = os.clock() - start
print("fib(30) = " .. result .. " in " .. elapsed .. " seconds")

-- Loop benchmark
print("\n=== Loop Test ===")
start = os.clock()
local sum = 0
for i = 1, 1000000 do
    sum = sum + i * 2 - 1
end
elapsed = os.clock() - start
print("Loop sum = " .. sum .. " in " .. elapsed .. " seconds")

-- Table benchmark
print("\n=== Table Test ===")
start = os.clock()
local t = {}
for i = 1, 100000 do
    t[i] = i * i
end
local tableSum = 0
for i = 1, 100000 do
    tableSum = tableSum + t[i]
end
elapsed = os.clock() - start
print("Table operations in " .. elapsed .. " seconds")

-- String benchmark
print("\n=== String Test ===")
start = os.clock()
local str = ""
for i = 1, 10000 do
    str = str .. "a"
end
elapsed = os.clock() - start
print("String concat (" .. #str .. " chars) in " .. elapsed .. " seconds")