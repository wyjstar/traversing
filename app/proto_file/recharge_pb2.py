# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: recharge.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='recharge.proto',
  package='',
  serialized_pb='\n\x0erecharge.proto\x1a\x0c\x63ommon.proto\"\x0e\n\x0cInitRecharge\"X\n\x0cRechargeData\x12\x15\n\rrecharge_time\x18\x01 \x01(\x02\x12\x1d\n\x15recharge_accumulation\x18\x02 \x01(\x02\x12\x12\n\nis_receive\x18\x03 \x01(\x05\"O\n\x0cRechargeItem\x12\x0f\n\x07gift_id\x18\x01 \x02(\x05\x12\x11\n\tgift_type\x18\x02 \x01(\x05\x12\x1b\n\x04\x64\x61ta\x18\x03 \x03(\x0b\x32\r.RechargeData\"D\n\x1bGetRechargeGiftDataResponse\x12%\n\x0erecharge_items\x18\x01 \x03(\x0b\x32\r.RechargeItem\"5\n\x16GetRechargeGiftRequest\x12\x1b\n\x04gift\x18\x01 \x03(\x0b\x32\r.RechargeItem\"]\n\x17GetRechargeGiftResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse')




_INITRECHARGE = _descriptor.Descriptor(
  name='InitRecharge',
  full_name='InitRecharge',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
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
  serialized_end=46,
)


_RECHARGEDATA = _descriptor.Descriptor(
  name='RechargeData',
  full_name='RechargeData',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='recharge_time', full_name='RechargeData.recharge_time', index=0,
      number=1, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='recharge_accumulation', full_name='RechargeData.recharge_accumulation', index=1,
      number=2, type=2, cpp_type=6, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='is_receive', full_name='RechargeData.is_receive', index=2,
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
  serialized_start=48,
  serialized_end=136,
)


_RECHARGEITEM = _descriptor.Descriptor(
  name='RechargeItem',
  full_name='RechargeItem',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='gift_id', full_name='RechargeItem.gift_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gift_type', full_name='RechargeItem.gift_type', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='data', full_name='RechargeItem.data', index=2,
      number=3, type=11, cpp_type=10, label=3,
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
  serialized_start=138,
  serialized_end=217,
)


_GETRECHARGEGIFTDATARESPONSE = _descriptor.Descriptor(
  name='GetRechargeGiftDataResponse',
  full_name='GetRechargeGiftDataResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='recharge_items', full_name='GetRechargeGiftDataResponse.recharge_items', index=0,
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
  serialized_start=219,
  serialized_end=287,
)


_GETRECHARGEGIFTREQUEST = _descriptor.Descriptor(
  name='GetRechargeGiftRequest',
  full_name='GetRechargeGiftRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='gift', full_name='GetRechargeGiftRequest.gift', index=0,
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
  serialized_start=289,
  serialized_end=342,
)


_GETRECHARGEGIFTRESPONSE = _descriptor.Descriptor(
  name='GetRechargeGiftResponse',
  full_name='GetRechargeGiftResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='GetRechargeGiftResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='GetRechargeGiftResponse.gain', index=1,
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
  serialized_start=344,
  serialized_end=437,
)

_RECHARGEITEM.fields_by_name['data'].message_type = _RECHARGEDATA
_GETRECHARGEGIFTDATARESPONSE.fields_by_name['recharge_items'].message_type = _RECHARGEITEM
_GETRECHARGEGIFTREQUEST.fields_by_name['gift'].message_type = _RECHARGEITEM
_GETRECHARGEGIFTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_GETRECHARGEGIFTRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['InitRecharge'] = _INITRECHARGE
DESCRIPTOR.message_types_by_name['RechargeData'] = _RECHARGEDATA
DESCRIPTOR.message_types_by_name['RechargeItem'] = _RECHARGEITEM
DESCRIPTOR.message_types_by_name['GetRechargeGiftDataResponse'] = _GETRECHARGEGIFTDATARESPONSE
DESCRIPTOR.message_types_by_name['GetRechargeGiftRequest'] = _GETRECHARGEGIFTREQUEST
DESCRIPTOR.message_types_by_name['GetRechargeGiftResponse'] = _GETRECHARGEGIFTRESPONSE

class InitRecharge(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _INITRECHARGE

  # @@protoc_insertion_point(class_scope:InitRecharge)

class RechargeData(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RECHARGEDATA

  # @@protoc_insertion_point(class_scope:RechargeData)

class RechargeItem(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RECHARGEITEM

  # @@protoc_insertion_point(class_scope:RechargeItem)

class GetRechargeGiftDataResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETRECHARGEGIFTDATARESPONSE

  # @@protoc_insertion_point(class_scope:GetRechargeGiftDataResponse)

class GetRechargeGiftRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETRECHARGEGIFTREQUEST

  # @@protoc_insertion_point(class_scope:GetRechargeGiftRequest)

class GetRechargeGiftResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETRECHARGEGIFTRESPONSE

  # @@protoc_insertion_point(class_scope:GetRechargeGiftResponse)


# @@protoc_insertion_point(module_scope)
