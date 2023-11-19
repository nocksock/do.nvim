describe("compose", function ()
  it("calls the composed function l to r", function()
    local chain = R'do.compose'(
      function() return 1 end,
      function() return 2 end,
      function() return 3 end
    )

    assert.are.same(3, chain())
  end)

  it("passes the results to the next", function()
    local chain = R'do.compose'(
      function(prev) return prev + 1 end,
      function(prev) return prev + 2 end,
      function(prev) return prev + 3 end
    )

    assert.are.same(6, chain(0))
  end)
end)
