local stub       = require 'luassert.stub'
local assert     = require 'luassert.assert'

---@type DoAction
local add_action = function(item)
  return function(prev_state)
    table.insert(prev_state.todos, item)
    return prev_state
  end
end


describe("dispatch", function()
  local dispatch
  local update

  before_each(function()
    require 'plenary.reload'.reload_module("do.")
    update = stub()
    package.loaded['do.update'] = update
    dispatch = require 'do.dispatch'
    require'do'.setup {}
  end)

  it("expects a reducer", function()
    local new_state = dispatch(add_action("foo"), { todos = {} })
    assert.are.same({ "foo" }, new_state.todos)
  end)

  it('returns the new state', function()
    assert.are.same({ name = "bar" }, dispatch(function()
      return { name = "bar" }
    end, { name = "foo" }))
  end)

  it('handles mutations inside action', function()
    local og_state = { name = "foo", ref = {} }
    local ref = og_state.ref

    local new_state = dispatch(function(old_state)
      old_state.ref = { new = true }
    end, og_state)

    -- doesn't mutate state
    assert.are.equal(og_state.ref, ref)
    assert.are.not_equal(new_state.ref, og_state.ref) -- due to deep copy, maybe change to only copy changed states?
    assert.are.same(new_state, { name = "foo", ref = { new = true } })
  end)

  -- TODO: not sure if this is a good idea or if it would be better to merge 
  -- the two states. Probably something to decide when there are more use cases.
  it('favors returned over mutated value', function()
    local og_state = { name = "foo", ref = {} }

    local new_state = dispatch(function(old_state)
      old_state.ref = { new = true }
      return { other = "bar" }
    end, og_state)

    assert.are.same(new_state, { name = "foo", other = "bar", ref = { new = true } })
  end)

  it('passes a resolver as second argument for async actions when giving it a function', function()
    local on_resolve = stub()

    dispatch(function(_, resolve)
      resolve({ name = "bar" })
    end, nil, { on_resolve = on_resolve })

    assert.stub(on_resolve).was_called_with({ name = "bar" })
  end)

  -- it.todo('it calls do.update with the new state', function()
  --   dispatch(function(_, resolve)
  --     resolve({ selected = 1 })
  --   end, { todos = { "a", "b" }, selected = nil })
  --
  --   assert.stub(update).was_called_with({ selected = 1, todos = { "a", "b" } })
  -- end)
end)
