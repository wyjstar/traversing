
Ï>
traversing_one.proto"0
LinkPB
link_no (
is_activation ("b
HeroPB
hero_no (
level (
exp (
break_level (
links (2.LinkPB"ˆ

BattleUnit

no (
quality (
normal_skill (

rage_skill (

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
is_boss (",
BattleUnitGrop
group (2.BattleUnit"9
Stage
stage_id (
attacks (
state ("D

StageAward

chapter_id (
award (
dragon_gift (":
	FinancePB
coin (
gold (
	hero_soul ("&
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
equipment_chips (2.EquipmentChipPB"‡
Mail_PB
	sender_id (	
sender_name (	
title (	
content (
	mail_type (
	send_time (
bag_id ("'
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
mail (2.Mail_PB",
ReceiveMailRequest
mail (2.Mail_PB"9

HeroChipPB
hero_chip_no (
hero_chip_num ("7
GetHeroChipsResponse

hero_chips (2.HeroChipPB"D
CommonResponse
result (
	result_no (
message (	"Ò
GameResourcesResponse
heros (2.HeroPB 

equipments (2.EquipmentPB
items (2.ItemPB

hero_chips (2.HeroChipPB)
equipment_chips (2.EquipmentChipPB
finance (2
.FinancePB"!
GameLoginRequest
token (	"Þ
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
	pvp_times ("0
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

id (""
GetShopItemsResponse

id ("
SoulShopResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse""
FriendCommon

target_ids ("#
AddFriendResponse
result ("+
FindFriendRequest
id_or_nickname (	"]
FindFriendResponse

id (
nickname (	

ap (
icon_id (
gift ("
GetPlayerFriendsRequest"_
CharacterInfo
	player_id (
nickname (	

ap (
icon_id (
gift ("†
GetPlayerFriendsResponse
friends (2.CharacterInfo!
	blacklist (2.CharacterInfo&
applicant_list (2.CharacterInfo"*
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
owner (2.ChatObjectInfo"x
ChatConectingRequest
owner (2.ChatObjectInfo
channel (
content (	
other (2.ChatObjectInfo"/
ChatResponse
result (
message (	"W
chatMessageResponse
channel (
owner (2.ChatObjectInfo
content (	"+
ItemPB
item_no (
item_num ("#
PlayerLoginRequest
token (	"'
CreatePlayerRequest
nickname (	"Z
AccountInfo
type (
	user_name (	
password (	
key (2.AccountKey"

AccountKey
key (	"L
AccountResponse
result (
message (	
key (2.AccountKey"T
AccountLoginRequest
key (2.AccountKey
	user_name (	
password (	"$
StageInfoRequest
stage_id ("(
ChapterInfoRequest

chapter_id ("%
StageStartRequest
stage_id (":
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
hero_no ("*
StageInfoResponse
stage (2.Stage"7
ChapterInfoResponse 
stage_award (2.StageAward"}
StageStartResponse
res (2.CommonResponse
drop_num (
red (2.BattleUnit
blue (2.BattleUnitGrop"@
StageSettlementResponse%
drops (2.GameResourcesResponse"X
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
message ("“
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

spare_time ("!
EditorCallRequest
call ("3
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
	cost_coin ("—
EquipmentPB

id (	

no (
strengthen_lv (
awakening_lv (
nobbing_effect (
hero_no (
set (2.SetEquipment