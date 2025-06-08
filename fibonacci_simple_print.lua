-- Simple fibonacci with basic print
function fib(n)
    if n <= 1 then
        return n
    else
        return fib(n-1) + fib(n-2)
    end
end

print("Starting fibonacci calculation...")
local result = fib(30)
print("Result calculated")
-- Just confirm it runs
if result == 832040 then
    print("Correct result!")
else
    print("Wrong result!")
end