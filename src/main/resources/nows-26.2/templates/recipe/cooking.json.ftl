{
  "type": "minecraft:${cookingType(data.recipeType!'Smelting')}",
  "ingredient": {
    "item": "<#if data.cookingInputStack??>${data.cookingInputStack}<#else>minecraft:stone</#if>"
  },
  "result": {
    "id": "${modid}:${registryname}"
  },
  "experience": <#if data.xpReward??>${data.xpReward}<#else>0.0</#if>,
  "cookingtime": <#if data.cookingTime??>${data.cookingTime}<#else>200</#if>
}

<#function cookingType recipeType>
  <#if recipeType == "Blasting">
    <#return "blasting">
  <#elseif recipeType == "Smoking">
    <#return "smoking">
  <#elseif recipeType == "Campfire cooking">
    <#return "campfire_cooking">
  <#else>
    <#return "smelting">
  </#if>
</#function>
