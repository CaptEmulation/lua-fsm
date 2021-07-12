local Fsm = require("Fsm")
local luaunit = require('luaunit')

FsmMachineTest = {}

function TestAvailableActions()
  local fsm = Fsm:New()
  fsm:AddState("start")
  fsm:AddState("stage 1")
  fsm:AddState("stage 2")
  fsm:AddState("stage 3")
  fsm:AddState("win")
  fsm:AddState("lose")
  fsm:Connect({
    from = "start",
    to = "stage 1",
    message = "begin"
  })
  fsm:Connect({
    from = "stage 1",
    to = "stage 2",
    message = "advance"
  })
  fsm:Connect({
    from = "stage 2",
    to = "stage 3",
    message = "advance"
  })
  fsm:Connect({
    from = { "stage 1", "stage 2", "stage 3" },
    to = "lose",
    message = "defeat"
  })
  fsm:Connect({
    from = "stage 3",
    to = "win",
    message = "success"
  })
  luaunit.assertItemsEquals(fsm:GetActions(), { "begin" })
  fsm:Switch("begin")
  luaunit.assertEquals(fsm:GetCurrent(), "stage 1")
  luaunit.assertItemsEquals(fsm:GetActions(), { "defeat", "advance" })
  fsm:Switch("advance")
  luaunit.assertEquals(fsm:GetCurrent(), "stage 2")
  luaunit.assertItemsEquals(fsm:GetActions(), { "defeat", "advance" })
  fsm:Switch("advance")
  luaunit.assertEquals(fsm:GetCurrent(), "stage 3")
  luaunit.assertItemsEquals(fsm:GetActions(), { "defeat", "success" })
  fsm:Switch("success")
  luaunit.assertEquals(fsm:GetCurrent(), "win")
  luaunit.assertItemsEquals(fsm:GetActions(), {})
end

function TestListenToOnLeave()
  local fsm = Fsm:New()
  fsm:AddState("init")
  fsm:AddState("start")
  fsm:AddState("end")
  fsm:Connect({
    from = "init",
    to = "start",
    message = "start"
  })
  fsm:Connect({
    from = "start",
    to = "end",
    message = "end"
  })
  local wasLeft = false
  fsm:Listen("start", {
    onLeave = function ()
      wasLeft = true
    end
  })
  fsm:Switch("start")
  luaunit.assertFalse(wasLeft)
  fsm:Switch("end")
  luaunit.assertTrue(wasLeft)
end

function TestListenToOnEnter()
  local fsm = Fsm:New()
  fsm:AddState("init")
  fsm:AddState("start")
  fsm:Connect({
    from = "init",
    to = "start",
    message = "start"
  })
  local wasEnter = false
  fsm:Listen("start", {
    onEnter = function ()
      wasEnter = true
    end
  })
  luaunit.assertFalse(wasEnter)
  fsm:Switch("start")
  luaunit.assertTrue(wasEnter)
end

function TestListenToCallbacks()
  local fsm = Fsm:New()
  fsm:AddState("init")
  fsm:AddState("start")
  fsm:AddState("end")
  fsm:Connect({
    from = "init",
    to = "start",
    message = "start"
  })
  fsm:Connect({
    from = "start",
    to = "end",
    message = "end"
  })
  local wasLeft = false
  local wasEnter = false
  fsm:Listen("start", {
    onLeave = function ()
      wasLeft = true
    end,
    onEnter = function ()
      wasEnter = true
    end
  })
  luaunit.assertFalse(wasEnter)
  fsm:Switch("start")
  luaunit.assertTrue(wasEnter)
  luaunit.assertFalse(wasLeft)
  fsm:Switch("end")
  luaunit.assertTrue(wasLeft)
end

os.exit( luaunit.LuaUnit.run() )
