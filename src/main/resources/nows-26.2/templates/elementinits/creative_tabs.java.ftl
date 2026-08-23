package ${package}.init;

import space.nows.mc.api.registry.McItemStack;
import space.nows.mc.api.registry.RegistryApi;
import space.nows.mc.api.text.TextApi;

public final class ${JavaModName}CreativeTabs {
    public static final String MAIN = "${modid}:main";

    private ${JavaModName}CreativeTabs() {
    }

    public static void register(RegistryApi registries, TextApi text) {
        registries.registerCreativeTab(
                MAIN,
                text.translatable("itemGroup.${modid}.main"),
                () -> registries.itemStack(McItemStack.of(<@tabIcon/>)),
                (parameters, output) -> {
<#if w.hasElementsOfType("block")>
<#list blocks as block>
                    output.accept(registries.itemStack(McItemStack.of(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()})));
</#list>
</#if>
<#if w.hasElementsOfType("item")>
<#list items as item>
                    output.accept(registries.itemStack(McItemStack.of(${JavaModName}Items.${item.getModElement().getRegistryNameUpper()})));
</#list>
</#if>
                });
    }
}

<#macro tabIcon>
<#if w.hasElementsOfType("item")>
    <#list items as item><#if item?index == 0>${JavaModName}Items.${item.getModElement().getRegistryNameUpper()}</#if></#list>
<#elseif w.hasElementsOfType("block")>
    <#list blocks as block><#if block?index == 0>${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()}</#if></#list>
<#else>
    "minecraft:stone"
</#if>
</#macro>
