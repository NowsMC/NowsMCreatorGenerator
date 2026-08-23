{
  "type": "minecraft:crafting_shapeless",
  "ingredients": [
<#if data.ingredients?? && data.ingredients?has_content>
<#list data.ingredients as ingredient>
    { "item": "${ingredient}" }<#sep>,
</#list>
<#else>
    { "item": "minecraft:stone" }
</#if>
  ],
  "result": {
    "id": "${modid}:${registryname}",
    "count": <#if data.recipeRetstackSize??>${data.recipeRetstackSize}<#else>1</#if>
  }
}
