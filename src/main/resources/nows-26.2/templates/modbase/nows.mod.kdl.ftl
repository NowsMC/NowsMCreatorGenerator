mod id="${modid}" name="${settings.getModName()}" version="${settings.getCleanVersion()}" minecraft="${generator.getGeneratorMinecraftVersion()}" side="<#if settings.isServerSideOnly()>server<#else>client</#if>" {
    info {
        description "${settings.getDescription()}"
        author "${settings.getAuthor()}"
        license "${settings.getLicense()}"
        icon "<#if settings.getModPicture()?has_content>logo.png</#if>"
    }

    links {
        homepage "${settings.getWebsiteURL()}"
        sources ""
        issues ""
    }

    compatibility {
        requires "minecraft" version="${generator.getGeneratorMinecraftVersion()}"
        requires "nows" version="${generator.getGeneratorBuildFileVersion()}"
    }

    runtime {
        entrypoint "${package}.${JavaModName}"
        mixin "${modid}.mixins.json"
        listener "${package}.${JavaModName}LifecycleListener"
    }
}
