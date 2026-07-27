# SC Turret 메모

## 목표

- `sc_turret`은 `npc_turret_floor`에 hook을 걸지 않는 독립 `base_anim` 기반 엔티티다.
- `base_ai`는 idle/animation 상태에서 엔진 내부 yaw를 기준으로 몸통을 되돌릴 수 있으므로 다시 쓰지 않는다.
- Lua API 수준에서는 `IsNPC()`가 `true`를 반환하게 해 NPC처럼 보이게 하되, 엔진 C++ NPC는 아니다.
- 메뉴 등록은 `SC Entity` 카테고리의 `SC Resistance Turret`으로 유지한다.
- spawnmenu 등록은 entity 탭이 아니라 NPC 목록에 유지한다.
- 기존 `npc_turret_floor`의 하드코딩된 Combine/시민 터렛 Relationship을 피하기 위해 target 판정은 `target:Disposition(owner) == D_HT`만 사용한다.

## 구현 파일

- `sc-turrets/lua/entities/sc_turret.lua`
- 이전 hook 기반 `sc_turret_resistance_floor.lua`는 제거한다.

## 현재 규칙

- 감지 반경은 현재 `2048`이다. Valve 원본 `FLOOR_TURRET_RANGE`는 `1200`이지만, Combine Soldier의 최대 look distance에 맞춰 확장한 값이므로 유지한다.
- 시야각은 원본 `m_flFieldOfView = 0.4`를 따른다. 후보 탐색과 active 상태 유지 모두 정면 view cone 안의 대상만 허용한다.
- 후보는 감지 반경 안의 살아 있는 `NPC`/`NextBot`이다.
- 후보 중 소환 Player를 적대하는 대상만 공격한다.
- 소환 Player는 `_owner` 내부 필드에만 저장하고 `SetCreator`/탄환 `Attacker`로 쓰지 않는다. 킬피드에는 터렛 자신이 attacker로 보여야 한다.
- 우선순위는 터렛과 가장 가까운 대상이다.
- 터렛 몸통 각도는 코드가 직접 바꾸지 않는다. 적 탐색/조준은 pose parameter로만 처리하고, 몸통 이동/회전은 중력건이나 충돌 같은 물리 상호작용에 맡긴다.
- `base_ai`/NPC schedule/yaw API는 몸통 회전 회귀를 만들 수 있으므로 쓰지 않는다. 현재 공격 대상은 내부 `Target` 필드에만 둔다.
- `SetEnemy`, `NPC_STATE_*`, `SetSchedule`, `SetNPCClass`, `SetIdealYawAndUpdate`는 다시 추가하지 않는다.
- `IsNPC()` 가장은 Lua 애드온 호환용이다. 필요 없는 NPC 메서드는 no-op으로만 추가하고, 엔진 AI 동작을 기대하지 않는다.
- 킬로그는 터렛 탄환의 `Attacker = self`와 터렛 사망 시 수동 `hook.Run("OnNPCKilled", self, attacker, inflictor)`로 유지한다.
- 일반 공격 피해로 체력을 깎거나 파괴하지 않는다. 원본처럼 damage event는 물리 힘과 재탐색만 유발하고, 파괴는 `SelfDestruct`/break 흐름에서만 발생한다.
- 파괴 시 gib는 만들지 않는다. 작은 폭발 이펙트/피해만 남기고 터렛 본체를 제거한다.
- 쓰러지면 `2~2.5`초 동안 thrash/비상 상태가 된 뒤 `inactive`로 내려간다. `inactive`에서는 비상 사운드/핑을 멈추고, 다시 세워졌을 때 `Enable()`로 복귀한다.
- 조준점은 `머리/눈 -> 몸통 -> 팔/다리 -> 손/발 -> 기타` 순서로 LoS가 잡히는 첫 위치다.
- 머리/눈 그룹에서는 pose가 반영된 bone 위치를 `EyePos()`보다 먼저 쓴다. `npc_fastzombie`처럼 기본 eye 위치가 실제 머리보다 높게 나오는 NPC를 피하기 위함이다.
- 애니메이션으로 hitbox가 움직이는 적을 따라가기 위해 hitbox 중심점을 named bone/attachment보다 먼저 조준한다.
- 탄퍼짐은 `vector_origin`으로 100% 정확도다.
- 원본은 `PISTOL` ammo type으로 발사한다. 현재 피해량은 `sk_npc_dmg_pistol * 2`이고, convar가 없으면 `10`이다.
- 원본 시간값: `FLOOR_TURRET_MAX_WAIT = 5`, `FLOOR_TURRET_SHORT_WAIT = 2.0`, `AutoSearchThink` 간격은 `0.2~0.4`초다.
- Lua 구현은 탐색 animation은 `0.05`초 간격으로 유지하되, 비싼 enemy scan은 `0.2~0.4`초마다만 실행한다.
- 원본 입력 이름인 `Toggle`, `Enable`, `Disable`, `DepleteAmmo`, `RestoreAmmo`, `SelfDestruct`를 유지한다.
- 원본의 상태 흐름인 auto search, deploy, search, active, retire, disabled, tipped, inactive, self destruct를 Lua 상태 머신으로 옮긴다.

## 참조

- Valve Source SDK 2013: `npc_turret_floor.cpp`
  - 원본은 기본 모델, 감지 거리 `1200`, pistol ammo 기반 발사, deploy/search/active think 흐름을 사용한다.
- Valve Developer Wiki: `npc_turret_floor`
  - 원본 엔티티의 spawnflag/keyvalue/io 문서 확인용이다.

## 나중에 바꿀 곳

- 모델: `ENT.ModelName`
- muzzle/light attachment 후보: `ENT.MuzzleAttachmentNames`, `ENT.EyeAttachmentNames`
- 스킨: `ENT.SkinNumber`
- 사운드: `SOUNDS`
- 연사 간격: `ENT.FireInterval`
- 감지 반경: `ENT.Range`
