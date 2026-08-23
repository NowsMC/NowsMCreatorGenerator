package ${package}.init;

import space.nows.mc.api.registry.FoodSpec;
import space.nows.mc.api.registry.ItemSpec;
import space.nows.mc.api.registry.RegistryApi;

public final class ${JavaModName}Items {
<#list items as item>
    public static final String ${item.getModElement().getRegistryNameUpper()} = "${modid}:${item.getModElement().getRegistryName()}";
</#list>

    private ${JavaModName}Items() {
    }

    public static void register(RegistryApi registries) {
<#list items as item>
        registries.registerItem(ItemSpec.builder(${item.getModElement().getRegistryNameUpper()})
                .maxStackSize(${item.stackSize!64})
<#if (item.damageCount!0) gt 0>
                .durability(${item.damageCount})
</#if>
<#if item.isFood!false>
                .food(FoodSpec.builder()
                        .nutrition(${item.nutritionalValue!0})
                        .saturationModifier(${item.saturation!0.0}F)
                        .build())
</#if>
<#if item.immuneToFire!false>
                .fireResistant()
</#if>
                .build());
</#list>
    }
}
