local r      = require
local stub   = r 'luassert.stub'
local assert = r 'luassert.assert'

describe("update", function()
  local update

  before_each(function()
    r 'plenary.reload'.reload_module("do.")
    update = r 'do.update'
  end)

  after_each(function()
    r 'do.update'.clear()
  end)

  it("triggers subscribed methods", function()
    local spy = stub()
    local sub = function() spy() end
    update.subscribe(sub, false)
    update("foo")
    assert.stub(spy).was_called(1)
  end)

  it("triggers subscribed methods with the args passed to update", function()
    local spy = stub()
    local sub = function(arg) spy(arg) end
    update.subscribe(sub, false)
    update("foo")
    assert.stub(spy).was_called_with("foo")
  end)

  it('has unsubscribe', function()
    local spy = stub()
    local sub = function() spy() end
    update.subscribe(sub, false)
    update.unsubscribe(sub)
    update("foo")
    assert.stub(spy).was_not_called()
  end)

  it('has clear', function()
    local spy = stub()
    local sub = function() spy() end
    update.subscribe(sub, false)
    update.clear()
    update("foo")
    assert.stub(spy).was_not_called()
  end)

  it('calls unmount function if it exists', function()
    local cleanup = stub()
    local sub = { stub(), function() cleanup() end }
    update.subscribe(sub, false)
    update.unsubscribe(sub)
    assert.stub(cleanup).was_called(1)
  end)
end)
