local event = CreateFrame"Frame"
local dummy = function() end
local inherit = GameFontNormalSmall

local OnEnter = function(self)
	local f, s = inherit:GetFont()
	self:GetFontString():SetTextColor(.64, .207, .933)
	self:GetFontString():SetFont(f, s, "OUTLINE")
end
local OnLeave = function(self)
	if(_G["ChatFrame"..self:GetID()] == SELECTED_CHAT_FRAME) then
		self:GetFontString():SetTextColor(.64, .207, .933)
	else
		self:GetFontString():SetTextColor(1, 1, 1)
	end

	local f, s = inherit:GetFont()
	self:GetFontString():SetFont(f, s)
end
local OnShow = function(self)
	local f, s = inherit:GetFont()
	self:GetParent():SetFont(f, s+1)
	self:GetParent():SetTextColor(1, 0, 0)
end
local OnHide = function(self)
	local f, s = inherit:GetFont()
	self:GetParent():SetFont(f, s)
	self:GetParent():SetTextColor(1, 1, 1)
end

local rollCF = function()
	for i = 1, 7 do
		local chat = _G["ChatFrame"..i]
		local tab = _G["ChatFrame"..i.."Tab"]
		local flash = _G["ChatFrame"..i.."TabFlash"]

		flash:GetRegions():SetTexture(nil)
		flash:SetScript("OnShow", OnShow)
		flash:SetScript("OnHide", OnHide)

		_G["ChatFrame"..i.."TabLeft"]:Hide()
		_G["ChatFrame"..i.."TabMiddle"]:Hide()
		_G["ChatFrame"..i.."TabRight"]:Hide()

		tab:SetScript("OnEnter", OnEnter)
		tab:SetScript("OnLeave", OnLeave)

		tab.SetAlpha = dummy
		if(chat == SELECTED_CHAT_FRAME) then
			tab:GetFontString():SetTextColor(.64, .207, .933)
		else
			tab:GetFontString():SetTextColor(1, 1, 1)
		end
		tab:GetHighlightTexture():SetTexture(nil)

		if(chat.isDocked) then
			tab:Show()
			tab.Hide = dummy
		else
			tab.SetAlpha = nil
			tab.Hide = nil
		end
	end
end

event.PLAYER_LOGIN = function()
	rollCF()
	hooksecurefunc("FCF_OpenNewWindow", rollCF)
	hooksecurefunc("FCF_Close", function(self)
		UIParent.Hide(_G[self:GetName().."Tab"])
	end)

	local _orig_FCF_Tab_OnClick = FCF_Tab_OnClick
	FCF_Tab_OnClick = function(...)
		_orig_FCF_Tab_OnClick(...)

		for k, v in pairs(DOCKED_CHAT_FRAMES) do
			if(v == SELECTED_CHAT_FRAME) then
				_G[v:GetName().."Tab"]:GetFontString():SetTextColor(.64, .207, .933)
			else
				_G[v:GetName().."Tab"]:GetFontString():SetTextColor(1, 1, 1)
			end
		end
	end

	FCF_ChatTabFadeFinished = dummy
end

event:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
event:RegisterEvent"PLAYER_LOGIN"
