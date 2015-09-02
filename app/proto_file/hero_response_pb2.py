# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: hero_response.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2
import hero_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='hero_response.proto',
  package='',
  serialized_pb='\n\x13hero_response.proto\x1a\x0c\x63ommon.proto\x1a\nhero.proto\"*\n\x10GetHerosResponse\x12\x16\n\x05heros\x18\x01 \x03(\x0b\x32\x07.HeroPB\"O\n\x13HeroUpgradeResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\r\n\x05level\x18\x02 \x01(\x05\x12\x0b\n\x03\x65xp\x18\x03 \x01(\x05\"o\n\x11HeroBreakResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\'\n\x07\x63onsume\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\x12\x13\n\x0b\x62reak_level\x18\x03 \x01(\x05\"[\n\x15HeroSacrificeResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\"J\n\x13HeroComposeResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x15\n\x04hero\x18\x02 \x01(\x0b\x32\x07.HeroPB\"V\n\x10HeroSellResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\"[\n\x12HeroRefineResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\'\n\x07\x63onsume\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse')




_GETHEROSRESPONSE = _descriptor.Descriptor(
  name='GetHerosResponse',
  full_name='GetHerosResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='heros', full_name='GetHerosResponse.heros', index=0,
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
  serialized_start=49,
  serialized_end=91,
)


_HEROUPGRADERESPONSE = _descriptor.Descriptor(
  name='HeroUpgradeResponse',
  full_name='HeroUpgradeResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroUpgradeResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='level', full_name='HeroUpgradeResponse.level', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='exp', full_name='HeroUpgradeResponse.exp', index=2,
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
  serialized_start=93,
  serialized_end=172,
)


_HEROBREAKRESPONSE = _descriptor.Descriptor(
  name='HeroBreakResponse',
  full_name='HeroBreakResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroBreakResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='consume', full_name='HeroBreakResponse.consume', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='break_level', full_name='HeroBreakResponse.break_level', index=2,
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
  serialized_start=174,
  serialized_end=285,
)


_HEROSACRIFICERESPONSE = _descriptor.Descriptor(
  name='HeroSacrificeResponse',
  full_name='HeroSacrificeResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroSacrificeResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='HeroSacrificeResponse.gain', index=1,
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
  serialized_start=287,
  serialized_end=378,
)


_HEROCOMPOSERESPONSE = _descriptor.Descriptor(
  name='HeroComposeResponse',
  full_name='HeroComposeResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroComposeResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero', full_name='HeroComposeResponse.hero', index=1,
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
  serialized_start=380,
  serialized_end=454,
)


_HEROSELLRESPONSE = _descriptor.Descriptor(
  name='HeroSellResponse',
  full_name='HeroSellResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroSellResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='HeroSellResponse.gain', index=1,
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
  serialized_start=456,
  serialized_end=542,
)


_HEROREFINERESPONSE = _descriptor.Descriptor(
  name='HeroRefineResponse',
  full_name='HeroRefineResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='HeroRefineResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='consume', full_name='HeroRefineResponse.consume', index=1,
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
  serialized_start=544,
  serialized_end=635,
)

_GETHEROSRESPONSE.fields_by_name['heros'].message_type = hero_pb2._HEROPB
_HEROUPGRADERESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROBREAKRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROBREAKRESPONSE.fields_by_name['consume'].message_type = common_pb2._GAMERESOURCESRESPONSE
_HEROSACRIFICERESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROSACRIFICERESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
_HEROCOMPOSERESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROCOMPOSERESPONSE.fields_by_name['hero'].message_type = hero_pb2._HEROPB
_HEROSELLRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROSELLRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
_HEROREFINERESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_HEROREFINERESPONSE.fields_by_name['consume'].message_type = common_pb2._GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['GetHerosResponse'] = _GETHEROSRESPONSE
DESCRIPTOR.message_types_by_name['HeroUpgradeResponse'] = _HEROUPGRADERESPONSE
DESCRIPTOR.message_types_by_name['HeroBreakResponse'] = _HEROBREAKRESPONSE
DESCRIPTOR.message_types_by_name['HeroSacrificeResponse'] = _HEROSACRIFICERESPONSE
DESCRIPTOR.message_types_by_name['HeroComposeResponse'] = _HEROCOMPOSERESPONSE
DESCRIPTOR.message_types_by_name['HeroSellResponse'] = _HEROSELLRESPONSE
DESCRIPTOR.message_types_by_name['HeroRefineResponse'] = _HEROREFINERESPONSE

class GetHerosResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETHEROSRESPONSE

  # @@protoc_insertion_point(class_scope:GetHerosResponse)

class HeroUpgradeResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROUPGRADERESPONSE

  # @@protoc_insertion_point(class_scope:HeroUpgradeResponse)

class HeroBreakResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROBREAKRESPONSE

  # @@protoc_insertion_point(class_scope:HeroBreakResponse)

class HeroSacrificeResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROSACRIFICERESPONSE

  # @@protoc_insertion_point(class_scope:HeroSacrificeResponse)

class HeroComposeResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROCOMPOSERESPONSE

  # @@protoc_insertion_point(class_scope:HeroComposeResponse)

class HeroSellResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROSELLRESPONSE

  # @@protoc_insertion_point(class_scope:HeroSellResponse)

class HeroRefineResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _HEROREFINERESPONSE

  # @@protoc_insertion_point(class_scope:HeroRefineResponse)


# @@protoc_insertion_point(module_scope)
