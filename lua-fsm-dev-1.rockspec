package = "lua-fsm"
version = "dev-1"
source = {
   url = "git+ssh://git@github.com/CaptEmulation/lua-fsm.git"
}
description = {
   summary = "Loosely based on https://www.programmersought.com/article/12832641613/",
   detailed = [[
Loosely based on https://www.programmersought.com/article/12832641613/
]],
   homepage = "*** please enter a project homepage ***",
   license = "*** please specify a license ***"
}
build = {
   type = "builtin",
   modules = {
      Fsm = "Fsm.lua",
      ["Fsm.test"] = "Fsm.test.lua",
      set_paths = "set_paths.lua"
   }
}
