{
  "type": "minecraft:stonecutting",
  "ingredient": {
    "item": "<#if data.cuttingInputStack??>${data.cuttingInputStack}<#else>minecraft:stone</#if>"
  },
  "result": {
    "id": "${modid}:${registryname}",
    "count": <#if data.recipeRetstackSize??>${data.recipeRetstackSize}<#else>1</#if>
  }
}
