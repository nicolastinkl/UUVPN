@file:Suppress("UNUSED_VARIABLE")

import com.android.build.gradle.AppExtension
import com.android.build.gradle.BaseExtension
import java.net.URL
import java.util.*

buildscript {
    repositories {
        mavenCentral()
        google()
        maven("https://raw.githubusercontent.com/MetaCubeX/maven-backup/main/releases")
    }
    dependencies {

        classpath(libs.build.android)
        classpath(libs.build.kotlin.common)
        classpath(libs.build.kotlin.serialization)
        classpath(libs.build.ksp)
        classpath(libs.build.golang)
    }
}

subprojects {
    repositories {
        mavenCentral()
        google()
        maven("https://raw.githubusercontent.com/MetaCubeX/maven-backup/main/releases")
    }

    val isApp = name == "app"

    apply(plugin = if (isApp) "com.android.application" else "com.android.library")

    extensions.configure<BaseExtension> {
        defaultConfig {
            if (isApp) {
                applicationId = "com.litevpn.fast"
            }

            multiDexEnabled = true
            minSdk = 24

            compileSdkVersion(34)
            targetSdkVersion(34)
            versionName = "3.1.0"
            versionCode = 323001

            resValue("string", "release_name", "v$versionName")
            resValue("integer", "release_code", "$versionCode")

            externalNativeBuild {
                cmake {

                    abiFilters("arm64-v8a", "armeabi-v7a",)
                }
            }

//            compileOptions{
//                isCoreLibraryDesugaringEnabled = false
//            }

            if (!isApp) {
                consumerProguardFiles("consumer-rules.pro")
            } else {
                setProperty("archivesBaseName", "UUVPN-$versionName")
            }
        }

//        ndkVersion = "23.0.7599858"
        ndkVersion = "27.0.12077973"
//        compileSdkVersion(defaultConfig.targetSdk!!)

        if (isApp) {
            packagingOptions {
                resources {
                    excludes.add("DebugProbesKt.bin")
                }
            }
        }

        productFlavors {
            flavorDimensions("feature")

            create("alpha") {
                isDefault = true
                dimension = flavorDimensionList[0]
                versionNameSuffix = ".Alpha"

                buildConfigField("boolean", "PREMIUM", "Boolean.parseBoolean(\"false\")")

                resValue("string", "launch_name", "UUVPN")
                resValue("string", "application_name", "UUVPN")

                if (isApp) {
                    applicationIdSuffix = ".alpha"
                }
            }

            create("meta") {

                dimension = flavorDimensionList[0]
               // versionNameSuffix = ".Meta"

                buildConfigField("boolean", "PREMIUM", "Boolean.parseBoolean(\"false\")")

                resValue("string", "launch_name", "UUVPN")//@string/launch_name_meta
                resValue("string", "application_name", "UUVPN")//@string/application_name_meta

                if (isApp) {
                   // applicationIdSuffix = ".meta"
                }
            }
        }

        sourceSets {
            getByName("meta") {
                java.srcDirs("src/foss/java")
            }
            getByName("alpha") {
                java.srcDirs("src/foss/java")
            }
        }

        signingConfigs {
            val keystore = rootProject.file("signing.properties")
            if (keystore.exists()) {
                create("release") {
                    val prop = Properties().apply {
                        keystore.inputStream().use(this::load)
                    }

                    storeFile = rootProject.file("release.keystore")
                    storePassword = prop.getProperty("keystore.password")!!
                    keyAlias = prop.getProperty("key.alias")!!
                    keyPassword = prop.getProperty("key.password")!!
                }
            }
        }

        buildTypes {
            named("release") {
                isMinifyEnabled = false
                isShrinkResources = false
                signingConfig = signingConfigs.findByName("release")
                proguardFiles(
                    getDefaultProguardFile("proguard-android-optimize.txt"),
                    "proguard-rules.pro"
                )
            }
            named("debug") {
               // versionNameSuffix = ".debug"
            }
        }

        buildFeatures.apply {
            dataBinding {
                isEnabled = name != "hideapi"
            }
        }

        if (isApp) {
            this as AppExtension

            splits {
                abi {
                    isEnable = true
                    isUniversalApk = true
                }
            }
        }
    }
}

task("clean", type = Delete::class) {
    delete(rootProject.buildDir)
}

tasks.wrapper {
    distributionType = Wrapper.DistributionType.ALL

    doLast {
        val sha256 = URL("$distributionUrl.sha256").openStream()
            .use { it.reader().readText().trim() }

        file("gradle/wrapper/gradle-wrapper.properties")
            .appendText("distributionSha256Sum=$sha256")
    }
}
