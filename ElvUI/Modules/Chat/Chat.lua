local E, L, V, P, G = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local CH = E:GetModule('Chat')
local LO = E:GetModule('Layout')
local Skins = E:GetModule('Skins')
local LSM = E.Libs.LSM

local _G = _G
local gsub, strfind, gmatch, format, max = gsub, strfind, gmatch, format, max
local ipairs, sort, wipe, time, difftime = ipairs, sort, wipe, time, difftime
local pairs, unpack, select, tostring, pcall, next, tonumber, type = pairs, unpack, select, tostring, pcall, next, tonumber, type
local strlower, strsub, strlen, strupper, strtrim, strmatch = strlower, strsub, strlen, strupper, strtrim, strmatch
local tinsert, tremove, tconcat = tinsert, tremove, table.concat

local Ambiguate = Ambiguate
local BetterDate = BetterDate
local BNGetFriendGameAccountInfo = BNGetFriendGameAccountInfo
local BNGetFriendInfo = BNGetFriendInfo
local BNGetFriendInfoByID = BNGetFriendInfoByID
local BNGetGameAccountInfo = BNGetGameAccountInfo
local BNGetNumFriendGameAccounts = BNGetNumFriendGameAccounts
local BNGetNumFriendInvites = BNGetNumFriendInvites
local BNGetNumFriends = BNGetNumFriends
local CreateFrame = CreateFrame
local FlashClientIcon = FlashClientIcon
local GetBNPlayerCommunityLink = GetBNPlayerCommunityLink
local GetBNPlayerLink = GetBNPlayerLink
local GetChannelName = GetChannelName
local GetChatWindowInfo = GetChatWindowInfo
local GetCursorPosition = GetCursorPosition
local GetCVar, GetCVarBool = GetCVar, GetCVarBool
local GetGuildRosterMOTD = GetGuildRosterMOTD
local GetInstanceInfo = GetInstanceInfo
local GetMouseFocus = GetMouseFocus
local GetNumGroupMembers = GetNumGroupMembers
local GetPlayerCommunityLink = GetPlayerCommunityLink
local GetPlayerInfoByGUID = GetPlayerInfoByGUID
local GetPlayerLink = GetPlayerLink
local GetRaidRosterInfo = GetRaidRosterInfo
local GMChatFrame_IsGM = GMChatFrame_IsGM
local GMError = GMError
local hooksecurefunc = hooksecurefunc
local InCombatLockdown = InCombatLockdown
local IsAltKeyDown = IsAltKeyDown
local IsInRaid, IsInGroup = IsInRaid, IsInGroup
local IsShiftKeyDown = IsShiftKeyDown
local PlaySoundFile = PlaySoundFile
local RemoveExtraSpaces = RemoveExtraSpaces
local RemoveNewlines = RemoveNewlines
local ToggleFrame = ToggleFrame
local UnitName = UnitName

local C_DateAndTime_GetCurrentCalendarTime = C_DateAndTime.GetCurrentCalendarTime
local C_Club_GetInfoFromLastCommunityChatLine = C_Club.GetInfoFromLastCommunityChatLine
local Chat_GetChatCategory = Chat_GetChatCategory
local ChatHistory_GetAccessID = ChatHistory_GetAccessID
local ChatFrame_ResolvePrefixedChannelName = ChatFrame_ResolvePrefixedChannelName
local BNet_GetValidatedCharacterName = BNet_GetValidatedCharacterName
local BNet_GetClientEmbeddedTexture = BNet_GetClientEmbeddedTexture
local BNET_CLIENT_WOW = BNET_CLIENT_WOW
-- GLOBALS: ElvCharacterDB

CH.GuidCache = {}
CH.ClassNames = {}
CH.Keywords = {}
CH.PluginMessageFilters = {}
CH.Smileys = {}
CH.TalkingList = {}

local throttle = {}

local PLAYER_REALM = E:ShortenRealm(E.myrealm)
local PLAYER_NAME = format('%s-%s', E.myname, PLAYER_REALM)

local DEFAULT_STRINGS = {
	GUILD = L["G"],
	PARTY = L["P"],
	RAID = L["R"],
	OFFICER = L["O"],
	PARTY_LEADER = L["PL"],
	RAID_LEADER = L["RL"],
	INSTANCE_CHAT = L["I"],
	INSTANCE_CHAT_LEADER = L["IL"],
}

local hyperlinkTypes = {
	apower = true,
	currency = true,
	enchant = true,
	glyph = true,
	instancelock = true,
	item = true,
	keystone = true,
	quest = true,
	spell = true,
	talent = true,
	unit = true
}

local tabTexs = {
	'',
	'Selected',
	'Highlight'
}

local historyTypes = { -- the events set on the chats are still in FindURL_Events, this is used to ignore some types only
	CHAT_MSG_WHISPER			= 'WHISPER',
	CHAT_MSG_WHISPER_INFORM		= 'WHISPER',
	CHAT_MSG_BN_WHISPER			= 'WHISPER',
	CHAT_MSG_BN_WHISPER_INFORM	= 'WHISPER',
	CHAT_MSG_GUILD				= 'GUILD',
	CHAT_MSG_OFFICER		= 'OFFICER',
	CHAT_MSG_PARTY			= 'PARTY',
	CHAT_MSG_PARTY_LEADER	= 'PARTY',
	CHAT_MSG_RAID			= 'RAID',
	CHAT_MSG_RAID_LEADER	= 'RAID',
	CHAT_MSG_RAID_WARNING	= 'RAID',
	CHAT_MSG_INSTANCE_CHAT			= 'INSTANCE',
	CHAT_MSG_INSTANCE_CHAT_LEADER	= 'INSTANCE',
	CHAT_MSG_CHANNEL		= 'CHANNEL',
	CHAT_MSG_SAY			= 'SAY',
	CHAT_MSG_YELL			= 'YELL',
	CHAT_MSG_EMOTE			= 'EMOTE' -- this never worked, check it sometime.
}

local canChangeMessage = function(arg1, id)
	if id and arg1 == '' then return id end
end

function CH:MessageIsProtected(message)
	return message and (message ~= gsub(message, '(:?|?)|K(.-)|k', canChangeMessage))
end

function CH:RemoveSmiley(key)
	if key and (type(key) == 'string') then
		CH.Smileys[key] = nil
	end
end

function CH:AddSmiley(key, texture)
	if key and (type(key) == 'string' and not strfind(key, ':%%', 1, true)) and texture then
		CH.Smileys[key] = texture
	end
end

