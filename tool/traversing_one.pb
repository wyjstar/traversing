
ÛT
traversing_one.proto"0
LinkPB
link_no (
is_activation ("b
HeroPB
hero_no (
level (
exp (
break_level (
links (2.LinkPB""
Skill

id (
buffs ("¡

BattleUnit

no (
quality (
normal_skill (2.Skill

rage_skill (2.Skill

hp (
atk (
physical_def (
	magic_def (
hit	 (
dodge
 (
cri (
	cri_coeff (
cri_ded_coeff (
block (
base_hp (
base_atk (
base_physical_def (
base_magic_def (
base_hit (

base_dodge (
base_cri (
base_cri_coeff (
base_cri_ded_coeff (

base_block (
level (
break_level (
is_boss (
break_skill (2.Skill
position (",
BattleUnitGrop
group (2.BattleUnit"9
Stage
stage_id (
attacks (
state ("D

StageAward

chapter_id (
award (
dragon_gift ("&
LineUp
pos (
hero_id ("C
Unparalleled

id (
unpar (2.Skill
activate ("z
	FinancePB
coin (
gold (
	hero_soul (
junior_stone (
middle_stone (

high_stone ("&
ShopRequest

id (
num ("{
ShopResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse"H
EquipmentChipPB
equipment_chip_no (
equipment_chip_num ("F
GetEquipmentChipsResponse)
equipment_chips (2.EquipmentChipPB"‘
Mail_PB
mail_id (	
	sender_id (
sender_name (	

receive_id (
receive_name (	
title (	
content (	
	mail_type (
	send_time	 (
	is_readed
 (
prize (	"'
GetMailInfos
mails (2.Mail_PB"6
ReadMailRequest
mail_ids (	
	mail_type ("V
ReadMailResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"$
DeleteMailRequest
mail_id (	")
SendMailRequest
mail (2.Mail_PB"-
ReceiveMailResponse
mail (2.Mail_PB"9

HeroChipPB
hero_chip_no (
hero_chip_num ("7
GetHeroChipsResponse

hero_chips (2.HeroChipPB"D
CommonResponse
result (
	result_no (
message (	"„
GameResourcesResponse
heros (2.HeroPB 

equipments (2.EquipmentPB
items (2.ItemPB

hero_chips (2.HeroChipPB)
equipment_chips (2.EquipmentChipPB
finance (2
.FinancePB
stamina ("!
GameLoginRequest
token (	"•
GameLoginResponse
res (2.CommonResponse

id (
nickname (	
level (
exp (
coin (
gold (
	hero_soul (
junior_stone (
middle_stone	 (

high_stone
 (
	fine_hero (
excellent_hero (
fine_equipment (
excellent_equipment (
stamina (
	pvp_times (
	vip_level (
server_time (
guild_id (
combat_power (
get_stamina_times (
buy_stamina_times (
last_gain_stamina_time (
soul_shop_refresh_times ("0
GetEquipmentsRequest
type (

id (	"@
EnhanceEquipmentRequest

id (	
type (
num ("%
ComposeEquipmentRequest

no ("%
NobbingEquipmentRequest

id (	"%
MeltingEquipmentRequest

id (	"(
AwakeningEquipmentRequest
ids (	"
SoulShopRequest

id ("@
GetShopItemsResponse
res (2.CommonResponse

id ("
SoulShopResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse""
FriendCommon

target_ids ("#
AddFriendResponse
result ("+
FindFriendRequest
id_or_nickname (	"¢
FindFriendResponse

id (
nickname (	
hero_no (
gift (
power (

hp (
atk (
physical_def (
	magic_def	 ("
GetPlayerFriendsRequest"ù
CharacterInfo

id (
nickname (	
hero_no (
gift (
power (

hp (
atk (
physical_def (
	magic_def	 ("ò
GetPlayerFriendsResponse
page_num (
friends (2.CharacterInfo!
	blacklist (2.CharacterInfo&
applicant_list (2.CharacterInfo"*
GetHerosResponse
heros (2.HeroPB"O
HeroUpgradeResponse
res (2.CommonResponse
level (
exp ("o
HeroBreakResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse
break_level ("[
HeroSacrificeResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"J
HeroComposeResponse
res (2.CommonResponse
hero (2.HeroPB"V
HeroSellResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse".
ChatObjectInfo

id (
nickname (	"4
LoginToChatRequest
owner (2.ChatObjectInfo"ä
ChatConectingRequest
owner (2.ChatObjectInfo
channel (
content (	
other (2.ChatObjectInfo
guild_id (	"/
ChatResponse
result (
message (	"W
chatMessageResponse
channel (
owner (2.ChatObjectInfo
content (	"
GetLevelGift
gift_id ("L
GetLevelGiftResponse
result ($
gain (2.GameResourcesResponse"+
ItemPB
item_no (
item_num ("#
PlayerLoginRequest
token (	"'
CreatePlayerRequest
nickname (	"

AccountKey
key (	"2
AccountResponse
result (
message (	"'
AccountLoginRequest
passport (	" 
GetOnlineGift
gift_id ("M
GetOnlineGiftResponse
result ($
gain (2.GameResourcesResponse"n
GetOnlineLevelGiftData
online_time (
received_online_gift_id (
received_level_gift_id ("ª
	RoundUnit

id (

hp (
atk (
physical_def (
	magic_def (
hit (
dodge (
cri (
	cri_coeff	 (
cri_ded_coeff
 (
block ("%
Effect
type (
value ("ô
Buff

id (
name (	
targets (2
.RoundUnit
	executors (2
.RoundUnit

has_parent (
unpara (
effect (2.Effect"o
Round
camp (
executor (2
.RoundUnit
skill_id (

skill_type (
buffs (2.Buff"$
StageInfoRequest
stage_id ("(
ChapterInfoRequest

chapter_id ("a
StageStartRequest
stage_id (
lineup (2.LineUp
unparalleled (
fid (":
StageSettlementRequest
stage_id (
result ("6
SlotEquipment

no (
equ (2.EquipmentPB"f

LineUpSlot
slot_no (

activation (
hero (2.HeroPB
equs (2.SlotEquipment"c
LineUpResponse
slot (2.LineUpSlot
sub (2.LineUpSlot
res (2.CommonResponse"L
ChangeEquipmentsRequest
slot_no (

no (
equipment_id (	"J
ChangeHeroRequest
slot_no (
change_type (
hero_no ("&
GetLineUpResponse
	target_id ("D
GetEatTimeResponse
res (2.CommonResponse
eat_time ("
EatFeastResponse
res ("*
StageInfoResponse
stage (2.Stage"7
ChapterInfoResponse 
stage_award (2.StageAward"∫
StageStartResponse
res (2.CommonResponse
drop_num (
red (2.BattleUnit
blue (2.BattleUnitGrop
friend (2.BattleUnit
monster_unpara (2.Skill"^
StageSettlementResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse",
FormationResponse
lineup (2.LineUp"4
UnparalleledResponse
unpar (2.Unparalleled"Ç
GetSignInResponse
days (
continuous_sign_in_days ( 
continuous_sign_in_prize (
repair_sign_in_times (""
RepairSignInRequest
day ("T
SignInResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"/
ContinuousSignInRequest
sign_in_days ("^
ContinuousSignInResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"X
HeroUpgradeWithItemRequest
hero_no (
exp_item_no (
exp_item_num ("#
HeroBreakRequest
hero_no ("(
HeroSacrificeRequest
hero_nos ("*
HeroComposeRequest
hero_chip_no ("#
HeroSellRequest
hero_nos ("*
GetItemsResponse
items (2.ItemPB"U
ItemUseResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"I
GuildCommonResponse
result (
	result_no (
message ("ì
	GuildInfo
g_id (	
name (
p_num (
level (
exp (
fund (
call (
record (
my_position	 ("]
RoleInfo
p_id (
name (
level (
	vip_level (
fight_power ("q
	RoleInfo1
p_id (
name (
level (
position (
all_contribution (
k_num ("v
	GuildRank
g_id (	
rank (
name (
level (
	president (
p_num (
record (""
CreateGuildRequest
name (" 
JoinGuildRequest
g_id (	"[
JoinGuildResponse
result (
	result_no (
message (

spare_time ("!
EditorCallRequest
call ("3
DealApplyRequest
p_ids (
res_type ("V
DealApplyResponse
result (
	result_no (
message (
p_ids ("&
ChangePresidentRequest
p_id ("
KickRequest
p_ids ("U
PromotionResponse
result (
	result_no (
message (
p_id (" 
WorshipRequest
w_type ("Q
GuildInfoProto
result (

guild_info (2
.GuildInfo
message ("O
ApplyListProto
result (
	role_info (2	.RoleInfo
message ("T
GuildRoleListProto
result (
	role_info (2
.RoleInfo1
message ("Q
GuildRankProto
result (

guild_rank (2
.GuildRank
message ("U
GetEquipmentResponse
res (2.CommonResponse
	equipment (2.EquipmentPB"Z
EnhanceEquipmentResponse
res (2.CommonResponse 
data (2.EnhanceDataFormat"S
ComposeEquipmentResponse
res (2.CommonResponse
equ (2.EquipmentPB"x
NobbingEquipmentResponse
res (2.CommonResponse
equ (2.EquipmentPB#
cgr (2.GameResourcesResponse"]
MeltingEquipmentResponse
res (2.CommonResponse#
cgr (2.GameResourcesResponse"_
AwakeningEquipmentResponse
res (2.CommonResponse#
cgr (2.GameResourcesResponse".
PlayerResponse

id (
nickname (	"'
SetEquipment

no (
num ("K
EnhanceDataFormat
	before_lv (
after_lv (
	cost_coin ("ó
EquipmentPB

id (	

no (
strengthen_lv (
awakening_lv (
nobbing_effect (
hero_no (
set (2.SetEquipment"0
	LoginInfo
	login_day (
is_new_p ("ô
InitLoginGiftResponse
cumulative_received (
continuous_received ("
cumulative_day (2
.LoginInfo"
continuous_day (2
.LoginInfo"A
GetLoginGiftRequest
activity_id (
activity_type ("_
GetLoginGiftResponse
result (
	result_no ($
gain (2.GameResourcesResponse