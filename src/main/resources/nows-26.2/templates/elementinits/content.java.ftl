package ${package}.init;

import space.nows.platform.api.NowsContext;
import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.registry.RegistryApi;
import space.nows.mc.api.text.TextApi;

public final class ${JavaModName}Content {
    private ${JavaModName}Content() {
    }

    public static void register(NowsContext context) {
        RegistryApi registries = MinecraftApi.registries(context);
        TextApi text = MinecraftApi.text(context);

<#if w.hasElementsOfType("block")>
        ${JavaModName}Blocks.register(registries);
</#if>
<#if w.hasElementsOfType("item")>
        ${JavaModName}Items.register(registries);
</#if>
<#if w.hasElementsOfType("item") || w.hasElementsOfType("block")>
        ${JavaModName}CreativeTabs.register(registries, text);
</#if>
<#if w.hasElementsOfType("command")>
        ${JavaModName}Commands.register(context);
</#if>
<#if w.hasElementsOfType("procedure")>
        ${JavaModName}Procedures.register();
</#if>
        ${JavaModName}Data.register(context);
        ${JavaModName}Events.register(context);
        ${JavaModName}Keybinds.register(context);
        ${JavaModName}Client.register(context);
        ${JavaModName}Config.register(context);
        ${JavaModName}Nbt.register(context);
        ${JavaModName}Recipes.register(context);
    }
}
