package ${package}.init;

public final class ${JavaModName}Resources {
    public static final String MOD_ID = "${modid}";
    public static final String ASSETS_ROOT = "assets/${modid}";
    public static final String DATA_ROOT = "data/${modid}";
    public static final String SOUNDS_JSON = ASSETS_ROOT + "/sounds.json";
    public static final String BLOCKSTATES = ASSETS_ROOT + "/blockstates";
    public static final String BLOCK_MODELS = ASSETS_ROOT + "/models/block";
    public static final String ITEM_MODELS = ASSETS_ROOT + "/models/item";
    public static final String CUSTOM_MODELS = ASSETS_ROOT + "/models/custom";
    public static final String BLOCK_TEXTURES = ASSETS_ROOT + "/textures/block";
    public static final String ITEM_TEXTURES = ASSETS_ROOT + "/textures/item";
    public static final String PARTICLE_TEXTURES = ASSETS_ROOT + "/textures/particle";
    public static final String ADVANCEMENTS = DATA_ROOT + "/advancement";
    public static final String FUNCTIONS = DATA_ROOT + "/function";
    public static final String LOOT_TABLES = DATA_ROOT + "/loot_table";
    public static final String RECIPES = DATA_ROOT + "/recipe";
    public static final String TAGS = DATA_ROOT + "/tags";

    private ${JavaModName}Resources() {
    }

    public static String id(String path) {
        return path.indexOf(':') >= 0 ? path : MOD_ID + ":" + path;
    }

    public static String blockTexture(String path) {
        return id("block/" + path);
    }

    public static String itemTexture(String path) {
        return id("item/" + path);
    }

    public static String particleTexture(String path) {
        return id("particle/" + path);
    }
}
