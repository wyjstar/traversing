# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: escort.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import stage_pb2
import guild_pb2
import pvp_rank_pb2
import common_pb2
import friend_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='escort.proto',
  package='',
  serialized_pb='\n\x0c\x65scort.proto\x1a\x0bstage.proto\x1a\x0bguild.proto\x1a\x0epvp_rank.proto\x1a\x0c\x63ommon.proto\x1a\x0c\x66riend.proto\"\x93\x02\n\nEscortTask\x12\x0f\n\x07task_id\x18\x01 \x02(\t\x12\x0f\n\x07task_no\x18\x02 \x02(\x05\x12\r\n\x05state\x18\x03 \x02(\x05\x12\x19\n\x11receive_task_time\x18\x04 \x01(\x05\x12\x1a\n\x12start_protect_time\x18\x05 \x01(\x05\x12&\n\x12protect_guild_info\x18\x06 \x01(\x0b\x32\n.GuildRank\x12\"\n\nprotecters\x18\x07 \x03(\x0b\x32\x0e.CharacterInfo\x12&\n\x06reward\x18\x08 \x01(\x0b\x32\x16.GameResourcesResponse\x12)\n\rrob_task_info\x18\t \x03(\x0b\x32\x12.RobEscortTaskInfo\"\xec\x01\n\x11RobEscortTaskInfo\x12\"\n\x0erob_guild_info\x18\x01 \x01(\x0b\x32\n.GuildRank\x12\x1f\n\x07robbers\x18\x02 \x03(\x0b\x32\x0e.CharacterInfo\x12\x1c\n\x03red\x18\x03 \x03(\x0b\x32\x0f.BattleUnitGrop\x12\x1d\n\x04\x62lue\x18\x04 \x03(\x0b\x32\x0f.BattleUnitGrop\x12\r\n\x05seed1\x18\x05 \x01(\x05\x12\r\n\x05seed2\x18\x06 \x01(\x05\x12#\n\x03rob\x18\x07 \x01(\x0b\x32\x16.GameResourcesResponse\x12\x12\n\nrob_result\x18\x08 \x01(\x08\"\xb6\x01\n\x16GetEscortTasksResponse\x12\x1b\n\x13start_protect_times\x18\x01 \x02(\x05\x12\x15\n\rprotect_times\x18\x02 \x02(\x05\x12\x11\n\trob_times\x18\x04 \x02(\x05\x12\x15\n\rrefresh_times\x18\x05 \x02(\x05\x12\x1a\n\x05tasks\x18\x06 \x03(\x0b\x32\x0b.EscortTask\x12\"\n\rcan_rob_tasks\x18\x07 \x03(\x0b\x32\x0b.EscortTask\".\n\x17GetEscortRecordsRequest\x12\x13\n\x0brecord_type\x18\x01 \x02(\x05\"6\n\x18GetEscortRecordsResponse\x12\x1a\n\x05tasks\x18\x01 \x03(\x0b\x32\x0b.EscortTask\"U\n\x19RefreshEscortTaskResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x1a\n\x05tasks\x18\x02 \x03(\x0b\x32\x0b.EscortTask\"C\n\x18ReceiveEscortTaskRequest\x12\x0f\n\x07task_id\x18\x01 \x02(\x05\x12\x16\n\x0eprotect_or_rob\x18\x02 \x02(\x05\"V\n\x17InviteEscortTaskRequest\x12\x0f\n\x07task_id\x18\x01 \x02(\x05\x12\x12\n\nsend_or_in\x18\x02 \x02(\x05\x12\x16\n\x0eprotect_or_rob\x18\x03 \x02(\x05\"Q\n\x1cInviteEscortTaskPushResponse\x12\x19\n\x04task\x18\x01 \x02(\x0b\x32\x0b.EscortTask\x12\x16\n\x0eprotect_or_rob\x18\x02 \x02(\x05\"A\n\x16StartEscortTaskRequest\x12\x0f\n\x07task_id\x18\x01 \x02(\t\x12\x16\n\x0eprotect_or_rob\x18\x02 \x02(\x05\"\x87\x01\n\x17StartEscortTaskResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12%\n\ttask_info\x18\x02 \x01(\x0b\x32\x12.RobEscortTaskInfo\x12\'\n\x07\x63onsume\x18\x03 \x01(\x0b\x32\x16.GameResourcesResponse')




_ESCORTTASK = _descriptor.Descriptor(
  name='EscortTask',
  full_name='EscortTask',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='task_id', full_name='EscortTask.task_id', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='task_no', full_name='EscortTask.task_no', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='state', full_name='EscortTask.state', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='receive_task_time', full_name='EscortTask.receive_task_time', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='start_protect_time', full_name='EscortTask.start_protect_time', index=4,
      number=5, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_guild_info', full_name='EscortTask.protect_guild_info', index=5,
      number=6, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protecters', full_name='EscortTask.protecters', index=6,
      number=7, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='reward', full_name='EscortTask.reward', index=7,
      number=8, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rob_task_info', full_name='EscortTask.rob_task_info', index=8,
      number=9, type=11, cpp_type=10, label=3,
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
  serialized_start=87,
  serialized_end=362,
)


