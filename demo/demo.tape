Output demo/demo.gif

Set FontSize 24
Set LineHeight 1.4
Set Width 1280
Set Height 960
Set Padding 8

Hide
Type "nvim"
Enter
Type ":colors tokyonight-night"
Enter
Ctrl+L
Show

Sleep 500ms

Type "iHello there!"
Enter@125ms
Enter@125ms
Type "do.nvim is a little helper to remind you of what you're currently doing."
Sleep 250ms
Type " Look."

Escape@250ms

Type ":Do Get a basic understanding of what do.nvim can do."
Enter@2
Sleep 500ms

Type "oLook at that bar at the top." 
Sleep 2
Type " Cute, right?"
Enter

Type "It will always be visible and follow you around."
Enter
Enter
Type "Of course it's not limited to just one entry!"
Escape@500ms
Sleep 2

Type ":Do add do.nvim to your nvim config."
Enter@2
Sleep 250ms

Type "oNew items will be appended to a list."
Sleep 250ms
Type " To add something to the top, use :Do!"
Sleep 125ms
Escape@500ms

Type ":Do! update to at least neovim 0.8"
Enter@1

Sleep 2

Type "oTo manage the list, there's :DoEdit, which will open a buffer in a popup."
Escape@125ms

Type ":DoEdit"
Enter@1
Sleep 2

Type@125ms "dd"
Type@1s "p"

Sleep 1

Type "oStar do.nvim on github!"
Escape@1s
Type@1 "q"

Type "oRemove the top item quickly with :Done"
Escape@1
Type ":Done"
Enter@1

Sleep 2
Type "oType :DoSave to persist the list in a .do_task file, "
Sleep 125ms
Type "and it loads automatically next time you start nvim in that folder!"
Enter
Enter
Type "No longer forget what you were doing while digging deep in code!"
Sleep 125ms
Escape@500ms
Type ":Do Tell your friends"
Enter@2
Sleep 500ms
