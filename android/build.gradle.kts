allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Plugin modules (e.g. :jni) otherwise default to an NDK that is not installed.
subprojects {
    // Runs after the plugin's own build.gradle, which sets flutter.ndkVersion.
    if (!project.state.executed) {
        project.afterEvaluate {
            project.extensions
                .findByType(com.android.build.api.dsl.LibraryExtension::class.java)
                ?.ndkVersion = "30.0.16248370"
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
