allprojects {
    ext {
        set("appCompatVersion", "1.4.2")             // or higher / as desired
        set("playServicesLocationVersion", "21.3.0") // or higher / as desired
        set("tslocationmanagerVersion", "4.0.+")
        set("compileSdkVersion", 35)
    }
    repositories {
        // background_geolocation
        // [DEV] Sonatype SNAPSHOT url
        maven(url = "https://central.sonatype.com/repository/maven-snapshots/")
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

// development
allprojects {
    configurations.all {
        resolutionStrategy {
            cacheChangingModulesFor(0, "seconds")
            cacheDynamicVersionsFor(0, "seconds")
        }
    }
}