local specialChatIcons
do --this can save some main file locals
	local x, y = ':16:16',':13:25'

	local ElvBlue		= E:TextureString(E.Media.ChatLogos.ElvBlue,y)
	local ElvGreen		= E:TextureString(E.Media.ChatLogos.ElvGreen,y)
	local ElvOrange		= E:TextureString(E.Media.ChatLogos.ElvOrange,y)
	local ElvPurple		= E:TextureString(E.Media.ChatLogos.ElvPurple,y)
	local ElvRed		= E:TextureString(E.Media.ChatLogos.ElvRed,y)
	local ElvYellow		= E:TextureString(E.Media.ChatLogos.ElvYellow,y)
	local ElvSimpy		= E:TextureString(E.Media.ChatLogos.ElvSimpy,y)
	local Bathrobe		= E:TextureString(E.Media.ChatLogos.Bathrobe,x)
	local Rainbow		= E:TextureString(E.Media.ChatLogos.Rainbow,x)
	local Hibiscus		= E:TextureString(E.Media.ChatLogos.Hibiscus,x)
	local Clover		= E:TextureString(E.Media.ChatLogos.Clover,x)
	local GoldShield	= E:TextureString(E.Media.ChatLogos.GoldShield,x)
	local Deathly		= E:TextureString(E.Media.ChatLogos.DeathlyHallows,x)
	local Gem			= E:TextureString(E.Media.ChatLogos.Gem,x)

	--[[ Simpys Thing: new icon color every message, in order then reversed back, repeating of course
		local a, b, c = 0, false, {ElvRed, ElvOrange, ElvYellow, ElvGreen, ElvBlue, ElvPurple, ElvPink}
		(a = a - (b and 1 or -1) if (b and a == 1 or a == 0) or a == #c then b = not b end return c[a])
	]]

	local itsElv, itsMis, itsMel, itsSimpy, itsTheFlyestNihilist
	do	--Simpy Chaos: super cute text coloring function that ignores hyperlinks and keywords
		local e, f, g = {'||','|Helvmoji:.-|h.-|h','|[Cc].-|[Rr]','|[TA].-|[ta]','|H.-|h.-|h'}, {}, {}
		local prettify = function(t,...) return gsub(gsub(E:TextGradient(gsub(gsub(t,'%%%%','\27'),'\124\124','\26'),...),'\27','%%%%'),'\26','||') end
		local protectText = function(t, u, v) local w = E:EscapeString(v) local r, s = strfind(u, w) while f[r] do r, s = strfind(u, w, s) end if r then tinsert(g, r) f[r] = w end return gsub(t, w, '\24') end
		local specialText = function(t,...) local u = t for _, w in ipairs(e) do for k in gmatch(t, w) do t = protectText(t, u, k) end end t = prettify(t,...)
			if next(g) then if #g > 1 then sort(g) end for n in gmatch(t, '\24') do local _, v = next(g) t = gsub(t, n, f[v], 1) tremove(g, 1) f[v] = nil end end return t
		end

		--Simpys Valentine Vibes: Rose Pink, Soft Pink, Soft Cyan, Soft Violet, Soft Rose, Soft Yellow
		local SimpyColors = function(t) return specialText(t, 1,.42,.78, 1,.56,.68, .66,.99,.98, .77,.52,1, 1,.48,.81, .98,.95,.68) end
		--Detroit Lions: Honolulu Blue to Silver [Elv: I stoles it @Simpy]
		local ElvColors = function(t) return specialText(t, 0,0.42,0.69, 0.61,0.61,0.61) end
		--Rainbow: FD3E44, FE9849, FFDE4B, 6DFD65, 54C4FC, A35DFA, C679FB, FE81C1
		local MisColors = function(t) return specialText(t, 0.99,0.24,0.26, 0.99,0.59,0.28, 1.00,0.87,0.29, 0.42,0.99,0.39, 0.32,0.76,0.98, 0.63,0.36,0.98, 0.77,0.47,0.98, 0.99,0.50,0.75) end
		--Light Spring: 50DAD3, 56E580, D8DA33, DFA455, EE8879, F972D1, B855DF, 50DAD3
		local MelColors = function(t) return specialText(t, 0.31,0.85,0.82, 0.33,0.89,0.50, 0.84,0.85,0.20, 0.87,0.64,0.33, 0.93,0.53,0.47, 0.97,0.44,0.81, 0.72,0.33,0.87, 0.31,0.85,0.82) end
		--Class: Normal to Negative (Orange->Blue, Red->Cyan, etc)
		local nm = function(c) return max(1-c,0.15) end
		local NihiColors = function(class) local c = _G.RAID_CLASS_COLORS[class] local c1,c2,c3, n1,n2,n3 = c.r,c.g,c.b, nm(c.r), nm(c.g), nm(c.b) return function(t) return specialText(t, c1,c2,c3, n1,n2,n3, c1,c2,c3, n1,n2,n3) end end

		itsSimpy = function() return ElvSimpy, SimpyColors end
		itsElv = function() return ElvBlue, ElvColors end
		itsMel = function() return Hibiscus, MelColors end
		itsMis = function() return Rainbow, MisColors end
		itsTheFlyestNihilist = function(class) local icon, prettyText = E:TextureString(E.Media.ChatLogos['Fox'..class],x), NihiColors(strupper(class)) return function() return icon, prettyText end end
	end

	specialChatIcons = {
		-- Simpy
		["Simpy-Atiesh"]		= itsSimpy, -- Warlock
		["Simpy-Myzrael"]		= itsSimpy, -- Warlock
		["Cutepally-Myzrael"]	= itsSimpy, -- Paladin
		["Imsocheesy-Myzrael"]	= itsSimpy, -- [Horde] Priest
		["Imsospicy-Myzrael"]	= itsSimpy, -- [Horde] Mage
		-- Blazeflack
		["Freezly-MirageRaceway"]	= ElvBlue, -- Mage
		["Blazii-MirageRaceway"]	= ElvBlue, -- Priest
		-- Luckyone
		["Luckyone-Shazzrah"]		= Clover, -- Hunter
		["Luckyfear-Shazzrah"]		= Clover, -- Warlock
		["Luckydruid-Shazzrah"]		= Clover, -- Druid
		["Luckyp-Shazzrah"]			= Clover, -- Priest
		["Luckyr-Shazzrah"]			= Clover, -- Rogue
		["Elvuidevtest-Shazzrah"]	= Clover, -- Warrior
		["Luckyone-BadgeofJustice"] = ElvGreen, -- Beta Test
		["Luckyone-ClassicBetaPvE"] = ElvGreen, -- Beta Test
		["Luckyone-ClassicBetaPvP"] = ElvGreen, -- Beta Test
	}
end

function CH:ChatFrame_OnMouseScroll(delta)
	local numScrollMessages = CH.db.numScrollMessages or 3
	if delta < 0 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		elseif IsAltKeyDown() then
			self:ScrollDown()
		else
			for _ = 1, numScrollMessages do
				self:ScrollDown()
			end
		end
	elseif delta > 0 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		elseif IsAltKeyDown() then
			self:ScrollUp()
		else
			for _ = 1, numScrollMessages do
				self:ScrollUp()
			end
		end

		if CH.db.scrollDownInterval ~= 0 then
			if self.ScrollTimer then
				CH:CancelTimer(self.ScrollTimer, true)
			end

			self.ScrollTimer = CH:ScheduleTimer('ScrollToBottom', CH.db.scrollDownInterval, self)
		end
	end
end

function CH:GetGroupDistribution()
	local _, instanceType = GetInstanceInfo()
	if instanceType == 'pvp' then return '/bg ' end
	if IsInRaid() then return '/ra ' end
	if IsInGroup() then return '/p ' end
	return '/s '
end

function CH:InsertEmotions(msg)
	for word in gmatch(msg, '%s-%S+%s*') do
		word = strtrim(word)
		local pattern = E:EscapeString(word)
		local emoji = CH.Smileys[pattern]
		if emoji and strmatch(msg, '[%s%p]-'..pattern..'[%s%p]*') then
			local base64 = E.Libs.Base64:Encode(word) -- btw keep `|h|cFFffffff|r|h` as it is
			msg = gsub(msg, '([%s%p]-)'..pattern..'([%s%p]*)', (base64 and ('%1|Helvmoji:%%'..base64..'|h|cFFffffff|r|h') or '%1')..emoji..'%2')
		end
	end

	return msg
end

function CH:GetSmileyReplacementText(msg)
	if not msg or not CH.db.emotionIcons or strfind(msg, '/run') or strfind(msg, '/dump') or strfind(msg, '/script') then return msg end
	local outstr = ''
	local origlen = strlen(msg)
	local startpos = 1
	local endpos, _

	while(startpos <= origlen) do
		local pos = strfind(msg,'|H',startpos,true)
		endpos = pos or origlen
		outstr = outstr .. CH:InsertEmotions(strsub(msg,startpos,endpos)) --run replacement on this bit
		startpos = endpos + 1
		if pos ~= nil then
			_, endpos = strfind(msg,'|h.-|h',startpos)
			endpos = endpos or origlen
			if startpos < endpos then
				outstr = outstr .. strsub(msg,startpos,endpos) --don't run replacement on this bit
				startpos = endpos + 1
			end
		end
	end

	return outstr
end

function CH:CopyButtonOnMouseUp(btn)
	local chat = self:GetParent()
	if btn == 'RightButton' and chat:GetID() == 1 then
		ToggleFrame(_G.ChatMenu)
	else
		CH:CopyChat(chat)
	end
end

function CH:CopyButtonOnEnter()
	self:SetAlpha(1)
end

function CH:CopyButtonOnLeave()
	local chat = self:GetParent()
	if _G[chat:GetName()..'TabText']:IsShown() then
		self:SetAlpha(0.35)
	else
		self:SetAlpha(0)
	end
end

function CH:ChatFrameTab_SetAlpha(_, skip)
	if skip then return end
	local chat = CH:GetOwner(self)
	self:SetAlpha((not chat.isDocked or self.selected) and 1 or 0.6, true)
end

do
	local charCount
	function CH:CountLinkCharacters()
		charCount = charCount + (strlen(self) + 4) -- 4 is ending '|h|r'
	end

	local repeatedText
	function CH:EditBoxOnTextChanged()
		local text = self:GetText()
		local len = strlen(text)

		if (not repeatedText or not strfind(text, repeatedText, 1, true)) and InCombatLockdown() then
			local MIN_REPEAT_CHARACTERS = CH.db.numAllowedCombatRepeat
			if len > MIN_REPEAT_CHARACTERS then
				local repeatChar = true
				for i = 1, MIN_REPEAT_CHARACTERS, 1 do
					local first = -1 - i
					if strsub(text,-i,-i) ~= strsub(text,first,first) then
						repeatChar = false
						break
					end
				end
				if repeatChar then
					repeatedText = text
					self:Hide()
					return
				end
			end
		end

		if len == 4 then
			if text == '/tt ' then
				local Name, Realm = UnitName('target')
				if Name then
					Name = gsub(Name,'%s','')

					if Realm and Realm ~= '' then
						Name = format('%s-%s', Name, E:ShortenRealm(Realm))
					end
				end

				if Name then
					_G.ChatFrame_SendTell(Name, self.chatFrame)
				else
					_G.UIErrorsFrame:AddMessage(E.InfoColor .. L["Invalid Target"])
				end
			elseif text == '/gr ' then
				self:SetText(CH:GetGroupDistribution() .. strsub(text, 5))
				_G.ChatEdit_ParseText(self, 0)
			end
		end

		-- recalculate the character count correctly with hyperlinks in it, using gsub so it matches multiple without gmatch
		charCount = 0
		gsub(text, '(|c%x-|H.-|h).-|h|r', CH.CountLinkCharacters)
		if charCount ~= 0 then len = len - charCount end

		self.characterCount:SetText(len > 0 and (255 - len) or '')

		if repeatedText then
			repeatedText = nil
		end
	end
end

function CH:EditBoxOnKeyDown(key)
	--Work around broken SetAltArrowKeyMode API. Code from Prat and modified by Simpy
	if (not self.historyLines) or #self.historyLines == 0 then
		return
	end

	if key == 'DOWN' then
		self.historyIndex = self.historyIndex - 1

		if self.historyIndex < 1 then
			self.historyIndex = 0
			self:SetText('')
			return
		end
	elseif key == 'UP' then
		self.historyIndex = self.historyIndex + 1

		if self.historyIndex > #self.historyLines then
			self.historyIndex = #self.historyLines
		end
	else
		return
	end

	self:SetText(strtrim(self.historyLines[#self.historyLines - (self.historyIndex - 1)]))
end

function CH:EditBoxFocusGained()
	if not _G.LeftChatPanel:IsShown() then
		_G.LeftChatPanel.editboxforced = true
		_G.LeftChatToggleButton:OnEnter()
		self:Show()
	end
end

function CH:EditBoxFocusLost()
	if _G.LeftChatPanel.editboxforced then
		_G.LeftChatPanel.editboxforced = nil

		if _G.LeftChatPanel:IsShown() then
			_G.LeftChatToggleButton:OnLeave()
			self:Hide()
		end
	end

	self.historyIndex = 0
end

function CH:UpdateEditboxFont(chatFrame)
	local style = GetCVar('chatStyle')
	if style == 'classic' and CH.LeftChatWindow then
		chatFrame = CH.LeftChatWindow
	end

	if chatFrame == _G.GeneralDockManager.primary then
		chatFrame = _G.GeneralDockManager.selected
	end

	local id = chatFrame:GetID()
	local font = LSM:Fetch('font', CH.db.font)
	local _, fontSize = _G.FCF_GetChatWindowInfo(id)

	local editbox = _G.ChatEdit_ChooseBoxForSend(chatFrame)
	editbox:FontTemplate(font, fontSize, 'NONE')
	editbox.header:FontTemplate(font, fontSize, 'NONE')

	if editbox.characterCount then
		editbox.characterCount:FontTemplate(font, fontSize, 'NONE')
	end

	-- the header and text will not update the placement without focus
	if editbox and editbox:IsShown() then
		editbox:SetFocus()
	end
end

function CH:StyleChat(frame)
	local name = frame:GetName()
	local tab = CH:GetTab(frame)

	local id = frame:GetID()
	local _, fontSize = _G.FCF_GetChatWindowInfo(id)
	local font, size, outline = LSM:Fetch('font', CH.db.font), fontSize, CH.db.fontOutline
	frame:FontTemplate(font, size, outline)

	frame:SetTimeVisible(CH.db.inactivityTimer)
	frame:SetMaxLines(CH.db.maxLines)
	frame:SetFading(CH.db.fade)

	tab.Text:FontTemplate(LSM:Fetch('font', CH.db.tabFont), CH.db.tabFontSize, CH.db.tabFontOutline)

	if frame.styled then return end

	frame:SetFrameLevel(4)
	frame:SetClampRectInsets(0,0,0,0)
	frame:SetClampedToScreen(false)
	frame:StripTextures(true)

	_G[name..'ButtonFrame']:Kill()

	local scrollTex = _G[name..'ThumbTexture']
	local scrollToBottom = frame.ScrollToBottomButton
	local scroll = frame.ScrollBar
	local editbox = frame.editBox

	if scroll then
		scroll:Kill()
		scrollToBottom:Kill()
		scrollTex:Kill()
	end

	--Character count
	local charCount = editbox:CreateFontString(nil, 'ARTWORK')
	charCount:FontTemplate()
	charCount:SetTextColor(190, 190, 190, 0.4)
	charCount:Point('TOPRIGHT', editbox, 'TOPRIGHT', -5, 0)
	charCount:Point('BOTTOMRIGHT', editbox, 'BOTTOMRIGHT', -5, 0)
	charCount:SetJustifyH('CENTER')
	charCount:Width(40)
	editbox.characterCount = charCount

	for _, texName in pairs(tabTexs) do
		_G[name..'Tab'..texName..'Left']:SetTexture()
		_G[name..'Tab'..texName..'Middle']:SetTexture()
		_G[name..'Tab'..texName..'Right']:SetTexture()
	end

	hooksecurefunc(tab, 'SetAlpha', CH.ChatFrameTab_SetAlpha)

	if not tab.left then tab.left = _G[name..'TabLeft'] end
	tab.Text:ClearAllPoints()
	tab.Text:Point('LEFT', tab, 'LEFT', tab.left:GetWidth(), 0)
	tab:Height(22)

	if tab.conversationIcon then
		tab.conversationIcon:ClearAllPoints()
		tab.conversationIcon:Point('RIGHT', tab.Text, 'LEFT', -1, 0)
	end

	--local a, b, c = select(6, editbox:GetRegions()); a:Kill(); b:Kill(); c:Kill()
	_G[name..'EditBoxLeft']:Kill()
	_G[name..'EditBoxMid']:Kill()
	_G[name..'EditBoxRight']:Kill()

	editbox:SetAltArrowKeyMode(CH.db.useAltKey)
	editbox:SetAllPoints(_G.LeftChatDataPanel)
	editbox:HookScript('OnTextChanged', CH.EditBoxOnTextChanged)
	CH:SecureHook(editbox, 'AddHistoryLine', 'ChatEdit_AddHistory')

	--Work around broken SetAltArrowKeyMode API
	editbox.historyLines = ElvCharacterDB.ChatEditHistory
	editbox.historyIndex = 0
	editbox:HookScript('OnKeyDown', CH.EditBoxOnKeyDown)
	editbox:Hide()

	editbox:HookScript('OnEditFocusGained', CH.EditBoxFocusGained)
	editbox:HookScript('OnEditFocusLost', CH.EditBoxFocusLost)

	for _, text in pairs(editbox.historyLines) do
		editbox:AddHistoryLine(text)
	end

	--copy chat button
	local copyButton = CreateFrame('Frame', format('ElvUI_CopyChatButton%d', id), frame)
	copyButton:EnableMouse(true)
	copyButton:SetAlpha(0.35)
	copyButton:Size(20, 22)
	copyButton:Point('TOPRIGHT', 0, -4)
	copyButton:SetFrameLevel(frame:GetFrameLevel() + 5)
	frame.copyButton = copyButton

	local copyTexture = frame.copyButton:CreateTexture(nil, 'OVERLAY')
	copyTexture:SetInside()
	copyTexture:SetTexture(E.Media.Textures.Copy)
	copyButton.texture = copyTexture

	copyButton:SetScript('OnMouseUp', CH.CopyButtonOnMouseUp)
	copyButton:SetScript('OnEnter', CH.CopyButtonOnEnter)
	copyButton:SetScript('OnLeave', CH.CopyButtonOnLeave)
	CH:ToggleChatButton(copyButton)

	frame.styled = true
end

function CH:GetChatTime()
	local unix = time()
	local realm = not CH.db.timeStampLocalTime and C_DateAndTime_GetCurrentCalendarTime()
	if realm then -- blizzard is weird
		realm.day = realm.monthDay
		realm.min = date('%M', unix)
		realm.sec = date('%S', unix)
		realm = time(realm)
	end

	return realm or unix
end

function CH:AddMessage(msg, infoR, infoG, infoB, infoID, accessID, typeID, isHistory, historyTime)
	local historyTimestamp --we need to extend the arguments on AddMessage so we can properly handle times without overriding
	if isHistory == 'ElvUI_ChatHistory' then historyTimestamp = historyTime end

	if CH.db.timeStampFormat and CH.db.timeStampFormat ~= 'NONE' then
		local timeStamp = BetterDate(CH.db.timeStampFormat, historyTimestamp or CH:GetChatTime())
		timeStamp = gsub(timeStamp, ' ', '')
		timeStamp = gsub(timeStamp, 'AM', ' AM')
		timeStamp = gsub(timeStamp, 'PM', ' PM')
		if CH.db.useCustomTimeColor then
			local color = CH.db.customTimeColor
			local hexColor = E:RGBToHex(color.r, color.g, color.b)
			msg = format('%s[%s]|r %s', hexColor, timeStamp, msg)
		else
			msg = format('[%s] %s', timeStamp, msg)
		end
	end

	if CH.db.copyChatLines then
		msg = format('|Hcpl:%s|h%s|h %s', self:GetID(), E:TextureString(E.Media.Textures.ArrowRight, ':14'), msg)
	end

	self.OldAddMessage(self, msg, infoR, infoG, infoB, infoID, accessID, typeID)
end

function CH:UpdateSettings()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		_G[name..'EditBox']:SetAltArrowKeyMode(CH.db.useAltKey)
	end
end

local removeIconFromLine
do
	local raidIconFunc = function(x) x = x~='' and _G['RAID_TARGET_'..x];return x and ('{'..strlower(x)..'}') or '' end
	local stripTextureFunc = function(w, x, y) if x=='' then return (w~='' and w) or (y~='' and y) or '' end end
	local hyperLinkFunc = function(w, x, y) if w~='' then return end
		local emoji = (x~='' and x) and strmatch(x, 'elvmoji:%%(.+)')
		return (emoji and E.Libs.Base64:Decode(emoji)) or y
	end
	local fourString = function(v, w, x, y)
		return format('%s%s%s', v, w, (v and v == '1' and x) or y)
	end
	removeIconFromLine = function(text)
		text = gsub(text, [[|TInterface\TargetingFrame\UI%-RaidTargetingIcon_(%d+):0|t]], raidIconFunc) --converts raid icons into {star} etc, if possible.
		text = gsub(text, '(%s?)(|?)|[TA].-|[ta](%s?)', stripTextureFunc) --strip any other texture out but keep a single space from the side(s).
		text = gsub(text, '(|?)|H(.-)|h(.-)|h', hyperLinkFunc) --strip hyperlink data only keeping the actual text.
		text = gsub(text, '(%d+)(.-)|4(.-):(.-);', fourString) --stuff where it goes 'day' or 'days' like played; tech this is wrong but okayish
		return text
	end
end

local function colorizeLine(text, r, g, b)
	local hexCode = E:RGBToHex(r, g, b)
	return format('%s%s|r', hexCode, text)
end

local copyLines = {}
function CH:GetLines(frame)
	local index = 1
	for i = 1, frame:GetNumMessages() do
		local message, r, g, b = frame:GetMessageInfo(i)
		if message and not CH:MessageIsProtected(message) then
			--Set fallback color values
			r, g, b = r or 1, g or 1, b or 1

			--Remove icons
			message = removeIconFromLine(message)

			--Add text color
			message = colorizeLine(message, r, g, b)

			copyLines[index] = message
			index = index + 1
		end
	end

	return index - 1
end

function CH:CopyChat(frame)
	if not _G.CopyChatFrame:IsShown() then
		local _, fontSize = _G.FCF_GetChatWindowInfo(frame:GetID())
		if fontSize < 10 then fontSize = 12 end
		_G.FCF_SetChatWindowFontSize(frame, frame, 0.01)
		_G.CopyChatFrame:Show()
		local lineCt = CH:GetLines(frame)
		local text = tconcat(copyLines, ' \n', 1, lineCt)
		_G.FCF_SetChatWindowFontSize(frame, frame, fontSize)
		_G.CopyChatFrameEditBox:SetText(text)
	else
		_G.CopyChatFrame:Hide()
	end
end

function CH:GetOwner(tab)
	if not tab.owner then
		tab.owner = _G[format('ChatFrame%s', tab:GetID())]
	end

	return tab.owner
end

function CH:GetTab(chat)
	if not chat.tab then
		chat.tab = _G[format('ChatFrame%sTab', chat:GetID())]
	end

	return chat.tab
end

function CH:TabOnEnter(tab)
	tab.Text:Show()

	if tab.conversationIcon then
		tab.conversationIcon:Show()
	end

	if not CH.db.hideCopyButton then
		local chat = CH:GetOwner(tab)
		if chat and chat.copyButton and GetMouseFocus() ~= chat.copyButton then
			chat.copyButton:SetAlpha(0.35)
		end
	end
end

function CH:TabOnLeave(tab)
	tab.Text:Hide()

	if tab.conversationIcon then
		tab.conversationIcon:Hide()
	end

	if not CH.db.hideCopyButton then
		local chat = CH:GetOwner(tab)
		if chat and chat.copyButton and GetMouseFocus() ~= chat.copyButton then
			chat.copyButton:SetAlpha(0)
		end
	end
end

function CH:ChatOnEnter(chat)
	CH:TabOnEnter(CH:GetTab(chat))
end

function CH:ChatOnLeave(chat)
	CH:TabOnLeave(CH:GetTab(chat))
end

function CH:HandleFadeTabs(chat, hook)
	local tab = CH:GetTab(chat)

	if hook then
		if not CH.hooks or not CH.hooks[chat] or not CH.hooks[chat].OnEnter then
			CH:HookScript(chat, 'OnEnter', 'ChatOnEnter')
			CH:HookScript(chat, 'OnLeave', 'ChatOnLeave')
		end

		if not CH.hooks or not CH.hooks[tab] or not CH.hooks[tab].OnEnter then
			CH:HookScript(tab, 'OnEnter', 'TabOnEnter')
			CH:HookScript(tab, 'OnLeave', 'TabOnLeave')
		end
	else
		if CH.hooks and CH.hooks[chat] and CH.hooks[chat].OnEnter then
			CH:Unhook(chat, 'OnEnter')
			CH:Unhook(chat, 'OnLeave')
		end

		if CH.hooks and CH.hooks[tab] and CH.hooks[tab].OnEnter then
			CH:Unhook(tab, 'OnEnter')
			CH:Unhook(tab, 'OnLeave')
		end
	end

	local focus = GetMouseFocus()
	if not hook then
		CH:TabOnEnter(tab)
	elseif focus ~= tab and focus ~= chat then
		CH:TabOnLeave(tab)
	end
end

function CH:ChatEdit_SetLastActiveWindow(editbox)
	local style = editbox.chatStyle or GetCVar('chatStyle')
	if style == 'im' then editbox:SetAlpha(0.5) end
end

function CH:FCFDock_SelectWindow(_, chatFrame)
	if chatFrame then
		CH:UpdateEditboxFont(chatFrame)
	end
end

function CH:ChatEdit_ActivateChat(editbox)
	if editbox and editbox.chatFrame then
		CH:UpdateEditboxFont(editbox.chatFrame)
	end
end

function CH:ChatEdit_DeactivateChat(editbox)
	local style = editbox.chatStyle or GetCVar('chatStyle')
	if style == 'im' then editbox:Hide() end
end

function CH:UpdateEditboxAnchors()
	local cvar = (type(self) == 'string' and self) or GetCVar('chatStyle')

	local classic = cvar == 'classic'
	local leftChat = classic and _G.LeftChatPanel
	local panel = 22

	for _, name in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[name]
		local editbox = frame and frame.editBox
		if not editbox then return end
		editbox.chatStyle = cvar
		editbox:ClearAllPoints()

		local anchorTo = leftChat or frame
		local below, belowInside = CH.db.editBoxPosition == 'BELOW_CHAT', CH.db.editBoxPosition == 'BELOW_CHAT_INSIDE'
		if below or belowInside then
			local showLeftPanel = E.db.datatexts.panels.LeftChatDataPanel.enable
			editbox:Point('TOPLEFT', anchorTo, 'BOTTOMLEFT', classic and (showLeftPanel and 1 or 0) or -2, (classic and (belowInside and 1 or 0) or -5))
			editbox:Point('BOTTOMRIGHT', anchorTo, 'BOTTOMRIGHT', classic and (showLeftPanel and -1 or 0) or -2, (classic and (belowInside and 1 or 0) or -5) + (belowInside and panel or -panel))
		else
			local aboveInside = CH.db.editBoxPosition == 'ABOVE_CHAT_INSIDE'
			editbox:Point('BOTTOMLEFT', anchorTo, 'TOPLEFT', classic and (aboveInside and 1 or 0) or -2, (classic and (aboveInside and -1 or 0) or 2))
			editbox:Point('TOPRIGHT', anchorTo, 'TOPRIGHT', classic and (aboveInside and -1 or 0) or 2, (classic and (aboveInside and -1 or 0) or 2) + (aboveInside and -panel or panel))
		end
	end
end

function CH:FindChatWindows()
	if not CH.db.panelSnapping then return end

	local left, right = CH.LeftChatWindow, CH.RightChatWindow

	-- they already exist just return them :)
	if left and right then
		return left, right
	end

	local docker = _G.GeneralDockManager.primary
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local chat = _G[name]
		if (chat.isDocked and docker) or chat:IsShown() then
			if not left and E:FramesOverlap(chat, _G.LeftChatPanel) then
				left = chat
			elseif not right and E:FramesOverlap(chat, _G.RightChatPanel) then
				right = chat
			end

			-- if both are found just return now, don't wait
			if left and right then
				return left, right
			end
		end
	end

	-- none or one was found
	return left, right
end

function CH:GetDockerParent(docker, chat)
	if not docker then return end

	local _, relativeTo = chat:GetPoint()
	if relativeTo == docker then
		return docker:GetParent()
	end
end

function CH:UpdateChatTab(chat)
	local fadeLeft, fadeRight
	if CH.db.fadeTabsNoBackdrop then
		local both = CH.db.panelBackdrop == 'HIDEBOTH'
		fadeLeft = (both or CH.db.panelBackdrop == 'RIGHT')
		fadeRight = (both or CH.db.panelBackdrop == 'LEFT')
	end

	if chat == CH.LeftChatWindow then
		CH:GetTab(chat):SetParent(_G.LeftChatPanel or _G.UIParent)
		chat:SetParent(_G.LeftChatPanel or _G.UIParent)

		CH:HandleFadeTabs(chat, fadeLeft)
	elseif chat == CH.RightChatWindow then
		CH:GetTab(chat):SetParent(_G.RightChatPanel or _G.UIParent)
		chat:SetParent(_G.RightChatPanel or _G.UIParent)

		CH:HandleFadeTabs(chat, fadeRight)
	else
		local docker = _G.GeneralDockManager.primary
		local parent = CH:GetDockerParent(docker, chat)

		-- we need to update the tab parent to mimic the docker
		CH:GetTab(chat):SetParent(parent or _G.UIParent)
		chat:SetParent(parent or _G.UIParent)

		if parent and docker == CH.LeftChatWindow then
			CH:HandleFadeTabs(chat, fadeLeft)
		elseif parent and docker == CH.RightChatWindow then
			CH:HandleFadeTabs(chat, fadeRight)
		else
			CH:HandleFadeTabs(chat, CH.db.fadeUndockedTabs and CH:IsUndocked(chat, docker))
		end
	end
end

function CH:UpdateChatTabs()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		CH:UpdateChatTab(_G[name])
	end
end

function CH:ToggleChatButton(button)
	if button then
		button:SetShown(not CH.db.hideCopyButton)
	end
end

function CH:ToggleCopyChatButtons()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		CH:ToggleChatButton(_G[name].copyButton)
	end
end

function CH:RefreshToggleButtons()
	_G.LeftChatToggleButton:SetAlpha(E.db.LeftChatPanelFaded and CH.db.fadeChatToggles and 0 or 1)
	_G.RightChatToggleButton:SetAlpha(E.db.RightChatPanelFaded and CH.db.fadeChatToggles and 0 or 1)
	_G.LeftChatToggleButton:SetShown(not CH.db.hideChatToggles and E.db.datatexts.panels.LeftChatDataPanel.enable)
	_G.RightChatToggleButton:SetShown(not CH.db.hideChatToggles and E.db.datatexts.panels.RightChatDataPanel.enable)
end

function CH:IsUndocked(chat, docker)
	if not docker then docker = _G.GeneralDockManager.primary end

	local primaryUndocked = docker ~= CH.LeftChatWindow and docker ~= CH.RightChatWindow
	return not chat.isDocked or (primaryUndocked and ((chat == docker) or CH:GetDockerParent(docker, chat)))
end

function CH:Unsnapped(chat)
	if chat == CH.LeftChatWindow then
		CH.LeftChatWindow = nil
	elseif chat == CH.RightChatWindow then
		CH.RightChatWindow = nil
	end
end

function CH:ClearSnapping()
	CH.LeftChatWindow = nil
	CH.RightChatWindow = nil
end

function CH:SnappingChanged(chat)
	CH:Unsnapped(chat)

	if chat == _G.GeneralDockManager.primary then
		for _, frame in ipairs(_G.GeneralDockManager.DOCKED_CHAT_FRAMES) do
			CH:PositionChat(frame)
		end
	else
		CH:PositionChat(chat)
	end
end

function CH:ShowBackground(background, show)
	if not background then return end

	if show then
		background.Show = nil
		background:Show()
	else
		background:Kill()
	end
end

function CH:PositionChat(chat)
	CH.LeftChatWindow, CH.RightChatWindow = CH:FindChatWindows()

	local docker = _G.GeneralDockManager.primary
	if chat == docker then
		local iconParent, chatParent = CH:GetAnchorParents(chat)
		_G.GeneralDockManager:SetParent(chatParent)

		if CH.db.pinVoiceButtons and not CH.db.hideVoiceButtons then
			CH:ReparentVoiceChatIcon(iconParent or chatParent)
		end
	end

	CH:UpdateChatTab(chat)

	if chat:IsMovable() then
		chat:SetUserPlaced(true)
	end

	if chat.FontStringContainer then
		chat.FontStringContainer:ClearAllPoints()
		chat.FontStringContainer:SetPoint('TOPLEFT', chat, 'TOPLEFT', -1, 1)
		chat.FontStringContainer:SetPoint('BOTTOMRIGHT', chat, 'BOTTOMRIGHT', 1, -1)
	end

	if chat:IsShown() then
		-- that chat font container leaks outside of its frame
		-- we cant clip it, so lets force that leak sooner so
		-- i can position it properly, patch: 8.3.0 ~Simpy
		chat:Hide()
		chat:Show()
	end

	local BASE_OFFSET = 32
	if chat == CH.LeftChatWindow then
		local LOG_OFFSET = chat:GetID() == 2 and (_G.LeftChatTab:GetHeight() + 4) or 0

		chat:ClearAllPoints()
		chat:SetPoint('BOTTOMLEFT', _G.LeftChatPanel, 'BOTTOMLEFT', 5, 5)
		chat:SetSize(CH.db.panelWidth - 10, CH.db.panelHeight - BASE_OFFSET - LOG_OFFSET)

		CH:ShowBackground(chat.Background, false)
	elseif chat == CH.RightChatWindow then
		local LOG_OFFSET = chat:GetID() == 2 and (_G.LeftChatTab:GetHeight() + 4) or 0

		chat:ClearAllPoints()
		chat:SetPoint('BOTTOMLEFT', _G.RightChatPanel, 'BOTTOMLEFT', 5, 5)
		chat:SetSize((CH.db.separateSizes and CH.db.panelWidthRight or CH.db.panelWidth) - 10, (CH.db.separateSizes and CH.db.panelHeightRight or CH.db.panelHeight) - BASE_OFFSET - LOG_OFFSET)

		CH:ShowBackground(chat.Background, false)
	else -- show if: not docked, or ChatFrame1, or attached to ChatFrame1
		CH:ShowBackground(chat.Background, CH:IsUndocked(chat, docker))
	end
end

function CH:PositionChats()
	_G.LeftChatPanel:Size(CH.db.panelWidth, CH.db.panelHeight)
	if CH.db.separateSizes then
		_G.RightChatPanel:Size(CH.db.panelWidthRight, CH.db.panelHeightRight)
	else
		_G.RightChatPanel:Size(CH.db.panelWidth, CH.db.panelHeight)
	end

	LO:RepositionChatDataPanels()

	-- dont proceed when chat is disabled
	if not E.private.chat.enable then return end

	for _, name in ipairs(_G.CHAT_FRAMES) do
		CH:PositionChat(_G[name])
	end
end

function CH:Panel_ColorUpdate()
	local panelColor = CH.db.panelColor
	self:SetBackdropColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
end

function CH:Panels_ColorUpdate()
	local panelColor = CH.db.panelColor
	_G.LeftChatPanel.backdrop:SetBackdropColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
	_G.RightChatPanel.backdrop:SetBackdropColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)

	if _G.ChatButtonHolder then
		_G.ChatButtonHolder:SetBackdropColor(panelColor.r, panelColor.g, panelColor.b, panelColor.a)
	end
end

function CH:UpdateChatTabColors()
	for _, name in ipairs(_G.CHAT_FRAMES) do
		local tab = CH:GetTab(_G[name])
		CH:FCFTab_UpdateColors(tab, tab.selected)
	end
end
E.valueColorUpdateFuncs[CH.UpdateChatTabColors] = true

function CH:ScrollToBottom(frame)
	frame:ScrollToBottom()

	CH:CancelTimer(frame.ScrollTimer, true)
end

function CH:PrintURL(url)
	return '|cFFFFFFFF[|Hurl:'..url..'|h'..url..'|h]|r '
end

function CH:FindURL(event, msg, author, ...)
	if not CH.db.url then
		msg = CH:CheckKeyword(msg, author)
		msg = CH:GetSmileyReplacementText(msg)
		return false, msg, author, ...
	end

	local text, tag = msg, strmatch(msg, '{(.-)}')
	if tag and _G.ICON_TAG_LIST[strlower(tag)] then
		text = gsub(gsub(text, '(%S)({.-})', '%1 %2'), '({.-})(%S)', '%1 %2')
	end

	text = gsub(gsub(text, '(%S)(|c.-|H.-|h.-|h|r)', '%1 %2'), '(|c.-|H.-|h.-|h|r)(%S)', '%1 %2')
	-- http://example.com
	local newMsg, found = gsub(text, '(%a+)://(%S+)%s?', CH:PrintURL('%1://%2'))
	if found > 0 then return false, CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg, author)), author, ... end
	-- www.example.com
	newMsg, found = gsub(text, 'www%.([_A-Za-z0-9-]+)%.(%S+)%s?', CH:PrintURL('www.%1.%2'))
	if found > 0 then return false, CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg, author)), author, ... end
	-- example@example.com
	newMsg, found = gsub(text, '([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?', CH:PrintURL('%1@%2%3%4'))
	if found > 0 then return false, CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg, author)), author, ... end
	-- IP address with port 1.1.1.1:1
	newMsg, found = gsub(text, '(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)(:%d+)%s?', CH:PrintURL('%1.%2.%3.%4%5'))
	if found > 0 then return false, CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg, author)), author, ... end
	-- IP address 1.1.1.1
	newMsg, found = gsub(text, '(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?', CH:PrintURL('%1.%2.%3.%4'))
	if found > 0 then return false, CH:GetSmileyReplacementText(CH:CheckKeyword(newMsg, author)), author, ... end

	msg = CH:CheckKeyword(msg, author)
	msg = CH:GetSmileyReplacementText(msg)

	return false, msg, author, ...
