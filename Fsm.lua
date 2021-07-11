FsmMachine = {}

function FsmMachine:New()
    self.__index = self
    o = setmetatable({}, self)
    o.states = {}
    o.curState = nil
    return o
end

 -- Add state
function FsmMachine:AddState(stateName, callbacks)
  local state = BaseState:New(stateName)

  function state:OnEnter()
      if callbacks["onEnter"] then
        callbacks["onEnter"]()
      end
  end

  function state:OnLeave()
    if callbacks["onLeave"] then
      callbacks["onLeave"]()
    end
  end

    self.states[stateName] = state

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

 -- switching state
function FsmMachine:Switch(message)
  local shouldTransition = false
  local destState = nil
  if self.curState.transitions[message] then
    shouldTransition = true
    destState = self.curState.transitions[message]
  end
  if shouldTransition then
    print("FsmMachine: [" .. message .. "] message received")
    self.curState:OnLeave()
    self.curState = destState
    self.curState:OnEnter()
  else
    print("FsmMachine: Unknown message [" .. message .. "] for state [" .. self.curState.stateName .. "]")
  end
end

BaseState = {}

function BaseState:New(stateName)
    self.__index = self
    local o = setmetatable({}, self)
    o.stateName = stateName
    o.transitions = {}
    return o
end

 -- Connect
function BaseState:Connect(message, destState)
  self.transitions[message] = destState
end

 -- Enter state 
function BaseState:OnEnter()
end

 -- leave the state
function BaseState:OnLeave()
end

return FsmMachine
