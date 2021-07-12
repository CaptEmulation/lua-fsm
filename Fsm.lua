function getTableKeys(tab)
  local keyset = {}
  for k,v in pairs(tab) do
    keyset[#keyset + 1] = k
  end
  return keyset
end

FsmMachine = {}

function FsmMachine:New(opts)
    opts = opts or {}

    self.__index = self
    local o = setmetatable({}, self)
    o.states = {}
    o.curState = nil
    o.debug = opts["debug"]
    return o
end

 -- Current state
function FsmMachine:GetCurrent()
  return self.curState.stateName
end


 -- Available actions
function FsmMachine:GetActions()
  return getTableKeys(self.curState.transitions)
end

 -- Add state
function FsmMachine:AddState(stateName, callbacks)
  local state = BaseState:New(stateName)

  self.states[stateName] = state

  if callbacks then
    self:Listen(stateName, callbacks)
  end

  if not self.curState then
    self:AddInitState(stateName)
  end
end

 -- default initialization
function FsmMachine:AddInitState(stateName)
    self.curState = self.states[stateName]
end

 -- connect
function FsmMachine:Connect(opts)
  local to = opts["to"]
  local message = opts["message"]
  local toState = self.states[to]
  local fromOrFroms = opts["from"]
  local froms = nil
  if type(fromOrFroms) == "table" then
    froms = fromOrFroms
  else
    froms = { fromOrFroms }
  end

  for i, from in ipairs(froms) do
    local fromState = self.states[from]
    fromState:Connect(message, toState)
  end
end

function FsmMachine:Listen(toStateName, callbacks)
  local state = self.states[toStateName]
  local onEnter = callbacks["onEnter"]
  if onEnter then
    state:ListenToOnEnter(onEnter)
  end

  local onLeave = callbacks["onLeave"]
  if onLeave then
    state:ListenToOnLeave(onLeave)
  end
end

 -- switching state
function FsmMachine:Switch(message)
  local shouldTransition = false
  local destState = nil
  if self.curState.transitions[message] then
    shouldTransition = true
    destState = self.curState.transitions[message]
  end
  if shouldTransition then
    if self.debug then print("FsmMachine: [" .. message .. "] message received") end
    self.curState:OnLeave()
    self.curState = destState
    self.curState:OnEnter()
  else
    if self.debug then print("FsmMachine: Unknown message [" .. message .. "] for state [" .. self.curState.stateName .. "]") end
  end
end

BaseState = {}

function BaseState:New(stateName)
    self.__index = self
    local o = setmetatable({}, self)
    o.stateName = stateName
    o.onLeaves = {}
    o.onEnters = {}
    o.transitions = {}
    return o
end

 -- Connect
function BaseState:Connect(message, destState)
  self.transitions[message] = destState
end

 -- Listen to onEnter
function BaseState:ListenToOnEnter(onEnter)
  table.insert(self.onEnters, onEnter)
end

 -- Listen to onLeave
function BaseState:ListenToOnLeave(onLeave)
  table.insert(self.onLeaves, onLeave)
end

 -- Enter state 
function BaseState:OnEnter()
  for i, onEnter in ipairs(self.onEnters) do
    onEnter()
  end
end

 -- leave the state
function BaseState:OnLeave()
  for i, onLeave in ipairs(self.onLeaves) do
    onLeave()
  end
end

return FsmMachine