end

function CH:SetChatEditBoxMessage(message)
	local ChatFrameEditBox = _G.ChatEdit_ChooseBoxForSend()
	local editBoxShown = ChatFrameEditBox:IsShown()
	local editBoxText = ChatFrameEditBox:GetText()
	if not editBoxShown then
		_G.ChatEdit_ActivateChat(ChatFrameEditBox)
	end
	if editBoxText and editBoxText ~= '' then
		ChatFrameEditBox:SetText('')
	end
	ChatFrameEditBox:Insert(message)
	ChatFrameEditBox:HighlightText()
end

local function HyperLinkedCPL(data)
	if strsub(data, 1, 3) == 'cpl' then
		local chatID = strsub(data, 5)
		local chat = _G[format('ChatFrame%d', chatID)]
		if not chat then return end
		local scale = chat:GetEffectiveScale() --blizzard does this with `scale = UIParent:GetScale()`
		local cursorX, cursorY = GetCursorPosition()
		cursorX, cursorY = (cursorX / scale), (cursorY / scale)
		local _, lineIndex = chat:FindCharacterAndLineIndexAtCoordinate(cursorX, cursorY)
		if lineIndex then
			local visibleLine = chat.visibleLines and chat.visibleLines[lineIndex]
			local message = visibleLine and visibleLine.messageInfo and visibleLine.messageInfo.message
			if message and message ~= '' then
				message = gsub(message, '|c%x%x%x%x%x%x%x%x(.-)|r', '%1')
				message = strtrim(removeIconFromLine(message))
				if not CH:MessageIsProtected(message) then
					CH:SetChatEditBoxMessage(message)
				end
			end
		end
	end
