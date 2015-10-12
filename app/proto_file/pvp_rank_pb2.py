# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: pvp_rank.proto

from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)


import stage_pb2
import common_pb2


DESCRIPTOR = _descriptor.FileDescriptor(
  name='pvp_rank.proto',
  package='',
  serialized_pb='\n\x0epvp_rank.proto\x1a\x0bstage.proto\x1a\x0c\x63ommon.proto\"\x94\x01\n\tRankItems\x12\x10\n\x08nickname\x18\x01 \x02(\t\x12\x0c\n\x04rank\x18\x02 \x02(\x05\x12\r\n\x05level\x18\x03 \x02(\x05\x12\n\n\x02\x61p\x18\x04 \x02(\x05\x12\x10\n\x08hero_ids\x18\x05 \x03(\x05\x12\x13\n\x0bhero_levels\x18\x06 \x03(\x05\x12\x0f\n\x07head_no\x18\x07 \x02(\x05\x12\x14\n\x0c\x63haracter_id\x18\x08 \x02(\x05\"~\n\x12PlayerRankResponse\x12\x1e\n\nrank_items\x18\x01 \x03(\x0b\x32\n.RankItems\x12\x13\n\x0bplayer_rank\x18\x02 \x01(\x05\x12\x11\n\tpvp_score\x18\x03 \x01(\x05\x12 \n\x18pvp_upstage_challenge_id\x18\x04 \x01(\x05\"^\n\x0fPvpFightRequest\x12\x16\n\x0e\x63hallenge_rank\x18\x01 \x02(\x05\x12\x14\n\x0c\x63hallenge_id\x18\x02 \x01(\x05\x12\x0e\n\x06lineup\x18\x03 \x03(\x05\x12\r\n\x05skill\x18\x04 \x01(\x05\"B\n\x0fPvpFightRevenge\x12\x10\n\x08\x62lack_id\x18\x01 \x02(\x05\x12\x0e\n\x06lineup\x18\x02 \x03(\x05\x12\r\n\x05skill\x18\x03 \x01(\x05\"@\n\x10PvpFightOvercome\x12\r\n\x05index\x18\x01 \x02(\x05\x12\x0e\n\x06lineup\x18\x03 \x03(\x05\x12\r\n\x05skill\x18\x04 \x01(\x05\"<\n\x14PvpFightOvercomeInfo\x12\x15\n\rcharacter_ids\x18\x01 \x03(\x05\x12\r\n\x05index\x18\x02 \x02(\x05\"+\n\x14PvpPlayerInfoRequest\x12\x13\n\x0bplayer_rank\x18\x01 \x02(\x05\"\x1d\n\x0cResetPvpTime\x12\r\n\x05times\x18\x01 \x02(\x05\"%\n\x14ResetPvpOvercomeTime\x12\r\n\x05times\x18\x01 \x02(\x05\"\xb6\x03\n\x10PvpFightResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x18\n\x03red\x18\x02 \x03(\x0b\x32\x0b.BattleUnit\x12\x19\n\x04\x62lue\x18\x03 \x03(\x0b\x32\x0b.BattleUnit\x12\x11\n\tred_skill\x18\x04 \x01(\x05\x12\x17\n\x0fred_skill_level\x18\x05 \x01(\x05\x12\x12\n\nblue_skill\x18\x06 \x01(\x05\x12\x18\n\x10\x62lue_skill_level\x18\x07 \x01(\x05\x12\x14\n\x0c\x66ight_result\x18\x08 \x01(\x08\x12\r\n\x05seed1\x18\t \x01(\x05\x12\r\n\x05seed2\x18\n \x01(\x05\x12$\n\x04gain\x18\x0b \x01(\x0b\x32\x16.GameResourcesResponse\x12\x10\n\x08top_rank\x18\x0c \x01(\x05\x12%\n\x05\x61ward\x18\r \x01(\x0b\x32\x16.GameResourcesResponse\x12&\n\x06\x61ward2\x18\x0e \x01(\x0b\x32\x16.GameResourcesResponse\x12\x11\n\trank_incr\x18\x0f \x01(\x05\x12\'\n\x07\x63onsume\x18\x10 \x01(\x0b\x32\x16.GameResourcesResponse\"(\n\x17PvpOvercomeAwardRequest\x12\r\n\x05index\x18\x01 \x02(\x05\"^\n\x18PvpOvercomeAwardResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12$\n\x04gain\x18\x02 \x01(\x0b\x32\x16.GameResourcesResponse\"_\n\nBattleBuff\x12\r\n\x05index\x18\x01 \x02(\x05\x12\x11\n\tbuff_type\x18\x02 \x02(\x05\x12\x12\n\nvalue_type\x18\x03 \x02(\x05\x12\r\n\x05value\x18\x04 \x02(\x02\x12\x0c\n\x04star\x18\x05 \x01(\x05\"*\n\x19GetPvpOvercomeBuffRequest\x12\r\n\x05index\x18\x01 \x02(\x05\"U\n\x1aGetPvpOvercomeBuffResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x19\n\x04\x62uff\x18\x02 \x03(\x0b\x32\x0b.BattleBuff\"7\n\x19\x42uyPvpOvercomeBuffRequest\x12\r\n\x05index\x18\x01 \x02(\x05\x12\x0b\n\x03num\x18\x02 \x02(\x05\"U\n\x1a\x42uyPvpOvercomeBuffResponse\x12\x1c\n\x03res\x18\x01 \x02(\x0b\x32\x0f.CommonResponse\x12\x19\n\x04\x62uff\x18\x02 \x03(\x0b\x32\x0b.BattleBuff\"\x82\x01\n\x12GetPvpOvercomeInfo\x12\x1a\n\x12pvp_overcome_index\x18\x01 \x02(\x05\x12\r\n\x05stars\x18\x02 \x02(\x05\x12\x15\n\rrefresh_count\x18\x03 \x02(\x05\x12\x0f\n\x07\x61warded\x18\x04 \x03(\x05\x12\x19\n\x04\x62uff\x18\x05 \x03(\x0b\x32\x0b.BattleBuff')




