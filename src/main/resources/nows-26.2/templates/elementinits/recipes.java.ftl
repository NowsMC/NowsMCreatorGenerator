package ${package}.init;

import space.nows.mc.api.MinecraftApi;
import space.nows.mc.api.recipe.RecipeViewerApi;
import space.nows.mc.api.registry.McItemStack;
import space.nows.platform.api.NowsContext;

public final class ${JavaModName}Recipes {
    private ${JavaModName}Recipes() {
    }

    public static void register(NowsContext context) {
        MinecraftApi.recipeViewer(context);
    }

    public static void registerCatalysts(NowsContext context) {
        RecipeViewerApi recipes = MinecraftApi.recipeViewer(context);
<#if w.hasElementsOfType("block")>
<#list blocks as block>
<#if block?index == 0>
        recipes.registerCatalyst("${modid}:main", MinecraftApi.registries(context)
                .itemStack(McItemStack.of(${JavaModName}Blocks.${block.getModElement().getRegistryNameUpper()})));
</#if>
</#list>
<#elseif w.hasElementsOfType("item")>
<#list items as item>
<#if item?index == 0>
        recipes.registerCatalyst("${modid}:main", MinecraftApi.registries(context)
                .itemStack(McItemStack.of(${JavaModName}Items.${item.getModElement().getRegistryNameUpper()})));
</#if>
</#list>
</#if>
    }
}
