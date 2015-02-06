# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: sign_in.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='sign_in.proto',
  package='',
  serialized_pb='\n\rsign_in.proto\x1a\x0c\x63ommon.proto\"\x8a\x01\n\x11GetSignInResponse\x12\x0c\n\x04\x64\x61ys\x18\x01 \x03(\x05\x12\x12\n\nsign_round\x18\x02 \x02(\x05\x12\x13\n\x0b\x63urrent_day\x18\x05 \x02(\x05\x12 \n\x18\x63ontinuous_sign_in_prize\x18\x03 \x03(\x05\x12\x1c\n\x14repair_sign_in_times\x18\x04 \x02(\x05\"\"\n\x13RepairSignInRequest\x12\x0b\n\x03\x64\x61y\x18\x01 \x02(\x05\"T\n\x0eSignInResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\"/\n\x17\x43ontinuousSignInRequest\x12\x14\n\x0csign_in_days\x18\x01 \x02(\x05\"^\n\x18\x43ontinuousSignInResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse')




_GETSIGNINRESPONSE = _descriptor.Descriptor(
  name='GetSignInResponse',
  full_name='GetSignInResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='days', full_name='GetSignInResponse.days', index=0,
      number=1, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='sign_round', full_name='GetSignInResponse.sign_round', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='current_day', full_name='GetSignInResponse.current_day', index=2,
      number=5, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='continuous_sign_in_prize', full_name='GetSignInResponse.continuous_sign_in_prize', index=3,
      number=3, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='repair_sign_in_times', full_name='GetSignInResponse.repair_sign_in_times', index=4,
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
  serialized_start=32,
  serialized_end=170,
)


_REPAIRSIGNINREQUEST = _descriptor.Descriptor(
  name='RepairSignInRequest',
  full_name='RepairSignInRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='day', full_name='RepairSignInRequest.day', index=0,
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
  serialized_start=172,
  serialized_end=206,
)


_SIGNINRESPONSE = _descriptor.Descriptor(
  name='SignInResponse',
  full_name='SignInResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='SignInResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='SignInResponse.gain', index=1,
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
  serialized_start=208,
  serialized_end=292,
)


_CONTINUOUSSIGNINREQUEST = _descriptor.Descriptor(
  name='ContinuousSignInRequest',
  full_name='ContinuousSignInRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='sign_in_days', full_name='ContinuousSignInRequest.sign_in_days', index=0,
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
  serialized_start=294,
  serialized_end=341,
)


_CONTINUOUSSIGNINRESPONSE = _descriptor.Descriptor(
  name='ContinuousSignInResponse',
  full_name='ContinuousSignInResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='ContinuousSignInResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='ContinuousSignInResponse.gain', index=1,
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
  serialized_start=343,
  serialized_end=437,
)

_SIGNINRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_SIGNINRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
_CONTINUOUSSIGNINRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_CONTINUOUSSIGNINRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['GetSignInResponse'] = _GETSIGNINRESPONSE
DESCRIPTOR.message_types_by_name['RepairSignInRequest'] = _REPAIRSIGNINREQUEST
DESCRIPTOR.message_types_by_name['SignInResponse'] = _SIGNINRESPONSE
DESCRIPTOR.message_types_by_name['ContinuousSignInRequest'] = _CONTINUOUSSIGNINREQUEST
DESCRIPTOR.message_types_by_name['ContinuousSignInResponse'] = _CONTINUOUSSIGNINRESPONSE

class GetSignInResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETSIGNINRESPONSE

  # @@protoc_insertion_point(class_scope:GetSignInResponse)

class RepairSignInRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _REPAIRSIGNINREQUEST

  # @@protoc_insertion_point(class_scope:RepairSignInRequest)

class SignInResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _SIGNINRESPONSE

  # @@protoc_insertion_point(class_scope:SignInResponse)

class ContinuousSignInRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CONTINUOUSSIGNINREQUEST

  # @@protoc_insertion_point(class_scope:ContinuousSignInRequest)

class ContinuousSignInResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CONTINUOUSSIGNINRESPONSE

  # @@protoc_insertion_point(class_scope:ContinuousSignInResponse)


# @@protoc_insertion_point(module_scope)
