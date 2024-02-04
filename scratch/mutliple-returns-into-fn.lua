local function foo() return 1, 2, 3 end

local function other(a,b)
  P({a = a, b = b})
end

other({foo()}, "foo")
