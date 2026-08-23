package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.client.config.ConfigUi;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Config {
    private static boolean enabled = true;
    private static int amount = 1;

    private ${JavaModName}Config() {
    }

    public static void register(NowsContext context) {
        MinecraftApi.configUi(context);
    }

    public static void registerDefaultScreen(NowsContext context) {
        ConfigUi config = MinecraftApi.configUi(context);
        config.register("${modid}", parent -> config.screen(parent, "${settings.getModName()}")
                .category("General")
                .booleanOption("Enabled", enabled, true, "Enable ${settings.getModName()}", value -> enabled = value)
                .intOption("Amount", amount, 1, 0, 64, "Example numeric option", value -> amount = value)
                .done()
                .build());
    }

    public static boolean enabled() {
        return enabled;
    }

    public static int amount() {
        return amount;
    }
}
