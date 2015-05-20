# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: common.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import hero_pb2
import equipment_pb2
import item_pb2
import hero_chip_pb2
import equipment_chip_pb2
import player_pb2
import travel_item_pb2
import travel_shoes_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='common.proto',
  package='',
  serialized_pb='\n\x0c\x63ommon.proto\x1a\nhero.proto\x1a\x0f\x65quipment.proto\x1a\nitem.proto\x1a\x0fhero_chip.proto\x1a\x14\x65quipment_chip.proto\x1a\x0cplayer.proto\x1a\x11travel_item.proto\x1a\x12travel_shoes.proto\"D\n\x0e\x43ommonResponse\x12\x0e\n\x06result\x18\x01 \x02(\x08\x12\x11\n\tresult_no\x18\x02 \x01(\x05\x12\x0f\n\x07message\x18\x03 \x01(\t\"\xcd\x02\n\x15GameResourcesResponse\x12\x16\n\x05heros\x18\x01 \x03(\x0b\x32\x07.HeroPB\x12 \n\nequipments\x18\x02 \x03(\x0b\x32\x0c.EquipmentPB\x12\x16\n\x05items\x18\x03 \x03(\x0b\x32\x07.ItemPB\x12\x1f\n\nhero_chips\x18\x04 \x03(\x0b\x32\x0b.HeroChipPB\x12)\n\x0f\x65quipment_chips\x18\x05 \x03(\x0b\x32\x10.EquipmentChipPB\x12\x1b\n\x07\x66inance\x18\x06 \x01(\x0b\x32\n.FinancePB\x12\x0f\n\x07stamina\x18\x07 \x01(\x05\x12 \n\x0btravel_item\x18\x08 \x03(\x0b\x32\x0b.TravelItem\x12\x1e\n\nshoes_info\x18\t \x03(\x0b\x32\n.ShoesInfo\x12\x14\n\x04runt\x18\n \x03(\x0b\x32\x06.Runt1\x12\x10\n\x08team_exp\x18\x0b \x01(\x05\"f\n\x05Runt1\x12\x0f\n\x07runt_no\x18\x01 \x02(\x0c\x12\x1c\n\tmain_attr\x18\x02 \x03(\x0b\x32\t.RuntAttr\x12\x1d\n\nminor_attr\x18\x03 \x03(\x0b\x32\t.RuntAttr\x12\x0f\n\x07runt_id\x18\x04 \x02(\x05\"b\n\x08RuntAttr\x12\x17\n\x0f\x61ttr_value_type\x18\x01 \x02(\x05\x12\x12\n\nattr_value\x18\x02 \x02(\x02\x12\x16\n\x0e\x61ttr_increment\x18\x03 \x02(\x05\x12\x11\n\tattr_type\x18\x04 \x02(\x05\"b\n\x0fGetGoldResponse\x12\x1c\n\x03res\x18\x01 \x01(\x0b\x32\x0f.CommonResponse\x12\x0c\n\x04gold\x18\x02 \x02(\x05\x12\x11\n\tvip_level\x18\x03 \x02(\x05\x12\x10\n\x08recharge\x18\x04 \x02(\x05')




_COMMONRESPONSE = _descriptor.Descriptor(
  name='CommonResponse',
  full_name='CommonResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='result', full_name='CommonResponse.result', index=0,
      number=1, type=8, cpp_type=7, label=2,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='result_no', full_name='CommonResponse.result_no', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='message', full_name='CommonResponse.message', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=149,
  serialized_end=217,
)


_GAMERESOURCESRESPONSE = _descriptor.Descriptor(
  name='GameResourcesResponse',
  full_name='GameResourcesResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='heros', full_name='GameResourcesResponse.heros', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equipments', full_name='GameResourcesResponse.equipments', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='items', full_name='GameResourcesResponse.items', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero_chips', full_name='GameResourcesResponse.hero_chips', index=3,
      number=4, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equipment_chips', full_name='GameResourcesResponse.equipment_chips', index=4,
      number=5, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='finance', full_name='GameResourcesResponse.finance', index=5,
      number=6, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='stamina', full_name='GameResourcesResponse.stamina', index=6,
      number=7, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='travel_item', full_name='GameResourcesResponse.travel_item', index=7,
      number=8, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='shoes_info', full_name='GameResourcesResponse.shoes_info', index=8,
      number=9, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='runt', full_name='GameResourcesResponse.runt', index=9,
      number=10, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='team_exp', full_name='GameResourcesResponse.team_exp', index=10,
      number=11, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=220,
  serialized_end=553,
)


