# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: equipment_chip.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)




DESCRIPTOR = _descriptor.FileDescriptor(
  name='equipment_chip.proto',
  package='',
  serialized_pb='\n\x14\x65quipment_chip.proto\"H\n\x0f\x45quipmentChipPB\x12\x19\n\x11\x65quipment_chip_no\x18\x01 \x02(\x05\x12\x1a\n\x12\x65quipment_chip_num\x18\x02 \x02(\x05\"F\n\x19GetEquipmentChipsResponse\x12)\n\x0f\x65quipment_chips\x18\x01 \x03(\x0b\x32\x10.EquipmentChipPB')




_EQUIPMENTCHIPPB = _descriptor.Descriptor(
  name='EquipmentChipPB',
  full_name='EquipmentChipPB',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='equipment_chip_no', full_name='EquipmentChipPB.equipment_chip_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equipment_chip_num', full_name='EquipmentChipPB.equipment_chip_num', index=1,
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
  serialized_start=24,
  serialized_end=96,
)


_GETEQUIPMENTCHIPSRESPONSE = _descriptor.Descriptor(
  name='GetEquipmentChipsResponse',
  full_name='GetEquipmentChipsResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='equipment_chips', full_name='GetEquipmentChipsResponse.equipment_chips', index=0,
      number=1, type=11, cpp_type=10, label=3,
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
  serialized_start=98,
  serialized_end=168,
)

_GETEQUIPMENTCHIPSRESPONSE.fields_by_name['equipment_chips'].message_type = _EQUIPMENTCHIPPB
DESCRIPTOR.message_types_by_name['EquipmentChipPB'] = _EQUIPMENTCHIPPB
DESCRIPTOR.message_types_by_name['GetEquipmentChipsResponse'] = _GETEQUIPMENTCHIPSRESPONSE

class EquipmentChipPB(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _EQUIPMENTCHIPPB

  # @@protoc_insertion_point(class_scope:EquipmentChipPB)

class GetEquipmentChipsResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETEQUIPMENTCHIPSRESPONSE

  # @@protoc_insertion_point(class_scope:GetEquipmentChipsResponse)


# @@protoc_insertion_point(module_scope)
