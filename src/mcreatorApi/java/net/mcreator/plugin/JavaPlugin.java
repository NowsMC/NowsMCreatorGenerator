package net.mcreator.plugin;

/**
 * Compile-only signature stub for the MCreator Java plugin API.
 * This class is NOT packaged into the plugin ZIP.
 */
public abstract class JavaPlugin {
    protected final Plugin plugin;

    public JavaPlugin(Plugin plugin) {
        this.plugin = plugin;
    }
}