_RUNT1 = _descriptor.Descriptor(
  name='Runt1',
  full_name='Runt1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='runt_no', full_name='Runt1.runt_no', index=0,
      number=1, type=12, cpp_type=9, label=2,
      has_default_value=False, default_value="",
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='main_attr', full_name='Runt1.main_attr', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='minor_attr', full_name='Runt1.minor_attr', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='runt_id', full_name='Runt1.runt_id', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=555,
  serialized_end=657,
)


_RUNTATTR = _descriptor.Descriptor(
  name='RuntAttr',
  full_name='RuntAttr',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='attr_value_type', full_name='RuntAttr.attr_value_type', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='attr_value', full_name='RuntAttr.attr_value', index=1,
      number=2, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='attr_increment', full_name='RuntAttr.attr_increment', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='attr_type', full_name='RuntAttr.attr_type', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=659,
  serialized_end=757,
)


_GETGOLDRESPONSE = _descriptor.Descriptor(
  name='GetGoldResponse',
  full_name='GetGoldResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='GetGoldResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gold', full_name='GetGoldResponse.gold', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='vip_level', full_name='GetGoldResponse.vip_level', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='recharge', full_name='GetGoldResponse.recharge', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  serialized_start=759,
  serialized_end=857,
)

_GAMERESOURCESRESPONSE.fields_by_name['heros'].message_type = hero_pb2._HEROPB
_GAMERESOURCESRESPONSE.fields_by_name['equipments'].message_type = equipment_pb2._EQUIPMENTPB
_GAMERESOURCESRESPONSE.fields_by_name['items'].message_type = item_pb2._ITEMPB
_GAMERESOURCESRESPONSE.fields_by_name['hero_chips'].message_type = hero_chip_pb2._HEROCHIPPB
_GAMERESOURCESRESPONSE.fields_by_name['equipment_chips'].message_type = equipment_chip_pb2._EQUIPMENTCHIPPB
_GAMERESOURCESRESPONSE.fields_by_name['finance'].message_type = player_pb2._FINANCEPB
_GAMERESOURCESRESPONSE.fields_by_name['travel_item'].message_type = travel_item_pb2._TRAVELITEM
_GAMERESOURCESRESPONSE.fields_by_name['shoes_info'].message_type = travel_shoes_pb2._SHOESINFO
_GAMERESOURCESRESPONSE.fields_by_name['runt'].message_type = _RUNT1
_RUNT1.fields_by_name['main_attr'].message_type = _RUNTATTR
_RUNT1.fields_by_name['minor_attr'].message_type = _RUNTATTR
_GETGOLDRESPONSE.fields_by_name['res'].message_type = _COMMONRESPONSE
DESCRIPTOR.message_types_by_name['CommonResponse'] = _COMMONRESPONSE
DESCRIPTOR.message_types_by_name['GameResourcesResponse'] = _GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['Runt1'] = _RUNT1
DESCRIPTOR.message_types_by_name['RuntAttr'] = _RUNTATTR
DESCRIPTOR.message_types_by_name['GetGoldResponse'] = _GETGOLDRESPONSE

class CommonResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _COMMONRESPONSE

  # @@protoc_insertion_point(class_scope:CommonResponse)

class GameResourcesResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GAMERESOURCESRESPONSE

  # @@protoc_insertion_point(class_scope:GameResourcesResponse)

class Runt1(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RUNT1

  # @@protoc_insertion_point(class_scope:Runt1)

class RuntAttr(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RUNTATTR

  # @@protoc_insertion_point(class_scope:RuntAttr)

class GetGoldResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETGOLDRESPONSE

  # @@protoc_insertion_point(class_scope:GetGoldResponse)


# @@protoc_insertion_point(module_scope)