_RANKITEMS = _descriptor.Descriptor(
  name='RankItems',
  full_name='RankItems',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='nickname', full_name='RankItems.nickname', index=0,
      number=1, type=9, cpp_type=9, label=2,
      has_default_value=False, default_value=unicode("", "utf-8"),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rank', full_name='RankItems.rank', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='level', full_name='RankItems.level', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='ap', full_name='RankItems.ap', index=3,
      number=4, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero_ids', full_name='RankItems.hero_ids', index=4,
      number=5, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='hero_levels', full_name='RankItems.hero_levels', index=5,
      number=6, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='head_no', full_name='RankItems.head_no', index=6,
      number=7, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='character_id', full_name='RankItems.character_id', index=7,
      number=8, type=5, cpp_type=1, label=2,
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
  serialized_start=46,
  serialized_end=194,
)


_PLAYERRANKRESPONSE = _descriptor.Descriptor(
  name='PlayerRankResponse',
  full_name='PlayerRankResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='rank_items', full_name='PlayerRankResponse.rank_items', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='player_rank', full_name='PlayerRankResponse.player_rank', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='pvp_score', full_name='PlayerRankResponse.pvp_score', index=2,
      number=3, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='pvp_upstage_challenge_id', full_name='PlayerRankResponse.pvp_upstage_challenge_id', index=3,
      number=4, type=5, cpp_type=1, label=1,
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
  serialized_start=196,
  serialized_end=322,
)


_PVPFIGHTREQUEST = _descriptor.Descriptor(
  name='PvpFightRequest',
  full_name='PvpFightRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='challenge_rank', full_name='PvpFightRequest.challenge_rank', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='challenge_id', full_name='PvpFightRequest.challenge_id', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='lineup', full_name='PvpFightRequest.lineup', index=2,
      number=3, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skill', full_name='PvpFightRequest.skill', index=3,
      number=4, type=5, cpp_type=1, label=1,
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
  serialized_start=324,
  serialized_end=418,
)


_PVPFIGHTREVENGE = _descriptor.Descriptor(
  name='PvpFightRevenge',
  full_name='PvpFightRevenge',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='black_id', full_name='PvpFightRevenge.black_id', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='lineup', full_name='PvpFightRevenge.lineup', index=1,
      number=2, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skill', full_name='PvpFightRevenge.skill', index=2,
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
  serialized_start=420,
  serialized_end=486,
)


_PVPFIGHTOVERCOME = _descriptor.Descriptor(
  name='PvpFightOvercome',
  full_name='PvpFightOvercome',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='index', full_name='PvpFightOvercome.index', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='lineup', full_name='PvpFightOvercome.lineup', index=1,
      number=3, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='skill', full_name='PvpFightOvercome.skill', index=2,
      number=4, type=5, cpp_type=1, label=1,
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
  serialized_start=488,
  serialized_end=552,
)


