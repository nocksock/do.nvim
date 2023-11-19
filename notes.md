next:  handle async select

maybe have actions return a resolver? Similar to promises

function Promise()
end

function select(state, payload, resolve)
    return function(resolve)
        vim.ui.select(state.tasks, {}, function(selected)
            resolve(selected)
        end)
    end
end
