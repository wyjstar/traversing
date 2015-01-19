# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: line_up.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2
import hero_pb2
import equipment_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='line_up.proto',
  package='',
  serialized_pb='\n\rline_up.proto\x1a\x0c\x63ommon.proto\x1a\nhero.proto\x1a\x0f\x65quipment.proto\"6\n\rSlotEquipment\x12\n\n\x02no\x18\x01 \x02(\x05\x12\x19\n\x03\x65qu\x18\x02 \x01(\x0b\x32\x0c.EquipmentPB\"f\n\nLineUpSlot\x12\x0f\n\x07slot_no\x18\x01 \x02(\x05\x12\x12\n\nactivation\x18\x02 \x01(\x08\x12\x15\n\x04hero\x18\x03 \x01(\x0b\x32\x07.HeroPB\x12\x1c\n\x04\x65qus\x18\x04 \x03(\x0b\x32\x0e.SlotEquipment\".\n\x05Unpar\x12\x10\n\x08unpar_id\x18\x01 \x02(\x05\x12\x13\n\x0bunpar_level\x18\x02 \x02(\x05\"\x8a\x01\n\x0eLineUpResponse\x12\x19\n\x04slot\x18\x01 \x03(\x0b\x32\x0b.LineUpSlot\x12\x18\n\x03sub\x18\x02 \x03(\x0b\x32\x0b.LineUpSlot\x12\x16\n\x06unpars\x18\x03 \x03(\x0b\x32\x06.Unpar\x12\x1c\n\x03res\x18\x04 \x01(\x0b\x32\x0f.CommonResponse\x12\r\n\x05order\x18\x05 \x03(\x05\";\n\x12LineUpUnparUpgrade\x12\x10\n\x08skill_id\x18\x01 \x02(\x05\x12\x13\n\x0bskill_level\x18\x02 \x02(\x05\"L\n\x17\x43hangeEquipmentsRequest\x12\x0f\n\x07slot_no\x18\x01 \x02(\x05\x12\n\n\x02no\x18\x02 \x01(\x05\x12\x14\n\x0c\x65quipment_id\x18\x03 \x01(\t\"F\n\x1c\x43hangeMultiEquipmentsRequest\x12&\n\x04\x65qus\x18\x01 \x03(\x0b\x32\x18.ChangeEquipmentsRequest\"J\n\x11\x43hangeHeroRequest\x12\x0f\n\x07slot_no\x18\x01 \x02(\x05\x12\x13\n\x0b\x63hange_type\x18\x02 \x01(\x05\x12\x0f\n\x07hero_no\x18\x03 \x01(\x05\"%\n\x10GetLineUpRequest\x12\x11\n\ttarget_id\x18\x01 \x02(\x05')




_SLOTEQUIPMENT = _descriptor.Descriptor(
  name='SlotEquipment',
  full_name='SlotEquipment',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='no', full_name='SlotEquipment.no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equ', full_name='SlotEquipment.equ', index=1,
      number=2, type=11, cpp_type=10, label=1,
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
  serialized_start=60,
  serialized_end=114,
)


_LINEUPSLOT = _descriptor.Descriptor(
  name='LineUpSlot',
  full_name='LineUpSlot',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='slot_no', full_name='LineUpSlot.slot_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='activation', full_name='LineUpSlot.activation', index=1,
      number=2, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero', full_name='LineUpSlot.hero', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equs', full_name='LineUpSlot.equs', index=3,
      number=4, type=11, cpp_type=10, label=3,
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
  serialized_start=116,
  serialized_end=218,
)


_UNPAR = _descriptor.Descriptor(
  name='Unpar',
  full_name='Unpar',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='unpar_id', full_name='Unpar.unpar_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='unpar_level', full_name='Unpar.unpar_level', index=1,
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
  serialized_start=220,
  serialized_end=266,
)


_LINEUPRESPONSE = _descriptor.Descriptor(
  name='LineUpResponse',
  full_name='LineUpResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='slot', full_name='LineUpResponse.slot', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='sub', full_name='LineUpResponse.sub', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='unpars', full_name='LineUpResponse.unpars', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='res', full_name='LineUpResponse.res', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='order', full_name='LineUpResponse.order', index=4,
      number=5, type=5, cpp_type=1, label=3,
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
  serialized_start=269,
  serialized_end=407,
)


_LINEUPUNPARUPGRADE = _descriptor.Descriptor(
  name='LineUpUnparUpgrade',
  full_name='LineUpUnparUpgrade',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='skill_id', full_name='LineUpUnparUpgrade.skill_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skill_level', full_name='LineUpUnparUpgrade.skill_level', index=1,
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
  serialized_start=409,
  serialized_end=468,
)


