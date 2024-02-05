local assert = require 'luassert'

local to_event = R 'do.input_to_event'
local add_action = require 'do.action.add'

describe("input_to_event", function()
  it('returns and event with an action', function()
    local handler = to_event({
      fargs = { ".add", "foo", "bar" },
      bang = false
    })

    assert.are.same({
      action = add_action,
      args = "foo bar"
    }, handler)
  end)

  it('falls back to add', function()
    local handler = to_event({
      fargs = { "foo", "bar" },
      bang = false
    })

    assert.are.same({
      action = add_action,
      args = "foo bar"
    }, handler)
  end)
end)
