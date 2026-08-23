package ${package};

import ${package}.init.${JavaModName}Content;
import reactor.util.Logger;
import space.nows.integration.logging.NowsLog;
import space.nows.platform.api.ModInitializer;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName} implements ModInitializer {
    private static final Logger LOG = NowsLog.get(${JavaModName}.class);

    @Override
    public void onInitialize(NowsContext context) {
        ${JavaModName}Content.register(context);
        LOG.info("${settings.getModName()} loaded on {} with {} mod(s).",
                context.side().metadataName(), context.mods().size());
    }
}
