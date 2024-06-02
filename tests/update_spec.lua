local r      = require
local stub   = r 'luassert.stub'
local assert = r 'luassert.assert'

describe("update", function()
  local state

  before_each(function()
    r 'plenary.reload'.reload_module("do.")
    state = r 'do.state'
  end)

  after_each(function()
    r 'do.state'.clear()
  end)

  it("triggers subscribed methods", function()
    local spy = stub()
    local sub = function() spy() end
    state.subscribe(sub, false)
    state.set("foo")
    assert.stub(spy).was_called(1)
  end)

  it("triggers subscribed methods with the args passed to update", function()
    local spy = stub()
    local sub = function(arg) spy(arg) end
    state.subscribe(sub, false)
    state.set("foo")
    assert.stub(spy).was_called_with("foo")
  end)

  it('has unsubscribe', function()
    local spy = stub()
    local sub = function() spy() end
    state.subscribe(sub, false)
    state.unsubscribe(sub)
    state.set("foo")
    assert.stub(spy).was_not_called()
  end)

  it('has clear', function()
    local spy = stub()
    local sub = function() spy() end
    state.subscribe(sub, false)
    state.clear()
    state.set("foo")
    assert.stub(spy).was_not_called()
  end)

  it('calls unmount function if it exists', function()
    local cleanup = stub()
    local sub = { stub(), function() cleanup() end }
    state.subscribe(sub, false)
    state.unsubscribe(sub)
    assert.stub(cleanup).was_called(1)
  end)
end)
