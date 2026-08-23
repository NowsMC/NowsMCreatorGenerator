# NowsMCreatorGenerator

MCreator generator plugin for Nows.

This branch targets Minecraft `26.2` and MCreator `2026.2`.

## Current Scope

- Creates a Nows Gradle workspace.
- Writes `gradle.properties`, `nows.mod.kdl`, and an empty mixin config.
- Generates the main Nows entrypoint and lifecycle listener.
- Provides early templates for simple items, blocks, creative tabs, commands, and basic model JSON.
- Adds small helper classes for Nows data, events, keybinds, client UI/player, config, NBT, and recipe viewer APIs.
- Includes first-pass procedure and recipe JSON templates for MCreator block-based workflows.

The generator is still incomplete. Keep templates small and prefer Nows APIs before adding version-specific Minecraft code.

## Build

```bash
./gradlew exportPlugin
```

The plugin ZIP is written to:

```text
build/distributions/generator-nows-26.2-2026.2.zip
```
