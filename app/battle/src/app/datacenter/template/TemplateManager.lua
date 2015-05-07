--lua层模板管理类，管理静态数据实例

TemplateManager = TemplateManager or class("TemplateManager")

local SoldierTemplate = import(".soldiers.SoldierTemplate")
local EquipTemplate = import(".equipment.EquipTemplate")
local BagTemplate = import(".bag.BagTemplate")
local LanguageTemplate = import(".language.LanguageTemplate")
local ChipTemplate = import(".chips.ChipTemplate")
local SquipTemplate = import(".equipment.SquipmentTemplate")
local LegionTemplate = import(".legion.LegionTemplate")
local SoulShopTemplate = import(".soul.SoulShopTemplate")
local ShopTemplate = import(".shop.ShopTemplate")
local InstanceTemplate = import(".instance.InstanceTemplate")
local BaseTemplate = import(".common.BaseTemplate")
local FormulaTemplate = import(".common.FormulaTemplate") 
local ResourceTemplate = import(".resource.ResourceTemplate")
local DropTemplate = import(".drop.DropTemplate")
local PlayerTemplate = import(".player.PlayerTemplate")
local RandomNameTemplate = import(".player.RandomNameTemplate")
local ArenaShopTemplate = import(".arena.ArenaShopTemplate")
local TravelTemplate = import(".travel.TravelTemplate")
local AchievementTemplate = import(".active.AchievementTemplate")
local StoneTemplate = import(".rune.StoneTemplate")
local SecretplaceTemplate = import(".secretplace.SecretplaceTemplate")
local MailTemplate = import(".mail.MailTemplate")

function TemplateManager:ctor(controller)
   self.c_SoldierTemplate = nil       --英雄模板类
   self.c_EquipTemplate = nil         --装备模板类
   self.c_BagTemplate = nil           --道具模板类
   self.c_LanguageTemplate = nil      --语言模板类
   self.c_ChipTemplate = nil          --装备碎片类
   self.c_SquipmentTemlate = nil      --套装模板类
   self.c_LegionTemplate = nil        --军团模板类
   self.c_SourlShopTemlate = nil      --套装模板类
   self.c_ShopTemplate = nil          --商城模板类
   self.c_InstanceTemplate = nil      --关卡模板类
   self.c_BaseTemplate = nil          --基本模板类
   self.c_ResourceTemplate = nil      --图片资源模板类
   self.c_DropTemplate = nil          --掉落包模板
   self.c_PlayerTemplate = nil        --玩家相关模板
   self.c_ArenaShopTemplate = nil     --竞技场商品兑换模板类
   self.c_AchievementTemplate = nil   --活跃度模板类
   self.c_TravelTemplate = nil        --游历模板类
   self.c_StoneTemplate = nil         --符文模板类
   self.c_SecretplaceTemplate = nil   --符文秘境
   self.c_FormulaTemplate = nil       -- 公式
   self.c_MailTemplate = nil          -- 邮件
end


function TemplateManager:getMailTemplate()
    if self.c_MailTemplate  == nil then
        self.c_MailTemplate = MailTemplate.new()
    end
    return self.c_MailTemplate
end

function TemplateManager:getSecretplaceTemplate()
    if self.c_SecretplaceTemplate  == nil then
        self.c_SecretplaceTemplate = SecretplaceTemplate.new()
    end
    return self.c_SecretplaceTemplate
end

function TemplateManager:getTravelTemplate()
    if self.c_TravelTemplate  == nil then
        self.c_TravelTemplate = TravelTemplate.new()
    end
    return self.c_TravelTemplate
end


function TemplateManager:getSoulShopTemplate()
    if self.c_SourlShopTemlate  == nil then
        self.c_SourlShopTemlate = SoulShopTemplate.new()
    end
    return self.c_SourlShopTemlate
end

function TemplateManager:getSoldierTemplate()
    if self.c_SoldierTemplate  == nil then
        self.c_SoldierTemplate = SoldierTemplate.new()
    end
    return self.c_SoldierTemplate
