package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.nbt.NbtApi;
import space.nows.mc.api.nbt.NbtCompound;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Nbt {
    private ${JavaModName}Nbt() {
    }

    public static void register(NowsContext context) {
        NbtApi nbt = MinecraftApi.nbt(context);
        NbtCompound stableData = nbt.stableCompound()
                .putString("mod", "${modid}")
                .putBoolean("enabled", true);
        nbt.compound(stableData);
    }
}
