plugins {
    `java-library`
}

group = "space.nows"
version = providers.gradleProperty("plugin_version").orElse("development").get()

val mcreatorVersion = providers.gradleProperty("mcreator_version").orElse("2026.2")
val minecraftVersion = providers.gradleProperty("minecraft_version").orElse("26.2")
val pluginVersion = providers.gradleProperty("plugin_version").orElse("2026.2-0.2.1")
val nowsVersion = providers.gradleProperty("nows_version").orElse("0.9.1")
base {
    archivesName.set("nows-mcreator-generator")
}

java {
    toolchain.languageVersion.set(JavaLanguageVersion.of(25))
}
// The MCreator Java plugin API is not published as a Maven artifact. Keep tiny
// compile-only API stubs in a separate source set so normal/release builds do
// not need a checkout of the entire MCreator repository. The stubs are never
// packaged; MCreator provides the real classes at runtime.
val mcreatorApi = sourceSets.create("mcreatorApi") {
    java.srcDir("src/mcreatorApi/java")
}
sourceSets.named("main") {
    compileClasspath += mcreatorApi.output
}
tasks.named<JavaCompile>("compileJava") {
    dependsOn(tasks.named("compileMcreatorApiJava"))
}
tasks.withType<JavaCompile>().configureEach {
    options.encoding = "UTF-8"
    options.release.set(17)
}

tasks.withType<AbstractArchiveTask>().configureEach {
    isPreserveFileTimestamps = false
    isReproducibleFileOrder = true
}
tasks.processResources {
    // MCreator 2026.2 derives GeneratorFlavor from the first segment of the
    // generator resource directory. NOWS is not a built-in flavor, so the
    // generator remains FABRIC-compatible internally. NowsMCreatorPlugin adds
    // a dedicated "Nows mod" workspace entry and keeps Nows hidden from the
    // normal Fabric selector.
    val sourceGeneratorPath = "nows-${minecraftVersion.get()}/"
    val mcreatorGeneratorPath = "fabric-${minecraftVersion.get()}-nows/"
    eachFile {
        if (path.startsWith(sourceGeneratorPath)) {
            path = mcreatorGeneratorPath + path.removePrefix(sourceGeneratorPath)
        }
    }

    filesMatching("plugin.json") {
        expand(
            "mcreatorVersion" to mcreatorVersion.get(),
            "minecraftVersion" to minecraftVersion.get(),
            "pluginVersion" to pluginVersion.get(),
            "supportedVersion" to mcreatorSupportedVersion(mcreatorVersion.get())
        )
    }
}
tasks.jar {
    archiveFileName.set("generator-nows-${minecraftVersion.get()}-${mcreatorVersion.get()}.zip")
}

tasks.register<Copy>("copyPlugin") {
    dependsOn(tasks.jar)
    from(tasks.jar.flatMap { it.archiveFile })
    into(layout.buildDirectory)
}

tasks.register<Zip>("exportPlugin") {
    group = "mcreator_plugins"
    description = "Builds the Nows MCreator generator + Java integration plugin ZIP."
    dependsOn(tasks.jar, tasks.named("copyPlugin"))
    from(zipTree(tasks.jar.flatMap { it.archiveFile }))
    archiveFileName.set("generator-nows-${minecraftVersion.get()}-${mcreatorVersion.get()}.zip")
    destinationDirectory.set(layout.buildDirectory.dir("distributions"))
}
fun mcreatorSupportedVersion(version: String): String {
    val parts = version.split(".")
    require(parts.size >= 2) { "MCreator version must be at least major.minor, got $version" }
    val base = parts[0] + parts[1].padStart(3, '0')
    return if (parts.size == 2) base else base + parts.drop(2).joinToString("")
}
