buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Flutter's required Gradle plugin
        classpath("com.android.tools.build:gradle:8.1.0") // check Flutter's supported version
        // Google services plugin
        classpath("com.google.gms:google-services:4.4.2")
    }
}


allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
