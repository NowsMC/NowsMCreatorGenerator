package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.client.keybind.KeybindApi;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Keybinds {
    public static final String CATEGORY = "key.categories.${modid}";

    private ${JavaModName}Keybinds() {
    }

    public static void register(NowsContext context) {
        KeybindApi keybinds = MinecraftApi.keybinds(context);
        keybinds.registerCategory(CATEGORY);
    }

    public static KeybindApi keybinds(NowsContext context) {
        return MinecraftApi.keybinds(context);
    }
}
