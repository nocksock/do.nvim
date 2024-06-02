next:  
- [x] create file source
- [x] create winbar
- [x] fix "not enough room"-error eg in lsp hover
- [x] rename `do.update` to `do.on_update` or maybe move it into state (so it reads 'do.state'.subscribe or 'do.state'.on_update
- [x] update state when do-file has been modified
- [ ] add context to todo (file path, selection)
- [x] winbar: update when todo-file is updated
- [ ] create management view

Q: How to manage multiple sources in the management view?
- eg github and file, maybe separate in sections 
- oil.nvim like interface?


flux-like architecture:
event -> dispatch action -> function over old state -> send new state to subscribers

subscribers = views to render
subscribers += sources to update

Goals:
- easy to add custom sources
- easy to add custom views
- keeping the core simple
- move complexity into extensions
- keep core mostly about handling state, ideally not tied to todos at all

Features:
- Done -> move into list, save with timestamp
- Did -> open git log like view with done tasks
useful when writing git commits or daily/weekly updates
