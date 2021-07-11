local Fsm = require("Fsm")


FsmMachineTest = {}


 ----- [testing state machine] -----------------------------
local fsm = Fsm:New()
fsm:AddState("LobbyState", {
  onLeave = function ()
    print("LobbyState:OnLeave()")
  end,
  onEnter = function ()
    print("LobbyState:OnLeave()")
  end
})
fsm:AddState("VoteStart", {
  onLeave = function ()
    print("VoteStart:OnLeave()")
  end,
  onEnter = function ()
    print("VoteStart:OnLeave()")
  end
})
fsm:AddState("NewGameState", {
  onLeave = function ()
    print("NewGameState:OnLeave()")
  end,
  onEnter = function ()
    print("NewGameState:OnLeave()")
  end
})
fsm:AddState("CalmPeriod", {
  onLeave = function ()
    print("CalmPeriod:OnLeave()")
  end,
  onEnter = function ()
    print("CalmPeriod:OnLeave()")
  end
})
fsm:AddState("LightsOut", {
  onLeave = function ()
    print("LightsOut:OnLeave()")
  end,
  onEnter = function ()
    print("LightsOut:OnLeave()")
  end
})
fsm:AddState("Escape", {
  onLeave = function ()
    print("Escape:OnLeave()")
  end,
  onEnter = function ()
    print("Escape:OnLeave()")
  end
})
fsm:AddState("Win", {
  onLeave = function ()
    print("Win:OnLeave()")
  end,
  onEnter = function ()
    print("Win:OnLeave()")
  end
})
fsm:AddState("Lose", {
  onLeave = function ()
    print("Lose:OnLeave()")
  end,
  onEnter = function ()
    print("Lose:OnLeave()")
  end
})
fsm:AddState("GameOver", {
  onLeave = function ()
    print("GameOver:OnLeave()")
  end,
  onEnter = function ()
    print("GameOver:OnLeave()")
  end
})
fsm:Connect({
  from = "LobbyState",
  to = "NewGameState",
  message = "lobby full"
})
fsm:Connect({
  from = "NewGameState",
  to = "CalmPeriod",
  message = "game ready"
})
fsm:Connect({
  from = "CalmPeriod",
  to = "LightsOut",
  message = "time up"
})
fsm:Connect({
  from = "LightsOut",
  to = "Escape",
  message = "escape"
})
fsm:Connect({
  from = "Escape",
  to = "Win",
  message = "win"
})
fsm:Connect({
  from = { "Win", "Lose" },
  to = "GameOver",
  message = "game over"
})
fsm:Connect({
  from = "GameOver",
  to = "LobbyState",
  message = "restart"
})
fsm:Connect({
  from = { "CalmPeriod", "LightsOut" },
  to = "Lose",
  message = "mutants win"
})

fsm:Switch("lobby full")
fsm:Switch("game ready")
fsm:Switch("time up")
fsm:Switch("escape")
fsm:Switch("win")
fsm:Switch("game over")
fsm:Switch("restart")
fsm:Switch("lobby full")
