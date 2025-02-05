import java.net.URL
import java.nio.file.Files
import java.nio.file.StandardCopyOption

plugins {
    kotlin("android")
    kotlin("kapt")
    id("com.android.application")

//    kotlin("jvm") version "1.8.10" // 使用兼容的 Kotlin 版本

}

dependencies {
    compileOnly(project(":hideapi"))
    implementation(project(":core"))
    implementation(project(":service"))
    implementation(project(":design"))
    implementation(project(":common"))

    implementation(libs.kotlin.coroutine)
    implementation(libs.androidx.core)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.fragment)
    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.coordinator)
    implementation(libs.androidx.recyclerview)
    implementation(libs.google.material)


    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.10.0")

    // https://mvnrepository.com/artifact/androidx.appcompat/appcompat

//    implementation(files("libs/appcompat-1.7.0.aar"))

//    implementation("im.crisp:crisp-sdk:2.0.5")

    //    implementation("im.crisp:crisp-sdk:2.0.5")
    // If you're using AndroidX
    //implementation("androidx.multidex:multidex:2.0.1")
    // If you're not using AndroidX
    //implementation ("com.android.support:multidex:1.0.3")

//    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.6.2")
}

tasks.getByName("clean", type = Delete::class) {
    delete(file("release"))
}

val geoFilesDownloadDir = "src/main/assets"

task("downloadGeoFiles") {

    val geoFilesUrls = mapOf(
        "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geoip.metadb" to "geoip.metadb",
        "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/geosite.dat" to "geosite.dat",
        // "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/country.mmdb" to "country.mmdb",
        "https://github.com/MetaCubeX/meta-rules-dat/releases/download/latest/GeoLite2-ASN.mmdb" to "ASN.mmdb",
    )

    doLast {
        geoFilesUrls.forEach { (downloadUrl, outputFileName) ->
            val url = URL(downloadUrl)
            val outputPath = file("$geoFilesDownloadDir/$outputFileName")

            // Check if the file already exists
            if (!outputPath.exists()) {
                println("Downloading $outputFileName from $downloadUrl")

                outputPath.parentFile.mkdirs()
                url.openStream().use { input ->
                    Files.copy(input, outputPath.toPath(), StandardCopyOption.REPLACE_EXISTING)
                    println("$outputFileName downloaded to $outputPath")
                }

            }else{

                println("$outputFileName already exists at $outputPath, skipping download")

            }

        }
    }
}

afterEvaluate {
    val downloadGeoFilesTask = tasks["downloadGeoFiles"]

    tasks.forEach {
        if (it.name.startsWith("assemble")) {
            it.dependsOn(downloadGeoFilesTask)
        }
    }
}

tasks.getByName("clean", type = Delete::class) {
    delete(file(geoFilesDownloadDir))
}
android {
    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
        getByName("debug") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}
