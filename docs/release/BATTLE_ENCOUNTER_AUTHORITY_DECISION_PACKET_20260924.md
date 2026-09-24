# ActiRune Production Battle Encounter Authority Decision Packet

Date: 2026-09-24
Status: `BLOCKED_OWNER_DECISION`
Scope: first production story/PvE encounter authority only.

## Why this packet exists

The runtime battle machinery is implemented and deliberately fail-closed, but production `/app` does not construct a Battle root because no repository-owned authoritative encounter/content record currently supplies the concrete encounter that should be playable.

This packet separates already locked product behavior from the remaining owner/content decisions. It must not be filled with fixture values merely to make the Battle tab open.

## Already locked — do not decide again

The product authority already fixes:

- standard flow: Adventure -> Battle Prep -> Movement/Camera Prep -> Live Battle -> Form Coach overlay -> Victory/Defeat -> Adventure;
- the encounter chooses the movement; standard story flow must not add a second movement-selection screen;
- supported verified movements: Squat, Lunge, Push-up, Plank;
- movement roles:
  - Squat: base attack / combo,
  - Lunge: agility / dodge / critical window,
  - Push-up: heavy attack / armor break,
  - Plank: defense / shield;
- Camera Prep is dynamic for the movement required by the encounter and must not hard-code Squat;
- meaningful battle progress comes from verified real-world movement;
- BattleSession rejects an unprepared or mismatched verified movement;
- a successful rewarded retry restarts the same PvE encounter from the beginning and consumes one of the currently locked retry allowances; it does not resume a hidden checkpoint;
- no forced ad appears during Camera Prep, Live Battle or Form Coach.

## Examples that are not production authority

The Product Bible contains design examples such as Stone Golem phases, wolf/golem encounters and example world identities. They demonstrate intended mechanics; they are not an instruction to ship the first production encounter with those exact enemies, targets, rewards or unlock rules.

Visual Battle artwork also does not create gameplay/content authority.

## Decisions still required for the first production encounter

The content/product owner must provide one authoritative record containing all of the following.

### 1. Encounter identity

- stable encounter id;
- story/quest node id;
- world/region id;
- enemy/boss id and display identity;
- content version or authority reference.

### 2. Unlock and eligibility

- exact rule that makes the encounter available;
- whether it is one-time, replayable or repeatable;
- any prerequisite story/progression state;
- any level/world gate that is genuinely intended.

Do not infer these values from artwork, screenshots or test fixtures.

### 3. Required movement

Choose exactly one authoritative prepared movement for a standard single-movement encounter, or provide an explicit multi-phase encounter definition if the intended encounter is multi-movement.

Allowed verified movement types are:

- `squat`
- `lunge`
- `pushUp`
- `plank`

A standard story encounter must not ask the user to choose again after the encounter has already assigned the movement.

### 4. Objective / target

Provide the concrete measurable target owned by content/balance authority, for example a verified repetition target or verified hold-duration target appropriate to the selected movement.

Required information:

- target metric;
- base target value;
- allowed Dynamic Difficulty adaptation boundary, if adaptation is permitted;
- intended active-duration band if it differs from the general short-encounter product direction.

No numeric target may be guessed from UI mockups.

### 5. Combat semantics

Provide the encounter-owned mapping required beyond the already locked movement role:

- enemy health/phase semantics or another explicit victory condition;
- any armor/shield/critical phase behavior required for this encounter;
- failure/defeat condition;
- whether Form Coach can pause/overlay at all phases or only specified phases.

Existing engine code must not invent damage, heal, shield or balance percentages where authority is absent.

### 6. Reward semantics

Provide the exact authoritative reward result for victory and, where relevant, defeat/retry outcomes:

- XP;
- Gold;
- materials/loot;
- progression/unlock consequence;
- any other already-approved economy output.

Do not derive reward amounts from visual fixtures.

### 7. Runtime content owner

Choose the source that owns production encounter records and their versioning, for example a repository content manifest or an approved backend/content service. The choice must identify:

- source of truth;
- schema/version owner;
- how runtime selects the unlocked encounter;
- how stale/invalid content fails closed;
- how the exact encounter version is auditable for a release.

This decision is separate from choosing Firebase or another infrastructure provider; no backend is implied here.

## Closure rule

P2-005 may leave `BLOCKED_EXTERNAL` only when the required first-encounter authority above exists as an explicit owner-approved content record and runtime can bind `MainShell.battleRootBuilder` from that record without hard-coded fixture values.

Until then, production Battle remaining unavailable is the correct fail-closed behavior.
