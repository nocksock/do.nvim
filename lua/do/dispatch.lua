---@alias DoReducer function(state: DoState, resolve?: function(state: DoState): nil)
---@alias DoEvent { action: DoReducer, args?: any }
---@alias DoAction<T> function(T): DoReducer

local merge_state = function(state_clone, new_state)
  if new_state == nil then
    return state_clone
  end
  return vim.tbl_deep_extend("force", state_clone, new_state)
end

---@param reducer DoReducer
---@param state DoState
---@param opts? { on_resolve?: function }
---@return DoState
return function (reducer, state, opts)
  -- TODO: instead of a deepcopy, it might be nice to track mutations via
  -- operator overloading in the meta-table merge with those. Might be
  -- worthwhile whit a lot of tasks etc
  local state_clone = vim.deepcopy(state)

  local on_resolve = opts and opts.on_resolve or function(new_state)
    state_clone = vim.deepcopy(require'do.state'.get()) -- apply the resolved state to the most recent state, not the one above which is potentially outdated
    require'do.update'(merge_state(state_clone, new_state))
  end

  local new_state = reducer(state_clone, on_resolve)
  return merge_state(state_clone, new_state)
end
