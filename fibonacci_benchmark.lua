-- Fibonacci benchmark with manual timing
function fib(n)
    if n <= 1 then
        return n
    else
        return fib(n-1) + fib(n-2)
    end
end

print("=== Fibonacci Test (Sync Mode) ===")
-- Start benchmark
local result = fib(30)
print("fib(30) = " .. result)
print("Benchmark completed")