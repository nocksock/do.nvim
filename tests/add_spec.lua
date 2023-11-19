local r = require
local assert = require 'luassert'

describe("storage", function()
  local add
  local storage

  before_each(function()
    storage = r'do.storage'
    add = r'do.add'
    storage.clear()
  end)

  it("adds an item to the list", function()
    assert.are.same({}, storage.get_all())
    add("thing one")
    add("thing two")
    assert.are.same({"thing one", "thing two"}, storage.get_all())
  end)
end)
