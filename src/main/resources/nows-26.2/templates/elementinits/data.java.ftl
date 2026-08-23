package ${package}.init;

import java.io.IOException;
import java.util.List;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.datagen.DataGen;
import space.nows.mc.api.datapack.DataPacks;
import space.nows.mc.api.registry.TagSpec;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Data {
    private ${JavaModName}Data() {
    }

    public static void register(NowsContext context) {
        MinecraftApi.dataPacks(context).modPackDirectory("${modid}");
    }

    public static void writeGeneratedData(NowsContext context) {
        DataGen dataGen = MinecraftApi.dataGen(context);
        try {
            dataGen.writeTag(TagSpec.items("${modid}:generated_items", List.of()));
        } catch (IOException exception) {
            throw new IllegalStateException("Unable to write generated ${modid} data", exception);
        }
    }

    public static DataPacks dataPacks(NowsContext context) {
        return MinecraftApi.dataPacks(context);
    }
}
