import java.util.Properties

// Yayın imzası anahtarları depoya GİRMEZ: android/key.properties dosyası
// .gitignore'da. Dosya yoksa sürüm derlemesi hata vermez, debug anahtarıyla
// imzalanır — `flutter run --release` çalışmaya devam etsin diye. Ama o APK
// mağazaya yüklenemez.
val imzaOzellikleri = Properties().apply {
    val dosya = rootProject.file("key.properties")
    if (dosya.exists()) dosya.inputStream().use { load(it) }
}
val yayinImzasiVar = imzaOzellikleri.containsKey("storeFile")

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.furkanogutlu.hayat_kariyer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.furkanogutlu.hayat_kariyer"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (yayinImzasiVar) {
            create("release") {
                storeFile = file(imzaOzellikleri["storeFile"] as String)
                storePassword = imzaOzellikleri["storePassword"] as String
                keyAlias = imzaOzellikleri["keyAlias"] as String
                keyPassword = imzaOzellikleri["keyPassword"] as String
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (yayinImzasiVar) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro",
            )
        }
    }
}

flutter {
    source = "../.."
}
