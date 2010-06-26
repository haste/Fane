local Fane = CreateFrame'Frame'
local inherit = GameFontNormalSmall

local updateFS = function(self, inc, flags, ...)
	local fstring = self:GetFontString()

	local font, fontSize = inherit:GetFont()
	if(inc) then
		fstring:SetFont(font, fontSize + 1, flags)
	else
		fstring:SetFont(font, fontSize, flags)
	end

	if((...)) then
		fstring:SetTextColor(...)
	end
end

local OnEnter = function(self)
	local emphasis = _G["ChatFrame"..self:GetID()..'TabFlash']:IsShown()
	updateFS(self, emphasis, 'OUTLINE', .64, .207, .933)
end

local OnLeave = function(self)
	local r, g, b
	local id = self:GetID()
	local emphasis = _G["ChatFrame"..id..'TabFlash']:IsShown()

	if (_G["ChatFrame"..id] == SELECTED_CHAT_FRAME) then
		r, g, b = .64, .207, .933
	elseif emphasis then
		r, g, b = 1, 0, 0
	else
		r, g, b = 1, 1, 1
	end

	updateFS(self, emphasis, nil, r, g, b)
end

local faneifyTab = function(frame, sel)
	local i = frame:GetID()

	if(not frame.Fane) then
		frame.leftTexture:Hide()
		frame.middleTexture:Hide()
		frame.rightTexture:Hide()

		frame.leftSelectedTexture:Hide()
		frame.middleSelectedTexture:Hide()
		frame.rightSelectedTexture:Hide()

		frame.leftSelectedTexture.Show = frame.leftSelectedTexture.Hide
		frame.middleSelectedTexture.Show = frame.middleSelectedTexture.Hide
		frame.rightSelectedTexture.Show = frame.rightSelectedTexture.Hide

		frame.leftHighlightTexture:Hide()
		frame.middleHighlightTexture:Hide()
		frame.rightHighlightTexture:Hide()

		frame:HookScript('OnEnter', OnEnter)
		frame:HookScript('OnLeave', OnLeave)

		frame.Fane = true
	end

	-- We can't trust sel. :(
	if(i == SELECTED_CHAT_FRAME:GetID()) then
		updateFS(frame, nil, nil, .64, .207, .933)
	else
		updateFS(frame, nil, nil, 1, 1, 1)
	end
end

hooksecurefunc('FCF_StartAlertFlash', function(frame)
	local tab = _G['ChatFrame' .. frame:GetID() .. 'Tab']
	updateFS(tab, true, nil, 1, 0, 0)
end)

hooksecurefunc('FCFTab_UpdateColors', faneifyTab)

for i=1,7 do
	faneifyTab(_G['ChatFrame' .. i .. 'Tab'])
end
