-- Test what the parser actually produces
local test = "\\v\\f"
print("Parsed string bytes:")
for i = 1, string.len(test) do
    print(i, string.byte(test, i))
end