_ROBESCORTTASKINFO = _descriptor.Descriptor(
  name='RobEscortTaskInfo',
  full_name='RobEscortTaskInfo',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='rob_guild_info', full_name='RobEscortTaskInfo.rob_guild_info', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='robbers', full_name='RobEscortTaskInfo.robbers', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red', full_name='RobEscortTaskInfo.red', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='blue', full_name='RobEscortTaskInfo.blue', index=3,
      number=4, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='seed1', full_name='RobEscortTaskInfo.seed1', index=4,
      number=5, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='seed2', full_name='RobEscortTaskInfo.seed2', index=5,
      number=6, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rob', full_name='RobEscortTaskInfo.rob', index=6,
      number=7, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rob_result', full_name='RobEscortTaskInfo.rob_result', index=7,
      number=8, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
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
  serialized_start=365,
  serialized_end=601,
)


_GETESCORTTASKSRESPONSE = _descriptor.Descriptor(
  name='GetEscortTasksResponse',
  full_name='GetEscortTasksResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='start_protect_times', full_name='GetEscortTasksResponse.start_protect_times', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_times', full_name='GetEscortTasksResponse.protect_times', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rob_times', full_name='GetEscortTasksResponse.rob_times', index=2,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='refresh_times', full_name='GetEscortTasksResponse.refresh_times', index=3,
      number=5, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='tasks', full_name='GetEscortTasksResponse.tasks', index=4,
      number=6, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='can_rob_tasks', full_name='GetEscortTasksResponse.can_rob_tasks', index=5,
      number=7, type=11, cpp_type=10, label=3,
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
  serialized_start=604,
  serialized_end=786,
)


_GETESCORTRECORDSREQUEST = _descriptor.Descriptor(
  name='GetEscortRecordsRequest',
  full_name='GetEscortRecordsRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='record_type', full_name='GetEscortRecordsRequest.record_type', index=0,
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
  serialized_start=788,
  serialized_end=834,
)


_GETESCORTRECORDSRESPONSE = _descriptor.Descriptor(
  name='GetEscortRecordsResponse',
  full_name='GetEscortRecordsResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='tasks', full_name='GetEscortRecordsResponse.tasks', index=0,
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
  serialized_start=836,
  serialized_end=890,
)


_REFRESHESCORTTASKRESPONSE = _descriptor.Descriptor(
  name='RefreshEscortTaskResponse',
  full_name='RefreshEscortTaskResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='RefreshEscortTaskResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='tasks', full_name='RefreshEscortTaskResponse.tasks', index=1,
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
  serialized_start=892,
  serialized_end=977,
)


_RECEIVEESCORTTASKREQUEST = _descriptor.Descriptor(
  name='ReceiveEscortTaskRequest',
  full_name='ReceiveEscortTaskRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='task_id', full_name='ReceiveEscortTaskRequest.task_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_or_rob', full_name='ReceiveEscortTaskRequest.protect_or_rob', index=1,
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
  serialized_start=979,
  serialized_end=1046,
)


_INVITEESCORTTASKREQUEST = _descriptor.Descriptor(
  name='InviteEscortTaskRequest',
  full_name='InviteEscortTaskRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='task_id', full_name='InviteEscortTaskRequest.task_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='send_or_in', full_name='InviteEscortTaskRequest.send_or_in', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_or_rob', full_name='InviteEscortTaskRequest.protect_or_rob', index=2,
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
  serialized_start=1048,
  serialized_end=1134,
)


_INVITEESCORTTASKPUSHRESPONSE = _descriptor.Descriptor(
  name='InviteEscortTaskPushResponse',
  full_name='InviteEscortTaskPushResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='task', full_name='InviteEscortTaskPushResponse.task', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_or_rob', full_name='InviteEscortTaskPushResponse.protect_or_rob', index=1,
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
  serialized_start=1136,
  serialized_end=1217,
)


_STARTESCORTTASKREQUEST = _descriptor.Descriptor(
  name='StartEscortTaskRequest',
  full_name='StartEscortTaskRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='task_id', full_name='StartEscortTaskRequest.task_id', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='protect_or_rob', full_name='StartEscortTaskRequest.protect_or_rob', index=1,
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
  serialized_start=1219,
  serialized_end=1284,
)


_STARTESCORTTASKRESPONSE = _descriptor.Descriptor(
  name='StartEscortTaskResponse',
  full_name='StartEscortTaskResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='StartEscortTaskResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='task_info', full_name='StartEscortTaskResponse.task_info', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='consume', full_name='StartEscortTaskResponse.consume', index=2,
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
  serialized_start=1287,
  serialized_end=1422,
)

