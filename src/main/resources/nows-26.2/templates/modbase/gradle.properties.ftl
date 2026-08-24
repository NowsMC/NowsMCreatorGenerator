org.gradle.jvmargs=-Xmx2G -Dfile.encoding=UTF-8
org.gradle.parallel=true

minecraft_version=${generator.getGeneratorMinecraftVersion()}
nows_version=${generator.getGeneratorBuildFileVersion()}
mod_id=${modid}
mod_name=${settings.getModName()}
mod_version=${settings.getCleanVersion()}
mod_description=${settings.getDescription()}
mod_author=${settings.getAuthor()}
mod_license=${settings.getLicense()}
mod_icon=<#if settings.getModPicture()?has_content>logo.png</#if>
mod_homepage=${settings.getWebsiteURL()}
mod_sources=
mod_issues=
