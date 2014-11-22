# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: travel.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import common_pb2
import travel_item_pb2
import travel_shoes_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='travel.proto',
  package='',
  serialized_pb='\n\x0ctravel.proto\x1a\x0c\x63ommon.proto\x1a\x11travel_item.proto\x1a\x12travel_shoes.proto\"4\n\x07\x43hapter\x12\x17\n\x06travel\x18\x01 \x03(\x0b\x32\x07.Travel\x12\x10\n\x08stage_id\x18\x02 \x02(\x05\"O\n\x06Travel\x12\x10\n\x08\x65vent_id\x18\x01 \x02(\x05\x12%\n\x05\x64rops\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\x12\x0c\n\x04time\x18\x03 \x01(\x05\"V\n\x05Shoes\x12\r\n\x05shoe1\x18\x01 \x02(\x05\x12\r\n\x05shoe2\x18\x02 \x02(\x05\x12\r\n\x05shoe3\x18\x03 \x02(\x05\x12\x10\n\x08use_type\x18\x04 \x02(\x05\x12\x0e\n\x06use_no\x18\x05 \x02(\x05\"!\n\rTravelRequest\x12\x10\n\x08stage_id\x18\x01 \x02(\x05\"g\n\x0eTravelResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x10\n\x08\x65vent_id\x18\x02 \x01(\x05\x12%\n\x05\x64rops\x18\x03 \x01(\x0b\x32\x16.GameResourcesResponse\"\x8b\x01\n\x12TravelInitResponse\x12\x19\n\x07\x63hapter\x18\x01 \x03(\x0b\x32\x08.Chapter\x12\x15\n\x05shoes\x18\x02 \x02(\x0b\x32\x06.Shoes\x12\x12\n\nchest_time\x18\x03 \x02(\x05\x12/\n\x13travel_item_chapter\x18\x04 \x03(\x0b\x32\x12.TravelItemChapter\"G\n\x11TravelItemChapter\x12\x10\n\x08stage_id\x18\x01 \x02(\x05\x12 \n\x0btravel_item\x18\x02 \x03(\x0b\x32\x0b.TravelItem\"2\n\x0f\x42uyShoesRequest\x12\x1f\n\x0bshoes_infos\x18\x01 \x03(\x0b\x32\n.ShoesInfo\"0\n\x10\x42uyShoesResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\"I\n\x13TravelSettleRequest\x12\x10\n\x08stage_id\x18\x01 \x02(\x05\x12\x10\n\x08\x65vent_id\x18\x02 \x02(\x05\x12\x0e\n\x06\x61nswer\x18\x03 \x01(\x05\"4\n\x14TravelSettleResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\"7\n\x11\x45ventStartRequest\x12\x10\n\x08stage_id\x18\x01 \x02(\x05\x12\x10\n\x08\x65vent_id\x18\x02 \x02(\x05\"@\n\x12\x45ventStartResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x0c\n\x04time\x18\x02 \x01(\x05\"3\n\rNoWaitRequest\x12\x10\n\x08stage_id\x18\x01 \x02(\x05\x12\x10\n\x08\x65vent_id\x18\x02 \x02(\x05\"<\n\x0eNoWaitResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x0c\n\x04time\x18\x02 \x01(\x05\"X\n\x11OpenChestResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12%\n\x05\x64rops\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse')




_CHAPTER = _descriptor.Descriptor(
  name='Chapter',
  full_name='Chapter',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='travel', full_name='Chapter.travel', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='Chapter.stage_id', index=1,
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
  serialized_start=69,
  serialized_end=121,
)


_TRAVEL = _descriptor.Descriptor(
  name='Travel',
  full_name='Travel',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='event_id', full_name='Travel.event_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='drops', full_name='Travel.drops', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='time', full_name='Travel.time', index=2,
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
  serialized_start=123,
  serialized_end=202,
)


_SHOES = _descriptor.Descriptor(
  name='Shoes',
  full_name='Shoes',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='shoe1', full_name='Shoes.shoe1', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='shoe2', full_name='Shoes.shoe2', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='shoe3', full_name='Shoes.shoe3', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='use_type', full_name='Shoes.use_type', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='use_no', full_name='Shoes.use_no', index=4,
      number=5, type=5, cpp_type=1, label=2,
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
  serialized_start=204,
  serialized_end=290,
)