_ESCORTTASK.fields_by_name['protect_guild_info'].message_type = guild_pb2._GUILDRANK
_ESCORTTASK.fields_by_name['protecters'].message_type = friend_pb2._CHARACTERINFO
_ESCORTTASK.fields_by_name['reward'].message_type = common_pb2._GAMERESOURCESRESPONSE
_ESCORTTASK.fields_by_name['rob_task_info'].message_type = _ROBESCORTTASKINFO
_ROBESCORTTASKINFO.fields_by_name['rob_guild_info'].message_type = guild_pb2._GUILDRANK
_ROBESCORTTASKINFO.fields_by_name['robbers'].message_type = friend_pb2._CHARACTERINFO
_ROBESCORTTASKINFO.fields_by_name['red'].message_type = stage_pb2._BATTLEUNITGROP
_ROBESCORTTASKINFO.fields_by_name['blue'].message_type = stage_pb2._BATTLEUNITGROP
_ROBESCORTTASKINFO.fields_by_name['rob'].message_type = common_pb2._GAMERESOURCESRESPONSE
_GETESCORTTASKSRESPONSE.fields_by_name['tasks'].message_type = _ESCORTTASK
_GETESCORTTASKSRESPONSE.fields_by_name['can_rob_tasks'].message_type = _ESCORTTASK
_GETESCORTRECORDSRESPONSE.fields_by_name['tasks'].message_type = _ESCORTTASK
_REFRESHESCORTTASKRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_REFRESHESCORTTASKRESPONSE.fields_by_name['tasks'].message_type = _ESCORTTASK
_INVITEESCORTTASKPUSHRESPONSE.fields_by_name['task'].message_type = _ESCORTTASK
_STARTESCORTTASKRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_STARTESCORTTASKRESPONSE.fields_by_name['task_info'].message_type = _ROBESCORTTASKINFO
_STARTESCORTTASKRESPONSE.fields_by_name['consume'].message_type = common_pb2._GAMERESOURCESRESPONSE
DESCRIPTOR.message_types_by_name['EscortTask'] = _ESCORTTASK
DESCRIPTOR.message_types_by_name['RobEscortTaskInfo'] = _ROBESCORTTASKINFO
DESCRIPTOR.message_types_by_name['GetEscortTasksResponse'] = _GETESCORTTASKSRESPONSE
DESCRIPTOR.message_types_by_name['GetEscortRecordsRequest'] = _GETESCORTRECORDSREQUEST
DESCRIPTOR.message_types_by_name['GetEscortRecordsResponse'] = _GETESCORTRECORDSRESPONSE
DESCRIPTOR.message_types_by_name['RefreshEscortTaskResponse'] = _REFRESHESCORTTASKRESPONSE
DESCRIPTOR.message_types_by_name['ReceiveEscortTaskRequest'] = _RECEIVEESCORTTASKREQUEST
DESCRIPTOR.message_types_by_name['InviteEscortTaskRequest'] = _INVITEESCORTTASKREQUEST
DESCRIPTOR.message_types_by_name['InviteEscortTaskPushResponse'] = _INVITEESCORTTASKPUSHRESPONSE
DESCRIPTOR.message_types_by_name['StartEscortTaskRequest'] = _STARTESCORTTASKREQUEST
DESCRIPTOR.message_types_by_name['StartEscortTaskResponse'] = _STARTESCORTTASKRESPONSE

class EscortTask(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ESCORTTASK

  # @@protoc_insertion_point(class_scope:EscortTask)

class RobEscortTaskInfo(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _ROBESCORTTASKINFO

  # @@protoc_insertion_point(class_scope:RobEscortTaskInfo)

class GetEscortTasksResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETESCORTTASKSRESPONSE

  # @@protoc_insertion_point(class_scope:GetEscortTasksResponse)

class GetEscortRecordsRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETESCORTRECORDSREQUEST

  # @@protoc_insertion_point(class_scope:GetEscortRecordsRequest)

class GetEscortRecordsResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETESCORTRECORDSRESPONSE

  # @@protoc_insertion_point(class_scope:GetEscortRecordsResponse)

class RefreshEscortTaskResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _REFRESHESCORTTASKRESPONSE

  # @@protoc_insertion_point(class_scope:RefreshEscortTaskResponse)

class ReceiveEscortTaskRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RECEIVEESCORTTASKREQUEST

  # @@protoc_insertion_point(class_scope:ReceiveEscortTaskRequest)

class InviteEscortTaskRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _INVITEESCORTTASKREQUEST

  # @@protoc_insertion_point(class_scope:InviteEscortTaskRequest)

class InviteEscortTaskPushResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _INVITEESCORTTASKPUSHRESPONSE

  # @@protoc_insertion_point(class_scope:InviteEscortTaskPushResponse)

class StartEscortTaskRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _STARTESCORTTASKREQUEST

  # @@protoc_insertion_point(class_scope:StartEscortTaskRequest)

class StartEscortTaskResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _STARTESCORTTASKRESPONSE

  # @@protoc_insertion_point(class_scope:StartEscortTaskResponse)


# @@protoc_insertion_point(module_scope)
