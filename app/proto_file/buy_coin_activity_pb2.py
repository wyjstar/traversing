# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: buy_coin_activity.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='buy_coin_activity.proto',
  package='',
  serialized_pb='\n\x17\x62uy_coin_activity.proto\x1a\x0c\x63ommon.proto\"H\n\x16GetBuyCoinInfoResponse\x12\x11\n\tbuy_times\x18\x01 \x02(\x05\x12\x1b\n\x13\x65xtra_can_buy_times\x18\x02 \x02(\x05\"/\n\x0f\x42uyCoinResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse')




_GETBUYCOININFORESPONSE = _descriptor.Descriptor(
  name='GetBuyCoinInfoResponse',
  full_name='GetBuyCoinInfoResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='buy_times', full_name='GetBuyCoinInfoResponse.buy_times', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='extra_can_buy_times', full_name='GetBuyCoinInfoResponse.extra_can_buy_times', index=1,
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
  serialized_start=41,
  serialized_end=113,
)


_BUYCOINRESPONSE = _descriptor.Descriptor(
  name='BuyCoinResponse',
  full_name='BuyCoinResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='BuyCoinResponse.res', index=0,
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
  serialized_start=115,
  serialized_end=162,
)

_BUYCOINRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
DESCRIPTOR.message_types_by_name['GetBuyCoinInfoResponse'] = _GETBUYCOININFORESPONSE
DESCRIPTOR.message_types_by_name['BuyCoinResponse'] = _BUYCOINRESPONSE

class GetBuyCoinInfoResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETBUYCOININFORESPONSE

  # @@protoc_insertion_point(class_scope:GetBuyCoinInfoResponse)

class BuyCoinResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BUYCOINRESPONSE

  # @@protoc_insertion_point(class_scope:BuyCoinResponse)


# @@protoc_insertion_point(module_scope)