# NowsMCreatorGenerator

MCreator generator plugin for Nows.

This branch targets Minecraft `26.2` and MCreator `2026.2`.

<p align="center">
  <img
    src="https://github.com/user-attachments/assets/e6612a13-b819-4e31-9457-26eb9fd48971"
    alt="image"
    width="50%"
  />
</p>


## Installation

1. Open **Preferences -> Manage plugins** in MCreator.
2. Enable **Java plugins** if it is not already enabled.
3. Load the Nows generator ZIP.
4. Restart MCreator.
5. Create a workspace from the dedicated **Nows mod** entry under Java Edition mods.

The generator resources and the small Java UI integration are shipped in the **same plugin ZIP**. There is no second plugin to install.

## Current Scope

- Creates a Nows Gradle workspace.
- Writes `gradle.properties`, `nows.mod.kdl`, and an empty mixin config.
- Generates the main Nows entrypoint and lifecycle listener.
- Provides early templates for simple items, blocks, creative tabs, commands, and basic model JSON.
- Adds small helper classes for Nows data, events, keybinds, client UI/player, config, NBT, and recipe viewer APIs.
- Includes first-pass procedure and recipe JSON templates for MCreator block-based workflows.
- Adds a dedicated **Nows mod** workspace type in MCreator 2026.2 while retaining an internal compatibility flavor because MCreator does not currently expose custom `GeneratorFlavor` registration.

The generator is still incomplete. Keep templates small and prefer Nows APIs before adding version-specific Minecraft code.

## Build

```bash
./gradlew exportPlugin
```

The plugin ZIP is written to:

```text
build/distributions/generator-nows-26.2-2026.2.zip
```
