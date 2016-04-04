
ò‘
traversing_one.proto"

AccountKey
key (	"2
AccountResponse
result (
message (	"'
AccountLoginRequest
passport (	"K
AccountKick

id (
time (
channel (	
	client_os (	"<
GetActivityInfoRequese
select_type (
value ("T
GetActivityInfoResponse
res (2.CommonResponse
info (2.ActivityInfo"Ñ
ActivityInfo
act_id (
state (
jindu (
accumulate_days (
recharge (
max_single_recharge ("5
GetActGiftRequest
act_id (
quantity ("Å
GetActGiftResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse'
consume (2.GameResourcesResponse"%
GetActInfoRequese
act_type ("m
GetActInfoResponse
res (2.CommonResponse
received_act_ids (
times (
act_type ("y
FundActivityInfo
act_id (
state (
accumulate_days (
recharge (
max_single_recharge (":
GetFundActivityResponse
info (2.FundActivityInfo"=
GuildActivityInitResponse 
acts (2.GuildActivityInfo"H
GuildActivityInfo
act_id (
	act_times (
finished ("/
GuildActivityGetRewardRequest
act_id ("d
GuildActivityGetRewardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"A
AddActivityInitResponse&
add_act_info (2.AddActivityInfo"P
AddActivityInfo
act_type (+
detail_info (2.AddActivityDetailInfo"V
AddActivityDetailInfo
res_type (
num (
item (2.AddActivityItem"3
AddActivityItem
act_id (
finished ("-
AddActivityGetRewardRequest
act_id ("b
AddActivityGetRewardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse" 
FulfilActivity
act_id ("[
AppleConsumeVerifyRequest
transaction_id (	
purchase_info (	
channel ("ò
AppleConsumeVerifyResponse
res (2.CommonResponse
transaction_id (	$
gain (2.GameResourcesResponse
info (2.GetGoldResponse"ª
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
buffs (2.Buff"0

BattleStep
step_id (
	step_type ("B
PvbBattleResult

battleStep (2.BattleStep
result ("Æ
BrewInfo

brew_times (
	brew_step (

nectar_num (

nectar_cur (
gold (
res (2.CommonResponse'
consume (2.GameResourcesResponse"
DoBrew
	brew_type ("H
GetBuyCoinInfoResponse
	buy_times (
extra_can_buy_times ("/
BuyCoinResponse
res (2.CommonResponse"
CdkeyRequest
cdkey (	"S
CdkeyResqonse
res (2.CommonResponse$
gain (2.GameResourcesResponse"g
ChatObjectInfo

id (
nickname (	
	vip_level (
guild_position (
head ("4
LoginToChatRequest
owner (2.ChatObjectInfo"µ
ChatConectingRequest
owner (2.ChatObjectInfo
channel (
content (	
other (2.ChatObjectInfo
guild_id (
	vip_level (
guild_position ("C
ChatResponse
result (
	result_no (
gag_time ("e
chatMessageResponse
channel (
owner (2.ChatObjectInfo
content (	
time ("(
GetChatHistoryRequest
channel ("|
GetChatHistoryResponse0
world_chat_history (2.chatMessageResponse0
guild_chat_history (2.chatMessageResponse"D
CommonResponse
result (
	result_no (
message (	"≠
GameResourcesResponse
heros (2.HeroPB 

equipments (2.EquipmentPB
items (2.ItemPB

hero_chips (2.HeroChipPB)
equipment_chips (2.EquipmentChipPB
finance (2
.FinancePB
stamina ( 
travel_item (2.TravelItem
runt
 (2.Runt1
team_exp ("f
Runt1
runt_no (
	main_attr (2	.RuntAttr

minor_attr (2	.RuntAttr
runt_id ("b
RuntAttr
attr_value_type (

attr_value (
attr_increment (
	attr_type ("b
GetGoldResponse
res (2.CommonResponse
gold (
	vip_level (
recharge ("O
LuckyHeroAttr
	attr_type (
attr_value_type (

attr_value ("K
LuckyHeroItem
pos (
hero_no (
attr (2.LuckyHeroAttr"F
StageLuckyHeroItems
stage_id (
heros (2.LuckyHeroItem"*
Heads_DB
head (
now_head ("˛
Mail_PB
mail_id (	
	sender_id (
sender_name (	
sender_icon (

receive_id (
receive_name (	
title (	
content (	
	mail_type	 (
	send_time
 (
	is_readed (
prize (	
	read_time (	
	config_id (
nickname (	

guild_name (	
guild_person_num (
guild_level (
guild_id (
rune_num (
pvp_rank (
boss_id (
integral (
rank (
arg1 (	
effec (
is_got_prize ("F
WorldBossAwardDB

award_type (
award (
rank_no ("

Stamina_DB
open_receive (:1
get_stamina_times (:0
buy_stamina_times (:0!
last_gain_stamina_time (:0
last_mail_day (:0
contributors ( 
last_buy_stamina_time (:0
resource_type (:0".
All_Stamina_DB
stamina (2.Stamina_DB"'
SetEquipment

no (
num ("K
EnhanceDataFormat
	before_lv (
after_lv (
	cost_coin ("¥
EquipmentPB

id (	

no (
strengthen_lv (
awakening_lv (
nobbing_effect (
hero_no (
set (2.SetEquipment 
data (2.EnhanceDataFormat
is_guard	 (
	main_attr
 (2.EquAttr

minor_attr (2.EquAttr
prefix (
attr_id (
exp ("a
EquAttr
attr_value_type (

attr_value (
attr_increment (
	attr_type ("H
EquipmentChipPB
equipment_chip_no (
equipment_chip_num ("F
GetEquipmentChipsResponse)
equipment_chips (2.EquipmentChipPB"0
GetEquipmentsRequest
type (

id (	"3
EnhanceEquipmentRequest

id (	
type ("%
ComposeEquipmentRequest

no ("%
NobbingEquipmentRequest

id (	"%
MeltingEquipmentRequest

id (	"(
AwakeningEquipmentRequest
ids (	"U
GetEquipmentResponse
res (2.CommonResponse
	equipment (2.EquipmentPB"g
EnhanceEquipmentResponse
res (2.CommonResponse
num ( 
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
cgr (2.GameResourcesResponse"≥

EscortTask
task_id (	
task_no (
state (
receive_task_time (
start_protect_time (&
protect_guild_info (2
.GuildRank"

protecters (2.CharacterInfo&
reward (2.GameResourcesResponse*
rob_task_infos	 (2.RobEscortTaskInfo
last_send_invite_time
 ("Í
RobEscortTaskInfo"
rob_guild_info (2
.GuildRank
robbers (2.CharacterInfo
red (2.BattleUnitGrop
blue (2.BattleUnitGrop
seed1 (
seed2 (*

rob_reward (2.GameResourcesResponse

rob_result (
rob_time	 (
	rob_state
 (
rob_receive_task_time (
rob_no (:-1
last_send_invite_time ("ÿ
GetEscortTasksResponse
start_protect_times (
protect_times (
	rob_times (
refresh_times (
tasks (2.EscortTask"
can_rob_tasks (2.EscortTask)
tasks_protect_invite (2.EscortTask%
tasks_rob_invite	 (2.EscortTask$
my_current_task (2.EscortTask(
my_current_rob_task (2.EscortTask"?
GetEscortRecordsRequest
record_type (
current ("6
GetEscortRecordsResponse
tasks (2.EscortTask"U
RefreshEscortTaskResponse
res (2.CommonResponse
tasks (2.EscortTask"n
ReceiveEscortTaskRequest
task_id (	
protect_or_rob (
task_guild_id (
rob_no (:-1"T
ReceiveEscortTaskResponse
res (2.CommonResponse
task (2.EscortTask"U
CancelEscortTaskRequest
task_id (	
task_guild_id (
rob_no (:-1"Å
InviteEscortTaskRequest
task_id (	

send_or_in (
protect_or_rob (
task_guild_id (
rob_no (:-1"Q
InviteEscortTaskPushResponse
task (2.EscortTask
protect_or_rob ("l
StartEscortTaskRequest
task_id (	
protect_or_rob (
task_guild_id (
rob_no (:-1"ã
StartEscortTaskResponse
res (2.CommonResponse)
rob_task_info (2.RobEscortTaskInfo'
consume (2.GameResourcesResponse"D
GetEatTimeResponse
res (2.CommonResponse
eat_time ("
EatFeastResponse
res (""
FriendCommon

target_ids ("#
AddFriendResponse
result ("+
FindFriendRequest
id_or_nickname ("3
FindFriendResponse
infos (2.CharacterInfo"
GetPlayerFriendsRequest"∆
CharacterInfo

id (
nickname (	
hero_no (
gift (:0
power (:1010
	last_time
 (:0
current (
target (
stat (
level (
b_rank (:1
	vip_level (
fight_times (
fight_last_time ( 
friend_info (2.BattleUnit
guild_position ("Æ
GetPlayerFriendsResponse
open_receive (
page_num (
friends (2.CharacterInfo!
	blacklist (2.CharacterInfo&
applicant_list (2.CharacterInfo"?
FriendPrivateChatRequest

target_uid (
content (	"h
GetRecommendFriendsResponse
open_receive (
page_num (!
	recommend (2.CharacterInfo"
DrawRewardReq
fid ("`
DrawRewardRsp
fid (
res (2.CommonResponse$
gain (2.GameResourcesResponse"
RecommendReq"/
RecommendRes
rfriend (2.CharacterInfo"ã
GameLoginRequest
token (	
plat_id (
client_version (	
system_software (	
system_hardware (	
telecom_oper (	
network (	
screen_width (
screen_hight	 (
density
 (
login_channel (	
mac (	
cpu_hardware (	
memory (
	gl_render (	

gl_version (	
	device_id (	
platform (
open_id (	
open_key (	
	pay_token (	
appid (	
appkey (	

pf (	
pfkey (	
zoneid (	
recharge_id ("‹
GameLoginResponse
res (2.CommonResponse

id (
nickname (	
level (
exp (
finances (
	fine_hero (
excellent_hero (
fine_equipment	 (
excellent_equipment
 (
	pvp_times (
pvp_refresh_count (
	vip_level (
server_time (
guild_id (
combat_power (
newbee_guide_id (
register_time (
get_stamina_times (
buy_stamina_times (
last_gain_stamina_time (
soul_shop_refresh_times (
head (
now_head (
first_recharge_ids (
gag (
closure (
recharge (
tomorrow_gift (
battle_speed (
fine_hero_times (
excellent_hero_times  (
fight_power_rank! (
pvp_overcome_index" (
pvp_overcome_stars$ ("
pvp_overcome_refresh_count% (#
	buy_times& (2.BuyStaminaTimes!
is_open_next_day_activity' (
first_recharge_activity( (
hight_power) (
story_id* (
button_one_time+ (
server_open_time, (
q360_recharge_url- (	
one_dollar_flowid. (	
oppo_recharge_url/ (	"c
BuyStaminaTimes
resource_type (
buy_stamina_times (
last_gain_stamina_time ("(
HeartBeatResponse
server_time (">
StaminaOperRequest(
finance_changes (2.FinanceChanges"p
StaminaOperResponse
res (2.CommonResponse(
finance_changes (2.FinanceChanges
	buy_times ("$
GmCommonModifyLevel
level ("$
RechargeTest
recharge_num ("*
GoogleGenerateIDRequest
channel ("'
GoogleGenerateIDResponse
uid (	"$
GoogleConsumeRequest
data (	"5
GoogleConsumeResponse
res (2.CommonResponse"=
GoogleConsumeVerifyRequest
data (	
	signature (	"Å
GoogleConsumeVerifyResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse
info (2.GetGoldResponse"L
GetGuildRankRequest
	rank_type (
min_rank (
max_rank ("b
GetGuildRankResponse
res (2.CommonResponse

guild_rank (2
.GuildRank
flag ("´
	GuildRank
g_id (
rank (
name (	
level (
	president (	
p_num (
icon_id (
call (	
be_apply	 (

ysdt_level
 (" 
JoinGuildRequest
g_id ("E
JoinGuildResponse
res (2.CommonResponse

spare_time ("1
ExitGuildResponse
res (2.CommonResponse"3
CreateGuildRequest
name (	
icon_id ("3
CreateGuildResponse
res (2.CommonResponse"N
GetGuildContributionResponse
contribution (
all_contribution ("É
GetGuildInfoResponse
res (2.CommonResponse
g_id (
name (	

member_num (
contribution (
all_contribution (
call (	
icon_id (
all_zan_num	 (
	zan_money
 (

have_apply (

build_info (2
.BuildInfo
captain_name (	
captain_level (
captain_power (
captain_vip_level (
captain_icon (
zan_num (
last_zan_time (
position (
luck_num (

bless_gift (
	bless_num (
guild_bless_times (
my_guild_rank (
my_contribution (
my_all_contribution (
my_day_contribution (
be_mobai_times ( 
guild_skill (2.GuildSkill
skill_point (
level  (

captain_id! (
mobai_times" ("4
	BuildInfo

build_type (
build_level ("$
UpBuildRequest

build_type ("/
UpBuildResponse
res (2.CommonResponse"!
EditorCallRequest
call (	"2
EditorCallResponse
res (2.CommonResponse"W
GetApplyListResponse
res (2.CommonResponse!
	role_info (2.ApplyUserInfo"à
ApplyUserInfo
p_id (
name (	
level (
	vip_level (
fight_power (
	is_online (
	user_icon ("X
GetGuildMemberListResponse
res (2.CommonResponse
	role_info (2	.RoleInfo"Ò
RoleInfo
p_id (
name (	
level (
position (
day_contribution (
all_contribution
 (
contribution (
fight_power (
	is_online (
	user_icon	 (
	vip_level (
be_mobai ("&
ChangePresidentRequest
p_id ("7
ChangePresidentResponse
res (2.CommonResponse"3
DealApplyRequest
p_ids (
res_type ("@
DealApplyResponse
res (2.CommonResponse
p_ids ("
KickRequest
p_ids (",
KickResponse
res (2.CommonResponse"$
InviteJoinRequest
user_id ("2
InviteJoinResponse
res (2.CommonResponse"G
DealInviteJoinRequest
res (
guild_id (
mail_id (	"M
DealInviteJoinResResponse
res (2.CommonResponse

spare_time ("ì
ZanResResponse
res (2.CommonResponse
all_zan_num (
	zan_money ($
gain (2.GameResourcesResponse
last_zan_time ("U
ReceiveResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse""
BlessRequest

bless_type ("-
BlessResponse
res (2.CommonResponse"&
GetBlessGiftRequest
gift_no ("Z
GetBlessGiftResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"&
FindGuildRequest

id_or_name ("Q
FindGuildResponse
res (2.CommonResponse

guild_info (2
.GuildRank"1
AppointRequest
	deal_type (
p_id ("/
AppointResponse
res (2.CommonResponse""
PositionChange
position ("Ü
GuildBossInitResponse
res (2.CommonResponse
trigger_times (

guild_boss (2
.GuildBoss
last_attack_time ("5

GuildSkill

skill_type (
skill_level ("è
	GuildBoss
	player_id (
player_name (	
hp_left (
hp_max (
stage_id (
trigger_time (
	boss_type (",
TriggerGuildBossRequest
	boss_type ("Å
TriggerGuildBossResponse
res (2.CommonResponse

guild_boss (2
.GuildBoss'
consume (2.GameResourcesResponse"*
GuildBossBattleRequest
stage_id ("·
GuildBossBattleResponse
res (2.CommonResponse
red (2.BattleUnit
blue (2.BattleUnit$
gain (2.GameResourcesResponse
fight_result (
guild_skill_point (
seed1	 (
seed2
 (")
UpGuildSkillRequest

skill_type ("O
UpGuildSkillResponse
res (2.CommonResponse
guild_skill_point ("!
GuildMOBAIRequest
u_id ("X
GuildMOBAIResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"Z
ReceiveMOBAIResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse""
MineSeekHelpRequest
pos ("4
MineSeekHelpResponse
res (2.CommonResponse"_
MineSeekHelpListResponse
res (2.CommonResponse%

help_infos (2.MineSeekHelpInfo"´
MineSeekHelpInfo
p_id (
name (	
icon (
mine_id (
	seek_time (
	vip_level (
level (
be_help_times (
position	 ("$
MineHelpRequest
	seek_time ("0
MineHelpResponse
res (2.CommonResponse"V
GuildDynamic
type (
time (
name1 (	
name2 (	
num1 ("V
GuildDynamicsResponse
res (2.CommonResponse
dynamics (2.GuildDynamic"0
LinkPB
link_no (
is_activation ("2
RuntType
	runt_type (
runt (2.Runt"x
Runt
runt_no (
	main_attr (2
.RuntAttr1

minor_attr (2
.RuntAttr1
runt_id (
runt_po ("ç
HeroPB
hero_no (
level (
exp (
break_level (
refine (
is_guard (
links (2.LinkPB
	runt_type (2	.RuntType
	is_online	 (
awake_level
 (
	awake_exp (
awake_item_num (
break_item_num ("c
	RuntAttr1
attr_value_type (

attr_value (
attr_increment (
	attr_type ("9

HeroChipPB
hero_chip_no (
hero_chip_num ("7
GetHeroChipsResponse

hero_chips (2.HeroChipPB"X
HeroUpgradeWithItemRequest
hero_no (
exp_item_no (
exp_item_num ("#
HeroBreakRequest
hero_no ("I
HeroSacrificeRequest
hero_nos (

hero_chips (2.HeroChipPB"*
HeroComposeRequest
hero_chip_no ("#
HeroSellRequest
hero_nos ("4
HeroRefineRequest
hero_no (
refine ("
HeroRequest
hero_no (";
HeroAwakeRequest
hero_no (
awake_item_num (".
HeroBreakRelatedInfoRequest
hero_no ("*
GetHerosResponse
heros (2.HeroPB"O
HeroUpgradeResponse
res (2.CommonResponse
level (
exp ("á
HeroBreakResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse
break_level (
break_item_num ("[
HeroSacrificeResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"J
HeroComposeResponse
res (2.CommonResponse
hero (2.HeroPB"V
HeroSellResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"[
HeroRefineResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse"j
OneKeyHeroUpgradeRespone
res (2.CommonResponse
level (
exp (
exp_item_num ("ö
HeroAwakeResponse
res (2.CommonResponse
awake_level (
	awake_exp (
awake_item_num ('
consume (2.GameResourcesResponse"M
HeroBreakRelatedInfoResponse
break_item_num (
hero_chip_num ("#
HjqyInitRequest
owner_id ("d
HjqyInitResponse
bosses (2.HjqyBossInfo
	damage_hp (
hjqy_ids (
rank ("ù
HjqyBossInfo
	player_id (
nickname (	
stage_id (
is_share (
state (
hp_left	 (
hp_max (
trigger_time ("Y
HjqyBattleRequest
owner_id (
lineup (
skill (
attack_type ("Ø
HjqyBattleResponse
res (2.CommonResponse
red (2.BattleUnit
blue (2.BattleUnit
	red_skill (
red_skill_level (

blue_skill (
blue_skill_level (
fight_result (
seed1	 (
seed2
 (
attack_type (
	hjqy_coin (
stage_id (""
HjqyAddRewardRequest

id ("[
HjqyAddRewardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"/
HjqyRankResponse
info (2.RankUserInfo"6
InheritRefineRequest
origin (
target ("9
InheritEquipmentRequest
origin (	
target (	"6
InheritUnparaRequest
origin (
target ("+
ItemPB
item_no (
item_num ("*
GetItemsResponse
items (2.ItemPB"U
ItemUseResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse")
KuaiyongFlowIdResponse
flow_id (	"+
MeizuFlowIdRequest
recharge_info (	"4
MeizuFlowIdResponse
flow_id (	
sign (	"D
VivoFlowIdRequest

rechargeid (	
title (	
desc (	"8
VivoFlowIdResponse
transNo (	
	accessKey (	"~
KuaiyongRechargeResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse
info (2.GetGoldResponse"
GetLevelGift
gift_id ("L
GetLevelGiftResponse
result ($
gain (2.GameResourcesResponse"X
NewLevelGiftResponse
res (2.CommonResponse"

level_info (2.LevelGiftInfo"E
LevelGiftInfo
level (%
drops (2.GameResourcesResponse"’
GetLimitHeroInfoResponse
res (2.CommonResponse
activity_id (
	free_time (
integral (

draw_times (
rank ("

limit_rank (2.LimitHeroRank
integral_draw_times ("A
LimitHeroRank
nickname (	
rank (
integral (")
LimitHeroDrawRequest
	draw_type ("†
LimitHeroDrawResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse
rank ("

limit_rank (2.LimitHeroRank
	free_time ("6
SlotEquipment

no (
equ (2.EquipmentPB"f

LineUpSlot
slot_no (

activation (
hero (2.HeroPB
equs (2.SlotEquipment"º
LineUpResponse
slot (2.LineUpSlot
sub (2.LineUpSlot
unpar_level (
res (2.CommonResponse
order (/
travel_item_chapter (2.TravelItemChapter
guild_level (
caption_pos	 (
ever_have_heros
 (

unpar_type (
unpar_other_id (
unpar_names (	"L
ChangeEquipmentsRequest
slot_no (

no (
equipment_id (	"F
ChangeMultiEquipmentsRequest&
equs (2.ChangeEquipmentsRequest"J
ChangeHeroRequest
slot_no (
change_type (
hero_no ("%
GetLineUpRequest
	target_id ("J
EquipmentStrengthInfo
slot_no ( 
data (2.EnhanceDataFormat"/
AllEquipmentsStrengthRequest
slot_no ("•
AllEquipmentsStrengthResponse
res (2.CommonResponse
slot_no (
coin (%
infos (2.EquipmentStrengthInfo 
line_up (2.LineUpResponse"T
SaveLineUpOrderRequest
lineup (

unpar_type (
unpar_other_id ("(
SetCaptainRequest
caption_pos ("#
ActiveUnparaRequest
name (	"/
	LoginInfo
activity_id (
state ("Ÿ
InitLoginGiftResponse"
cumulative_day (2
.LoginInfo"
continuous_day (2
.LoginInfo
cumulative_day_num (
continuous_day_num (#
continuous_7day (2
.LoginInfo
continuous_7day_num ("A
GetLoginGiftRequest
activity_id (
activity_type ("_
GetLoginGiftResponse
result (
	result_no ($
gain (2.GameResourcesResponse"H
GetMailInfos
mails (2.Mail_PB
target (
current ("6
ReadMailRequest
mail_ids (	
	mail_type ("ä
ReadMailResponse
res (2.CommonResponse
target (
current (
	mail_type ($
gain (2.GameResourcesResponse"%
DeleteMailRequest
mail_ids (	")
SendMailRequest
mail (2.Mail_PB"-
ReceiveMailResponse
mail (2.Mail_PB""
GetPrizeRequest
mail_id (	"V
GetPrizeResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"#
positionRequest
position ("œ
mineData
position (
type (
status (
nickname (	
	last_time (
gen_time (
is_guild (
	is_friend (
fight_power	 (
	seek_help
 (
mine_id ("c

mineUpdate
reset_today (

reset_free (
reset_count (
mine (2	.mineData"Y
searchResponse
res (2.CommonResponse
position (
mine (2	.mineData"
resetMap
free ("
resetResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse
mine (2.mineUpdate
free ("0
	stoneData
stone_id (
	stone_num ("“

mineDetail
position (
res (2.CommonResponse
mine (2	.mineData
limit (
normal (2
.stoneData
lucky (2
.stoneData
increase (
lineup (2.LineUpResponse
genUnit	 (
rate
 (
incrcost (
stage_id (

guard_time (
accelerate_times (
	seek_help ("ã

drawStones
position (
res (2.CommonResponse&
normal (2.GameResourcesResponse%
lucky (2.GameResourcesResponse"+
shopInfo
shop_id (
status ("U

shopStatus
position (
shop (2	.shopInfo
res (2.CommonResponse"4
exchangeRequest
position (
shop_id ("¢
exchangeResponse
position (
shop_id (
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse"=
	boxReward
position (
data (2.ItemUseResponse"~
IncreaseResponse
position (
	last_time ('
consume (2.GameResourcesResponse
res (2.CommonResponse"n
MineGuardRequest
pos (&
line_up_slots (2.MineLineUpSlot
best_skill_id (
lineup ("_
MineLineUpSlot
slot_no (
hero_no (+
equipment_slots (2.MineEquipmentSlot":
MineEquipmentSlot
slot_no (
equipment_id (	"a
MineBattleRequest
pos (
lineup (
unparalleled (
fid (
hold ("’
MineBattleResponse
res (2.CommonResponse
red (2.BattleUnit
blue (2.BattleUnit
red_best_skill_id (
red_best_skill_level (
blue_best_skill_id (
blue_best_skill_level (
awake_no (
seed1	 (
seed2
 ($
gain (2.GameResourcesResponse
fight_result (
hold ("J
MineSettleRequest
pos (
result (
steps (2	.StepInfo"
	MineSpeed"$
MineAccelerateRequest
pos ("_
MineAccelerateResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse"Ü
NoticeResponse
	notice_id (
player_name (	
hero_no (
hero_break_level (
equipment_no (
msg (	" 
GetOnlineGift
gift_id ("M
GetOnlineGiftResponse
result ($
gain (2.GameResourcesResponse"n
GetOnlineLevelGiftData
online_time (
received_online_gift_id (
received_level_gift_id ("K
GetActivityResponse
result ($
gain (2.GameResourcesResponse"F
FinanceChanges
	item_type (
item_num (
item_no ("…
	FinancePB
coin (
gold (
	hero_soul (
junior_stone (
middle_stone (

high_stone (
	pvp_score (
finances ((
finance_changes	 (2.FinanceChanges"#
PlayerLoginRequest
token (	"'
CreatePlayerRequest
nickname (	""
UpGuideRequest
guide_id ("S
NewbeeGuideStepRequest
step_id (
	common_id (	
sub_common_id (	"$
ChangeHeadRequest
hero_id (""
ChangeBattleSpeed
speed ("$
ChangeStageStory
story_id (")
ButtonOneTimeRequest
	button_id (".
PlayerResponse

id (
nickname (	"ó
NewbeeGuideStepResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse'
consume (2.GameResourcesResponse
step_id ("2
ChangeHeadResponse
res (2.CommonResponse"/
UpdateHightPowerResponse
hight_power ("#
registerPush
deviceToken (	"/
registerPushRes
res (2.CommonResponse"-
	msgSwitch
msg_type (
switch ("*
msgSwitchReq
switch (2
.msgSwitch"*
msgSwitchRes
switch (2
.msgSwitch"ø
	RankItems
nickname (	
rank (
level (

ap (
hero_ids (
hero_levels (
head_no (
character_id (
	vip_level	 (:-1

guild_name
 (	"©
PlayerRankResponse

rank_items (2
.RankItems
player_rank (
	pvp_score (#
pvp_upstage_challenge_id (:0&
pvp_upstage_challenge_nickname (	"q
PvpFightRequest
challenge_rank (
challenge_id (
lineup (
skill (
	self_rank ("B
PvpFightRevenge
black_id (
lineup (
skill ("@
PvpFightOvercome
index (
lineup (
skill ("5
PvpRobTreasureRequest
uid (
chip_id ("<
PvpFightOvercomeInfo
character_ids (
index ("+
PvpPlayerInfoRequest
player_rank ("
ResetPvpTime
times ("%
ResetPvpOvercomeTime
times ("J
RobTreasureMoreTimesRequest
uid (
chip_id (
times ("À
PvpFightResponse
res (2.CommonResponse
red (2.BattleUnit
blue (2.BattleUnit
	red_skill (
red_skill_level (

blue_skill (
blue_skill_level (
fight_result (
seed1	 (
seed2
 ($
gain (2.GameResourcesResponse
top_rank (%
award (2.GameResourcesResponse&
award2 (2.GameResourcesResponse
	rank_incr ('
consume (2.GameResourcesResponse
before_rank ("g
RobTreasureMoreTimesResponse
res (2.CommonResponse)
one_time_info (2.RobTreasureReward"ã
RobTreasureReward$
gain (2.GameResourcesResponse)
	look_gain (2.GameResourcesResponse%

fight_info (2.PvpFightResponse"(
PvpOvercomeAwardRequest
index ("^
PvpOvercomeAwardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"_

BattleBuff
index (
	buff_type (

value_type (
value (
star ("*
GetPvpOvercomeBuffRequest
index ("U
GetPvpOvercomeBuffResponse
res (2.CommonResponse
buff (2.BattleBuff"7
BuyPvpOvercomeBuffRequest
index (
num ("U
BuyPvpOvercomeBuffResponse
res (2.CommonResponse
buff (2.BattleBuff"∆
GetPvpOvercomeInfo
pvp_overcome_index (
stars (
refresh_count (
awarded (
buff (2.BattleBuff
target_fight_powers (

target_ids (
	is_failed ("F
GetRankRequest
first_no (
last_no (
	rank_type ("á
GetRankResponse
res (2.CommonResponse 
	user_info (2.RankUserInfo#
my_rank_info (2.RankUserInfo
all_num ("ª
RankUserInfo
rank (

id (
nickname (	
level (
fight_power (
star_num (
stage_id (
	last_rank (
	user_icon	 (
	damage_hp
 ("E

rebateData
rid (
switch (
last (
draw ("
rebateRequest"*

rebateInfo
rebates (2.rebateData"

rebateDraw
rid ("]

rebateResp
rid (
res (2.CommonResponse$
gain (2.GameResourcesResponse"$
InitRecharge
recharge_ids ("X
RechargeData
recharge_time (
recharge_accumulation (

is_receive ("O
RechargeItem
gift_id (
	gift_type (
data (2.RechargeData"D
GetRechargeGiftDataResponse%
recharge_items (2.RechargeItem"5
GetRechargeGiftRequest
gift (2.RechargeItem"]
GetRechargeGiftResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"•
RobTreasureInitResponse
start_truce (
truce_item_num (
truce_item_num_day (+
player_info (2.PlayerRobTreasureInfo
refresh_time ("&
RobTreasureTruceRequest
num ("™
RobTreasureTruceResponse
res (2.CommonResponse
start_truce (
truce_item_num (
truce_item_num_day ('
consume (2.GameResourcesResponse"-
ComposeTreasureRequest
treasure_id ("R
ComposeTreasureResponse
res (2.CommonResponse
equ (2.EquipmentPB""
BuyTruceItemRequest
num ("É
BuyTruceItemResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse"ô
PlayerRobTreasureInfo

id (
nickname (	
power (
guild_id (	
	vip_level (
now_head (
level (
color ("}
RefreshRobTreasureResponse
res (2.CommonResponse+
player_info (2.PlayerRobTreasureInfo
refresh_time ("ä
RobTreasureRewardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse)
	look_gain (2.GameResourcesResponse" 
BeRobTreasure
chip_id ("7
RobTreasureEnhanceRequest

no (	
use_no (	":
RobTreasureEnhanceResponse
res (2.CommonResponse"Y
RuntSetRequest
hero_no (
	runt_type (#
runt_set_info (2.RuntSetInfo"/
RuntSetResponse
res (2.CommonResponse"/
RuntSetInfo
runt_no (
runt_po ("F
RuntPickRequest
hero_no (
	runt_type (
runt_po ("0
RuntPickResponse
res (2.CommonResponse"}
InitRuntResponse
runt (2.Runt1
stone1 (
stone2 (
refresh_runt (2.Runt1
refresh_times ("Q
RefreshRuntResponse
res (2.CommonResponse
refresh_runt (2.Runt1"&
RefiningRuntRequest
runt_no ("j
RefiningRuntResponse
res (2.CommonResponse
stone1 (
stone2 (
runt (2.Runt1"O
BuildRuntResponse
res (2.CommonResponse
refresh_runt (2.Runt1"/
MakeRuntRequest
runt_no (
num ("F
MakeRuntResponse
res (2.CommonResponse
runt (2.Runt1"'
XiaomiFlowIdResponse
flow_id (	"|
XiaomiRechargeResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse
info (2.GetGoldResponse"
ClientGetShareStatusData"'
ClientGetShareReward
task_id ("(
ServerShareStatusData
task_id ("%
RefreshShopItems
	shop_type ("!
GetShopItems
	shop_type (".
ShopRequest
ids (

item_count ("À
ShopResponse
res (2.CommonResponse'
consume (2.GameResourcesResponse$
gain (2.GameResourcesResponse
limit_item_current_num (
limit_item_max_num (

is_all_buy ("Í
GetShopItemsResponse
res (2.CommonResponse

id (
luck_num (
refresh_times (
items (2	.ItemInfo
	all_items (2	.ItemInfo
guild_items (2	.ItemInfo'
consume	 (2.GameResourcesResponse"-
ItemInfo
item_id (
item_num ("•
GetSignInResponse
days (

sign_round (
current_day ( 
continuous_sign_in_prize (
repair_sign_in_times (
box_sign_in_prize (""
RepairSignInRequest
day ("T
SignInResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"/
ContinuousSignInRequest
sign_in_days ("^
ContinuousSignInResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"
SignInBoxRequest

id (""
Skill

id (
buffs ("®

BattleUnit

no (
quality (

hp (
atk (
physical_def (
	magic_def (
hit (
dodge (
cri	 (
	cri_coeff
 (
cri_ded_coeff (
block (
	ductility (
level (
break_level (
is_boss (
break_skills (
position (
is_break (
is_awake (
	origin_no (
hp_max (
awake_level  (
power! (",
BattleUnitGrop
group (2.BattleUnit"w
Stage
stage_id (
attacks (
state (
reset (2.Reset
chest_state (
star_num ("$
Reset
times (
time ("q

StageAward

chapter_id (
award (

now_random (
	star_gift (
random_gift_times (";
Unparalleled

id (
unpar (
activate (".
StepInfo
step_id (
	step_type ("$
StageInfoRequest
stage_id ("(
ChapterInfoRequest

chapter_id ("l
StageStartRequest
stage_id (

stage_type (
lineup (
unparalleled (
fid ("ç
StageSettlementRequest
stage_id (

stage_type (
steps (2	.StepInfo
result (
is_skip (

always_win ("H
StageSweepRequest
stage_id (
times (

sweep_type ("%
ResetStageRequest
stage_id (":
StarAwardRequest

chapter_id (

award_type (".
UpdataPlotChapterRequest

chapter_id ("0
UpdataChapterPromptRequest

chapter_id (")
OpenStageChestRequest
stage_id ("=
GetStarRandomRequest

chapter_id (
	is_newbee ("4
DealRandomRequest

chapter_id (
res ("*
LookHideStageRequest

chapter_id ("°
StageInfoResponse
stage (2.Stage
elite_stage_times (
act_stage_times (
plot_chapter (
act_coin_stage_times (
act_exp_stage_times (.
stage_lucky_hero (2.StageLuckyHeroItems
already_look_hide_stage (
elite_stage_reset_times	 ("7
ChapterInfoResponse 
stage_award (2.StageAward"9
UpdataPlotChapterResponse
res (2.CommonResponse"Ü
StageStartResponse
res (2.CommonResponse
drop_num (
red (2.BattleUnit
blue (2.BattleUnitGrop
friend (2.BattleUnit

hero_unpar (
hero_unpar_level (
monster_unpar	 (
replace
 (2.BattleUnit

replace_no (
awake (2.BattleUnit
awake_no (
seed1 (
seed2 ('
consume (2.GameResourcesResponse"ƒ
StageSettlementResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse
hjqy_stage_id (
star_num (

battle_res ('
consume (2.GameResourcesResponse"#
FormationResponse
lineup ("4
UnparalleledResponse
unpar (2.Unparalleled"ô
StageSweepResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse'
consume (2.GameResourcesResponse
hjqy_stage_id ("2
ResetStageResponse
res (2.CommonResponse"i
StarAwardResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse
gift_id ("]
OpenStageChestResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse"I
GetStarRandomResponse
res (2.CommonResponse

random_num ("Y
DealRandomResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse";
UpdataChapterPromptResponse
res (2.CommonResponse"5
LookHideStageResponse
res (2.CommonResponse"<
EliteStageTimesResetResponse
res (2.CommonResponse"(
GetStartTargetInfoRequest
day ("t
GetStartTargetInfoResponse
res (2.CommonResponse
day (+
start_target_info (2.StartTargetInfo"B
StartTargetInfo
	target_id (
jindu (
state ("0
GetStartTargetRewardRequest
	target_id ("b
GetStartTargetRewardResponse
res (2.CommonResponse$
gain (2.GameResourcesResponse"B
PushStartTarget
	target_id (
jindu (
state ("F
Task
tid (!
	condition (2.TaskCondition
status ("E
TaskCondition
condition_no (
current (
state ("
TaskInfoRequest
sort ("(
TaskInfoResponse
tasks (2.Task" 
TaskRewardRequest
tid ("e
TaskRewardResponse
tid ($
gain (2.GameResourcesResponse
res (2.CommonResponse"/
ShareRequest
tid (

share_type (":
ShareResponse
res (2.CommonResponse
tid (")

FulfilTask
tid (
lively ("<
ConditionsResponse&
condition_info (2.ConditionInfo")
ConditionInfo
cid (
num ("4
Chapter
travel (2.Travel
stage_id ("^
Travel
event_id (%
drops (2.GameResourcesResponse
time (
state ("!
TravelRequest
stage_id ("ê
TravelResponse
res (2.CommonResponse
event_id (%
drops (2.GameResourcesResponse'
consume (2.GameResourcesResponse"∂
TravelInitResponse
res (2.CommonResponse
chapter (2.Chapter"
stage_travel (2.StageTravel

chest_time (/
travel_item_chapter (2.TravelItemChapter"G
TravelItemChapter
stage_id ( 
travel_item (2.TravelItem"
BuyShoesRequest
num ("0
BuyShoesResponse
res (2.CommonResponse"L
TravelSettleRequest
stage_id (
event_id (
	parameter ("[
TravelSettleResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse"7
EventStartRequest
stage_id (
event_id ("@
EventStartResponse
res (2.CommonResponse
time ("3
NoWaitRequest
stage_id (
event_id ("<
NoWaitResponse
res (2.CommonResponse
time ("X
OpenChestResponse
res (2.CommonResponse%
drops (2.GameResourcesResponse"4
AutoTravelRequest
ttime (
stage_id ("V
AutoTravelResponse
res (2.CommonResponse"
stage_travel (2.StageTravel"h

AutoTravel

start_time (
continued_time (
travel (2.Travel
already_times ("A
StageTravel
stage_id ( 
auto_travel (2.AutoTravel"`
SettleAutoRequest
stage_id (

start_time (
event_id (
settle_type ("V
SettleAutoResponse
res (2.CommonResponse"
stage_travel (2.StageTravel"=
FastFinishAutoRequest
stage_id (

start_time ("Z
FastFinishAutoResponse
res (2.CommonResponse"
stage_travel (2.StageTravel"%

TravelItem

id (
num ("

PvbRequest
boss_id (	"±
PvbRankItem
nickname (	
level (
now_head (
	demage_hp (%
line_up_info (2.LineUpResponse
	player_id (
rank_no (
	vip_level ("¨
PvbBeforeInfoResponse
stage_id (#
lucky_heros (2.LuckyHeroItem
debuff_skill_no ( 

rank_items (2.PvbRankItem$
last_shot_item (2.PvbRankItem
open_or_not (
hp_left	 (
	demage_hp
 (
rank_no (
fight_times (
last_fight_time (
encourage_coin_num (
encourage_gold_num (
gold_reborn_times (
hp_max ( 
last_coin_encourage_time ("8
PvbPlayerInfoRequest
rank_no (
boss_id (	"S
EncourageHerosRequest
finance_type (
finance_num (
boss_id (	"U
PvbStartRequest
boss_id (	
lineup (
unparalleled (
fid ("˝
PvbFightResponse
res (2.CommonResponse
red (2.BattleUnit
blue (2.BattleUnit
red_best_skill (
red_best_skill_level (
fight_result (
seed1 (
seed2 (
debuff_skill_no	 (
damage_rate
 ("S
MineBossResponse
res (2.CommonResponse
boss_id (	
stage_id ("n
PvbAwardResponse
is_over (

award_type ($
gain (2.GameResourcesResponse
rank_no (