_PVPFIGHTOVERCOMEINFO = _descriptor.Descriptor(
  name='PvpFightOvercomeInfo',
  full_name='PvpFightOvercomeInfo',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='character_ids', full_name='PvpFightOvercomeInfo.character_ids', index=0,
      number=1, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='index', full_name='PvpFightOvercomeInfo.index', index=1,
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
  serialized_start=554,
  serialized_end=614,
)


_PVPPLAYERINFOREQUEST = _descriptor.Descriptor(
  name='PvpPlayerInfoRequest',
  full_name='PvpPlayerInfoRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='player_rank', full_name='PvpPlayerInfoRequest.player_rank', index=0,
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
  serialized_start=616,
  serialized_end=659,
)


_RESETPVPTIME = _descriptor.Descriptor(
  name='ResetPvpTime',
  full_name='ResetPvpTime',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='times', full_name='ResetPvpTime.times', index=0,
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
  serialized_start=661,
  serialized_end=690,
)


_RESETPVPOVERCOMETIME = _descriptor.Descriptor(
  name='ResetPvpOvercomeTime',
  full_name='ResetPvpOvercomeTime',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='times', full_name='ResetPvpOvercomeTime.times', index=0,
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
  serialized_start=692,
  serialized_end=729,
)


_PVPFIGHTRESPONSE = _descriptor.Descriptor(
  name='PvpFightResponse',
  full_name='PvpFightResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='PvpFightResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red', full_name='PvpFightResponse.red', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='blue', full_name='PvpFightResponse.blue', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red_skill', full_name='PvpFightResponse.red_skill', index=3,
      number=4, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='red_skill_level', full_name='PvpFightResponse.red_skill_level', index=4,
      number=5, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='blue_skill', full_name='PvpFightResponse.blue_skill', index=5,
      number=6, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='blue_skill_level', full_name='PvpFightResponse.blue_skill_level', index=6,
      number=7, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='fight_result', full_name='PvpFightResponse.fight_result', index=7,
      number=8, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='seed1', full_name='PvpFightResponse.seed1', index=8,
      number=9, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='seed2', full_name='PvpFightResponse.seed2', index=9,
      number=10, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='PvpFightResponse.gain', index=10,
      number=11, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='top_rank', full_name='PvpFightResponse.top_rank', index=11,
      number=12, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='award', full_name='PvpFightResponse.award', index=12,
      number=13, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='award2', full_name='PvpFightResponse.award2', index=13,
      number=14, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='rank_incr', full_name='PvpFightResponse.rank_incr', index=14,
      number=15, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='consume', full_name='PvpFightResponse.consume', index=15,
      number=16, type=11, cpp_type=10, label=1,
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
  serialized_start=732,
  serialized_end=1170,
)


_PVPOVERCOMEAWARDREQUEST = _descriptor.Descriptor(
  name='PvpOvercomeAwardRequest',
  full_name='PvpOvercomeAwardRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='index', full_name='PvpOvercomeAwardRequest.index', index=0,
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
  serialized_start=1172,
  serialized_end=1212,
)


_PVPOVERCOMEAWARDRESPONSE = _descriptor.Descriptor(
  name='PvpOvercomeAwardResponse',
  full_name='PvpOvercomeAwardResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='PvpOvercomeAwardResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='gain', full_name='PvpOvercomeAwardResponse.gain', index=1,
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
  serialized_start=1214,
  serialized_end=1308,
)


_BATTLEBUFF = _descriptor.Descriptor(
  name='BattleBuff',
  full_name='BattleBuff',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='index', full_name='BattleBuff.index', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='buff_type', full_name='BattleBuff.buff_type', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value_type', full_name='BattleBuff.value_type', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='value', full_name='BattleBuff.value', index=3,
      number=4, type=2, cpp_type=6, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='star', full_name='BattleBuff.star', index=4,
      number=5, type=5, cpp_type=1, label=1,
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
  serialized_start=1310,
  serialized_end=1405,
)


_GETPVPOVERCOMEBUFFREQUEST = _descriptor.Descriptor(
  name='GetPvpOvercomeBuffRequest',
  full_name='GetPvpOvercomeBuffRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='index', full_name='GetPvpOvercomeBuffRequest.index', index=0,
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
  serialized_start=1407,
  serialized_end=1449,
)


