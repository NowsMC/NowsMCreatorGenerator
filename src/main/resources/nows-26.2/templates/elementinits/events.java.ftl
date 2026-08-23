package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.event.GameEvents;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Events {
    private ${JavaModName}Events() {
    }

    public static void register(NowsContext context) {
        MinecraftApi.events(context);
    }

    public static GameEvents events(NowsContext context) {
        return MinecraftApi.events(context);
    }
}
