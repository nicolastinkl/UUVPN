plugins {
    kotlin("android")
    kotlin("kapt")
    id("com.android.library")
}

dependencies {


    implementation("com.airbnb.android:lottie:6.5.2")
//    implementation("androidx.cardview:cardview:1.0.0")

    implementation(project(":common"))
    implementation(project(":core"))
    implementation(project(":service"))

    implementation(libs.kotlin.coroutine)
    implementation(libs.androidx.core)
    implementation(libs.androidx.appcompat)
    implementation(libs.androidx.activity)
    implementation(libs.androidx.coordinator)
    implementation(libs.androidx.recyclerview)
    implementation(libs.androidx.fragment)
    implementation(libs.androidx.viewpager)
    implementation(libs.google.material)


    implementation("com.squareup.retrofit2:retrofit:2.9.0")
    implementation("com.squareup.retrofit2:converter-gson:2.9.0")
    implementation("com.squareup.okhttp3:logging-interceptor:4.10.0")

    implementation("androidx.swiperefreshlayout:swiperefreshlayout:1.1.0")

    implementation("com.github.bumptech.glide:glide:4.16.0")
    annotationProcessor("com.github.bumptech.glide:compiler:4.15.1")
    
}
