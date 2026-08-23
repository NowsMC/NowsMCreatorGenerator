package ${package}.init;

import reactor.util.Logger;
import space.nows.integration.logging.NowsLog;
import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.command.CommandSpec;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Commands {
    private static final Logger LOG = NowsLog.get(${JavaModName}Commands.class);

    private ${JavaModName}Commands() {
    }

    public static void register(NowsContext context) {
<#list commands as command>
        MinecraftApi.commands(context).register(CommandSpec.literal("${command.commandName!command.getModElement().getRegistryName()}")
                .executes(() -> LOG.info("Executed ${command.commandName!command.getModElement().getRegistryName()}"))
                .result(1)
                .build());
</#list>
    }
}
