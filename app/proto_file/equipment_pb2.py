# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: equipment.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='equipment.proto',
  package='proto_file.equipment',
  serialized_pb='\n\x0f\x65quipment.proto\x12\x14proto_file.equipment\x1a\x0c\x63ommon.proto\"\'\n\x0cSetEquipment\x12\n\n\x02no\x18\x01 \x02(\x05\x12\x0b\n\x03num\x18\x02 \x01(\x05\"\x92\x01\n\tEquipment\x12\n\n\x02id\x18\x01 \x02(\t\x12\n\n\x02no\x18\x02 \x01(\x05\x12\x15\n\rstrengthen_lv\x18\x03 \x01(\x05\x12\x14\n\x0c\x61wakening_lv\x18\x04 \x01(\x05\x12\x0f\n\x07hero_no\x18\x05 \x01(\x05\x12/\n\x03set\x18\x06 \x01(\x0b\x32\".proto_file.equipment.SetEquipment\"0\n\x14GetEquipmentsRequest\x12\x0c\n\x04type\x18\x01 \x02(\x05\x12\n\n\x02id\x18\x02 \x01(\t\"h\n\x14GetEquipmentResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x32\n\tequipment\x18\x02 \x03(\x0b\x32\x1f.proto_file.equipment.Equipment')




_SETEQUIPMENT = _descriptor.Descriptor(
  name='SetEquipment',
  full_name='proto_file.equipment.SetEquipment',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='no', full_name='proto_file.equipment.SetEquipment.no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='num', full_name='proto_file.equipment.SetEquipment.num', index=1,
      number=2, type=5, cpp_type=1, label=1,
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
  serialized_start=55,
  serialized_end=94,
)


_EQUIPMENT = _descriptor.Descriptor(
  name='Equipment',
  full_name='proto_file.equipment.Equipment',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='id', full_name='proto_file.equipment.Equipment.id', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='no', full_name='proto_file.equipment.Equipment.no', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='strengthen_lv', full_name='proto_file.equipment.Equipment.strengthen_lv', index=2,
      number=3, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='awakening_lv', full_name='proto_file.equipment.Equipment.awakening_lv', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='proto_file.equipment.Equipment.hero_no', index=4,
      number=5, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='set', full_name='proto_file.equipment.Equipment.set', index=5,
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
  serialized_start=97,
  serialized_end=243,
)


_GETEQUIPMENTSREQUEST = _descriptor.Descriptor(
  name='GetEquipmentsRequest',
  full_name='proto_file.equipment.GetEquipmentsRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='type', full_name='proto_file.equipment.GetEquipmentsRequest.type', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='proto_file.equipment.GetEquipmentsRequest.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
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
  serialized_start=245,
  serialized_end=293,
)


_GETEQUIPMENTRESPONSE = _descriptor.Descriptor(
  name='GetEquipmentResponse',
  full_name='proto_file.equipment.GetEquipmentResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='proto_file.equipment.GetEquipmentResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equipment', full_name='proto_file.equipment.GetEquipmentResponse.equipment', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
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
  serialized_start=295,
  serialized_end=399,
)

_EQUIPMENT.fields_by_name['set'].message_type = _SETEQUIPMENT
_GETEQUIPMENTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_GETEQUIPMENTRESPONSE.fields_by_name['equipment'].message_type = _EQUIPMENT
DESCRIPTOR.message_types_by_name['SetEquipment'] = _SETEQUIPMENT
DESCRIPTOR.message_types_by_name['Equipment'] = _EQUIPMENT
DESCRIPTOR.message_types_by_name['GetEquipmentsRequest'] = _GETEQUIPMENTSREQUEST
DESCRIPTOR.message_types_by_name['GetEquipmentResponse'] = _GETEQUIPMENTRESPONSE

class SetEquipment(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _SETEQUIPMENT

  # @@protoc_insertion_point(class_scope:proto_file.equipment.SetEquipment)

class Equipment(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _EQUIPMENT

  # @@protoc_insertion_point(class_scope:proto_file.equipment.Equipment)

class GetEquipmentsRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETEQUIPMENTSREQUEST

  # @@protoc_insertion_point(class_scope:proto_file.equipment.GetEquipmentsRequest)

class GetEquipmentResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETEQUIPMENTRESPONSE

  # @@protoc_insertion_point(class_scope:proto_file.equipment.GetEquipmentResponse)


# @@protoc_insertion_point(module_scope)
