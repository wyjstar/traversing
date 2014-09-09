# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: login_gift.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)




DESCRIPTOR = _descriptor.FileDescriptor(
  name='login_gift.proto',
  package='',
  serialized_pb='\n\x10login_gift.proto\"0\n\tLoginInfo\x12\x11\n\tlogin_day\x18\x01 \x02(\x05\x12\x10\n\x08is_new_p\x18\x02 \x02(\x05\"\x99\x01\n\x15InitLoginGiftResponse\x12\x1b\n\x13\x63umulative_received\x18\x01 \x03(\x05\x12\x1b\n\x13\x63ontinuous_received\x18\x02 \x03(\x05\x12\"\n\x0e\x63umulative_day\x18\x03 \x02(\x0b\x32\n.LoginInfo\x12\"\n\x0e\x63ontinuous_day\x18\x04 \x02(\x0b\x32\n.LoginInfo\"A\n\x13GetLoginGiftRequest\x12\x13\n\x0b\x61\x63tivity_id\x18\x01 \x02(\x05\x12\x15\n\ractivity_type\x18\x02 \x02(\x05')




_LOGININFO = _descriptor.Descriptor(
  name='LoginInfo',
  full_name='LoginInfo',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='login_day', full_name='LoginInfo.login_day', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='is_new_p', full_name='LoginInfo.is_new_p', index=1,
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
  serialized_start=20,
  serialized_end=68,
)


_INITLOGINGIFTRESPONSE = _descriptor.Descriptor(
  name='InitLoginGiftResponse',
  full_name='InitLoginGiftResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='cumulative_received', full_name='InitLoginGiftResponse.cumulative_received', index=0,
      number=1, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='continuous_received', full_name='InitLoginGiftResponse.continuous_received', index=1,
      number=2, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='cumulative_day', full_name='InitLoginGiftResponse.cumulative_day', index=2,
      number=3, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='continuous_day', full_name='InitLoginGiftResponse.continuous_day', index=3,
      number=4, type=11, cpp_type=10, label=2,
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
  serialized_start=71,
  serialized_end=224,
)


_GETLOGINGIFTREQUEST = _descriptor.Descriptor(
  name='GetLoginGiftRequest',
  full_name='GetLoginGiftRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='activity_id', full_name='GetLoginGiftRequest.activity_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='activity_type', full_name='GetLoginGiftRequest.activity_type', index=1,
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
  serialized_start=226,
  serialized_end=291,
)

_INITLOGINGIFTRESPONSE.fields_by_name['cumulative_day'].message_type = _LOGININFO
_INITLOGINGIFTRESPONSE.fields_by_name['continuous_day'].message_type = _LOGININFO
DESCRIPTOR.message_types_by_name['LoginInfo'] = _LOGININFO
DESCRIPTOR.message_types_by_name['InitLoginGiftResponse'] = _INITLOGINGIFTRESPONSE
DESCRIPTOR.message_types_by_name['GetLoginGiftRequest'] = _GETLOGINGIFTREQUEST

class LoginInfo(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _LOGININFO

  # @@protoc_insertion_point(class_scope:LoginInfo)

class InitLoginGiftResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _INITLOGINGIFTRESPONSE

  # @@protoc_insertion_point(class_scope:InitLoginGiftResponse)

class GetLoginGiftRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETLOGINGIFTREQUEST

  # @@protoc_insertion_point(class_scope:GetLoginGiftRequest)


# @@protoc_insertion_point(module_scope)
