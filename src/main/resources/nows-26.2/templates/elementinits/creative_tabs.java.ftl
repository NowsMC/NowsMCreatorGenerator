package ${package}.init;

import net.minecraft.world.item.CreativeModeTab;
import net.minecraft.world.item.ItemStack;
import space.nows.mc.api.registry.RegistryApi;
import space.nows.mc.api.text.TextApi;

public final class ${JavaModName}CreativeTabs {
    public static CreativeModeTab MAIN;

    private ${JavaModName}CreativeTabs() {
    }

    public static void register(RegistryApi registries, TextApi text) {
        MAIN = registries.registerCreativeTab(
                "${modid}:main",
                text.translatable("itemGroup.${modid}.main"),
                () -> new ItemStack(<@tabIcon/>),
                (parameters, output) -> {
<#if w.hasElementsOfType("block")>
<#list blocks as block>
                    output.accept(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}.item());
</#list>
</#if>
<#if w.hasElementsOfType("item")>
<#list items as item>
                    output.accept(${JavaModName}Items.${item.getModElement().getRegistryNameUpper()});
</#list>
</#if>
                });
    }
}

<#macro tabIcon>
<#if w.hasElementsOfType("item")>
    <#list items as item><#if item?index == 0>${JavaModName}Items.${item.getModElement().getRegistryNameUpper()}</#if></#list>
<#elseif w.hasElementsOfType("block")>
    <#list blocks as block><#if block?index == 0>${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}.item()</#if></#list>
<#else>
    registries.getItem("minecraft:stone")
</#if>
</#macro>