_TRAVELREQUEST = _descriptor.Descriptor(
  name='TravelRequest',
  full_name='TravelRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='TravelRequest.stage_id', index=0,
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
  serialized_start=292,
  serialized_end=325,
)


_TRAVELRESPONSE = _descriptor.Descriptor(
  name='TravelResponse',
  full_name='TravelResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='TravelResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='event_id', full_name='TravelResponse.event_id', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='drops', full_name='TravelResponse.drops', index=2,
      number=3, type=11, cpp_type=10, label=1,
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
  serialized_start=327,
  serialized_end=430,
)


_TRAVELINITRESPONSE = _descriptor.Descriptor(
  name='TravelInitResponse',
  full_name='TravelInitResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='chapter', full_name='TravelInitResponse.chapter', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='shoes', full_name='TravelInitResponse.shoes', index=1,
      number=2, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='chest_time', full_name='TravelInitResponse.chest_time', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='travel_item_chapter', full_name='TravelInitResponse.travel_item_chapter', index=3,
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
  serialized_start=433,
  serialized_end=572,
)


_TRAVELITEMCHAPTER = _descriptor.Descriptor(
  name='TravelItemChapter',
  full_name='TravelItemChapter',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='TravelItemChapter.stage_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='travel_item', full_name='TravelItemChapter.travel_item', index=1,
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
  serialized_start=574,
  serialized_end=645,
)


_BUYSHOESREQUEST = _descriptor.Descriptor(
  name='BuyShoesRequest',
  full_name='BuyShoesRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='shoes_infos', full_name='BuyShoesRequest.shoes_infos', index=0,
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
  serialized_start=647,
  serialized_end=697,
)


_BUYSHOESRESPONSE = _descriptor.Descriptor(
  name='BuyShoesResponse',
  full_name='BuyShoesResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='BuyShoesResponse.res', index=0,
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
  serialized_start=699,
  serialized_end=747,
)


_TRAVELSETTLEREQUEST = _descriptor.Descriptor(
  name='TravelSettleRequest',
  full_name='TravelSettleRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='TravelSettleRequest.stage_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='event_id', full_name='TravelSettleRequest.event_id', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='answer', full_name='TravelSettleRequest.answer', index=2,
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
  serialized_start=749,
  serialized_end=822,
)


_TRAVELSETTLERESPONSE = _descriptor.Descriptor(
  name='TravelSettleResponse',
  full_name='TravelSettleResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='TravelSettleResponse.res', index=0,
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
  serialized_start=824,
  serialized_end=876,
)


_EVENTSTARTREQUEST = _descriptor.Descriptor(
  name='EventStartRequest',
  full_name='EventStartRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='EventStartRequest.stage_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='event_id', full_name='EventStartRequest.event_id', index=1,
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
  serialized_start=878,
  serialized_end=933,
)


_EVENTSTARTRESPONSE = _descriptor.Descriptor(
  name='EventStartResponse',
  full_name='EventStartResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='EventStartResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='time', full_name='EventStartResponse.time', index=1,
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
  serialized_start=935,
  serialized_end=999,
)


_NOWAITREQUEST = _descriptor.Descriptor(
  name='NoWaitRequest',
  full_name='NoWaitRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='stage_id', full_name='NoWaitRequest.stage_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='event_id', full_name='NoWaitRequest.event_id', index=1,
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
  serialized_start=1001,
  serialized_end=1052,
)


_NOWAITRESPONSE = _descriptor.Descriptor(
  name='NoWaitResponse',
  full_name='NoWaitResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='NoWaitResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='time', full_name='NoWaitResponse.time', index=1,
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
  serialized_start=1054,
  serialized_end=1114,
)


_OPENCHESTRESPONSE = _descriptor.Descriptor(
  name='OpenChestResponse',
  full_name='OpenChestResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='OpenChestResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='drops', full_name='OpenChestResponse.drops', index=1,
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
  serialized_start=1116,
  serialized_end=1204,
)

