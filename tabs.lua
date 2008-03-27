--[[-------------------------------------------------------------------------
  Copyright (c) 2007-2008, Trond A Ekseth
  All rights reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

      * Redistributions of source code must retain the above copyright
        notice, this list of conditions and the following disclaimer.
      * Redistributions in binary form must reproduce the above
        copyright notice, this list of conditions and the following
        disclaimer in the documentation and/or other materials provided
        with the distribution.
      * Neither the name of Fane nor the names of its contributors
        may be used to endorse or promote products derived from this
        software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
  OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
---------------------------------------------------------------------------]]

local event = CreateFrame"Frame"
local dummy = function() end
local inherit = GameFontNormalSmall

local OnEnter = function(self)
	local f, s = inherit:GetFont()
	self:SetTextColor(.64, .207, .933)
	self:SetFont(f, s, "OUTLINE")
end
local OnLeave = function(self)
	if(_G["ChatFrame"..self:GetID()] == SELECTED_CHAT_FRAME) then
		self:SetTextColor(.64, .207, .933)
	else
		self:SetTextColor(1, 1, 1)
	end

	local f, s = inherit:GetFont()
	self:SetFont(f, s)
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
			tab:SetTextColor(.64, .207, .933)
		else
			tab:SetTextColor(1, 1, 1)
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
	FCF_Tab_OnClick = function(button)
		_orig_FCF_Tab_OnClick(button)

		for k, v in pairs(DOCKED_CHAT_FRAMES) do
			if(v == SELECTED_CHAT_FRAME) then
				_G[v:GetName().."Tab"]:SetTextColor(.64, .207, .933)
			else
				_G[v:GetName().."Tab"]:SetTextColor(1, 1, 1)
			end
		end
	end

	FCF_ChatTabFadeFinished = dummy
end

event:SetScript("OnEvent", function(self, event, ...)
	self[event](self, event, ...)
end)
event:RegisterEvent"PLAYER_LOGIN"
