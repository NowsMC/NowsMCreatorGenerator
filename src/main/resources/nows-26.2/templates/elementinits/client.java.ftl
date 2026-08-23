package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.client.player.PlayerApi;
import space.nows.mc.api.client.ui.Ui;
import space.nows.mc.api.registry.McItemStack;
import space.nows.mc.api.text.McText;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Client {
    private ${JavaModName}Client() {
    }

    public static void register(NowsContext context) {
        MinecraftApi.ui(context);
        MinecraftApi.players(context);
    }

    public static void addTitleButton(NowsContext context, String label, Runnable onPress) {
        Ui ui = MinecraftApi.ui(context);
        ui.titleScreen().addButton(screen -> screen.addButton(
                screen.centerX(120), screen.height() / 4 + 96, 120, 20, label, onPress));
    }

    public static void showPlayerStatus(NowsContext context) {
        PlayerApi player = MinecraftApi.players(context);
        player.current().ifPresent(ignored -> {
            player.sendSystemMessage(McText.literal("${settings.getModName()} loaded."));
            player.addItem(McItemStack.of("minecraft:stone"));
        });
    }
}