_GETPVPOVERCOMEBUFFRESPONSE = _descriptor.Descriptor(
  name='GetPvpOvercomeBuffResponse',
  full_name='GetPvpOvercomeBuffResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='GetPvpOvercomeBuffResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='buff', full_name='GetPvpOvercomeBuffResponse.buff', index=1,
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
  serialized_start=1451,
  serialized_end=1536,
)


_BUYPVPOVERCOMEBUFFREQUEST = _descriptor.Descriptor(
  name='BuyPvpOvercomeBuffRequest',
  full_name='BuyPvpOvercomeBuffRequest',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='index', full_name='BuyPvpOvercomeBuffRequest.index', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='num', full_name='BuyPvpOvercomeBuffRequest.num', index=1,
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
  serialized_start=1538,
  serialized_end=1593,
)


_BUYPVPOVERCOMEBUFFRESPONSE = _descriptor.Descriptor(
  name='BuyPvpOvercomeBuffResponse',
  full_name='BuyPvpOvercomeBuffResponse',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='res', full_name='BuyPvpOvercomeBuffResponse.res', index=0,
      number=1, type=11, cpp_type=10, label=2,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='buff', full_name='BuyPvpOvercomeBuffResponse.buff', index=1,
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
  serialized_start=1595,
  serialized_end=1680,
)


_GETPVPOVERCOMEINFO = _descriptor.Descriptor(
  name='GetPvpOvercomeInfo',
  full_name='GetPvpOvercomeInfo',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='pvp_overcome_index', full_name='GetPvpOvercomeInfo.pvp_overcome_index', index=0,
      number=1, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='stars', full_name='GetPvpOvercomeInfo.stars', index=1,
      number=2, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='refresh_count', full_name='GetPvpOvercomeInfo.refresh_count', index=2,
      number=3, type=5, cpp_type=1, label=2,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='awarded', full_name='GetPvpOvercomeInfo.awarded', index=3,
      number=4, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='buff', full_name='GetPvpOvercomeInfo.buff', index=4,
      number=5, type=11, cpp_type=10, label=3,
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
  serialized_start=1683,
  serialized_end=1813,
)

_PLAYERRANKRESPONSE.fields_by_name['rank_items'].message_type = _RANKITEMS
_PVPFIGHTRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_PVPFIGHTRESPONSE.fields_by_name['red'].message_type = stage_pb2._BATTLEUNIT
_PVPFIGHTRESPONSE.fields_by_name['blue'].message_type = stage_pb2._BATTLEUNIT
_PVPFIGHTRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
_PVPFIGHTRESPONSE.fields_by_name['award'].message_type = common_pb2._GAMERESOURCESRESPONSE
_PVPFIGHTRESPONSE.fields_by_name['award2'].message_type = common_pb2._GAMERESOURCESRESPONSE
_PVPFIGHTRESPONSE.fields_by_name['consume'].message_type = common_pb2._GAMERESOURCESRESPONSE
_PVPOVERCOMEAWARDRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_PVPOVERCOMEAWARDRESPONSE.fields_by_name['gain'].message_type = common_pb2._GAMERESOURCESRESPONSE
_GETPVPOVERCOMEBUFFRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_GETPVPOVERCOMEBUFFRESPONSE.fields_by_name['buff'].message_type = _BATTLEBUFF
_BUYPVPOVERCOMEBUFFRESPONSE.fields_by_name['res'].message_type = common_pb2._COMMONRESPONSE
_BUYPVPOVERCOMEBUFFRESPONSE.fields_by_name['buff'].message_type = _BATTLEBUFF
_GETPVPOVERCOMEINFO.fields_by_name['buff'].message_type = _BATTLEBUFF
DESCRIPTOR.message_types_by_name['RankItems'] = _RANKITEMS
DESCRIPTOR.message_types_by_name['PlayerRankResponse'] = _PLAYERRANKRESPONSE
DESCRIPTOR.message_types_by_name['PvpFightRequest'] = _PVPFIGHTREQUEST
DESCRIPTOR.message_types_by_name['PvpFightRevenge'] = _PVPFIGHTREVENGE
DESCRIPTOR.message_types_by_name['PvpFightOvercome'] = _PVPFIGHTOVERCOME
DESCRIPTOR.message_types_by_name['PvpFightOvercomeInfo'] = _PVPFIGHTOVERCOMEINFO
DESCRIPTOR.message_types_by_name['PvpPlayerInfoRequest'] = _PVPPLAYERINFOREQUEST
DESCRIPTOR.message_types_by_name['ResetPvpTime'] = _RESETPVPTIME
DESCRIPTOR.message_types_by_name['ResetPvpOvercomeTime'] = _RESETPVPOVERCOMETIME
DESCRIPTOR.message_types_by_name['PvpFightResponse'] = _PVPFIGHTRESPONSE
DESCRIPTOR.message_types_by_name['PvpOvercomeAwardRequest'] = _PVPOVERCOMEAWARDREQUEST
DESCRIPTOR.message_types_by_name['PvpOvercomeAwardResponse'] = _PVPOVERCOMEAWARDRESPONSE
DESCRIPTOR.message_types_by_name['BattleBuff'] = _BATTLEBUFF
DESCRIPTOR.message_types_by_name['GetPvpOvercomeBuffRequest'] = _GETPVPOVERCOMEBUFFREQUEST
DESCRIPTOR.message_types_by_name['GetPvpOvercomeBuffResponse'] = _GETPVPOVERCOMEBUFFRESPONSE
DESCRIPTOR.message_types_by_name['BuyPvpOvercomeBuffRequest'] = _BUYPVPOVERCOMEBUFFREQUEST
DESCRIPTOR.message_types_by_name['BuyPvpOvercomeBuffResponse'] = _BUYPVPOVERCOMEBUFFRESPONSE
DESCRIPTOR.message_types_by_name['GetPvpOvercomeInfo'] = _GETPVPOVERCOMEINFO

