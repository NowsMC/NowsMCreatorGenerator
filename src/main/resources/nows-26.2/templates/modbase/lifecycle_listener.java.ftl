package ${package};

import reactor.util.Logger;
import space.nows.integration.geb.NowsLifecycleListener;
import space.nows.integration.geb.event.NowsEntrypointsCompletedEvent;
import space.nows.integration.logging.NowsLog;

public final class ${JavaModName}LifecycleListener implements NowsLifecycleListener {
    private static final Logger LOG = NowsLog.get(${JavaModName}LifecycleListener.class);

    @Override
    public void onNowsEntrypointsCompleted(NowsEntrypointsCompletedEvent event) {
        LOG.info("${settings.getModName()} observed {} entrypoint(s).", event.count());
    }
}
