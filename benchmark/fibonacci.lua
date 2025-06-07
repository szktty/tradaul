-- Fibonacci (recursive) - function call overhead測定
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