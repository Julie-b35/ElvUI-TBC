-- Korean localization file for koKR.
local E = unpack(select(2, ...)) --Import: Engine, Locales, PrivateDB, ProfileDB, GlobalDB
local L = E.Libs.ACL:NewLocale("ElvUI", "koKR")

L[" |cff00ff00bound to |r"] = " 키로 다음의 행동을 실행합니다: |cff2eb7e4"
L["|cFFE30000Lua error recieved. You can view the error message when you exit combat."] = "Lua 에러가 발생하였습니다. 전투가 끝난 후에 내역을 표시하겠습니다."
L["%s frame has a conflicting anchor point. Forcing the Buffs to be attached to the main unitframe."] = "%s 프레임에 충돌하는 앵커 위치가 있습니다. 버프가 기본 유닛 프레임에 연결되도록합니다."
L["%s is attempting to share his filters with you. Would you like to accept the request?"] = "%s 유저가 필터설정을 전송하려 합니다. 받으시겠습니까?"
L["%s is attempting to share the profile %s with you. Would you like to accept the request?"] = "%s 유저가 ElvUI 설정을 전송하려 합니다. 받으시겠습니까?"
L["%s: %s tried to call the protected function '%s'."] = "%s: %s 기능이 사용할 수 없는 %s 함수를 사용하려 합니다."
L["(Hold Shift) Memory Usage"] = "Shift: 메모리 사용량"
L["(Modifer Click) Collect Garbage"] = "[확인 클릭] 잡동사니 수집"
L["A raid marker feature is available by pressing Escape -> Keybinds. Scroll to the bottom -> ElvUI -> Raid Marker."] = "공격대 징표 기능은 [Esc>단축키 설정] 에서 설정할수 있습니다. [스크롤 하단>ElvUI TBC> 공격대 징표(Raid Marker) 기능을 사용하면 편리합니다."
L["A setting you have changed will change an option for this character only. This setting that you have changed will be uneffected by changing user profiles. Changing this setting requires that you reload your User Interface."] = "이 설정은 캐릭터별로 따로 저장되므로|n프로필에 영향을 주지도, 받지도 않습니다.|n|n설정 적용을 위해 리로드 하시겠습니까?"
L["ABOVE_THREAT_FORMAT"] = "%s: %.0f%% [%.0f%% 정도 |cff%02x%02x%02x%s|r보다 많음]"
L["AFK"] = "자리비움"
L["AVD: "] = "방어율: "
L["Accepting this will reset the UnitFrame settings for %s. Are you sure?"] = "%s의 설정이 초기화됩니다. 진행 하시겠습니까?"
L["Accepting this will reset your Filter Priority lists for all auras on NamePlates. Are you sure?"] = "이름표(NamePlates)에 적용된 모든 필터 목록이 초기화 됩니다. 진행 하시겠습니까?"
L["Accepting this will reset your Filter Priority lists for all auras on UnitFrames. Are you sure?"] = "유닛프레임에 적용된 모든 필터 목록이 초기화 됩니다. 진행 하시겠습니까?"
L["Adjust the UI Scale to fit your screen."] = "화면의 UI 구성 크기를 설정합니다."
L["All keybindings cleared for |cff00ff00%s|r."] = "|cff00ff00%s|r 버튼에 설정된 모든 단축키 설정이 해제되었습니다."
L["Alliance: "] = "얼라이언스: "
L["Already Running.. Bailing Out!"] = "이미 실행중입니다. 잠시만 기다려 주세요."
L["Are you sure you want to apply this font to all ElvUI elements?"] = "이 글꼴를 ElvUI의 모든 구성요소에 적용하시겠습니까?"
L["Are you sure you want to disband the group?"] = "현재 그룹을 해체 하시겠습니까?"
L["Are you sure you want to reset all the settings on this profile?"] = "이 프로필의 모든 설정을 초기화 하시겠습니까?"
L["Are you sure you want to reset every mover back to it's default position?"] = "모든 프레임의 위치를 초기화 하시겠습니까?"
L["Arena Frames"] = "투기장 프레임"
L["Aura Bars"] = "오라(버프/디버프) 바"
L["Auras Set"] = "오라(버프/디버프) 설정"
L["Auras"] = "오라 설정"
L["Auto Scale"] = "UI 자동설정"
L["Avoidance Breakdown"] = "방어율 목록"
L["BINDINGS_HELP"] = ("단축키 지정:*단축바|r,*매크로|r 또는 *마법책|r 에 마우스를 대고 단축키을 눌러 입력.*가방|r에 항목에도 적용됨. 저장을 눌러야만 적용됨."):gsub('*', E.InfoColor):gsub('%^', E.InfoColor2)
L["BNet Frame"] = "배틀넷 알림"
L["Bag Mover (Grow Down)"] = "가방 물품 이동(아래로 쌓임)"
L["Bag Mover (Grow Up)"] = "가방 물품 이동(위로 쌓임)"
L["Bag Mover"] = "가방 물품 이동"
L["Bags"] = "가방"
L["Bandwidth"] = "툴팁밴드 폭"
L["Bank Mover (Grow Down)"] = "은행 물품 이동(아래로 쌓임)"
L["Bank Mover (Grow Up)"] = "은행 물품 이동(위로 쌓임)'"
L["Bank"] = "은행"
L["Bar "] = "바 "
L["Bars"] = "바"
L["Battleground datatexts temporarily hidden, to show type /bgstats"] = "전장용 상황정보 문자를 일시적으로 숨김니다. [/bgstats] 명령으로 다시 볼수 있습니다."
L["Battleground datatexts will now show again if you are inside a battleground."] = "전장용 상황정보 문자를 다시 표시합니다."
L["BelowMinimapWidget"] = "미니 맵 아래 버튼"
L["Binding"] = "주키/보조키"
L["Binds Discarded"] = "단축키 설정이 취소 되었습니다."
L["Binds Saved"] = "단축키 설정이 저장되었습니다."
L["Blizzard Widgets"] = "블리자드 위젯"
L["BoE"] = "착귀"
L["BoP"] = "획귀"
L["BoU"] = "사귀"
L["CVars Set"] = "게임 인터페이스 설정(콘솔)"
L["CVars"] = "게임 인터페이스"
L["Can't buy anymore slots!"] = "더 이상 가방을 늘릴 수 없습니다."
L["Character: "] = "캐릭터:"
L["Chat Set"] = "대화창 설정"
L["Chat"] = "대화창"
L["Choose a theme layout you wish to use for your initial setup."] = "기초 설정에 사용할 테마 레이아웃을 선택하십시오."
L["Class Totems"] = "토템바"
L["Classbar"] = "직업바"
L["Classic"] = "클래식"
L["Combat Time"] = "전투 시간"
L["Combat"] = "전투"
L["Config Mode:"] = "표시할 프레임 계열:"
L["Confused.. Try Again!"] = "문제가 발생하였습니다. 다시 시도해 주세요."
L["Continue"] = "계속"
L["Coords"] = "좌표"
L["Count"] = "수량"
L["DND"] = "다른 용무중"
L["DPS"] = "딜러"
L["Dark"] = "어두운 느낌"
L["Data From: %s"] = "%s 유저에게서 데이터 받는중..."
L["Dead"] = "죽음"
L["Deficit:"] = "손실:"
L["Delete gray items?"] = "잡템을 삭제하시겠습니까?"
L["Deposit Reagents"] = _G.REAGENTBANK_DEPOSIT
L["Detected that your ElvUI OptionsUI addon is out of date. This may be a result of your Tukui Client being out of date. Please visit our download page and update your Tukui Client, then reinstall ElvUI. Not having your ElvUI OptionsUI addon up to date will result in missing options."] = "ElvUI_OptionsUI 가 오래된 버전입니다. 업데이트하고 ElvUI를 재설치하세요."
L["Disable Warning"] = "경고 끄기"
L["Disable"] = "사용안함(끄기)"
L["Disband Group"] = "그룹 탈퇴"
L["Discard"] = "작업 취소"
L["Discord"] = "디스코드(Discord)"
L["Do you enjoy the new ElvUI?"] = "새로운 ElvUI가 마음에 드십니까?"
L["Do you swear not to post in technical support about something not working without first disabling the addon/module combination first?"] = "ElvUI 플러그인 애드온를 사용하며 생기는 문제는 스스로 해결하세요."
L["Don't forget to backup your WTF folder, all your profiles and settings are in there."] = "WTF 폴더 백업을 잊지 마세요. 모든 프로필과 설정이 저장되어 있습니다."
L["Download"] = "다운로드"
L["Durability Frame"] = "내구도 프레임"
L["Earned:"] = "수입:"
L["ElvUI Installation"] = "ElvUI 설치"
L["ElvUI Plugin Installation"] = "ElvUI 플러그인  설치"
L["ElvUI Status"] = "ElvUI 상세정보"
L["ElvUI has a dual spec feature which allows you to load different profiles based on your current spec on the fly. You can enable it in the profiles tab."] = "ElvUI에는 현재 사양에 따라 다른 프로필을 즉시 불러 올 수있는 이중 사양 기능이 있습니다. 프로필 탭에서 활성화 할 수 있습니다."
L["ElvUI is five or more revisions out of date. You can download the newest version from www.tukui.org. Get premium membership and have ElvUI automatically updated with the Tukui Client!"] = "설치된 [ElvUI]가 최신버전에 5버전 이상 차이가 납니다. http://www.tukui.org 에서 새 버전을 다운로드 받으세요. 프리미엄유저가 되어 Tukui Client 프로그램을 쓰면 자동으로 업데이트 해줍니다."
L["ElvUI is out of date. You can download the newest version from www.tukui.org. Get premium membership and have ElvUI automatically updated with the Tukui Client!"] = "설치된 ElvUI의 버전 ..OTL.. 입니다. http://www.tukui.org 에서 새 버전을 다운로드 받으세요. 프리미엄유저가 되어 Tukui Client 프로그램을 쓰면 자동으로 업데이트 해드립니다."
L["ElvUI needs to perform database optimizations please be patient."] = "ElvUI 데이터베이스의 조정이 필요가 있습니다. 잠시 기다려주세요."
L["ElvUI was updated while the game is still running. Please relaunch the game, as this is required for the files to be properly updated."] = "게임이 진행하는 동안 ElvUI가 업데이트 되었습니다. 정상적인 작동을 위하여 게임을 종료후 다시 시작하십시오."
L["Empty Slot"] = "빈 슬롯"
L["Enable"] = "사용(켜기)"
L["Error resetting UnitFrame."] = "UnitFrame을 재설정하는 동안 오류가 발생했습니다."
L["Experience Bar"] = "경험치 바"
L["Experience"] = "경험치"
L["Filter download complete from %s, would you like to apply changes now?"] = "%s 가 보내준 필터 설정이 저장 되었습니다. 변경사항을 적용하시겠습니까?"
L["Finished"] = "끝마침"
L["Fishy Loot"] = "낚시 전리품"
L["Focus Castbar"] = "주시대상 시전바"
L["Focus Frame"] = "주시대상 프레임"
L["FocusTarget Frame"] = "주시대상의 대상 프레임"
L["Friends List"] = "친구 목록"
L["From time to time you should compare your ElvUI version against the most recent version on our website or the Tukui client."] = "때때로 ElvUI 버전을 저희 웹 사이트 나 Tukui 클라이언트의 최신 버전과 비교해야합니다."
L["G"] = "길드"
L["GM Ticket Frame"] = "GM요청 프레임"
L["Ghost"] = "유령"
L["Gold"] = "골드"
L["Grid Size:"] = "바둑판 크기 :"
L["HP"] = "치유력"
L["HPS"] = "초당힐량"
L["Hold Control + Right Click:"] = "Ctrl + 우클릭:"
L["Hold Shift + Drag:"] = "Shift + 드래그:"
L["Hold Shift + Right Click:"] = "Shift + 우클릭"
L["Home Latency:"] = "지연 시간:"
L["Home Protocol:"] = true
L["Horde: "] = "호드: "
L["I Swear"] = "알겠습니다."
L["I"] = "인스"
L["IL"] = "파티장"
L["INCOMPATIBLE_ADDON"] = "%s의 기능이 ElvUI의 %s 모듈과 충돌 됩니다. \n사용할 기능 또는 모듈을 선택하세요."
L["Icons Only"] = "아이콘만 표시"
L["If you accidently remove a chat frame you can always go the in-game configuration menu, press install, go to the chat portion and reset them."] = "실수로 채팅 프레임을 제거한 경우에도 메뉴로 이동하여 [설치]를 누르고 채팅 부분의 [대화창 설치] 눌러 채팅창을 초기화 할수 있습니다."
L["If you are experiencing issues with ElvUI try disabling all your addons except ElvUI first."] = "ELVUI를 쓰면서 문제를 경험중이시라면 우선은 ELVUI를 제외한 다른 애드온을 다 비활성화 해보십시오."
L["If you have an icon or aurabar that you don't want to display simply hold down shift and right click the icon for it to disapear."] = "숨기고 싶은 아이콘 또는 바가 있는 경우 Shift 키를 누른 상태에서 아이콘을 오른쪽 마우스 클릭하면 사라집니다.-(블랙리스트 필터등록이 됩니다.)"
L["Importance: |cFF33FF33Low|r"] = "중요도 : |cFF33FF33낮음|r"
L["Importance: |cffD3CF00Medium|r"] = "중요도: |cffD3CF00보통|r"
L["Importance: |cffFF3333High|r"] = "중요도: |cffFF3333높음|r"
L["In Progress"] = "진행 중"
L["Install"] = "설치"
L["Installation Complete"] = "설치 완료"
L["Invalid Target"] = "잘못된 대상"
L["It appears one of your AddOns have disabled the AddOn Blizzard_CompactRaidFrames. This can cause errors and other issues. The AddOn will now be re-enabled."] = "설치된 애드온 중 하나가 정상 로드되지 않았습니다. 에러가 날 확률이 높아 리로드합니다."
L["Item level: %.2f"] = "아이템 레벨: %.2f"
L["KEY_ALT"] = "A+"
L["KEY_CTRL"] = "C+"
L["KEY_DELETE"] = "Del"
L["KEY_HOME"] = "Hm"
L["KEY_INSERT"] = "Ins"
L["KEY_MOUSEBUTTON"] = "M"
L["KEY_MOUSEWHEELDOWN"] = "W▼"
L["KEY_MOUSEWHEELUP"] = "W▲"
L["KEY_NUMPAD"] = "N"
L["KEY_PAGEDOWN"] = "P▼"
L["KEY_PAGEUP"] = "P▲"
L["KEY_SHIFT"] = "Sh+"
L["KEY_SPACE"] = "Spc"
L["Key Binds"] = "단축키 지정"
L["Key"] = "단축키"
L["LOGIN_MSG"] = ("*ElvUI TBC|r 버전 *%s|r이 설치 되었습니다.\n메뉴 호출은*/ec|r.기술 지원은 https://www.tukui.org \n또는,*Discord :|r https://discord.gg/xFWcfgE"):gsub('*', E.InfoColor)
L["LOGIN_MSG_HELP"] = ("*ElvUI|r 명령어 목록은 */ehelp|r를 입력하면 됩니다."):gsub('*', E.InfoColor)
L["Layout Set"] = "레이아웃 설정"
L["Layout"] = "레이아웃"
L["Left Chat"] = "왼쪽 패널"
L["Left Click:"] = "왼쪽 클릭 :"
L["List of installations in queue:"] = "설치 대기열 목록"
L["Lock"] = "잠금"
L["Loot / Alert Frames"] = "획득/알림 창"
L["Loot Frame"] = "전리품 프레임"
L["Lord! It's a miracle! The download up and vanished like a fart in the wind! Try Again!"] = "기적입니다!다운로드가 바람에 날리는 방귀처럼 사라졌습니다! 다시 시도하십시오!..OTL.."
L["MA Frames"] = "지원공격 프레임"
L["MT Frames"] = "방어전담 프레임"
L["Micro Bar"] = "메뉴모음 바"
L["Minimap"] = "미니맵"
L["MirrorTimer"] = "미러 타이머"
L["Mitigation By Level: "] = "레벨별 데미지 경감률: "
L["Mobile"] = "모바일"
L["Mov. Speed:"] = _G.STAT_MOVEMENT_SPEED
L["Need help? Join our Discord: https://discord.gg/xFWcfgE"] = "도움이 필요할땐 우리 디스코드에 서버에 참가해보세요: https://discord.gg/xFWcfgE"
L["New Profile will create a fresh profile for this character."] = "'새로운 프로필'은 이 캐릭터에 대한 프로필을 만듭니다."
L["New Profile"] = "새로운 프로필"
L["No Guild"] = "길드 없음"
L["No bindings set."] = "설정한 단축키가 없습니다."
L["No gray items to delete."] = "버릴 물건이 없습니다."
L["No, Revert Changes!"] = "아니요, 변경 하지 안습니다.!"
L["Nudge"] = "미세조정"
L["O"] = "관리자"
L["Objective Frame"] = "퀘스트 프레임"
L["Offline"] = "오프라인"
L["Oh lord, you have got ElvUI and Tukui both enabled at the same time. Select an addon to disable."] = "ElvUI 와 TukUI 를 동시에 사용하려 하고 있습니다. 하나만 선택해 주세요."
L["One or more of the changes you have made require a ReloadUI."] = "변경 사항을 적용하려면 애드온을 리로드 해야합니다."
L["One or more of the changes you have made will effect all characters using this addon. You will have to reload the user interface to see the changes you have made."] = "이 설정은 모든 캐릭터에게 동일하게 적용됩니다.|n|n설정 적용을 위해 리로드 하시겠습니까?"
L["P"] = "파티"
L["PL"] = "파티장"
L["Party Frames"] = "파티 프레임"
L["Pending"] = "보류 중"
L["Pet Bar"] = "소환수 바"
L["Pet Castbar"] = "소환수 시전바"
L["Pet Frame"] = "소환수 프레임"
L["PetTarget Frame"] = "소환수 대상 프레임"
L["Player Buffs"] = "플레이어 버프"
L["Player Castbar"] = "플레이어 시전바"
L["Player Debuffs"] = "플레이어 디버프"
L["Player Frame"] = "플레이어 프레임"
L["Player NamePlate"] = "플레이어 이룜표"
L["Player Powerbar"] = "플레이어 자원바"
L["Please click the button below so you can setup variables and ReloadUI."] = "아래 버튼을 누르면 설치를 마무리하고 UI를 재시작합니다."
L["Please click the button below to setup your CVars."] = "ElvUI의 게임 인터페이스 설정을 적용하려면 아래 버튼을 누르세요."
L["Please click the button below to setup your Profile Settings."] = "프로필 설정 하려면 아래 버튼을 누르세요."
L["Please press the continue button to go onto the next step."] = "다음 단계로 진해을 원하면|cff2eb7e4[계속]|r 버튼을 누르세요."
L["Plugins"] = "플러그인" -- ConfigElvUI.lua line41
L["PowerBarWidget"] = "자원바 위젯"
L["Preview"] = "미리보기" -- ConfigElvUI.lua line41
L["Profile Settings Setup"] = "프로필 배치 설정"
L["Profile download complete from %s, but the profile %s already exists. Change the name or else it will overwrite the existing profile."] = "%s 유저에게서 ElvUI 설정 다운로드가 완료되었습니다. 하지만 건네받은 프로필 이름이 이미 존재합니다. 프로필이름을 바꾸지 않으면 기존의 것에 덮어씌웁니다."
L["Profile download complete from %s, would you like to load the profile %s now?"] = "%s 유저에게서 ElvUI 설정 다운로드가 완료되었습니다. 건네받은 설정을 지금 불러올까요?"
L["Profile request sent. Waiting for response from player."] = "상대에게서 전송여부를 확인받고 있습니다."
L["Profit:"] = "이익:"
L["Purchase Bags"] = "가방 슬롯 구입"
L["Quest Objective Frame"] = "퀘스트 목표 프레임"
L["Quest Timer Frame"] = "퀘스트 타임 프레임"
L["R"] = "공대"
L["RL"] = "공대장"
L["RW"] = "경보"
L["Raid Frames"] = "레이드 프레임"
L["Raid Menu"] = "레이드 매뉴"
L["Raid Pet Frames"] = "레이드 소환수 프레임"
L["Raid-40 Frames"] = "레이드 프레임(40인)"
L["Remaining:"] = "다음 레벨까지: "
L["Remove Bar %d Action Page"] = "Blizzard %d번 행동단축바 숨기기"
L["Reposition Window"] = "옵션창 위치 초기화"
L["Reputation Bar"] = "평판 바"
L["Request was denied by user."] = "상대방이 전송을 거절했습니다."
L["Reset Anchors"] = "위치 초기화"
L["Reset Character Data: Hold Shift + Right Click"] = "케릭터 데이터 재설정 : Shift + 오른쪽 클릭"
L["Reset Position"] = "위치 초기화"
L["Reset Session Data: Hold Ctrl + Right Click"] = "정보 데이터 재설정 : Ctrl + 오른쪽 클릭"
L["Reset all frames to their original positions."] = "ElvUI 에서 움직일 수 있는 모든 프레임의 위치를 기본 위치로 초기화합니다."
L["Reset the size and position of this frame."] = "프레임의 크기와 위치를 재설정합니다."
L["Rested:"] = "휴식 경험치:"
L["Right Chat"] = "오른쪽 패널"
L["Run the installation process."] = "ElvUI의 설치 프로세스를 실행합니다."
L["SP"] = "주문력"
L["Save"] = "저장"
L["Select the type of aura system you want to use with ElvUI's unitframes. Set to Aura Bars to use both aura bars and icons, set to Icons Only to only see icons."] = "ElvUI의 유닛 프레임과 함께 사용할 오라(버프/디버프) 유형을 선택하십시오. '클래스타이머'와 '아이콘'을 모두 사용하려면 '클래스타이머'로 설정하고' '아이콘'만 보려면 '아이콘만 표시'를 선택합니다."
L["Server: "] = "서버:"
L["Session:"] = "현재 접속:"
L["Setup CVars"] = "인터페이스 설치 적용"
L["Setup Chat"] = "대화창 설치"
L["Shared Profile will select the default profile."] = "'공유 프로필'은 기본(기본값) 프로필을 선택합니다."
L["Shared Profile"] = "프로필 공유"
L["Shows a frame with needed info for support."] = "ElvUI의 AddOn 상세정보와 Plugins 정보지원에 정보를 WOW우 클라이언트 정보 등을 보여줍니다."
L["Skip Process"] = "건너뛰기"
L["Sort Bags"] = "가방 정리"
L["Spec"] = "전문화"
L["Spell/Heal Power"] = "주문/치유력"
L["Spent:"] = "지출:"
L["Stance Bar"] = "태세 바"
L["Steps"] = "단계"
L["Sticky Frames"] = "자석"
L["System"] = "시스템"
L["Tank / Physical DPS"] = "탱커/물리적 딜러"
L["Target Castbar"] = "대상 시전바"
L["Target Frame"] = "대상 프레임"
L["Target Powerbar"] = "대상 자원바"
L["TargetTarget Frame"] = "대상의대상 프레임"
L["TargetTargetTarget Frame"] = "대상의대상의대상 프레임"
L["Targeted By:"] = "선택됨:"
L["Temporary Move"] = "임시 이동"
L["The chat windows function the same as Blizzard standard chat windows, you can right click the tabs and drag them around, rename, etc. Please click the button below to setup your chat windows."] = "보편적인 설정을 적용할 뿐이므로, 마음대로 채널표시나 색상을 변경할 수 있습니다.|n아래 버튼을 클릭하면 채팅창 설정을 적용합니다."
L["The in-game configuration menu can be accessed by typing the /ec command. Press the button below if you wish to skip the installation process."] = "게임내 설정창은 /ec 명령을 입력하여 호출할 수 있습니다.\n설치 과정을 건너 뛰려면 아래 버튼을 누르십시오."
L["The profile you tried to import already exists. Choose a new name or accept to overwrite the existing profile."] = "불러오려는 프로필이 이미 존재합니다. 새로운 이름을 지정하시거나 기존 프로필에 덮어쓸지를 선택하십시오."
L["The spell '%s' has been added to the '%s' unitframe aura filter."] = " '%s'주문이 '%s' 오라 필터에 추가되었습니다."
L["Theme Set"] = "테마 적용"
L["Theme Setup"] = "테마 설정"
L["This install process will help you learn some of the features in ElvUI has to offer and also prepare your user interface for usage."] = "이 설치과정을 통해 ElvUI를 좀 더 자신에게 맞게 설정하고|n몇가지 기능을 배울수 있습니다."
L["This part of the installation process sets up your World of Warcraft default options it is recommended you should do this step for everything to behave properly."] = "WoW의 기본 인터페이스 설정을 ElvUI에 적합하게 변경합니다. 애드온 사용에 있어 유용하니 적용할 것을 추천합니다."
L["This part of the installation process sets up your chat windows names, positions and colors."] = "채팅창 설정을 변경합니다. 간단한 채널설정, 색상설정 등이 포함되어 있습니다.|n자신만의 채널 설정, 색상 등을 유지하고 싶으면 설치하지 마세요."
L["This setting caused a conflicting anchor point, where '%s' would be attached to itself. Please check your anchor points. Setting '%s' to be attached to '%s'."] = "이 설정으로 인해 '%s'이 첨부되는 앵커 위치가 충돌합니다. 앵커 위치를 확인하십시오. '%s'가 '%s'에 첨부되도록 설정합니다."
L["This will change the layout of your unitframes and actionbars."] = "역할에 따라서 유닛프레임과 행동단축바의 레이아웃이 알맞게 바뀝니다."
L["To list all available ElvUI commands, type in chat /ehelp"] = "사용가능한 ELVUI 명령을 모두 보려면 /ehelp 를 입력하세요"
L["Threat Bar"] = "어그로 바"
-- L["To move abilities on the actionbars by default hold shift + drag. You can change the modifier key from the actionbar options menu."] = "기본적으로 단축바에서 스킬을 뺄려면 |cff2eb7e4Shift 키를 누른 상태에서 드래그|r해야 합니다. 수정키는 /ec -> 행동단축바 항목에서 바꿀 수 있습니다."
L["To quickly move around certain elements of the UI, type /moveui"] = "UI의 특정 요소를 빠르게 이동하려면 /moveui 를 입력하세요."
L["To setup chat colors, chat channels and chat font size, right-click the chat tab name."] = "채팅탭을 우클릭으로 대화 색상,채널 및 대화 글꼴 크기등 설정을 변경할 수 있습니다."
L["Toggle Anchors"] = "프레임 이동 모드"
L["Toggle Bags"] = "가방슬롯 보기"
L["Toggle Chat Frame"] = "패널 표시 전환"
L["Toggle Configuration"] = "ElvUI 설정창 열기"
L["Toggle Keyring"] = "열쇠가방 열기/닫기"
L["Toggle Tutorials"] = "애드온 튜토리얼 확인"
L["Tooltip"] = "툴팁"
L["TopWidget"] = "위쪽 위젯"
L["Total CPU:"] = "전체 CPU 사용량:"
L["Total: "] = "합계:"
L["Trigger"] = "묶음을 펼치고 각 주문에 지정하세요."
L["Type /hellokitty to revert to old settings."] = "/hellokitty 를 입력해서 예전 세팅으로 돌릴 수 있습니다."
L["Unhittable:"] = "100% 방어행동까지"
L["Unlock various elements of the UI to be repositioned."] = "ElvUI의 이동가능한 모든 프레임들을 설정 하는 화면모드로 전환합니다.."
L["VehicleLeaveButton"] = "비행 중지 버튼"
L["Vendor / Delete Grays"] = "잡템 판매/삭제"
L["Vendored gray items for: %s"] = "모든 잡탬들을 판매했습니다.: %s"
L["Vendoring Grays"] = "잡탬_팔기"
L["Welcome to ElvUI TBC version %.2f!"] = "ElvUI TBC 버전 %.2f에 오신 것을 환영합니다!"
L["World Latency:"] = "월드 지연시간"
L["World Protocol:"] = true
L["XP:"] = "경험치:"
L["Yes, Keep Changes!"] = "네! 변경 하겠습니다.!"
L["You are going to copy settings for |cffD3CF00\"%s\"|r from your current |cff4beb2c\"%s\"|r profile to |cff4beb2c\"%s\"|r profile. Are you sure?"] = "|cffD3CF00\"%s\"|r의 설정을 |cff4beb2c\"%s\"|r에게서 |cff4beb2c\"%s\"|r로 보내주어 적용시키려 합니다. 진행 하시겠습니까?" --  0422 추가
L["You are going to copy settings for |cffD3CF00\"%s\"|r from |cff4beb2c\"%s\"|r profile to your current |cff4beb2c\"%s\"|r profile. Are you sure?"] = "|cffD3CF00\"%s\"|r 설정을 |cff4beb2c\"%s\"|r에게서 가저와서, |cff4beb2c\"%s\"|r에게 적용시키려고 합니다. 진행 하시겠습니까?" -- 0422 추가
L["You are now finished with the installation process. If you are in need of technical support please visit us at http://www.tukui.org."] = "설치 과정이 완료되었습니다.|n궁금한 점 해결이나 기술지원이 필요하면 |cff2eb7e4www.tukui.org|r 를 방문하세요."
L["You are using CPU Profiling. This causes decreased performance. Do you want to disable it or continue?"] = "CPU 프로파일링을 사용하고 있습니다. 이로 인해 성능이 저하 될수 있습니다. 비활성화 하시겠습니까? 아니면 계속 하시겠습니까?"
L["You can access the copy chat and chat menu functions by left/right clicking on the icon in the top right corner of the chat panel."] = "대화 패널의 오른쪽 상단에 있는 아이콘을 왼쪽/오른쪽으로 클릭하면 대화 복사 및 대화 메뉴 기능에 이용할수 있습니다."
L["You can access the microbar by using middle mouse button on the minimap. You can also enable the MicroBar in the actionbar settings."] = "미니맵에서 마우스 가운데 버튼을 사용하여 마이크로바에 접근할 수 있습니다. 또한 행동바 설정에서 마이크로바를 활성화 할 수도 있습니다."
L["You can always change fonts and colors of any element of ElvUI from the in-game configuration."] = "ElvUI에서 표시하는 글꼴과 색상은 설정에서 언제든지 바꿀 수 있습니다."
L["You can enter the keybind mode by typing /kb"] = "|cff2eb7e4/kb|r 를 입력하면 단축키 설정 모드로 들어갈 수 있습니다."
L["You can now choose what layout you wish to use based on your combat role."] = "이제 전투 역할에 따라 사용할 레이아웃을 선택할 수 있습니다."
L["You can quickly change your displayed DataTexts by mousing over them while holding ALT."] = "ALT를 누른 상태에서 마우스를 올려 표시된 데이터문자를 빠르게 변경할 수 있습니다."
L["You can see someones average item level inside the tooltip by holding shift and mousing over them."] = "Shift를 누른 상태에서 마우스를 가져가면 툴팁 내에서 누군가의 평균 아이템 레벨을 볼 수 있습니다."
L["You don't have enough money to repair."] = "수리 비용이 부족합니다."
L["You don't have permission to mark targets."] = "레이드 징표을 지정할 권한이 없습니다."
L["You have imported settings which may require a UI reload to take effect. Reload now?"] = "가저온 설정의 적용을 위해 재시작이 필요합니다. 지금 UI를 재시작하시겠습니까?"
L["You must be at a vendor."] = "상인을 만나야 가능합니다."
L["You must purchase a bank slot first!"] = "우선 은행가방 칸을 구입해야됩니다!"
L["Your items have been repaired for: "] = "자동으로 수리하고 비용을 지불했습니다: "
L["Your profile was successfully recieved by the player."] = "상대에게 데이터를 성공적으로 전송했습니다."
L["copperabbrev"] = [[|TInterface\MoneyFrame\UI-MoneyIcons:0:0:1:0:64:16:33:48:1:16|t]]
L["goldabbrev"] = [[|TInterface\MoneyFrame\UI-MoneyIcons:0:0:1:0:64:16:1:16:1:16|t]]
L["lvl"] = "레벨"
L["says"] = "일반"
L["silverabbrev"] = [[|TInterface\MoneyFrame\UI-MoneyIcons:0:0:1:0:64:16:17:32:1:16|t]]
L["whispers"] = "귓속말"
L["yells"] = "외침"
-------------------------------------------------
L["DESC_MOVERCONFIG"] = [=[프레임을 드래그로 원하는 위치로 이동시키세요.|n[잠금] 버튼을 누르면 이동모드가 종료됩니다.

선택사항:
  LeftClick - Toggle Nudge Frame.
  우클릭 - Open Config Section.
  Shift + 우클릭 - 조정자를 일시적으로 숨깁니다.
  Ctrl + 우클릭 - 조정자의 위치를 기본값으로 초기화합니다.
]=]

