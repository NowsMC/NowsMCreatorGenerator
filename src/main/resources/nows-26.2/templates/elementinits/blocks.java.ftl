package ${package}.init;

import space.nows.mc.api.registry.BlockMaterial;
import space.nows.mc.api.registry.BlockSpec;
import space.nows.mc.api.registry.ItemSpec;
import space.nows.mc.api.registry.RegistryApi;

public final class ${JavaModName}Blocks {
<#list blocks as block>
    public static final String ${block.getModElement().getRegistryNameUpper()} = "${modid}:${block.getModElement().getRegistryName()}";
</#list>

    private ${JavaModName}Blocks() {
    }

    public static void register(RegistryApi registries) {
<#list blocks as block>
        registries.registerBlockWithItem(BlockSpec.builder(${block.getModElement().getRegistryNameUpper()})
                .material(BlockMaterial.${blockMaterial(block)})
                .strength(${block.hardness!1.0}F, ${block.resistance!1.0}F)
<#if block.requiresCorrectTool!false>
                .requiresCorrectTool()
</#if>
<#if block.hasTransparency!false>
                .noOcclusion()
</#if>
                .item(ItemSpec.builder(${block.getModElement().getRegistryNameUpper()})
                        .maxStackSize(${block.maxStackSize!64})
<#if block.immuneToFire!false>
                        .fireResistant()
</#if>
                        .build())
                .build());
</#list>
    }
}

<#function blockMaterial block>
    <#assign base = (block.blockBase!"")?upper_case>
    <#assign sound = (block.soundOnStep!"STONE")?upper_case>
    <#if base?contains("PLANT") || base?contains("CROP") || base?contains("FLOWER") || sound?contains("GRASS")>
        <#return "PLANT">
    <#elseif sound?contains("WOOD") || base?contains("WOOD") || base?contains("FENCE") || base?contains("DOOR")>
        <#return "WOOD">
    <#elseif sound?contains("METAL") || base?contains("IRON")>
        <#return "METAL">
    <#elseif sound?contains("GLASS") || base?contains("GLASS")>
        <#return "GLASS">
    <#elseif sound?contains("GRAVEL") || sound?contains("SAND") || sound?contains("DIRT")>
        <#return "DIRT">
    <#else>
        <#return "STONE">
    </#if>
</#function>
