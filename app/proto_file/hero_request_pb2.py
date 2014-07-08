# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: hero_request.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)




DESCRIPTOR = _descriptor.FileDescriptor(
  name='hero_request.proto',
  package='app.gate',
  serialized_pb='\n\x12hero_request.proto\x12\x08\x61pp.gate\"2\n\rCommonRequest\x12\x10\n\x08playerid\x18\x01 \x02(\x03\x12\x0f\n\x07message\x18\x02 \x01(\t\"<\n\x12HeroUpgradeRequest\x12\x14\n\x0chero_no_list\x18\x01 \x03(\x05\x12\x10\n\x08\x65xp_list\x18\x02 \x03(\x05\"X\n\x1aHeroUpgradeWithItemRequest\x12\x0f\n\x07hero_no\x18\x01 \x02(\x05\x12\x13\n\x0b\x65xp_item_no\x18\x02 \x02(\x05\x12\x14\n\x0c\x65xp_item_num\x18\x03 \x02(\x05\"*\n\x12HeroComposeRequest\x12\x14\n\x0chero_chip_no\x18\x02 \x02(\x05\"#\n\x10HeroBreakRequest\x12\x0f\n\x07hero_no\x18\x01 \x02(\x05\",\n\x14HeroSacrificeRequest\x12\x14\n\x0chero_no_list\x18\x01 \x03(\x05')




_COMMONREQUEST = _descriptor.Descriptor(
  name='CommonRequest',
  full_name='app.gate.CommonRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='playerid', full_name='app.gate.CommonRequest.playerid', index=0,
      number=1, type=3, cpp_type=2, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='message', full_name='app.gate.CommonRequest.message', index=1,
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
  serialized_start=32,
  serialized_end=82,
)


_HEROUPGRADEREQUEST = _descriptor.Descriptor(
  name='HeroUpgradeRequest',
  full_name='app.gate.HeroUpgradeRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no_list', full_name='app.gate.HeroUpgradeRequest.hero_no_list', index=0,
      number=1, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp_list', full_name='app.gate.HeroUpgradeRequest.exp_list', index=1,
      number=2, type=5, cpp_type=1, label=3,
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
  serialized_start=84,
  serialized_end=144,
)


_HEROUPGRADEWITHITEMREQUEST = _descriptor.Descriptor(
  name='HeroUpgradeWithItemRequest',
  full_name='app.gate.HeroUpgradeWithItemRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='app.gate.HeroUpgradeWithItemRequest.hero_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp_item_no', full_name='app.gate.HeroUpgradeWithItemRequest.exp_item_no', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp_item_num', full_name='app.gate.HeroUpgradeWithItemRequest.exp_item_num', index=2,
      number=3, type=5, cpp_type=1, label=2,
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
  serialized_start=146,
  serialized_end=234,
)


_HEROCOMPOSEREQUEST = _descriptor.Descriptor(
  name='HeroComposeRequest',
  full_name='app.gate.HeroComposeRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_chip_no', full_name='app.gate.HeroComposeRequest.hero_chip_no', index=0,
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
  serialized_start=236,
  serialized_end=278,
)


_HEROBREAKREQUEST = _descriptor.Descriptor(
  name='HeroBreakRequest',
  full_name='app.gate.HeroBreakRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='app.gate.HeroBreakRequest.hero_no', index=0,
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
  serialized_start=280,
  serialized_end=315,
)


_HEROSACRIFICEREQUEST = _descriptor.Descriptor(
  name='HeroSacrificeRequest',
  full_name='app.gate.HeroSacrificeRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no_list', full_name='app.gate.HeroSacrificeRequest.hero_no_list', index=0,
      number=1, type=5, cpp_type=1, label=3,
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
  serialized_start=317,
  serialized_end=361,
)

DESCRIPTOR.message_types_by_name['CommonRequest'] = _COMMONREQUEST
DESCRIPTOR.message_types_by_name['HeroUpgradeRequest'] = _HEROUPGRADEREQUEST
DESCRIPTOR.message_types_by_name['HeroUpgradeWithItemRequest'] = _HEROUPGRADEWITHITEMREQUEST
DESCRIPTOR.message_types_by_name['HeroComposeRequest'] = _HEROCOMPOSEREQUEST
DESCRIPTOR.message_types_by_name['HeroBreakRequest'] = _HEROBREAKREQUEST
DESCRIPTOR.message_types_by_name['HeroSacrificeRequest'] = _HEROSACRIFICEREQUEST

class CommonRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _COMMONREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.CommonRequest)

class HeroUpgradeRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROUPGRADEREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.HeroUpgradeRequest)

class HeroUpgradeWithItemRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROUPGRADEWITHITEMREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.HeroUpgradeWithItemRequest)

class HeroComposeRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROCOMPOSEREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.HeroComposeRequest)

class HeroBreakRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROBREAKREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.HeroBreakRequest)

class HeroSacrificeRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROSACRIFICEREQUEST

  # @@protoc_insertion_point(class_scope:app.gate.HeroSacrificeRequest)


# @@protoc_insertion_point(module_scope)