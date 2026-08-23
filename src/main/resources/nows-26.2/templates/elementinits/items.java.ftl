package ${package}.init;

import net.minecraft.world.item.Item;
import space.nows.mc.api.registry.ItemSpec;
import space.nows.mc.api.registry.RegistryApi;

public final class ${JavaModName}Items {
<#list items as item>
    public static Item ${item.getModElement().getRegistryNameUpper()};
</#list>

    private ${JavaModName}Items() {
    }

    public static void register(RegistryApi registries) {
<#list items as item>
        ${item.getModElement().getRegistryNameUpper()} = registries.registerItem(ItemSpec.builder("${modid}:${item.getModElement().getRegistryName()}")
                .maxStackSize(${item.stackSize!64})
<#if item.immuneToFire!false>
                .fireResistant()
</#if>
                .build());
</#list>
    }
}
