-- local utils = require('do.utils')
local joy = vim.split([[
(* ^ ω ^)
(´ ∀ ` *)
٩(◕‿◕｡)۶
☆*:.｡.o(≧▽≦)o.｡.:*☆
(o^▽^o)
(⌒▽⌒)☆
<(￣︶￣)>
。.:☆*:･'(*⌒―⌒*)))
ヽ(・∀・)ﾉ
(´｡• ω •｡`)
(￣ω￣)
｀;:゛;｀;･(°ε° )
(o･ω･o)
(＠＾◡＾)
ヽ(*・ω・)ﾉ
(o_ _)ﾉ彡☆
(^人^)
(o´▽`o)
(*´▽`*)
｡ﾟ( ﾟ^∀^ﾟ)ﾟ｡
( ´ ω ` )
(((o(*°▽°*)o)))
(≧◡≦)
(o´∀`o)
(´• ω •`)
(＾▽＾)
(⌒ω⌒)
∑d(°∀°d)
╰(▔∀▔)╯
(─‿‿─)
(*^‿^*)
ヽ(o^ ^o)ﾉ
(✯◡✯)
(◕‿◕)
(*≧ω≦*)
(☆▽☆)
(⌒‿⌒)
＼(≧▽≦)／
ヽ(o＾▽＾o)ノ
☆ ～('▽^人)
(*°▽°*)
٩(｡•́‿•̀｡)۶
(✧ω✧)
ヽ(*⌒▽⌒*)ﾉ
(´｡• ᵕ •｡`)
( ´ ▽ ` )
(￣▽￣)
╰(*´︶`*)╯
ヽ(>∀<☆)ノ
o(≧▽≦)o
(☆ω☆)
(っ˘ω˘ς )
＼(￣▽￣)／
(*¯︶¯*)
＼(＾▽＾)／
٩(◕‿◕)۶
(o˘◡˘o)
\(★ω★)/
\(^ヮ^)/
(〃＾▽＾〃)
(╯✧▽✧)╯
o(>ω<)o
o( ❛ᴗ❛ )o
｡ﾟ(TヮT)ﾟ｡
( ‾́ ◡ ‾́ )
(ﾉ´ヮ`)ﾉ*: ･ﾟ
(b ᵔ▽ᵔ)b
(๑˃ᴗ˂)ﻭ
(๑˘︶˘๑)
°˖✧◝(⁰▿⁰)◜✧˖°
(´･ᴗ･ ` )
(ﾉ◕ヮ◕)ﾉ*:･ﾟ✧
(„• ֊ •„)
(.❛ ᴗ ❛.)
(⁀ᗢ⁀)
(￢‿￢ )
(¬‿¬ )
(*￣▽￣)b
( ˙▿˙ )
(¯▿¯)
( ◕▿◕ )
＼(٥⁀▽⁀ )／
(„• ᴗ •„)
(ᵔ◡ᵔ)
( ´ ▿ ` )
]], "\n")

local confused = vim.split([[
(￣ω￣;)
σ(￣、￣〃)
(￣～￣;)
(-_-;)・・・
┐('～`;)┌
(・_・ヾ
(〃￣ω￣〃ゞ
┐(￣ヘ￣;)┌
(・_・;)
(￣_￣)・・・
╮(￣ω￣;)╭
(¯ . ¯;)
(＠_＠)
(・・;)ゞ
Σ(￣。￣ﾉ)
(・・ ) ?
(•ิ_•ิ)?
(◎ ◎)ゞ
(ーー;)
ლ(ಠ_ಠ ლ)
ლ(¯ロ¯"ლ)
(¯ . ¯٥)
(¯  ¯٥)
]], "\n")

local doubt = vim.split([[
(￢_￢)
(→_→)
(￢ ￢)
(￢‿￢ )
(¬_¬ )
(←_←)
(¬ ¬ )
(¬‿¬ )
(↼_↼)
(⇀_⇀)
(ᓀ ᓀ)
]], "\n")

local doing = vim.split([[
( ^▽^)ψ__
( . .)φ__
(づ￣ ³￣)づ
(つ≧▽≦)つ
(つ✧ω✧)つ
(づ ◕‿◕ )づ
(⊃｡•́‿•̀｡)⊃
(っಠ‿ಠ)っ
(づ◡﹏◡)づ
⊂(´• ω •`⊂)
⊂(･ω･*⊂)
⊂(￣▽￣)⊃
⊂( ´ ▽ ` )⊃
( ~*-*)~
(｡•̀ᴗ-)✧
]], "\n")

-- NOTE: had to move this here to avoid circular requirements
local memo_store = {}
setmetatable(memo_store, {__mode = "v"})  -- make values weak
local function memo_random(table, seed)
  local key = seed or math.random(#table)

  if memo_store[key] then
    return memo_store[key]
  else
    local newcolor = table[math.random(#table)]
    memo_store[key] = newcolor
    return newcolor
  end
end
return {
  doubt = function(seed) return memo_random(doubt, seed) end,
  confused = function(seed) return memo_random(confused, seed) end,
  joy = function(seed) return memo_random(joy, seed) end,
  doing = function(seed) return memo_random(doing, seed) end,
}