end

--背包道具模板
function TemplateManager:getBagTemplate()
    if self.c_BagTemplate == nil then
        self.c_BagTemplate = BagTemplate.new()
    end
    return self.c_BagTemplate
end

--装备模板
function TemplateManager:getEquipTemplate()
    if self.c_EquipTemplate == nil then
    	self.c_EquipTemplate = EquipTemplate.new()
    end
    return self.c_EquipTemplate
end

--装备碎片模板
function TemplateManager:getChipTemplate()
    if self.c_ChipTemplate == nil then
        self.c_ChipTemplate = ChipTemplate.new()
    end
    return self.c_ChipTemplate
end

--语言模板
function TemplateManager:getLanguageTemplate()
  if self.c_LanguageTemplate == nil then
    self.c_LanguageTemplate = LanguageTemplate.new()
  end
  return self.c_LanguageTemplate
end

--套装模板
function TemplateManager:getSquipmentTemplate()
    if self.c_SquipmentTemlate == nil then
        self.c_SquipmentTemlate = SquipTemplate.new()
    end
    return self.c_SquipmentTemlate
end

--军团模板
function TemplateManager:getLegionTemplate()
  if self.c_LegionTemplate == nil then
    self.c_LegionTemplate = LegionTemplate.new()
  end
  return self.c_LegionTemplate
end

--商城模板
function TemplateManager:getShopTemplate()
    if self.c_ShopTemplate == nil then
        self.c_ShopTemplate = ShopTemplate.new()
    end
    return self.c_ShopTemplate
end

--副本模板
function TemplateManager:getInstanceTemplate()
    if self.c_InstanceTemplate == nil then
        self.c_InstanceTemplate = InstanceTemplate.new()
    end
    return self.c_InstanceTemplate
end

--基本配置模板
function TemplateManager:getBaseTemplate()
  if self.c_BaseTemplate == nil then
    self.c_BaseTemplate = BaseTemplate.new()
  end
  return self.c_BaseTemplate
end

--图片资源模板
function TemplateManager:getResourceTemplate()
    if self.c_ResourceTemplate == nil then
        self.c_ResourceTemplate = ResourceTemplate.new()
    end
    return self.c_ResourceTemplate
end

--掉落包模板
function TemplateManager:getDropTemplate()
    if self.c_DropTemplate == nil then
      self.c_DropTemplate = DropTemplate.new()
    end
    return self.c_DropTemplate
end

--玩家相关模板
function TemplateManager:getPlayerTemplate()
    if self.c_PlayerTemplate == nil then
        self.c_PlayerTemplate = PlayerTemplate.new()
    end
    return self.c_PlayerTemplate
end

--玩家昵称模板
function TemplateManager:getRandomTemplate()
    if self.c_RandomTemplate == nil then
        self.c_RandomTemplate = RandomNameTemplate.new()
    end
    return self.c_RandomTemplate
end

--竞技场商品兑换模板
function TemplateManager:getArenaShopTemplate()
  if self.c_ArenaShopTemplate == nil then
    self.c_ArenaShopTemplate = ArenaShopTemplate.new()
  end
  return self.c_ArenaShopTemplate
end

--活跃度模板类
function TemplateManager:getAchievementTemplate()
  if self.c_AchievementTemplate == nil then
    self.c_AchievementTemplate = AchievementTemplate.new()
  end
  return self.c_AchievementTemplate
end

--符文模板类
function TemplateManager:getStoneTemplate()
  if self.c_StoneTemplate == nil then
    self.c_StoneTemplate = StoneTemplate.new()
  end
  return self.c_StoneTemplate
end

--公式模板类
function TemplateManager:getFormulaTemplate()
  if self.c_FormulaTemplate == nil then
    self.c_FormulaTemplate = FormulaTemplate.new()
  end
  return self.c_FormulaTemplate
end

return TemplateManager