end

local function HyperLinkedURL(data)
	if strsub(data, 1, 3) == 'url' then
		local currentLink = strsub(data, 5)
		if currentLink and currentLink ~= '' then
			CH:SetChatEditBoxMessage(currentLink)
		end
	end
end

local SetHyperlink = _G.ItemRefTooltip.SetHyperlink
function _G.ItemRefTooltip:SetHyperlink(data, ...)
	if strsub(data, 1, 3) == 'cpl' then
		HyperLinkedCPL(data)
	elseif strsub(data, 1, 3) == 'url' then
		HyperLinkedURL(data)
	else
		SetHyperlink(self, data, ...)
	end
end

local hyperLinkEntered
function CH:OnHyperlinkEnter(frame, refString)
	if InCombatLockdown() then return end
	local linkToken = strmatch(refString, '^([^:]+)')
	if hyperlinkTypes[linkToken] then
		_G.GameTooltip:SetOwner(frame, 'ANCHOR_CURSOR')
		_G.GameTooltip:SetHyperlink(refString)
		_G.GameTooltip:Show()
		hyperLinkEntered = frame
	end
end

function CH:OnHyperlinkLeave()
	if hyperLinkEntered then
		hyperLinkEntered = nil
		_G.GameTooltip:Hide()
	end
end

function CH:OnMouseWheel(frame)
	if hyperLinkEntered == frame then
		hyperLinkEntered = false
		_G.GameTooltip:Hide()
	end
end

function CH:ToggleHyperlink(enable)
	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[frameName]
		local hooked = CH.hooks and CH.hooks[frame] and CH.hooks[frame].OnHyperlinkEnter
		if enable and not hooked then
			CH:HookScript(frame, 'OnHyperlinkEnter')
			CH:HookScript(frame, 'OnHyperlinkLeave')
			CH:HookScript(frame, 'OnMouseWheel')
		elseif not enable and hooked then
			CH:Unhook(frame, 'OnHyperlinkEnter')
			CH:Unhook(frame, 'OnHyperlinkLeave')
			CH:Unhook(frame, 'OnMouseWheel')
		end
	end
end

function CH:DisableChatThrottle()
	wipe(throttle)
end

function CH:ShortChannel()
	return format('|Hchannel:%s|h[%s]|h', self, DEFAULT_STRINGS[strupper(self)] or gsub(self, 'channel:', ''))
end

function CH:HandleShortChannels(msg)
	msg = gsub(msg, '|Hchannel:(.-)|h%[(.-)%]|h', CH.ShortChannel)
	msg = gsub(msg, 'CHANNEL:', '')
	msg = gsub(msg, '^(.-|h) '..L["whispers"], '%1')
	msg = gsub(msg, '^(.-|h) '..L["says"], '%1')
	msg = gsub(msg, '^(.-|h) '..L["yells"], '%1')
	msg = gsub(msg, '<'.._G.AFK..'>', '[|cffFF0000'..L["AFK"]..'|r] ')
	msg = gsub(msg, '<'.._G.DND..'>', '[|cffE7E716'..L["DND"]..'|r] ')
	msg = gsub(msg, '^%['.._G.RAID_WARNING..'%]', '['..L["RW"]..']')
	return msg
end

function CH:GetBNFirstToonClassColor(id)
	if not id then return end
	for i = 1, BNGetNumFriends() do
		local accountInfo --= C_BattleNet_GetFriendAccountInfo(i)
		if accountInfo and (accountInfo.gameAccountInfo and accountInfo.gameAccountInfo.isOnline) and accountInfo.bnetAccountID == id then
			local numGameAccounts --= C_BattleNet_GetFriendNumGameAccounts(i)
			if numGameAccounts and numGameAccounts > 0 then
				for y = 1, numGameAccounts do
					local gameAccountInfo --= C_BattleNet_GetFriendGameAccountInfo(i, y)
					local className = gameAccountInfo and gameAccountInfo.className
					if className and className ~= '' and (gameAccountInfo.clientProgram == BNET_CLIENT_WOW) then
						return className --return the first toon's class
					end
				end
			end
			break
		end
	end
end

function CH:GetBNFriendColor(name, id, useBTag)
	local accountInfo --= C_BattleNet_GetAccountInfoByID(id)
	if not accountInfo then return name end

	local battleTag, isBattleTagFriend, gameAccountInfo = accountInfo.battleTag, accountInfo.isBattleTagFriend, accountInfo.gameAccountInfo

	local BATTLE_TAG = battleTag and strmatch(battleTag,'([^#]+)')
	local TAG = (useBTag or CH.db.useBTagName) and BATTLE_TAG

	local Class
	if not (gameAccountInfo and gameAccountInfo.gameAccountID) then
		local firstToonClass = CH:GetBNFirstToonClassColor(id)
		if firstToonClass then
			Class = E:UnlocalizedClassName(firstToonClass)
		else
			return TAG or name, isBattleTagFriend and BATTLE_TAG
		end
	end

	if not Class then
		Class = gameAccountInfo and gameAccountInfo.className and E:UnlocalizedClassName(gameAccountInfo.className)
	end

	local Color = E:ClassColor(Class)
	return (Color and format('|c%s%s|r', Color.colorStr, TAG or name)) or TAG or name, isBattleTagFriend and BATTLE_TAG
end

local PluginIconsCalls = {}
function CH:AddPluginIcons(func)
	tinsert(PluginIconsCalls, func)
end

function CH:GetPluginIcon(sender)
	for _, func in ipairs(PluginIconsCalls) do
		local icon = func(sender)
		if icon and icon ~= '' then
			return icon
		end
	end
end

function CH:AddPluginMessageFilter(func, position)
	if position then
		tinsert(CH.PluginMessageFilters, position, func)
	else
		tinsert(CH.PluginMessageFilters, func)
	end
end

--Modified copy from FrameXML ChatFrame.lua to add CUSTOM_CLASS_COLORS (args were changed)
function CH:GetColoredName(event, _, arg2, _, _, _, _, _, arg8, _, _, _, arg12)
	local chatType = strsub(event, 10)

	local subType = strsub(chatType, 1, 7)
	if subType == 'WHISPER' then
		chatType = 'WHISPER'
	elseif subType == 'CHANNEL' then
		chatType = 'CHANNEL'..arg8
	end

	--ambiguate guild chat names
	arg2 = Ambiguate(arg2, (chatType == 'GUILD' and 'guild') or 'none')

	local info = arg12 and _G.ChatTypeInfo[chatType]
	if info and _G.Chat_ShouldColorChatByClass(info) then
		local data = CH:GetPlayerInfoByGUID(arg12)
		local classColor = data and data.classColor
		if classColor then
			return format('\124cff%.2x%.2x%.2x%s\124r', classColor.r*255, classColor.g*255, classColor.b*255, arg2)
		end
	end

	return arg2
end

--Copied from FrameXML ChatFrame.lua and modified to add CUSTOM_CLASS_COLORS
local seenGroups = {}
function CH:ChatFrame_ReplaceIconAndGroupExpressions(message, noIconReplacement, noGroupReplacement)
	wipe(seenGroups)

	local ICON_LIST, ICON_TAG_LIST, GROUP_TAG_LIST = _G.ICON_LIST, _G.ICON_TAG_LIST, _G.GROUP_TAG_LIST
	for tag in gmatch(message, '%b{}') do
		local term = strlower(gsub(tag, '[{}]', ''))
		if not noIconReplacement and ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] then
			message = gsub(message, tag, ICON_LIST[ICON_TAG_LIST[term]] .. '0|t')
		elseif not noGroupReplacement and GROUP_TAG_LIST[term] then
			local groupIndex = GROUP_TAG_LIST[term]
			if not seenGroups[groupIndex] then
				seenGroups[groupIndex] = true
				local groupList = '['
				for i = 1, GetNumGroupMembers() do
					local name, _, subgroup, _, _, classFileName = GetRaidRosterInfo(i)
					if name and subgroup == groupIndex then
						local classColorTable = E:ClassColor(classFileName)
						if classColorTable then
							name = format('\124cff%.2x%.2x%.2x%s\124r', classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, name)
						end
						groupList = groupList..(groupList == '[' and '' or _G.PLAYER_LIST_DELIMITER)..name
					end
				end
				if groupList ~= '[' then
					groupList = groupList..']'
					message = gsub(message, tag, groupList, 1)
				end
			end
		end
	end

	return message
end

-- copied from ChatFrame.lua
local function GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
	-- Renaming for clarity:
	local specialFlag = arg6;
	--local zoneChannelID = arg7;
	--local localChannelID = arg8;

	if specialFlag ~= '' then
		if specialFlag == 'GM' or specialFlag == 'DEV' then
			-- Add Blizzard Icon if this was sent by a GM/DEV
			return '|TInterface\\ChatFrame\\UI-ChatIcon-Blizz:12:20:0:0:32:16:4:28:0:16|t '
		else
			return _G['CHAT_FLAG_'..specialFlag]
		end
	end

	return '';
end

