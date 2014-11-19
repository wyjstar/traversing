# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: hero_request.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)




DESCRIPTOR = _descriptor.FileDescriptor(
  name='hero_request.proto',
  package='',
  serialized_pb='\n\x12hero_request.proto\"X\n\x1aHeroUpgradeWithItemRequest\x12\x0f\n\x07hero_no\x18\x01 \x02(\x05\x12\x13\n\x0b\x65xp_item_no\x18\x02 \x02(\x05\x12\x14\n\x0c\x65xp_item_num\x18\x03 \x02(\x05\"#\n\x10HeroBreakRequest\x12\x0f\n\x07hero_no\x18\x01 \x02(\x05\"(\n\x14HeroSacrificeRequest\x12\x10\n\x08hero_nos\x18\x01 \x03(\x05\"*\n\x12HeroComposeRequest\x12\x14\n\x0chero_chip_no\x18\x01 \x02(\x05\"#\n\x0fHeroSellRequest\x12\x10\n\x08hero_nos\x18\x01 \x03(\x05\"4\n\x11HeroRefineRequest\x12\x0f\n\x07hero_no\x18\x01 \x02(\x05\x12\x0e\n\x06refine\x18\x02 \x02(\x05')




_HEROUPGRADEWITHITEMREQUEST = _descriptor.Descriptor(
  name='HeroUpgradeWithItemRequest',
  full_name='HeroUpgradeWithItemRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='HeroUpgradeWithItemRequest.hero_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp_item_no', full_name='HeroUpgradeWithItemRequest.exp_item_no', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp_item_num', full_name='HeroUpgradeWithItemRequest.exp_item_num', index=2,
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
  serialized_start=22,
  serialized_end=110,
)


_HEROBREAKREQUEST = _descriptor.Descriptor(
  name='HeroBreakRequest',
  full_name='HeroBreakRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='HeroBreakRequest.hero_no', index=0,
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
  serialized_start=112,
  serialized_end=147,
)


_HEROSACRIFICEREQUEST = _descriptor.Descriptor(
  name='HeroSacrificeRequest',
  full_name='HeroSacrificeRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_nos', full_name='HeroSacrificeRequest.hero_nos', index=0,
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
  serialized_start=149,
  serialized_end=189,
)


_HEROCOMPOSEREQUEST = _descriptor.Descriptor(
  name='HeroComposeRequest',
  full_name='HeroComposeRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_chip_no', full_name='HeroComposeRequest.hero_chip_no', index=0,
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
  serialized_start=191,
  serialized_end=233,
)


_HEROSELLREQUEST = _descriptor.Descriptor(
  name='HeroSellRequest',
  full_name='HeroSellRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_nos', full_name='HeroSellRequest.hero_nos', index=0,
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
  serialized_start=235,
  serialized_end=270,
)


_HEROREFINEREQUEST = _descriptor.Descriptor(
  name='HeroRefineRequest',
  full_name='HeroRefineRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='hero_no', full_name='HeroRefineRequest.hero_no', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='refine', full_name='HeroRefineRequest.refine', index=1,
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
  serialized_start=272,
  serialized_end=324,
)

DESCRIPTOR.message_types_by_name['HeroUpgradeWithItemRequest'] = _HEROUPGRADEWITHITEMREQUEST
DESCRIPTOR.message_types_by_name['HeroBreakRequest'] = _HEROBREAKREQUEST
DESCRIPTOR.message_types_by_name['HeroSacrificeRequest'] = _HEROSACRIFICEREQUEST
DESCRIPTOR.message_types_by_name['HeroComposeRequest'] = _HEROCOMPOSEREQUEST
DESCRIPTOR.message_types_by_name['HeroSellRequest'] = _HEROSELLREQUEST
DESCRIPTOR.message_types_by_name['HeroRefineRequest'] = _HEROREFINEREQUEST

class HeroUpgradeWithItemRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROUPGRADEWITHITEMREQUEST

  # @@protoc_insertion_point(class_scope:HeroUpgradeWithItemRequest)

class HeroBreakRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROBREAKREQUEST

  # @@protoc_insertion_point(class_scope:HeroBreakRequest)

class HeroSacrificeRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROSACRIFICEREQUEST

  # @@protoc_insertion_point(class_scope:HeroSacrificeRequest)

class HeroComposeRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROCOMPOSEREQUEST

  # @@protoc_insertion_point(class_scope:HeroComposeRequest)

class HeroSellRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROSELLREQUEST

  # @@protoc_insertion_point(class_scope:HeroSellRequest)

class HeroRefineRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROREFINEREQUEST

  # @@protoc_insertion_point(class_scope:HeroRefineRequest)


# @@protoc_insertion_point(module_scope)