_CHANGEEQUIPMENTSREQUEST = _descriptor.Descriptor(
  name='ChangeEquipmentsRequest',
  full_name='ChangeEquipmentsRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='slot_no', full_name='ChangeEquipmentsRequest.slot_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='no', full_name='ChangeEquipmentsRequest.no', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='equipment_id', full_name='ChangeEquipmentsRequest.equipment_id', index=2,
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
  serialized_start=470,
  serialized_end=546,
)


_CHANGEMULTIEQUIPMENTSREQUEST = _descriptor.Descriptor(
  name='ChangeMultiEquipmentsRequest',
  full_name='ChangeMultiEquipmentsRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='equs', full_name='ChangeMultiEquipmentsRequest.equs', index=0,
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
  serialized_start=548,
  serialized_end=618,
)


_CHANGEHEROREQUEST = _descriptor.Descriptor(
  name='ChangeHeroRequest',
  full_name='ChangeHeroRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='slot_no', full_name='ChangeHeroRequest.slot_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='change_type', full_name='ChangeHeroRequest.change_type', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='ChangeHeroRequest.hero_no', index=2,
      number=3, type=5, cpp_type=1, label=1,
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
  serialized_start=620,
  serialized_end=694,
)


_GETLINEUPREQUEST = _descriptor.Descriptor(
  name='GetLineUpRequest',
  full_name='GetLineUpRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='target_id', full_name='GetLineUpRequest.target_id', index=0,
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
  serialized_start=696,
  serialized_end=733,
)

_SLOTEQUIPMENT.fields_by_name['equ'].message_type = equipment_pb2._EQUIPMENTPB
_LINEUPSLOT.fields_by_name['hero'].message_type = hero_pb2._HEROPB
_LINEUPSLOT.fields_by_name['equs'].message_type = _SLOTEQUIPMENT
_LINEUPRESPONSE.fields_by_name['slot'].message_type = _LINEUPSLOT
_LINEUPRESPONSE.fields_by_name['sub'].message_type = _LINEUPSLOT
_LINEUPRESPONSE.fields_by_name['unpars'].message_type = _UNPAR
_LINEUPRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_CHANGEMULTIEQUIPMENTSREQUEST.fields_by_name['equs'].message_type = _CHANGEEQUIPMENTSREQUEST
DESCRIPTOR.message_types_by_name['SlotEquipment'] = _SLOTEQUIPMENT
DESCRIPTOR.message_types_by_name['LineUpSlot'] = _LINEUPSLOT
DESCRIPTOR.message_types_by_name['Unpar'] = _UNPAR
DESCRIPTOR.message_types_by_name['LineUpResponse'] = _LINEUPRESPONSE
DESCRIPTOR.message_types_by_name['LineUpUnparUpgrade'] = _LINEUPUNPARUPGRADE
DESCRIPTOR.message_types_by_name['ChangeEquipmentsRequest'] = _CHANGEEQUIPMENTSREQUEST
DESCRIPTOR.message_types_by_name['ChangeMultiEquipmentsRequest'] = _CHANGEMULTIEQUIPMENTSREQUEST
DESCRIPTOR.message_types_by_name['ChangeHeroRequest'] = _CHANGEHEROREQUEST
DESCRIPTOR.message_types_by_name['GetLineUpRequest'] = _GETLINEUPREQUEST

class SlotEquipment(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _SLOTEQUIPMENT

  # @@protoc_insertion_point(class_scope:SlotEquipment)

class LineUpSlot(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _LINEUPSLOT

  # @@protoc_insertion_point(class_scope:LineUpSlot)

class Unpar(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _UNPAR

  # @@protoc_insertion_point(class_scope:Unpar)

class LineUpResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _LINEUPRESPONSE

  # @@protoc_insertion_point(class_scope:LineUpResponse)

class LineUpUnparUpgrade(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _LINEUPUNPARUPGRADE

  # @@protoc_insertion_point(class_scope:LineUpUnparUpgrade)

class ChangeEquipmentsRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CHANGEEQUIPMENTSREQUEST

  # @@protoc_insertion_point(class_scope:ChangeEquipmentsRequest)

class ChangeMultiEquipmentsRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CHANGEMULTIEQUIPMENTSREQUEST

  # @@protoc_insertion_point(class_scope:ChangeMultiEquipmentsRequest)

class ChangeHeroRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CHANGEHEROREQUEST

  # @@protoc_insertion_point(class_scope:ChangeHeroRequest)

class GetLineUpRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETLINEUPREQUEST

  # @@protoc_insertion_point(class_scope:GetLineUpRequest)


# @@protoc_insertion_point(module_scope)