function CH:ChatFrame_MessageEventHandler(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17, isHistory, historyTime, historyName, historyBTag)
	-- ElvUI Chat History Note: isHistory, historyTime, historyName, and historyBTag are passed from CH:DisplayChatHistory() and need to be on the end to prevent issues in other addons that listen on ChatFrame_MessageEventHandler.
	-- we also send isHistory and historyTime into CH:AddMessage so that we don't have to override the timestamp.
	if strsub(event, 1, 8) == 'CHAT_MSG' then
		if arg16 then return true end -- hiding sender in letterbox: do NOT even show in chat window (only shows in cinematic frame)

		local notChatHistory, historySavedName --we need to extend the arguments on CH.ChatFrame_MessageEventHandler so we can properly handle saved names without overriding
		if isHistory == 'ElvUI_ChatHistory' then
			if historyBTag then arg2 = historyBTag end -- swap arg2 (which is a |k string) to btag name
			historySavedName = historyName
		else
			notChatHistory = true
		end

		local chatType = strsub(event, 10)
		local info = _G.ChatTypeInfo[chatType]

		--If it was a GM whisper, dispatch it to the GMChat addon.
		if arg6 == 'GM' and chatType == 'WHISPER' then
			return
		end

		local chatFilters = _G.ChatFrame_GetMessageEventFilters(event)
		if chatFilters then
			for _, filterFunc in next, chatFilters do
				local filter, newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14 = filterFunc(frame, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)
				if filter then
					return true
				elseif newarg1 then
					arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14 = newarg1, newarg2, newarg3, newarg4, newarg5, newarg6, newarg7, newarg8, newarg9, newarg10, newarg11, newarg12, newarg13, newarg14
				end
			end
		end

		-- data from populated guid info
		local nameWithRealm, realm
		local data = CH:GetPlayerInfoByGUID(arg12)
		if data then
			realm = data.realm
			nameWithRealm = data.nameWithRealm
		end

		-- fetch the name color to use
		local coloredName = historySavedName or CH:GetColoredName(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14)

		local channelLength = strlen(arg4)
		local infoType = chatType
		if chatType == 'COMMUNITIES_CHANNEL' or ((strsub(chatType, 1, 7) == 'CHANNEL') and (chatType ~= 'CHANNEL_LIST') and ((arg1 ~= 'INVITE') or (chatType ~= 'CHANNEL_NOTICE_USER'))) then
			if arg1 == 'WRONG_PASSWORD' then
				local _, popup = _G.StaticPopup_Visible('CHAT_CHANNEL_PASSWORD')
				if popup and strupper(popup.data) == strupper(arg9) then
					return -- Don't display invalid password messages if we're going to prompt for a password (bug 102312)
				end
			end

			local found = false
			for index, value in pairs(frame.channelList) do
				if channelLength > strlen(value) then
					-- arg9 is the channel name without the number in front...
					if ((arg7 > 0) and (frame.zoneChannelList[index] == arg7)) or (strupper(value) == strupper(arg9)) then
						found = true
						infoType = 'CHANNEL'..arg8
						info = _G.ChatTypeInfo[infoType]
						if chatType == 'CHANNEL_NOTICE' and (arg1 == 'YOU_LEFT') then
							frame.channelList[index] = nil
							frame.zoneChannelList[index] = nil
						end
						break
					end
				end
			end
			if not found or not info then
				return true
			end
		end

		local chatGroup = _G.Chat_GetChatCategory(chatType)
		local chatTarget
		if chatGroup == 'CHANNEL' then
			chatTarget = tostring(arg8)
		elseif chatGroup == 'WHISPER' or chatGroup == 'BN_WHISPER' then
			if not(strsub(arg2, 1, 2) == '|K') then
				chatTarget = strupper(arg2)
			else
				chatTarget = arg2
			end
		end

		if _G.FCFManager_ShouldSuppressMessage(frame, chatGroup, chatTarget) then
			return true
		end

		if chatGroup == 'WHISPER' or chatGroup == 'BN_WHISPER' then
			if frame.privateMessageList and not frame.privateMessageList[strlower(arg2)] then
				return true
			elseif frame.excludePrivateMessageList and frame.excludePrivateMessageList[strlower(arg2)] and ((chatGroup == 'WHISPER' and GetCVar('whisperMode') ~= 'popout_and_inline') or (chatGroup == 'BN_WHISPER' and GetCVar('whisperMode') ~= 'popout_and_inline')) then
				return true
			end
		end

		if frame.privateMessageList then
			-- Dedicated BN whisper windows need online/offline messages for only that player
			if (chatGroup == 'BN_INLINE_TOAST_ALERT' or chatGroup == 'BN_WHISPER_PLAYER_OFFLINE') and not frame.privateMessageList[strlower(arg2)] then
				return true
			end

			-- HACK to put certain system messages into dedicated whisper windows
			if chatGroup == 'SYSTEM' then
				local matchFound = false
				local message = strlower(arg1)
				for playerName in pairs(frame.privateMessageList) do
					local playerNotFoundMsg = strlower(format(_G.ERR_CHAT_PLAYER_NOT_FOUND_S, playerName))
					local charOnlineMsg = strlower(format(_G.ERR_FRIEND_ONLINE_SS, playerName, playerName))
					local charOfflineMsg = strlower(format(_G.ERR_FRIEND_OFFLINE_S, playerName))
					if message == playerNotFoundMsg or message == charOnlineMsg or message == charOfflineMsg then
						matchFound = true
						break
					end
				end

				if not matchFound then
					return true
				end
			end
		end

		if (chatType == 'SYSTEM' or chatType == 'SKILL' or chatType == 'CURRENCY' or chatType == 'MONEY' or
			chatType == 'OPENING' or chatType == 'TRADESKILLS' or chatType == 'PET_INFO' or chatType == 'TARGETICONS' or chatType == 'BN_WHISPER_PLAYER_OFFLINE') then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'LOOT' then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType,1,7) == 'COMBAT_' then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType,1,6) == 'SPELL_' then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif strsub(chatType,1,10) == 'BG_SYSTEM_' then
			frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'IGNORED' then
			frame:AddMessage(format(_G.CHAT_IGNORED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'FILTERED' then
			frame:AddMessage(format(_G.CHAT_FILTERED, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'RESTRICTED' then
			frame:AddMessage(_G.CHAT_RESTRICTED_TRIAL, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'CHANNEL_LIST' then
			if channelLength > 0 then
				frame:AddMessage(format(_G['CHAT_'..chatType..'_GET']..arg1, tonumber(arg8), arg4), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				frame:AddMessage(arg1, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == 'CHANNEL_NOTICE_USER' then
			local globalstring = _G['CHAT_'..arg1..'_NOTICE_BN']
			if not globalstring then
				globalstring = _G['CHAT_'..arg1..'_NOTICE']
			end
			if not globalstring then
				GMError(('Missing global string for %q'):format('CHAT_'..arg1..'_NOTICE_BN'))
				return
			end
			if arg5 ~= '' then
				-- TWO users in this notice (E.G. x kicked y)
				frame:AddMessage(format(globalstring, arg8, arg4, arg2, arg5), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			elseif arg1 == 'INVITE' then
				frame:AddMessage(format(globalstring, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			else
				frame:AddMessage(format(globalstring, arg8, arg4, arg2), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
			if arg1 == 'INVITE' and GetCVarBool('blockChannelInvites') then
				frame:AddMessage(_G.CHAT_MSG_BLOCK_CHAT_CHANNEL_INVITE, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == 'CHANNEL_NOTICE' then
			local globalstring
			if arg1 == 'TRIAL_RESTRICTED' then
				globalstring = _G.CHAT_TRIAL_RESTRICTED_NOTICE_TRIAL
			else
				globalstring = _G['CHAT_'..arg1..'_NOTICE_BN']
				if not globalstring then
					globalstring = _G['CHAT_'..arg1..'_NOTICE']
					if not globalstring then
						GMError(('Missing global string for %q'):format('CHAT_'..arg1..'_NOTICE'))
						return
					end
				end
			end
			local accessID = _G.ChatHistory_GetAccessID(chatGroup, arg8)
			local typeID = _G.ChatHistory_GetAccessID(infoType, arg8, arg12)
			frame:AddMessage(format(globalstring, arg8, _G.ChatFrame_ResolvePrefixedChannelName(arg4)), info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		elseif chatType == 'BN_INLINE_TOAST_ALERT' then
			local globalstring = _G['BN_INLINE_TOAST_'..arg1]
			if not globalstring then
				GMError(('Missing global string for %q'):format('BN_INLINE_TOAST_'..arg1))
				return
			end

			local message
			if arg1 == 'FRIEND_REQUEST' then
				message = globalstring
			elseif arg1 == 'FRIEND_PENDING' then
				message = format(_G.BN_INLINE_TOAST_FRIEND_PENDING, BNGetNumFriendInvites())
			elseif arg1 == 'FRIEND_REMOVED' or arg1 == 'BATTLETAG_FRIEND_REMOVED' then
				message = format(globalstring, arg2)
			elseif arg1 == 'FRIEND_ONLINE' or arg1 == 'FRIEND_OFFLINE' then
				local _, _, battleTag, _, characterName, _, client = BNGetFriendInfoByID(arg13)

				local linkDisplayText
				if client and client ~= '' then
					linkDisplayText = format('[%s] (%s%s)', arg2, BNet_GetClientEmbeddedTexture(client, 14), BNet_GetValidatedCharacterName(characterName, battleTag, client) or '')
				else
					linkDisplayText = format('[%s]', arg2)
				end

				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
				message = format(globalstring, playerLink)
			else
				local linkDisplayText = ('[%s]'):format(arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
				message = format(globalstring, playerLink)
			end
			frame:AddMessage(message, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
		elseif chatType == 'BN_INLINE_TOAST_BROADCAST' then
			if arg1 ~= '' then
				arg1 = RemoveNewlines(RemoveExtraSpaces(arg1))
				local linkDisplayText = ('[%s]'):format(arg2)
				local playerLink = GetBNPlayerLink(arg2, linkDisplayText, arg13, arg11, chatGroup, 0)
				frame:AddMessage(format(_G.BN_INLINE_TOAST_BROADCAST, playerLink, arg1), info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		elseif chatType == 'BN_INLINE_TOAST_BROADCAST_INFORM' then
			if arg1 ~= '' then
				frame:AddMessage(_G.BN_INLINE_TOAST_BROADCAST_INFORM, info.r, info.g, info.b, info.id, nil, nil, isHistory, historyTime)
			end
		else
			local body

			if chatType == 'WHISPER_INFORM' and GMChatFrame_IsGM and GMChatFrame_IsGM(arg2) then
				return
			end

			local showLink = 1
			if strsub(chatType, 1, 7) == 'MONSTER' or strsub(chatType, 1, 9) == 'RAID_BOSS' then
				showLink = nil
			else
				arg1 = gsub(arg1, '%%', '%%%%')
			end

			-- Search for icon links and replace them with texture links.
			arg1 = CH:ChatFrame_ReplaceIconAndGroupExpressions(arg1, arg17, not _G.ChatFrame_CanChatGroupPerformExpressionExpansion(chatGroup)) -- If arg17 is true, don't convert to raid icons

			--Remove groups of many spaces
			arg1 = RemoveExtraSpaces(arg1)

			--ElvUI: Get class colored name for BattleNet friend
			if chatType == 'BN_WHISPER' or chatType == 'BN_WHISPER_INFORM' then
				coloredName = historySavedName or CH:GetBNFriendColor(arg2, arg13)
			end

			local playerLink
			local playerLinkDisplayText = coloredName
			local relevantDefaultLanguage = frame.defaultLanguage
			if chatType == 'SAY' or chatType == 'YELL' then
				relevantDefaultLanguage = frame.alternativeDefaultLanguage
			end
			local usingDifferentLanguage = (arg3 ~= '') and (arg3 ~= relevantDefaultLanguage)
			local usingEmote = (chatType == 'EMOTE') or (chatType == 'TEXT_EMOTE')

			if usingDifferentLanguage or not usingEmote then
				playerLinkDisplayText = ('[%s]'):format(coloredName)
			end

			local isCommunityType = chatType == 'COMMUNITIES_CHANNEL'
			local playerName, lineID, bnetIDAccount = arg2, arg11, arg13
			if isCommunityType then
				local isBattleNetCommunity = bnetIDAccount ~= nil and bnetIDAccount ~= 0
				local messageInfo, clubId, streamId = C_Club_GetInfoFromLastCommunityChatLine()

				if messageInfo ~= nil then
					if isBattleNetCommunity then
						playerLink = GetBNPlayerCommunityLink(playerName, playerLinkDisplayText, bnetIDAccount, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					else
						playerLink = GetPlayerCommunityLink(playerName, playerLinkDisplayText, clubId, streamId, messageInfo.messageId.epoch, messageInfo.messageId.position)
					end
				else
					playerLink = playerLinkDisplayText
				end
			else
				if chatType == 'BN_WHISPER' or chatType == 'BN_WHISPER_INFORM' then
					playerLink = GetBNPlayerLink(playerName, playerLinkDisplayText, bnetIDAccount, lineID, chatGroup, chatTarget)
				elseif ((chatType == 'GUILD' or chatType == 'TEXT_EMOTE') or arg14) and (nameWithRealm and nameWithRealm ~= playerName) then
					playerName = nameWithRealm
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				else
					playerLink = GetPlayerLink(playerName, playerLinkDisplayText, lineID, chatGroup, chatTarget)
				end
			end

			local message = arg1
			if arg14 then --isMobile
				message = _G.ChatFrame_GetMobileEmbeddedTexture(info.r, info.g, info.b)..message
			end

			-- Player Flags
			local pflag = GetPFlag(arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12, arg13, arg14, arg15, arg16, arg17)
			local chatIcon, pluginChatIcon = specialChatIcons[playerName], CH:GetPluginIcon(playerName)
			if type(chatIcon) == 'function' then
				local icon, prettify = chatIcon()
				if prettify and not CH:MessageIsProtected(message) then
					message = prettify(message)
				end
				chatIcon = icon or ''
			end

			-- Special Chat Icon
			if chatIcon then
				pflag = pflag..chatIcon
			end
			-- Plugin Chat Icon
			if pluginChatIcon then
				pflag = pflag..pluginChatIcon
			end

			if usingDifferentLanguage then
				local languageHeader = '['..arg3..'] '
				if showLink and (arg2 ~= '') then
					body = format(_G['CHAT_'..chatType..'_GET']..languageHeader..message, pflag..playerLink)
				else
					body = format(_G['CHAT_'..chatType..'_GET']..languageHeader..message, pflag..arg2)
				end
			else
				if not showLink or arg2 == '' then
					if chatType == 'TEXT_EMOTE' then
						body = message
					else
						body = format(_G['CHAT_'..chatType..'_GET']..message, pflag..arg2, arg2)
					end
				else
					if chatType == 'EMOTE' then
						body = format(_G['CHAT_'..chatType..'_GET']..message, pflag..playerLink)
					elseif chatType == 'TEXT_EMOTE' and realm then
						if info.colorNameByClass then
							body = gsub(message, arg2..'%-'..realm, pflag..gsub(playerLink, '(|h|c.-)|r|h$','%1-'..realm..'|r|h'), 1)
						else
							body = gsub(message, arg2..'%-'..realm, pflag..gsub(playerLink, '(|h.-)|h$','%1-'..realm..'|h'), 1)
						end
					elseif chatType == 'TEXT_EMOTE' then
						body = gsub(message, arg2, pflag..playerLink, 1)
					elseif chatType == 'GUILD_ITEM_LOOTED' then
						body = gsub(message, '$s', GetPlayerLink(arg2, playerLinkDisplayText))
					else
						body = format(_G['CHAT_'..chatType..'_GET']..message, pflag..playerLink)
					end
				end
			end

			-- Add Channel
			if channelLength > 0 then
				body = '|Hchannel:channel:'..arg8..'|h['.._G.ChatFrame_ResolvePrefixedChannelName(arg4)..']|h '..body
			end

			if CH.db.shortChannels and (chatType ~= 'EMOTE' and chatType ~= 'TEXT_EMOTE') then
				body = CH:HandleShortChannels(body)
			end

			for _, filter in ipairs(CH.PluginMessageFilters) do
				body = filter(body)
			end

			local accessID = _G.ChatHistory_GetAccessID(chatGroup, chatTarget)
			local typeID = _G.ChatHistory_GetAccessID(infoType, chatTarget, arg12 or arg13)

			local alertType = notChatHistory and not CH.SoundTimer and not strfind(event, '_INFORM') and CH.db.channelAlerts[historyTypes[event]]
			if alertType and alertType ~= 'None' and arg2 ~= PLAYER_NAME and (not CH.db.noAlertInCombat or not InCombatLockdown()) then
				CH.SoundTimer = E:Delay(5, CH.ThrottleSound)
				PlaySoundFile(LSM:Fetch('sound', alertType), 'Master')
			end

			frame:AddMessage(body, info.r, info.g, info.b, info.id, accessID, typeID, isHistory, historyTime)
		end

		if notChatHistory and (chatType == 'WHISPER' or chatType == 'BN_WHISPER') then
			_G.ChatEdit_SetLastTellTarget(arg2, chatType)
			FlashClientIcon()
		end

		if notChatHistory and not frame:IsShown() then
			if (frame == _G.DEFAULT_CHAT_FRAME and info.flashTabOnGeneral) or (frame ~= _G.DEFAULT_CHAT_FRAME and info.flashTab) then
				if not _G.CHAT_OPTIONS.HIDE_FRAME_ALERTS or chatType == 'WHISPER' or chatType == 'BN_WHISPER' then
					if not _G.FCFManager_ShouldSuppressMessageFlash(frame, chatGroup, chatTarget) then
						_G.FCF_StartAlertFlash(frame) --This would taint if we were not using LibChatAnims
					end
				end
			end
		end

		return true
	end
end

function CH:ChatFrame_ConfigEventHandler(...)
	return _G.ChatFrame_ConfigEventHandler(...)
end

function CH:ChatFrame_SystemEventHandler(frame, event, message, ...)
	return _G.ChatFrame_SystemEventHandler(frame, event, message, ...)
end

function CH:ChatFrame_OnEvent(...)
	if CH:ChatFrame_ConfigEventHandler(...) then return end
	if CH:ChatFrame_SystemEventHandler(...) then return end
	if CH:ChatFrame_MessageEventHandler(...) then return end
end

function CH:FloatingChatFrame_OnEvent(...)
	CH:ChatFrame_OnEvent(...)
	_G.FloatingChatFrame_OnEvent(...)
end

local function FloatingChatFrameOnEvent(...)
	CH:FloatingChatFrame_OnEvent(...)
end

function CH:ChatFrame_SetScript(script, func)
	if script == 'OnMouseWheel' and func ~= CH.ChatFrame_OnMouseScroll then
		self:SetScript(script, CH.ChatFrame_OnMouseScroll)
	end
end

function CH:SetupChat()
	if not E.private.chat.enable then return end

	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[frameName]
		local id = frame:GetID()
		CH:StyleChat(frame)

		_G.FCFTab_UpdateAlpha(frame)

		if id ~= 2 and not frame.OldAddMessage then
			--Don't add timestamps to combat log, they don't work.
			--This usually taints, but LibChatAnims should make sure it doesn't.
			frame.OldAddMessage = frame.AddMessage
			frame.AddMessage = CH.AddMessage
		end

		if not frame.scriptsSet then
			if id ~= 2 then
				frame:SetScript('OnEvent', FloatingChatFrameOnEvent)
			end

			frame:SetScript('OnMouseWheel', CH.ChatFrame_OnMouseScroll)
			hooksecurefunc(frame, 'SetScript', CH.ChatFrame_SetScript)
			frame.scriptsSet = true
		end
	end

	CH:ToggleHyperlink(CH.db.hyperlinkHover)

	local chat = _G.GeneralDockManager.primary
	_G.GeneralDockManager:ClearAllPoints()
	_G.GeneralDockManager:Point('BOTTOMLEFT', chat, 'TOPLEFT', 0, 3)
	_G.GeneralDockManager:Point('BOTTOMRIGHT', chat, 'TOPRIGHT', 0, 3)
	_G.GeneralDockManager:Height(22)
	_G.GeneralDockManagerScrollFrame:Height(22)
	_G.GeneralDockManagerScrollFrameChild:Height(22)

	CH:PositionChats()

	if not CH.HookSecured then
		CH:SecureHook('FCF_OpenTemporaryWindow', 'SetupChat')
		CH.HookSecured = true
	end
end

local function PrepareMessage(author, message)
	if author and author ~= '' and message and message ~= '' then
		return strupper(author) .. message
	end
end

function CH:ChatThrottleHandler(arg1, arg2, when)
	local msg = PrepareMessage(arg1, arg2)
	if msg then
		for message, object in pairs(throttle) do
			if difftime(when, object.time) >= CH.db.throttleInterval then
				throttle[message] = nil
			end
		end

		if not throttle[msg] then
			throttle[msg] = {time = time(), count = 1}
		else
			throttle[msg].count = throttle[msg].count + 1
		end
	end
end

function CH:ChatThrottleBlockFlag(author, message, when)
	local msg = (author ~= PLAYER_NAME) and (CH.db.throttleInterval ~= 0) and PrepareMessage(author, message)
	local object = msg and throttle[msg]

	return object and object.time and object.count and object.count > 1 and (difftime(when, object.time) <= CH.db.throttleInterval), object
end

function CH:ChatThrottleIntervalHandler(event, message, author, ...)
	local blockFlag, blockObject = CH:ChatThrottleBlockFlag(author, message, time())

	if blockFlag then
		return true
	else
		if blockObject then blockObject.time = time() end
		return CH:FindURL(event, message, author, ...)
	end
end

function CH:CHAT_MSG_CHANNEL(event, message, author, ...)
	return CH:ChatThrottleIntervalHandler(event, message, author, ...)
end

function CH:CHAT_MSG_YELL(event, message, author, ...)
	return CH:ChatThrottleIntervalHandler(event, message, author, ...)
end

function CH:CHAT_MSG_SAY(event, message, author, ...)
	return CH:ChatThrottleIntervalHandler(event, message, author, ...)
end

function CH:ThrottleSound()
	CH.SoundTimer = nil
end

local protectLinks = {}
function CH:CheckKeyword(message, author)
	local letInCombat = not CH.db.noAlertInCombat or not InCombatLockdown()
	local letSound = not CH.SoundTimer and (CH.db.keywordSound ~= 'None' and author ~= PLAYER_NAME) and letInCombat

	for hyperLink in gmatch(message, '|c%x-|H.-|h.-|h|r') do
		protectLinks[hyperLink] = gsub(hyperLink,'%s','|s')

		if letSound then
			for keyword in pairs(CH.Keywords) do
				if hyperLink == keyword then
					CH.SoundTimer = E:Delay(5, CH.ThrottleSound)
					PlaySoundFile(LSM:Fetch('sound', CH.db.keywordSound), 'Master')
					letSound = false -- dont let a second sound fire below
					break
				end
			end
		end
	end

	for hyperLink, tempLink in pairs(protectLinks) do
		message = gsub(message, E:EscapeString(hyperLink), tempLink)
	end

	local rebuiltString
	local isFirstWord = true
	for word in gmatch(message, '%s-%S+%s*') do
		if not next(protectLinks) or not protectLinks[gsub(gsub(word,'%s',''),'|s',' ')] then
			local tempWord = gsub(word, '[%s%p]', '')
			local lowerCaseWord = strlower(tempWord)

			for keyword in pairs(CH.Keywords) do
				if lowerCaseWord == strlower(keyword) then
					word = gsub(word, tempWord, format('%s%s|r', E.media.hexvaluecolor, tempWord))

					if letSound then -- dont break because it's recoloring all found
						CH.SoundTimer = E:Delay(5, CH.ThrottleSound)
						PlaySoundFile(LSM:Fetch('sound', CH.db.keywordSound), 'Master')
						letSound = false -- but dont let additional hits call the sound
					end
				end
			end

			if CH.db.classColorMentionsChat then
				tempWord = gsub(word,'^[%s%p]-([^%s%p]+)([%-]?[^%s%p]-)[%s%p]*$','%1%2')
				lowerCaseWord = strlower(tempWord)

				local classMatch = CH.ClassNames[lowerCaseWord]
				local wordMatch = classMatch and lowerCaseWord

				if wordMatch and not E.global.chat.classColorMentionExcludedNames[wordMatch] then
					local classColorTable = E:ClassColor(classMatch)
					if classColorTable then
						word = gsub(word, gsub(tempWord, '%-','%%-'), format('\124cff%.2x%.2x%.2x%s\124r', classColorTable.r*255, classColorTable.g*255, classColorTable.b*255, tempWord))
					end
				end
			end
		end

		if isFirstWord then
			rebuiltString = word
			isFirstWord = false
		else
			rebuiltString = rebuiltString..word
		end
	end

	for hyperLink, tempLink in pairs(protectLinks) do
		rebuiltString = gsub(rebuiltString, E:EscapeString(tempLink), hyperLink)
		protectLinks[hyperLink] = nil
	end

	return rebuiltString
end

function CH:AddLines(lines, ...)
	for i = select('#', ...), 1, -1 do
	local x = select(i, ...)
		if x:IsObjectType('FontString') and not x:GetName() then
			tinsert(lines, x:GetText())
		end
	end
end

function CH:ChatEdit_OnEnterPressed(editBox)
	editBox:ClearHistory() -- we will use our own editbox history so keeping them populated on blizzards end is pointless

	local chatType = editBox:GetAttribute('chatType')
	local chatFrame = chatType and editBox:GetParent()
	if chatFrame and (not chatFrame.isTemporary) and (_G.ChatTypeInfo[chatType].sticky == 1) then
		if not CH.db.sticky then chatType = 'SAY' end
		editBox:SetAttribute('chatType', chatType)
	end
end

function CH:SetChatFont(dropDown, chatFrame, fontSize)
	if not chatFrame then chatFrame = _G.FCF_GetCurrentChatFrame() end
	if not fontSize then fontSize = dropDown.value end

	chatFrame:FontTemplate(LSM:Fetch('font', CH.db.font), fontSize, CH.db.fontOutline)

	CH:UpdateEditboxFont(chatFrame)
end

CH.SecureSlashCMD = {
	'^/rl',
	'^/tar',
	'^/target',
	'^/startattack',
	'^/stopattack',
	'^/assist',
	'^/cast',
	'^/use',
	'^/castsequence',
	'^/cancelaura',
	'^/cancelform',
	'^/equip',
	'^/exit',
	'^/camp',
	'^/logout'
}

function CH:ChatEdit_AddHistory(_, line) -- editBox, line
	line = line and strtrim(line)

	if line and strlen(line) > 0 then
		for _, command in next, CH.SecureSlashCMD do
			if strmatch(line, command) then
				return
			end
		end

		for index, text in pairs(ElvCharacterDB.ChatEditHistory) do
			if text == line then
				tremove(ElvCharacterDB.ChatEditHistory, index)
				break
			end
		end

		tinsert(ElvCharacterDB.ChatEditHistory, line)

		if #ElvCharacterDB.ChatEditHistory > CH.db.editboxHistorySize then
			tremove(ElvCharacterDB.ChatEditHistory, 1)
		end
	end
end

function CH:UpdateChatKeywords()
	wipe(CH.Keywords)

	local keywords = CH.db.keywords
	keywords = gsub(keywords,',%s',',')

	for stringValue in gmatch(keywords, '[^,]+') do
		if stringValue ~= '' then
			CH.Keywords[stringValue] = true
		end
	end
end

function CH:FCF_Close(chat)
	-- clear these off when it's closed, used by FCFTab_UpdateColors
	local tab = CH:GetTab(chat)
	tab.whisperName = nil
	tab.classColor = nil
end

function CH:UpdateFading()
	for _, frameName in ipairs(_G.CHAT_FRAMES) do
		local frame = _G[frameName]
		if frame then
			frame:SetTimeVisible(CH.db.inactivityTimer)
			frame:SetFading(CH.db.fade)
		end
	end
end

function CH:DisplayChatHistory()
	local data = ElvCharacterDB.ChatHistoryLog
	if not (data and next(data)) then return end

	if not CH:GetPlayerInfoByGUID(E.myguid) then
		E:Delay(0.1, CH.DisplayChatHistory)
		return
	end

	for _, chat in ipairs(_G.CHAT_FRAMES) do
		for _, d in ipairs(data) do
			if type(d) == 'table' then
				for _, messageType in pairs(_G[chat].messageTypeList) do
					local historyType, skip = historyTypes[d[50]]
					if historyType then -- let others go by..
						if not CH.db.showHistory[historyType] then skip = true end -- but kill ignored ones
					end
					if not skip and gsub(strsub(d[50],10),'_INFORM','') == messageType then
						if d[1] and not CH:MessageIsProtected(d[1]) then
							CH:ChatFrame_MessageEventHandler(_G[chat],d[50],d[1],d[2],d[3],d[4],d[5],d[6],d[7],d[8],d[9],d[10],d[11],d[12],d[13],d[14],d[15],d[16],d[17],'ElvUI_ChatHistory',d[51],d[52],d[53])
						end
					end
				end
			end
		end
	end
end

tremove(_G.ChatTypeGroup.GUILD, 2)
function CH:DelayGuildMOTD()
	local delay, checks, delayFrame, chat = 0, 0, CreateFrame('Frame')
	tinsert(_G.ChatTypeGroup.GUILD, 2, 'GUILD_MOTD')
	delayFrame:SetScript('OnUpdate', function(df, elapsed)
		delay = delay + elapsed
		if delay < 5 then return end
		local msg = GetGuildRosterMOTD()
		if msg and strlen(msg) > 0 then
			for _, frame in ipairs(_G.CHAT_FRAMES) do
				chat = _G[frame]
				if chat and chat:IsEventRegistered('CHAT_MSG_GUILD') then
					CH:ChatFrame_SystemEventHandler(chat, 'GUILD_MOTD', msg)
					chat:RegisterEvent('GUILD_MOTD')
				end
			end
			df:SetScript('OnUpdate', nil)
		else -- 5 seconds can be too fast for the API response. let's try once every 5 seconds (max 5 checks).
			delay, checks = 0, checks + 1
			if checks >= 5 then
				df:SetScript('OnUpdate', nil)
			end
		end
	end)
end

function CH:SaveChatHistory(event, ...)
	local historyType = historyTypes[event]
	if historyType then -- let others go by..
		if not CH.db.showHistory[historyType] then return end -- but kill ignored ones
	end

	if CH.db.throttleInterval ~= 0 and (event == 'CHAT_MSG_SAY' or event == 'CHAT_MSG_YELL' or event == 'CHAT_MSG_CHANNEL') then
		local message, author = ...
		local when = time()

		CH:ChatThrottleHandler(author, message, when)

		if CH:ChatThrottleBlockFlag(author, message, when) then
			return
		end
	end

	if not CH.db.chatHistory then return end
	local data = ElvCharacterDB.ChatHistoryLog
	if not data then return end

	local tempHistory = {}
	for i = 1, select('#', ...) do
		tempHistory[i] = select(i, ...) or false
	end

	if #tempHistory > 0 and not CH:MessageIsProtected(tempHistory[1]) then
		tempHistory[50] = event
		tempHistory[51] = CH:GetChatTime()

		local coloredName, battleTag
		if tempHistory[13] > 0 then coloredName, battleTag = CH:GetBNFriendColor(tempHistory[2], tempHistory[13], true) end
		if battleTag then tempHistory[53] = battleTag end -- store the battletag, only when the person is known by battletag, so we can replace arg2 later in the function
		tempHistory[52] = coloredName or CH:GetColoredName(event, ...)

		tinsert(data, tempHistory)
		while #data >= CH.db.historySize do
			tremove(data, 1)
		end
	end
end

function CH:GetCombatLog()
	local LOG = _G.COMBATLOG -- ChatFrame2
	if LOG then return LOG, CH:GetTab(LOG) end
end

function CH:FCFDock_UpdateTabs(dock)
	if dock == _G.GeneralDockManager then
		local logchat, logchattab = CH:GetCombatLog()
		dock.scrollFrame:ClearAllPoints()
		dock.scrollFrame:Point('RIGHT', dock.overflowButton, 'LEFT')
		dock.scrollFrame:Point('TOPLEFT', (logchat.isDocked and logchattab) or CH:GetTab(dock.primary), 'TOPRIGHT')
	end
end

function CH:FCF_SetWindowAlpha(frame, alpha)
	frame.oldAlpha = alpha or 1
end

local FindURL_Events = {
	'CHAT_MSG_WHISPER',
	'CHAT_MSG_WHISPER_INFORM',
	'CHAT_MSG_BN_WHISPER',
	'CHAT_MSG_BN_WHISPER_INFORM',
	'CHAT_MSG_BN_INLINE_TOAST_BROADCAST',
	'CHAT_MSG_GUILD',
	'CHAT_MSG_OFFICER',
	'CHAT_MSG_PARTY',
	'CHAT_MSG_PARTY_LEADER',
	'CHAT_MSG_RAID',
	'CHAT_MSG_RAID_LEADER',
	'CHAT_MSG_RAID_WARNING',
	'CHAT_MSG_CHANNEL',
	'CHAT_MSG_SAY',
	'CHAT_MSG_YELL',
	'CHAT_MSG_EMOTE',
	'CHAT_MSG_AFK',
	'CHAT_MSG_DND',
	'CHAT_MSG_COMMUNITIES_CHANNEL',
}

function CH:DefaultSmileys()
	local x = ':16:16'
	if next(CH.Smileys) then
		wipe(CH.Smileys)
	end

	-- new keys
	CH:AddSmiley(':angry:', E:TextureString(E.Media.ChatEmojis.Angry,x))
	CH:AddSmiley(':blush:', E:TextureString(E.Media.ChatEmojis.Blush,x))
	CH:AddSmiley(':broken_heart:', E:TextureString(E.Media.ChatEmojis.BrokenHeart,x))
	CH:AddSmiley(':call_me:', E:TextureString(E.Media.ChatEmojis.CallMe,x))
	CH:AddSmiley(':cry:', E:TextureString(E.Media.ChatEmojis.Cry,x))
	CH:AddSmiley(':facepalm:', E:TextureString(E.Media.ChatEmojis.Facepalm,x))
	CH:AddSmiley(':grin:', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley(':heart:', E:TextureString(E.Media.ChatEmojis.Heart,x))
	CH:AddSmiley(':heart_eyes:', E:TextureString(E.Media.ChatEmojis.HeartEyes,x))
	CH:AddSmiley(':joy:', E:TextureString(E.Media.ChatEmojis.Joy,x))
	CH:AddSmiley(':kappa:', E:TextureString(E.Media.ChatEmojis.Kappa,x))
	CH:AddSmiley(':middle_finger:', E:TextureString(E.Media.ChatEmojis.MiddleFinger,x))
	CH:AddSmiley(':murloc:', E:TextureString(E.Media.ChatEmojis.Murloc,x))
	CH:AddSmiley(':ok_hand:', E:TextureString(E.Media.ChatEmojis.OkHand,x))
	CH:AddSmiley(':open_mouth:', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':poop:', E:TextureString(E.Media.ChatEmojis.Poop,x))
	CH:AddSmiley(':rage:', E:TextureString(E.Media.ChatEmojis.Rage,x))
	CH:AddSmiley(':sadkitty:', E:TextureString(E.Media.ChatEmojis.SadKitty,x))
	CH:AddSmiley(':scream:', E:TextureString(E.Media.ChatEmojis.Scream,x))
	CH:AddSmiley(':scream_cat:', E:TextureString(E.Media.ChatEmojis.ScreamCat,x))
	CH:AddSmiley(':slight_frown:', E:TextureString(E.Media.ChatEmojis.SlightFrown,x))
	CH:AddSmiley(':smile:', E:TextureString(E.Media.ChatEmojis.Smile,x))
	CH:AddSmiley(':smirk:', E:TextureString(E.Media.ChatEmojis.Smirk,x))
	CH:AddSmiley(':sob:', E:TextureString(E.Media.ChatEmojis.Sob,x))
	CH:AddSmiley(':sunglasses:', E:TextureString(E.Media.ChatEmojis.Sunglasses,x))
	CH:AddSmiley(':thinking:', E:TextureString(E.Media.ChatEmojis.Thinking,x))
	CH:AddSmiley(':thumbs_up:', E:TextureString(E.Media.ChatEmojis.ThumbsUp,x))
	CH:AddSmiley(':semi_colon:', E:TextureString(E.Media.ChatEmojis.SemiColon,x))
	CH:AddSmiley(':wink:', E:TextureString(E.Media.ChatEmojis.Wink,x))
	CH:AddSmiley(':zzz:', E:TextureString(E.Media.ChatEmojis.ZZZ,x))
	CH:AddSmiley(':stuck_out_tongue:', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley(':stuck_out_tongue_closed_eyes:', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))

	-- Darth's keys
	CH:AddSmiley(':meaw:', E:TextureString(E.Media.ChatEmojis.Meaw,x))

	-- Simpy's keys
	CH:AddSmiley('>:%(', E:TextureString(E.Media.ChatEmojis.Rage,x))
	CH:AddSmiley(':%$', E:TextureString(E.Media.ChatEmojis.Blush,x))
	CH:AddSmiley('<\\3', E:TextureString(E.Media.ChatEmojis.BrokenHeart,x))
	CH:AddSmiley(':\'%)', E:TextureString(E.Media.ChatEmojis.Joy,x))
	CH:AddSmiley(';\'%)', E:TextureString(E.Media.ChatEmojis.Joy,x))
	CH:AddSmiley(',,!,,', E:TextureString(E.Media.ChatEmojis.MiddleFinger,x))
	CH:AddSmiley('D:<', E:TextureString(E.Media.ChatEmojis.Rage,x))
	CH:AddSmiley(':o3', E:TextureString(E.Media.ChatEmojis.ScreamCat,x))
	CH:AddSmiley('XP', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))
	CH:AddSmiley('8%-%)', E:TextureString(E.Media.ChatEmojis.Sunglasses,x))
	CH:AddSmiley('8%)', E:TextureString(E.Media.ChatEmojis.Sunglasses,x))
	CH:AddSmiley(':%+1:', E:TextureString(E.Media.ChatEmojis.ThumbsUp,x))
	CH:AddSmiley(':;:', E:TextureString(E.Media.ChatEmojis.SemiColon,x))
	CH:AddSmiley(';o;', E:TextureString(E.Media.ChatEmojis.Sob,x))

	-- old keys
	CH:AddSmiley(':%-@', E:TextureString(E.Media.ChatEmojis.Angry,x))
	CH:AddSmiley(':@', E:TextureString(E.Media.ChatEmojis.Angry,x))
	CH:AddSmiley(':%-%)', E:TextureString(E.Media.ChatEmojis.Smile,x))
	CH:AddSmiley(':%)', E:TextureString(E.Media.ChatEmojis.Smile,x))
	CH:AddSmiley(':D', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley(':%-D', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley(';%-D', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley(';D', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley('=D', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley('xD', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley('XD', E:TextureString(E.Media.ChatEmojis.Grin,x))
	CH:AddSmiley(':%-%(', E:TextureString(E.Media.ChatEmojis.SlightFrown,x))
	CH:AddSmiley(':%(', E:TextureString(E.Media.ChatEmojis.SlightFrown,x))
	CH:AddSmiley(':o', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':%-o', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':%-O', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':O', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':%-0', E:TextureString(E.Media.ChatEmojis.OpenMouth,x))
	CH:AddSmiley(':P', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley(':%-P', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley(':p', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley(':%-p', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley('=P', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley('=p', E:TextureString(E.Media.ChatEmojis.StuckOutTongue,x))
	CH:AddSmiley(';%-p', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))
	CH:AddSmiley(';p', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))
	CH:AddSmiley(';P', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))
	CH:AddSmiley(';%-P', E:TextureString(E.Media.ChatEmojis.StuckOutTongueClosedEyes,x))
	CH:AddSmiley(';%-%)', E:TextureString(E.Media.ChatEmojis.Wink,x))
	CH:AddSmiley(';%)', E:TextureString(E.Media.ChatEmojis.Wink,x))
	CH:AddSmiley(':S', E:TextureString(E.Media.ChatEmojis.Smirk,x))
	CH:AddSmiley(':%-S', E:TextureString(E.Media.ChatEmojis.Smirk,x))
	CH:AddSmiley(':,%(', E:TextureString(E.Media.ChatEmojis.Cry,x))
	CH:AddSmiley(':,%-%(', E:TextureString(E.Media.ChatEmojis.Cry,x))
	CH:AddSmiley(':\'%(', E:TextureString(E.Media.ChatEmojis.Cry,x))
	CH:AddSmiley(':\'%-%(', E:TextureString(E.Media.ChatEmojis.Cry,x))
	CH:AddSmiley(':F', E:TextureString(E.Media.ChatEmojis.MiddleFinger,x))
	CH:AddSmiley('<3', E:TextureString(E.Media.ChatEmojis.Heart,x))
	CH:AddSmiley('</3', E:TextureString(E.Media.ChatEmojis.BrokenHeart,x))
end

function CH:GetAnchorParents(chat)
	local Left = (chat == CH.LeftChatWindow and _G.LeftChatPanel)
	local Right = (chat == CH.RightChatWindow and _G.RightChatPanel)
	local Chat, TabPanel = Left or Right or _G.UIParent
	if CH.db.panelTabBackdrop and not ((CH.db.panelBackdrop == 'HIDEBOTH') or (Left and CH.db.panelBackdrop == 'RIGHT') or (Right and CH.db.panelBackdrop == 'LEFT')) then
		TabPanel = (Left and _G.LeftChatTab) or (Right and _G.RightChatTab)
	end

	return TabPanel or Chat, Chat
end

function CH:ReparentVoiceChatIcon(parent)
	if not parent then
		parent = CH:GetAnchorParents(_G.GeneralDockManager.primary)
	end

	_G.ChatFrameChannelButton:SetParent(parent)
end

function CH:RepositionOverflowButton()
	_G.GeneralDockManagerOverflowButton:ClearAllPoints()
	_G.GeneralDockManagerOverflowButton:Point('RIGHT', _G.ChatFrameChannelButton, 'LEFT', -4, 0)
end

function CH:UpdateVoiceChatIcons()
	_G.ChatFrameChannelButton.Icon:SetDesaturated(CH.db.desaturateVoiceIcons)
end

function CH:HandleChatVoiceIcons()
	if CH.db.hideVoiceButtons then
		_G.ChatFrameChannelButton:Hide()
	elseif CH.db.pinVoiceButtons then
		Skins:HandleButton(_G.ChatFrameChannelButton)
		_G.ChatFrameChannelButton.Icon:SetDesaturated(CH.db.desaturateVoiceIcons)
		_G.ChatFrameChannelButton:ClearAllPoints()
		_G.ChatFrameChannelButton:Point('RIGHT', _G.GeneralDockManager, 'RIGHT', 2, 0)
		_G.ChatFrameChannelButton.backdrop:Hide()

		CH:RepositionOverflowButton()
	else
		CH:CreateChatVoicePanel()
	end

	if not CH.db.hideVoiceButtons then
		_G.GeneralDockManagerOverflowButtonList:SetFrameStrata('LOW')
		_G.GeneralDockManagerOverflowButtonList:SetFrameLevel(5)
	end

	if not CH.db.pinVoiceButtons then
		_G.GeneralDockManagerOverflowButton:ClearAllPoints()
		_G.GeneralDockManagerOverflowButton:Point('RIGHT', _G.GeneralDockManager, 'RIGHT', -4, 0)
	end
end

function CH:CreateChatVoicePanel()
	local Holder = CreateFrame('Frame', 'ChatButtonHolder', E.UIParent)
	Holder:ClearAllPoints()
	Holder:Point('BOTTOMLEFT', _G.LeftChatPanel, 'TOPLEFT', 0, 1)
	Holder:Size(30, 86)
	Holder:SetTemplate('Transparent', nil, true)
	Holder:SetBackdropColor(CH.db.panelColor.r, CH.db.panelColor.g, CH.db.panelColor.b, CH.db.panelColor.a)
	E:CreateMover(Holder, 'SocialMenuMover', _G.BINDING_HEADER_VOICE_CHAT, nil, nil, nil, nil, nil, 'chat')

	_G.ChatFrameChannelButton:ClearAllPoints()
	_G.ChatFrameChannelButton:Point('TOP', Holder, 'TOP', 0, -2)

	Skins:HandleButton(_G.ChatFrameChannelButton, nil, nil, true)
	_G.ChatFrameChannelButton.Icon:SetParent(_G.ChatFrameChannelButton)
	_G.ChatFrameChannelButton.Icon:SetDesaturated(CH.db.desaturateVoiceIcons)
	_G.ChatFrameChannelButton:SetParent(Holder)

	_G.ChatAlertFrame:ClearAllPoints()
	_G.ChatAlertFrame:Point('BOTTOM', _G.ChatFrameChannelButton, 'TOP', 1, 3)
end

function CH:ResetVoicePanelAlpha()
	if CH.VoicePanel then
		CH.VoicePanel:SetAlpha(CH.db.mouseoverVoicePanel and CH.db.voicePanelAlpha or 1)
	end
end

function CH:BuildCopyChatFrame()
	local frame = CreateFrame('Frame', 'CopyChatFrame', E.UIParent, 'BackdropTemplate')
	tinsert(_G.UISpecialFrames, 'CopyChatFrame')
	frame:SetTemplate('Transparent')
	frame:Size(700, 200)
	frame:Point('BOTTOM', E.UIParent, 'BOTTOM', 0, 3)
	frame:Hide()
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:SetResizable(true)
	frame:SetMinResize(350, 100)
	frame:SetScript('OnMouseDown', function(copyChat, button)
		if button == 'LeftButton' and not copyChat.isMoving then
			copyChat:StartMoving()
			copyChat.isMoving = true
		elseif button == 'RightButton' and not copyChat.isSizing then
			copyChat:StartSizing()
			copyChat.isSizing = true
		end
	end)
	frame:SetScript('OnMouseUp', function(copyChat, button)
		if button == 'LeftButton' and copyChat.isMoving then
			copyChat:StopMovingOrSizing()
			copyChat.isMoving = false
		elseif button == 'RightButton' and copyChat.isSizing then
			copyChat:StopMovingOrSizing()
			copyChat.isSizing = false
		end
	end)
	frame:SetScript('OnHide', function(copyChat)
		if copyChat.isMoving or copyChat.isSizing then
			copyChat:StopMovingOrSizing()
			copyChat.isMoving = false
			copyChat.isSizing = false
		end
	end)
	frame:SetFrameStrata('DIALOG')

	local scrollArea = CreateFrame('ScrollFrame', 'CopyChatScrollFrame', frame, 'UIPanelScrollFrameTemplate')
	scrollArea:Point('TOPLEFT', frame, 'TOPLEFT', 8, -30)
	scrollArea:Point('BOTTOMRIGHT', frame, 'BOTTOMRIGHT', -30, 8)
	Skins:HandleScrollBar(_G.CopyChatScrollFrameScrollBar)
	scrollArea:SetScript('OnSizeChanged', function(scroll)
		_G.CopyChatFrameEditBox:Width(scroll:GetWidth())
		_G.CopyChatFrameEditBox:Height(scroll:GetHeight())
	end)
	scrollArea:HookScript('OnVerticalScroll', function(scroll, offset)
		_G.CopyChatFrameEditBox:SetHitRectInsets(0, 0, offset, (_G.CopyChatFrameEditBox:GetHeight() - offset - scroll:GetHeight()))
	end)

	local editBox = CreateFrame('EditBox', 'CopyChatFrameEditBox', frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(_G.ChatFontNormal)
	editBox:Width(scrollArea:GetWidth())
	editBox:Height(200)
	editBox:SetScript('OnEscapePressed', function() _G.CopyChatFrame:Hide() end)
	scrollArea:SetScrollChild(editBox)
	_G.CopyChatFrameEditBox:SetScript('OnTextChanged', function(_, userInput)
		if userInput then return end
		local _, Max = _G.CopyChatScrollFrameScrollBar:GetMinMaxValues()
		for _ = 1, Max do
			_G.ScrollFrameTemplate_OnMouseWheel(_G.CopyChatScrollFrame, -1)
		end
	end)

	local close = CreateFrame('Button', 'CopyChatFrameCloseButton', frame, 'UIPanelCloseButton, BackdropTemplate')
	close:Point('TOPRIGHT')
	close:SetFrameLevel(close:GetFrameLevel() + 1)
	close:EnableMouse(true)
	Skins:HandleCloseButton(close)
end

CH.TabStyles = {
	NONE	= '%s',
	ARROW	= '%s>|r%s%s<|r',
	ARROW1	= '%s>|r %s %s<|r',
	ARROW2	= '%s<|r%s%s>|r',
	ARROW3	= '%s<|r %s %s>|r',
	BOX		= '%s[|r%s%s]|r',
	BOX1	= '%s[|r %s %s]|r',
	CURLY	= '%s{|r%s%s}|r',
	CURLY1	= '%s{|r %s %s}|r',
	CURVE	= '%s(|r%s%s)|r',
	CURVE1	= '%s(|r %s %s)|r',
}

function CH:FCFTab_UpdateColors(tab, selected)
	if not tab then return end

	if tab:GetParent() == _G.ChatConfigFrameChatTabManager then
		if selected then
			tab.Text:SetTextColor(1, 1, 1)
		end

		local name = GetChatWindowInfo(tab:GetID())
		if name then
			tab.Text:SetText(name)
		end

		tab:SetAlpha(1) -- for some reason blizzard likes to change the alpha here? idk
	else -- actual chat tab and other
		local chat = CH:GetOwner(tab)
		if not chat then return end

		tab.selected = selected

		local whisper = tab.conversationIcon and chat.chatTarget
		local name = chat.name or UNKNOWN

		if whisper and not tab.whisperName then
			tab.whisperName = gsub(E:StripMyRealm(name), '([%S]-)%-[%S]+', '%1|cFF999999*|r')
		end

		if selected then
			if CH.db.tabSelector == 'NONE' then
				tab:SetFormattedText(CH.TabStyles.NONE, tab.whisperName or name)
			else
				local color = CH.db.tabSelectorColor
				local hexColor = E:RGBToHex(color.r, color.g, color.b)
				tab:SetFormattedText(CH.TabStyles[CH.db.tabSelector] or CH.TabStyles.ARROW1, hexColor, tab.whisperName or name, hexColor)
			end

			if CH.db.tabSelectedTextEnabled then
				local color = CH.db.tabSelectedTextColor
				tab.Text:SetTextColor(color.r, color.g, color.b)
				return -- using selected text color
			end
		end

		if whisper then
			if not selected then
				tab:SetText(tab.whisperName or name)
			end

			if not tab.classColor then
				local classMatch = CH.ClassNames[strlower(name)]
				if classMatch then tab.classColor = E:ClassColor(classMatch) end
			end

			if tab.classColor then
				tab.Text:SetTextColor(tab.classColor.r, tab.classColor.g, tab.classColor.b)
			end
		else
			if not selected then
				tab:SetText(name)
			end

			tab.Text:SetTextColor(unpack(E.media.rgbvaluecolor))
		end
	end
end

function CH:GetPlayerInfoByGUID(guid)
	local data = CH.GuidCache[guid]
	if not data then
		local ok, localizedClass, englishClass, localizedRace, englishRace, sex, name, realm = pcall(GetPlayerInfoByGUID, guid)
		if not (ok and englishClass) then return end

		if realm == '' then realm = nil end -- dont add realm for people on your realm
		local shortRealm, nameWithRealm = realm and E:ShortenRealm(realm)
		if name and name ~= '' then
			nameWithRealm = (shortRealm and name..'-'..shortRealm) or name..'-'..PLAYER_REALM
		end

		-- move em into a table
		data = {
			localizedClass = localizedClass,
			englishClass = englishClass,
			localizedRace = localizedRace,
			englishRace = englishRace,
			sex = sex,
			name = name,
			realm = realm,
			nameWithRealm = nameWithRealm -- we use this to correct mobile to link with the realm as well
		}

		-- add it to ClassNames
		if name then
			CH.ClassNames[strlower(name)] = englishClass
		end
		if nameWithRealm then
			CH.ClassNames[strlower(nameWithRealm)] = englishClass
		end

		-- push into the cache
		CH.GuidCache[guid] = data
	end

	-- we still need to recheck this each time because CUSTOM_CLASS_COLORS can change
	if data then data.classColor = E:ClassColor(data.englishClass) end

	return data
end

function CH:ResetEditboxHistory()
	ElvCharacterDB.ChatEditHistory = {}
end

function CH:ResetHistory()
	ElvCharacterDB.ChatHistoryLog = {}
end

function CH:Initialize()
	if ElvCharacterDB.ChatHistory then ElvCharacterDB.ChatHistory = nil end --Depreciated
	if ElvCharacterDB.ChatLog then ElvCharacterDB.ChatLog = nil end --Depreciated

	CH:DelayGuildMOTD() -- Keep this before `is Chat Enabled` check

	CH.db = E.db.chat
	if not E.private.chat.enable then
		-- if the chat module is off we still need to spawn the dts for the panels
		-- if we are going to have the panels show even when it's disabled
		CH:PositionChats()
		CH:Panels_ColorUpdate()
		return
	end
	CH.Initialized = true

	if not ElvCharacterDB.ChatEditHistory then ElvCharacterDB.ChatEditHistory = {} end
	if not ElvCharacterDB.ChatHistoryLog or not CH.db.chatHistory then ElvCharacterDB.ChatHistoryLog = {} end

	_G.ChatFrameMenuButton:Kill()

	CH:SetupChat()
	CH:DefaultSmileys()
	CH:UpdateChatKeywords()
	CH:UpdateFading()
	CH:Panels_ColorUpdate()
	CH:HandleChatVoiceIcons()
	CH:UpdateEditboxAnchors()
	E:UpdatedCVar('chatStyle', CH.UpdateEditboxAnchors)

	CH:SecureHook('GetPlayerInfoByGUID')
	CH:SecureHook('ChatEdit_SetLastActiveWindow')
	CH:SecureHook('ChatEdit_DeactivateChat')
	CH:SecureHook('ChatEdit_ActivateChat')
	CH:SecureHook('ChatEdit_OnEnterPressed')
	CH:SecureHook('FCFDock_UpdateTabs')
	CH:SecureHook('FCF_Close')
	CH:SecureHook('FCF_SetWindowAlpha')
	CH:SecureHook('FCFTab_UpdateColors')
	CH:SecureHook('FCFDock_SelectWindow')
	CH:SecureHook('FCF_SetChatWindowFontSize', 'SetChatFont')
	CH:SecureHook('FCF_SavePositionAndDimensions', 'SnappingChanged')
	CH:SecureHook('FCF_UnDockFrame', 'SnappingChanged')
	CH:SecureHook('FCF_DockFrame', 'SnappingChanged')
	CH:SecureHook('FCF_ResetChatWindows', 'ClearSnapping')
	CH:SecureHook('RedockChatWindows', 'ClearSnapping')
	CH:RegisterEvent('UPDATE_CHAT_WINDOWS', 'SetupChat')
	CH:RegisterEvent('UPDATE_FLOATING_CHAT_WINDOWS', 'SetupChat')

	if _G.WIM then
		_G.WIM.RegisterWidgetTrigger('chat_display', 'whisper,chat,w2w,demo', 'OnHyperlinkClick', function(frame) CH.clickedframe = frame end)
		_G.WIM.RegisterItemRefHandler('url', HyperLinkedURL)
		_G.WIM.RegisterItemRefHandler('cpl', HyperLinkedCPL)
	end

	for _, event in pairs(FindURL_Events) do
		_G.ChatFrame_AddMessageEventFilter(event, CH[event] or CH.FindURL)
		local nType = strsub(event, 10)
		if nType ~= 'AFK' and nType ~= 'DND' and nType ~= 'COMMUNITIES_CHANNEL' then
			CH:RegisterEvent(event, 'SaveChatHistory')
		end
	end

	if CH.db.chatHistory then CH:DisplayChatHistory() end
	CH:BuildCopyChatFrame()

	-- Editbox Backdrop Color
	hooksecurefunc('ChatEdit_UpdateHeader', function(editbox)
		local chatType = editbox:GetAttribute('chatType')
		if not chatType then return end

		local ChatTypeInfo = _G.ChatTypeInfo
		local info = ChatTypeInfo[chatType]
		local chanTarget = editbox:GetAttribute('channelTarget')
		local chanName = chanTarget and GetChannelName(chanTarget)

		--Increase inset on right side to make room for character count text
		local insetLeft, insetRight, insetTop, insetBottom = editbox:GetTextInsets()
		editbox:SetTextInsets(insetLeft, insetRight + 30, insetTop, insetBottom)

		if not editbox.backdrop then
			editbox:CreateBackdrop(nil, true, nil, nil, nil, nil, true)
		end

		if chanName and (chatType == 'CHANNEL') then
			if chanName == 0 then
				editbox.backdrop:SetBackdropBorderColor(unpack(E.media.bordercolor))
			else
				info = ChatTypeInfo[chatType..chanName]
				editbox.backdrop:SetBackdropBorderColor(info.r, info.g, info.b)
			end
		else
			editbox.backdrop:SetBackdropBorderColor(info.r, info.g, info.b)
		end
	end)
end

E:RegisterModule(CH:GetName())