L["EHELP_COMMANDS"] = ([=[다음은 모든 중요한 *ElvUI|r 명령 목록입니다.:
 */ec|r or */elvui|r  -  *옵션 UI|r 호출.
 */moveui|r  -  [프레임 이동 모드]를 호출하여 프레임의 위치를 변경.
 */kb|r  -  단축키 설정 모드를 실행.
 */resetui|r -  모든 프레임을 원래 위치로 재설정.
 */bgstats|r -  전장전용 정보문자를 표기를 켜기/끄기.
 */hdt|r  -  *설정창|r을 열지 않고 <데이터 텍스트>를 편집.
 */estatus|r  -  ElvUI 제원 정보와 Plugins에 관한 정보를.
 */egrid|r ^64|r or ^128|r or ^256|r - 격자무늬 픽색을 변경.
 */luaerror|r ^on|r or ^off|r - ElvUI를 제외한 모든 애드온을 끄기.
  참고: */luaerror|r ^off|r 비활성화 된 애드온을 다시 활성화.
  해당 세션 내에서 */luaerror|r ^on|r 사용.
]=]):gsub('*', E.InfoColor):gsub('%^', E.InfoColor2)

----------------TagInfo Locales----------------
--[[
	tagName = 태그 이름
	category = 카테고리 
	description = 설명
	order = 이것은 선택 사항입니다. 이름이 아닌 순서로 태그를 정렬하는 데 사용됩니다. +10은 규칙이 아닙니다. 처음 10 개의 슬롯을 예약합니다.
]]