class RankItems(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RANKITEMS

  # @@protoc_insertion_point(class_scope:RankItems)

class PlayerRankResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PLAYERRANKRESPONSE

  # @@protoc_insertion_point(class_scope:PlayerRankResponse)

class PvpFightRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPFIGHTREQUEST

  # @@protoc_insertion_point(class_scope:PvpFightRequest)

class PvpFightRevenge(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPFIGHTREVENGE

  # @@protoc_insertion_point(class_scope:PvpFightRevenge)

class PvpFightOvercome(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPFIGHTOVERCOME

  # @@protoc_insertion_point(class_scope:PvpFightOvercome)

class PvpFightOvercomeInfo(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPFIGHTOVERCOMEINFO

  # @@protoc_insertion_point(class_scope:PvpFightOvercomeInfo)

class PvpPlayerInfoRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPPLAYERINFOREQUEST

  # @@protoc_insertion_point(class_scope:PvpPlayerInfoRequest)

class ResetPvpTime(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RESETPVPTIME

  # @@protoc_insertion_point(class_scope:ResetPvpTime)

class ResetPvpOvercomeTime(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _RESETPVPOVERCOMETIME

  # @@protoc_insertion_point(class_scope:ResetPvpOvercomeTime)

class PvpFightResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPFIGHTRESPONSE

  # @@protoc_insertion_point(class_scope:PvpFightResponse)

class PvpOvercomeAwardRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPOVERCOMEAWARDREQUEST

  # @@protoc_insertion_point(class_scope:PvpOvercomeAwardRequest)

class PvpOvercomeAwardResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _PVPOVERCOMEAWARDRESPONSE

  # @@protoc_insertion_point(class_scope:PvpOvercomeAwardResponse)

class BattleBuff(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BATTLEBUFF

  # @@protoc_insertion_point(class_scope:BattleBuff)

class GetPvpOvercomeBuffRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETPVPOVERCOMEBUFFREQUEST

  # @@protoc_insertion_point(class_scope:GetPvpOvercomeBuffRequest)

class GetPvpOvercomeBuffResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETPVPOVERCOMEBUFFRESPONSE

  # @@protoc_insertion_point(class_scope:GetPvpOvercomeBuffResponse)

class BuyPvpOvercomeBuffRequest(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BUYPVPOVERCOMEBUFFREQUEST

  # @@protoc_insertion_point(class_scope:BuyPvpOvercomeBuffRequest)

class BuyPvpOvercomeBuffResponse(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _BUYPVPOVERCOMEBUFFRESPONSE

  # @@protoc_insertion_point(class_scope:BuyPvpOvercomeBuffResponse)

class GetPvpOvercomeInfo(_message.Message):
  __metaclass__ = _reflection.GeneratedProtocolMessageType
  DESCRIPTOR = _GETPVPOVERCOMEINFO

  # @@protoc_insertion_point(class_scope:GetPvpOvercomeInfo)


# @@protoc_insertion_point(module_scope)
