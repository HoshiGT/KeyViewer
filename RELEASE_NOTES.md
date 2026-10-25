Two critical fixes for Linux players (verified on ADOFAI r148 / Unity 6 / UMM 0.32.5):

## 1. Profile scan pollution
`ProfilePath = Mod.Path` made every `*.json` in the mod folder a "profile": system files (Settings/info/language files) got listed in the profile UI, auto-activated, and **overwritten by profile save operations** — a clobbered `info.json` makes UMM drop the whole mod (`Id is null`). The scanner now excludes system files and prunes stale ActiveProfiles entries.

## 2. Garbage color roundtrip (invisible keys)
On Linux, saving a profile wrote **uninitialized-memory garbage** into color fields (e+20 / e-41 bit patterns from cross-assembly `VertexGradient` reads), and loading them back yielded alpha=0 — keys rendered fully transparent. Symptom: a profile created in-session displays fine, but is **invisible after every restart**. Both `GColor.Serialize` and `Deserialize` now sanitize invalid floats to opaque white; existing broken files self-heal after one load/save roundtrip.

Also includes the Linux shader fallback in AssetManager (`UI/Default` instead of bundle shaders).

## Install
UMM → Mods → drag the zip in (upgrades 4.14.4 in place; profiles/keys preserved — broken colors are repaired automatically on first load).
