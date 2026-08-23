# NowsMCreatorGenerator

MCreator generator integration for Nows.

This repository is version-branched by the target Minecraft compatibility line. The initial working branch is `26.2`, matching the root Nows workspace `minecraft_version=26.2`.

The first generator target creates the same Nows base workspace shape as `Test/my_mod`, including:

- `space.nows.gradle` setup
- `gradle.properties` metadata for Nows
- `nows.mod.kdl`
- an empty mixin config
- a main `ModInitializer`
- a GEB lifecycle listener
- Nows `RegistryApi` item and block registration templates
- a generated creative tab for item/block content
- simple `CommandSpec` command registration templates
- basic item/block model and blockstate JSON templates

Generated Java templates prefer Nows-owned stable values (`ItemSpec`, `BlockSpec`, `ItemStackSpec`, `CommandSpec`) and stable service entry points (`MinecraftApi`, `RegistryApi`, `TextApi`) over direct Minecraft classes. Direct Minecraft code should be treated as a signal that the Nows stable API needs to grow.

## Branches

- `26.2` - generator work for Minecraft `26.2`.

Future Minecraft targets should use their own branches instead of mixing generator templates across versions.

## Build

```bash
./gradlew exportPlugin
```

The generated plugin is written to:

```text
build/distributions/generator-nows-26.2-2026.2.zip
```
