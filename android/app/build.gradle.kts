plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
val releaseStoreFile = keystoreProperties.getProperty("storeFile")
val hasCompleteReleaseSigning = keystorePropertiesFile.isFile &&
    listOf("storePassword", "keyPassword", "keyAlias").all { key ->
        !keystoreProperties.getProperty(key).orEmpty().trim().isEmpty()
    } &&
    !releaseStoreFile.isNullOrBlank() &&
    rootProject.file(releaseStoreFile!!).isFile
val validateReleaseSigning = tasks.register("validateReleaseSigning") {
    doLast {
        if (!hasCompleteReleaseSigning) {
            throw GradleException(
                "Production Android release signing is unavailable. " +
                    "Inject android/key.properties with a real keystore before building release variants."
            )
        }
    }
}

android {
    namespace = "com.hable.app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "28.2.13676358" // Recommended highest version from plugins

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        resValues = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.hable.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    flavorDimensions += "version"

    productFlavors {
        create("primary") {
            dimension = "version"
            applicationIdSuffix = ".primary"
            resValue("string", "app_name", "Hable Primary")
        }
        create("friend") {
            dimension = "version"
            applicationIdSuffix = ".friend"
            resValue("string", "app_name", "Hable Friend")
        }
    }

    signingConfigs {
        if (hasCompleteReleaseSigning) {
            create("release") {
                keyAlias = keystoreProperties["keyAlias"] as String?
                keyPassword = keystoreProperties["keyPassword"] as String?
                storeFile = keystoreProperties["storeFile"]?.let { file(it as String) }
                storePassword = keystoreProperties["storePassword"] as String?
            }
        }
    }

    buildTypes {
        release {
            if (hasCompleteReleaseSigning) {
                signingConfig = signingConfigs.getByName("release")
            } else {
                signingConfig = null
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

tasks.configureEach {
    if (name.matches(Regex("^(assemble|bundle|package).*Release$"))) {
        dependsOn(validateReleaseSigning)
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
    releaseImplementation(project(":integration_test"))
}