--Classification:분류--
L['Classification'] = 'Classification:분류'
L["Displays the unit's classification in icon form (golden icon for 'ELITE' silver icon for 'RARE')"] = "아이콘 형태로 유닛의 분류를 표시합니다. ('정예(ELITE)'는 황금색 아이콘, '희귀(RARE)'는 은색 아이콘)"
L["Displays the unit's classification (e.g. 'ELITE' and 'RARE')"] = "유닛의 분류를 표시합니다 (예 : '정예','희귀')"
L["Displays the creature type of the unit"] = "유닛의 생물 유형을 표시합니다."
L["Displays the character '+' if the unit is an elite or rare-elite"] = "유닛이 '정예' 또는 '희귀 정예' 인 경우 문자 '+'를 표시합니다."
L["Displays 'Rare' when the unit is a rare or rareelite"] = "유닛이 '희귀' 또는 '희귀 정예' 일 때 '희귀'를 표시합니다."
L["Displays the unit's classification in short form (e.g. '+' for ELITE and 'R' for RARE)"] = "화면에 분류 형식을 짧게 표시합니다 (예 : ELITE의 경우 '+', RARE의 경우 'R')."
--Classpower:콤보--
L['Classpower'] = 'Classpower:콤보'
L["Displays amount of combo points the player has"] = "플레이어가 가진 콤보 포인트의 양을 표시."
--Colors:색상--
L["Changes the text color, depending on the unit's classification"] = "유닛의 분류에 따라 문자 색상을 변경."
L["Changes the color of the special power based upon its type"] = "유형에 따라 특수 능력의 색상을 변경합니다."
L["Changes color of the next tag based on how difficult the unit is compared to the players level"] = "대상유닛이 플레이어 레벨에 비해 상대가 가능 여부로 색상을 변경합니다."
L["Changes the text color, depending on the unit's current health"] = "대상유닛의 현재 체력에 따라 텍스트 색상을 변경."
L["Colors names by player class or NPC reaction (Ex: [namecolor][name])"] = "플레이어 클래스 또는 NPC 반응별 색상 이름(예:[namecolor][name])"
L["Colors the following tags by difficulty, red for impossible, orange for hard, green for easy"] = "다음 태그를 난이도별로, 빨간색-불가능, 주황색-하드, 녹색-쉬운, 색상을 지정."
L["Colors the following tags based upon pet happiness (e.g. happy = green)"] = "애완 동물의 행복에 따라 다음 태그에 색상을 지정 (예 : happy = green)."
L["Colors the power text based upon its type"] = "유형에 따라 파워 텍스트에 색상을 지정합니다."
L["Colors names by NPC reaction (Bad/Neutral/Good)"] = "NPC 반응 별 색상 이름 (적대/중립/우호)"
L["Changes the text color, depending on the unit's threat situation"] = "유닛의 위협 상황에 따라 텍스트 색상을 변경합니다."
--Guild:길드--
L['Guild'] = 'Guild:길드'
L["Displays the guild name with < > and transliteration (e.g. <GUILD>)"] = "<> 및 음역으로 길드 이름을 표시합니다 (예:<GUILD>)."
L["Displays the guild name with < > brackets (e.g. <GUILD>)"] = "<> 괄호로 길드 이름을 표시합니다 (예 : <GUILD>)."
L["Displays the guild rank"] = "길드의 위치(등급)를 표시합니다."
L["Displays the guild name with transliteration for cyrillic letters"] = "키릴 문자(러시아어)의 음역으로 길드 이름을 표시합니다."
L["Displays the guild name"] = "길드 이름을 표시합니다."
--Health
L['Health'] = 'Health:체력'
L["Displays the current HP without decimals"] = "소수점없이 현재 HP를 표시합니다."
L["Displays the health as a deficit and the name at full health"] = "깍인 체력값 표시,Max 체력일때 이름 표시"
L["Shortvalue of the unit's current and max health, without status"] = "현재 체력값-최대 체력값 표시 (단위축약)"
L["Displays the current and maximum health of the unit, separated by a dash, without status"] = "현재 체력값-최대 체력값 표시"
L["Shortvalue of current and max hp (% when not full hp, without status)"] = "현재 체력값-최대 체력값 | %값 (단위축약)"
L["Displays the current and max hp of the unit, separated by a dash (% when not full hp), without status"] = "현재 체력값-최대 체력값 | %값"
L["Shortvalue of current and max hp (% when not full hp)"] = "현재 체력값-최대 체력값 | %값 - 상태표시"
L["Displays the current and max hp of the unit, separated by a dash (% when not full hp)"] = "현재 체력값-최대 체력값 | %값 (단위축약)-상태표시"
L["Shortvalue of the unit's current and max hp, separated by a dash"] = "현재 체력값-최대 체력값 (단위축약):상태표시"
L["Displays the current and maximum health of the unit, separated by a dash"] = "현재 체력값-최대 체력값:상태표시"
L["Shortvalue of the unit's current health without status"] = "현재 체력값(단위축약)"
L["Displays the current health of the unit, without status"] = "현재 체력값"
L["Shortvalue of the unit's current hp (% when not full hp), without status"] = "현재 체력값-%값(단위축약)"
L["Displays the current hp of the unit (% when not full hp), without status"] = "현재 체력값-%값"
L["Shortvalue of the unit's current hp (% when not full hp)"] = "현재 체력값-현재%값(단위축약):상태표시"
L["Displays the current hp of the unit (% when not full hp)"] = "현재 체력값-현재%값:상태표시"
L["Shortvalue of the unit's current health (e.g. 81k instead of 81200)"] = "현재 체력값(단위축약):상태표시 (예: 81200 대신 81k2 또는8만2.2천 사망시:유령 표시)"
L["Displays the current health of the unit"] = "현재 체력값(단위축약):상태표시"
L["Shortvalue of the health deficit, without status"] = "깍인 체력값 표시(단위축약)"
L["Displays the health of the unit as a deficit, without status"] = "깍인 체력값 표시"
L["Displays the health deficit as a percentage and the name of the unit (limited to 20 letters)"] = "깍인 체력값 (-)값으로 표시:Max 체력일때 이름을 20글자로 출력:상태표시"
L["Displays the health deficit as a percentage and the name of the unit (limited to 15 letters)"] = "깍인 체력값 (-)값으로 표시:Max 체력일때 이름을 15글자로 출력:상태표시"
L["Displays the health deficit as a percentage and the name of the unit (limited to 10 letters)"] = "깍인 체력값 (-)값으로 표시:Max 체력일때 이름을 10글자로 출력:상태표시"
L["Displays the health deficit as a percentage and the name of the unit (limited to 5 letters)"] = "깍인 체력값 (-)값으로 표시:Max 체력일때 이름을 5글자로 출력:상태표시"
L["Displays the health deficit as a percentage and the full name of the unit"] = "깍인 체력값 (-)값으로 표시:Max 체력일때 이름 출력"
L["Displays the health deficit as a percentage, without status"] = "깍인 체력값 (-)값으로 표시(단위축약):상태표시"
L["Shortvalue of the health deficit (e.g. -41k instead of -41300)"] = "깍인 체력 표시(단위축약) (예.-41300 대신  -41k 또는 -4만1천)"
L["Displays the health of the unit as a deficit (Total Health - Current Health = -Deficit)"] = "깍인 체력값 상태를 (-)값으로 표시 [Total Health(총체력) - Current Health(현재체력) = -Deficit(깍인체력)]"
L["Shortvalue of the unit's maximum health"] = "최대 체력값 만을 표시(단위축약)"
L["Displays the maximum health of the unit"] = "최대 체력값 만을 표시"
L["Displays the unit's current health as a percentage, without status"] = "현재 체력의 %값 만을 표시(단위축약)"
L["Displays the current health of the unit as a percentage"] = "현재 체력의 %값 만을 표시"
L["Displays max HP without decimals"] = "소수점 없이 최대 체력 값만 표시"
L["Displays the missing health of the unit in whole numbers, when not at full health"] = "최대 체력이 아닐 때 깍인 체력을 정수로 표시."
L["Displays percentage HP without decimals or the % sign.  You can display the percent sign by adjusting the tag to [perhp<%]."] = "소수와 (%)기호 없이 백분율 체력을 표시. 태그를 [perhp <%]로 조정하여 백분율 기호를 표시 할 수 있습니다."
--Hunter:사냥꾼--
L['Hunter'] = 'Hunter:사냥꾼'
L["Displays the diet of your pet (Fish, Meat, ...)"] = "애완 동물의 식단을 표시 (생선, 고기 등)."
L["Displays the pet happiness like a Discord emoji"] = "Discord 이모티콘처럼 애완 동물의 행복을 표시."
L["Displays the pet happiness as a word (e.g. 'Happy')"] = "애완 동물 행복을 단어로 표시 (예 : 'Happy') "
L["Displays the pet happiness like the default Blizzard icon"] = "기본 블리자드 아이콘과 같은 애완 동물 행복을 표시"
L["Displays the pet loyalty level"] = "애완 동물 충성도 수준을 표시."
--Leve:레벨--
L['Level'] = 'Level:레벨'
L["Displays the level of the unit"] = "레벨을 표시합니다"
L["Only display the unit's level if it is not the same as yours"] = "당신과 같지 않은 경우에만 유닛의 레벨을 표시합니디."
--Mana:마나--
L['Mana'] = 'Mana:마나'
L["Displays the current mana without decimals"] = "소수점없이 현재 마나를 표시"
L["Displays the current and max mana of the unit, separated by a dash (% when not full)"] = "현재 마나값 - 최대 마나값 | %(최대값이 아닌경우만 표시)"
L["Displays the unit's current and maximum mana, separated by a dash"] = "현재 마나값 - 최대 마나값"
L["Displays the current mana of the unit and % when not full"] = "현재 마나값 - %(최대값이 아닌경우만 표시)"
L["Displays the unit's current mana"] = "현재 마나만을 표시."
L["Displays the player's mana as a deficit"] = "플레이어의 마나를 (-)값으로 표시.(!!작동안됨!!)"
L["Displays the player's mana as a percentage"] = "%로만 표시"
L["Displays the max amount of mana the unit can have"] = "최대 마나값 만을 표시"
--Miscellaneous--
--Names--
L['Names'] = 'Names:이름'
L["|cFF666666[1/5]|r White name text, missing hp red"] = "|cFF666666[1/5]|r 흰색 이름 텍스트, hp 빨간색 누락" -- OptionsUI>Tags.lua 
L["|cFF666666[2/5]|r Class color name text, missing hp red"] = "|cFF666666[2/5]|r 클래스 색상 이름 텍스트, hp 빨간색 누락" -- OptionsUI>Tags.lua 
L["|cFF666666[3/5]|r Class color name text, missing hp based on hex code"] = "|cFF666666[3/5]|r 클래스 색상 이름 텍스트, 16 진수 코드에 따라 hp 누락" -- OptionsUI>Tags.lua 
L["|cFF666666[4/5]|r Name text based on hex code, missing hp red"] = "|cFF666666[4/5]|r 16 진수 코드에 기반한 이름 텍스트, hp 빨간색 누락" -- OptionsUI>Tags.lua 
L["|cFF666666[5/5]|r Name text based on hex code, missing hp class color"] = "|cFF666666[5/5]|r 16 진수 코드에 기반한 이름 텍스트, hp 클래스 색상 누락" -- OptionsUI>Tags.lua 
L["Displays the name of the unit with abbreviation (limited to 20 letters)"] = "약어로 단위 이름을 표시.(한글 20자 제한)."
L["Displays the name of the unit with abbreviation (limited to 15 letters)"] = "약어로 단위 이름을 표시.(한글 15자 제한)."
L["Displays the name of the unit with abbreviation (limited to 10 letters)"] = "약어로 단위 이름을 표시.(한글 10자 제한)."
L["Displays the name of the unit with abbreviation (limited to 5 letters)"] = "약어로 단위 이름을 표시.(한글 5자 제한)."
L["Displays the name of the unit with abbreviation (e.g. 'Shadowfury Witch Doctor' becomes 'S. W. Doctor')"] = "약어로 유닛의 이름을 표시합니다 (예 : 'Shadowfury Witch Doctor'는 'S.W. Doctor'가 됨). "
L["Displays the last word of the unit's name"] = "대상 이름의 마지막 단어를 표시합니다."
L["Replace the name of the unit with 'DEAD' or 'OFFLINE' if applicable (limited to 20 letters)"] = "(이름을 20자) 이하로 표시하고, '죽음'또는 '오프라인' 상태라면 상태표시를 이름으로 표시"
L["Displays the name of the unit with transliteration for cyrillic letters (limited to 20 letters)"] = "키릴 문자(러시어어)의 음역으로 단위 이름을 표시합니다 (20 자로 제한됨)."
L["Displays the name of the unit (limited to 20 letters)"] = "(이름을 20자) 이하로 표시"
L["Replace the name of the unit with 'DEAD' or 'OFFLINE' if applicable (limited to 15 letters)"] = "(이름을 15자) 이하로 표시하고, '죽음'또는 '오프라인' 상태라면 상태표시를 이름으로 표시"
L["Displays the name of the unit with transliteration for cyrillic letters (limited to 15 letters)"] = "키릴 문자(러시어어)의 음역으로 단위 이름을 표시합니다 (15 자로 제한됨)."
L["Displays the name of the unit (limited to 15 letters)"] = "(이름을 15자) 이하로 표시"
L["Replace the name of the unit with 'DEAD' or 'OFFLINE' if applicable (limited to 10 letters)"] = "(이름을 10자) 이하로 표시하고, '죽음'또는 '오프라인' 상태라면 상태표시를 이름으로 표시"
L["Displays the name of the unit with transliteration for cyrillic letters (limited to 10 letters)"] = "키릴 문자(러시어어)의 음역으로 단위 이름을 표시합니다 (10 자로 제한됨)."
L["Displays the name of the unit (limited to 10 letters)"] = "(이름을 10자) 이하로 표시"
L["Replace the name of the unit with 'DEAD' or 'OFFLINE' if applicable (limited to 5 letters)"] = "(이름을 5자) 이하로 표시하고, '죽음'또는 '오프라인' 상태라면 상태표시를 이름으로 표시"
L["Displays player name and title"] = "플레이어 이름과 명예계급을 표시합니다."
L["Displays the name of the unit with transliteration for cyrillic letters (limited to 5 letters)"] = "키릴 문자(러시어어)의 음역으로 단위 이름을 표시합니다 (5 자로 제한됨)."
L["Displays the name of the unit (limited to 5 letters)"] = "(이름을 5자) 이하로 표시"
L["Displays the full name of the unit without any letter limitation"] = "전체 이름을 표시."
L["Displays the NPC title with brackets (e.g. <General Goods Vendor>)"] = "괄호로 NPC의 직업/직책을 표시. - 예: <잡화 상인>"
L["Displays the NPC title (e.g. General Goods Vendor)"] = "NPC 직책/직업이 있다면 표시. - 예: 잡화 상인"
L["Displays player title"] = "플레이어의 명예계급을 표시"
--Party and Raid:파티&레이드--
L["Party and Raid"] = "파티 & 레이드"
L["Displays the group number the unit is in ('1' - '8')"] = "파티/레이드 속한 그룹 번호를 표시합니다 ('1'-'8')."
L["Displays 'L' if the unit is the group/raid leader"] = "대상이 파티/레이드 리더인 경우 'L'표시"
L["Displays 'Leader' if the unit is the group/raid leader"] = "대상이 파티/레이드 리더인 경우 '리더'표시"
--Power:파워 기력/분노/마나--
L['Power'] = 'Power:자원(기력/분노/마나)'
L["Displays the unit's current power without decimals"] = "현재 파워를 정수로 표시."
L["Displays the max amount of power of the unit in whole numbers without decimals"] = "최대 파워량을 정수로 표시."
L["Displays the missing power of the unit in whole numbers when not at full power"] = "최대 파워가 아닐때 누락된 파워를 정수로 표시."
L["Displays the unit's percentage power without decimals "] = "파월를 정수값의 %로 표시."
L["Shortvalue of the current power and max power, separated by a dash (% when not full power)"] = "현재값 - 최대값 |%값 (최대값일때 최대값만 표시)(단위축약)"
L["Displays the current power and max power, separated by a dash (% when not full power)"] = "현재값 - 최대값 |%값 (최대값일대 최대값만 표시)"
L["Shortvalue of the current power and max power, separated by a dash"] = "현재값 - 최대값 (최대값일대 최대값만 표시) (단위축약)"
L["Displays the current power and max power, separated by a dash"] = "현재값 - 최대값 (최대값일대 최대값만 표시)"
L["Shortvalue of the current power and power as a percentage, separated by a dash"] = "현재값 - 현재%값 (최대값일대 최대값만 표시)(단위축약)"
L["Displays the current power and power as a percentage, separated by a dash"] = "현재값 - 현재%값 (최대값일대 최대값만 표시)"
L["Shortvalue of the unit's current amount of power (e.g. 4k instead of 4000)"] = "현재값만 표시(단위축약)(예. 4400 일때 4.4k 또는 4.4천)"
L["Displays the unit's current amount of power"] = "현재값만 표시"
L["Shortvalue of the power as a deficit (Total Power - Current Power = -Deficit)"] = "최대값에서 모자른 파워값 상태를 (-)값으로 표시 (단위축약)[총 파워 - 현재 파워 = -Deficit(부족한값)]"
L["Displays the power as a deficit (Total Power - Current Power = -Deficit)"] = "최대값에서 모자른 파워값 상태를 (-)값으로 표시 [총 파워 - 현재 파워 = -Deficit(부족한값)]"
L["Shortvalue of the unit's maximum power"] = "최대 파워값 (단위축약)"
L["Displays the unit's maximum power"] = "최대 파워값 (단위축약)"
L["Displays the unit's power as a percentage"] = "현재 파워의 %값"