_CHAPTER.fields_by_name['travel'].message_type = _TRAVEL
_TRAVEL.fields_by_name['drops'].message_type = common_pb2._GAMERESOURCESRESPONSE
_TRAVELRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_TRAVELRESPONSE.fields_by_name['drops'].message_type = common_pb2._GAMERESOURCESRESPONSE
_TRAVELINITRESPONSE.fields_by_name['chapter'].message_type = _CHAPTER
_TRAVELINITRESPONSE.fields_by_name['shoes'].message_type = _SHOES
_TRAVELINITRESPONSE.fields_by_name['travel_item_chapter'].message_type = _TRAVELITEMCHAPTER
_TRAVELITEMCHAPTER.fields_by_name['travel_item'].message_type = travel_item_pb2._TRAVELITEM
_BUYSHOESREQUEST.fields_by_name['shoes_infos'].message_type = travel_shoes_pb2._SHOESINFO
_BUYSHOESRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_TRAVELSETTLERESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_EVENTSTARTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_NOWAITRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_OPENCHESTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_OPENCHESTRESPONSE.fields_by_name['drops'].message_type = common_pb2._GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['Chapter'] = _CHAPTER
DESCRIPTOR.message_types_by_name['Travel'] = _TRAVEL
DESCRIPTOR.message_types_by_name['Shoes'] = _SHOES
DESCRIPTOR.message_types_by_name['TravelRequest'] = _TRAVELREQUEST
DESCRIPTOR.message_types_by_name['TravelResponse'] = _TRAVELRESPONSE
DESCRIPTOR.message_types_by_name['TravelInitResponse'] = _TRAVELINITRESPONSE
DESCRIPTOR.message_types_by_name['TravelItemChapter'] = _TRAVELITEMCHAPTER
DESCRIPTOR.message_types_by_name['BuyShoesRequest'] = _BUYSHOESREQUEST
DESCRIPTOR.message_types_by_name['BuyShoesResponse'] = _BUYSHOESRESPONSE
DESCRIPTOR.message_types_by_name['TravelSettleRequest'] = _TRAVELSETTLEREQUEST
DESCRIPTOR.message_types_by_name['TravelSettleResponse'] = _TRAVELSETTLERESPONSE
DESCRIPTOR.message_types_by_name['EventStartRequest'] = _EVENTSTARTREQUEST
DESCRIPTOR.message_types_by_name['EventStartResponse'] = _EVENTSTARTRESPONSE
DESCRIPTOR.message_types_by_name['NoWaitRequest'] = _NOWAITREQUEST
DESCRIPTOR.message_types_by_name['NoWaitResponse'] = _NOWAITRESPONSE
DESCRIPTOR.message_types_by_name['OpenChestResponse'] = _OPENCHESTRESPONSE

class Chapter(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _CHAPTER

  # @@protoc_insertion_point(class_scope:Chapter)

class Travel(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVEL

  # @@protoc_insertion_point(class_scope:Travel)

class Shoes(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _SHOES

  # @@protoc_insertion_point(class_scope:Shoes)

class TravelRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELREQUEST

  # @@protoc_insertion_point(class_scope:TravelRequest)

class TravelResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELRESPONSE

  # @@protoc_insertion_point(class_scope:TravelResponse)

class TravelInitResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELINITRESPONSE

  # @@protoc_insertion_point(class_scope:TravelInitResponse)

class TravelItemChapter(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELITEMCHAPTER

  # @@protoc_insertion_point(class_scope:TravelItemChapter)

class BuyShoesRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BUYSHOESREQUEST

  # @@protoc_insertion_point(class_scope:BuyShoesRequest)

class BuyShoesResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BUYSHOESRESPONSE

  # @@protoc_insertion_point(class_scope:BuyShoesResponse)

class TravelSettleRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELSETTLEREQUEST

  # @@protoc_insertion_point(class_scope:TravelSettleRequest)

class TravelSettleResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _TRAVELSETTLERESPONSE

  # @@protoc_insertion_point(class_scope:TravelSettleResponse)

class EventStartRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _EVENTSTARTREQUEST

  # @@protoc_insertion_point(class_scope:EventStartRequest)

class EventStartResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _EVENTSTARTRESPONSE

  # @@protoc_insertion_point(class_scope:EventStartResponse)

class NoWaitRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _NOWAITREQUEST

  # @@protoc_insertion_point(class_scope:NoWaitRequest)

class NoWaitResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _NOWAITRESPONSE

  # @@protoc_insertion_point(class_scope:NoWaitResponse)

class OpenChestResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _OPENCHESTRESPONSE

  # @@protoc_insertion_point(class_scope:OpenChestResponse)


# @@protoc_insertion_point(module_scope)
