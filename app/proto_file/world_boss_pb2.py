# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: world_boss.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2
import stage_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='world_boss.proto',
  package='',
  serialized_pb='\n\x10world_boss.proto\x1a\x0c\x63ommon.proto\x1a\x0bstage.proto\"i\n\x0bPvbRankItem\x12\x10\n\x08nickname\x18\x01 \x02(\t\x12\x0f\n\x07rank_no\x18\x02 \x02(\x05\x12\r\n\x05level\x18\x03 \x02(\x05\x12\x15\n\rfirst_hero_no\x18\x04 \x02(\x05\x12\x11\n\tdemage_hp\x18\x05 \x02(\x05\"\xaf\x01\n\x19GetBeforePvbFightResponse\x12\x11\n\thigh_hero\x18\x01 \x02(\x05\x12\x13\n\x0bmiddle_hero\x18\x02 \x03(\x05\x12\x10\n\x08low_hero\x18\x03 \x03(\x05\x12\x10\n\x08skill_no\x18\x04 \x02(\x05\x12 \n\nrank_items\x18\x05 \x03(\x0b\x32\x0c.PvbRankItem\x12$\n\x0elast_shot_item\x18\x06 \x01(\x0b\x32\x0c.PvbRankItem\"\'\n\x14PvbPlayerInfoRequest\x12\x0f\n\x07rank_no\x18\x01 \x02(\x05\"B\n\x15\x45ncourageHerosRequest\x12\x14\n\x0c\x66inance_type\x18\x01 \x02(\x05\x12\x13\n\x0b\x66inance_num\x18\x02 \x02(\x05\"6\n\x16\x45ncourageHerosResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\".\n\x0eRebornResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\"\x93\x01\n\x10PvbFightResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x18\n\x03red\x18\x02 \x03(\x0b\x32\x0b.BattleUnit\x12\x19\n\x04\x62lue\x18\x03 \x03(\x0b\x32\x0b.BattleUnit\x12\x16\n\x0ered_best_skill\x18\x04 \x01(\x05\x12\x14\n\x0c\x66ight_result\x18\x05 \x01(\x08')




_PVBRANKITEM = _descriptor.Descriptor(
  name='PvbRankItem',
  full_name='PvbRankItem',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='nickname', full_name='PvbRankItem.nickname', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rank_no', full_name='PvbRankItem.rank_no', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='level', full_name='PvbRankItem.level', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='first_hero_no', full_name='PvbRankItem.first_hero_no', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='demage_hp', full_name='PvbRankItem.demage_hp', index=4,
      number=5, type=5, cpp_type=1, label=2,
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
  serialized_start=47,
  serialized_end=152,
)


_GETBEFOREPVBFIGHTRESPONSE = _descriptor.Descriptor(
  name='GetBeforePvbFightResponse',
  full_name='GetBeforePvbFightResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='high_hero', full_name='GetBeforePvbFightResponse.high_hero', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='middle_hero', full_name='GetBeforePvbFightResponse.middle_hero', index=1,
      number=2, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='low_hero', full_name='GetBeforePvbFightResponse.low_hero', index=2,
      number=3, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skill_no', full_name='GetBeforePvbFightResponse.skill_no', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rank_items', full_name='GetBeforePvbFightResponse.rank_items', index=4,
      number=5, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='last_shot_item', full_name='GetBeforePvbFightResponse.last_shot_item', index=5,
      number=6, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
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
  serialized_start=155,
  serialized_end=330,
)


_PVBPLAYERINFOREQUEST = _descriptor.Descriptor(
  name='PvbPlayerInfoRequest',
  full_name='PvbPlayerInfoRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='rank_no', full_name='PvbPlayerInfoRequest.rank_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
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
  serialized_start=332,
  serialized_end=371,
)


_ENCOURAGEHEROSREQUEST = _descriptor.Descriptor(
  name='EncourageHerosRequest',
  full_name='EncourageHerosRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='finance_type', full_name='EncourageHerosRequest.finance_type', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='finance_num', full_name='EncourageHerosRequest.finance_num', index=1,
      number=2, type=5, cpp_type=1, label=2,
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
  serialized_start=373,
  serialized_end=439,
)


_ENCOURAGEHEROSRESPONSE = _descriptor.Descriptor(
  name='EncourageHerosResponse',
  full_name='EncourageHerosResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='EncourageHerosResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
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
  serialized_start=441,
  serialized_end=495,
)


_REBORNRESPONSE = _descriptor.Descriptor(
  name='RebornResponse',
  full_name='RebornResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='RebornResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
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
  serialized_start=497,
  serialized_end=543,
)


_PVBFIGHTRESPONSE = _descriptor.Descriptor(
  name='PvbFightResponse',
  full_name='PvbFightResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='PvbFightResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red', full_name='PvbFightResponse.red', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='blue', full_name='PvbFightResponse.blue', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red_best_skill', full_name='PvbFightResponse.red_best_skill', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='fight_result', full_name='PvbFightResponse.fight_result', index=4,
      number=5, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
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
  serialized_start=546,
  serialized_end=693,
)

_GETBEFOREPVBFIGHTRESPONSE.fields_by_name['rank_items'].message_type = _PVBRANKITEM
_GETBEFOREPVBFIGHTRESPONSE.fields_by_name['last_shot_item'].message_type = _PVBRANKITEM
_ENCOURAGEHEROSRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_REBORNRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_PVBFIGHTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_PVBFIGHTRESPONSE.fields_by_name['red'].message_type = stage_pb2._BATTLEUNIT
_PVBFIGHTRESPONSE.fields_by_name['blue'].message_type = stage_pb2._BATTLEUNIT
DESCRIPTOR.message_types_by_name['PvbRankItem'] = _PVBRANKITEM
DESCRIPTOR.message_types_by_name['GetBeforePvbFightResponse'] = _GETBEFOREPVBFIGHTRESPONSE
DESCRIPTOR.message_types_by_name['PvbPlayerInfoRequest'] = _PVBPLAYERINFOREQUEST
DESCRIPTOR.message_types_by_name['EncourageHerosRequest'] = _ENCOURAGEHEROSREQUEST
DESCRIPTOR.message_types_by_name['EncourageHerosResponse'] = _ENCOURAGEHEROSRESPONSE
DESCRIPTOR.message_types_by_name['RebornResponse'] = _REBORNRESPONSE
DESCRIPTOR.message_types_by_name['PvbFightResponse'] = _PVBFIGHTRESPONSE

class PvbRankItem(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVBRANKITEM

  # @@protoc_insertion_point(class_scope:PvbRankItem)

class GetBeforePvbFightResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETBEFOREPVBFIGHTRESPONSE

  # @@protoc_insertion_point(class_scope:GetBeforePvbFightResponse)

class PvbPlayerInfoRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVBPLAYERINFOREQUEST

  # @@protoc_insertion_point(class_scope:PvbPlayerInfoRequest)

class EncourageHerosRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ENCOURAGEHEROSREQUEST

  # @@protoc_insertion_point(class_scope:EncourageHerosRequest)

class EncourageHerosResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ENCOURAGEHEROSRESPONSE

  # @@protoc_insertion_point(class_scope:EncourageHerosResponse)

class RebornResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _REBORNRESPONSE

  # @@protoc_insertion_point(class_scope:RebornResponse)

class PvbFightResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVBFIGHTRESPONSE

  # @@protoc_insertion_point(class_scope:PvbFightResponse)


# @@protoc_insertion_point(module_scope)
