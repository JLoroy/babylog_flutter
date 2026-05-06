import java.io.FileInputStream
import java.util.Properties
import org.gradle.api.JavaVersion

val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    FileInputStream(localPropertiesFile).use { stream ->
        localProperties.load(stream)
    }
}


val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    FileInputStream(keystorePropertiesFile).use { stream ->
        keystoreProperties.load(stream)
    }
}

val flutterRoot = localProperties.getProperty("flutter.sdk") ?: 
    throw GradleException("Flutter SDK not found. Define location with flutter.sdk in the local.properties file.")

val flutterVersionCode = localProperties.getProperty("flutter.versionCode")?.toInt() ?: 1
val flutterVersionName = localProperties.getProperty("flutter.versionName") ?: "1.0"

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.eranova.babylog"
    compileSdk = 35
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    lint {
        disable += "InvalidPackage"
    }

    
    signingConfigs {
        create("release") {
            // Prefer key.properties (android/key.properties) for local/CI portability.
            // Fallback to env vars when not provided.
            val storeFilePath = (keystoreProperties["storeFile"] as String?)
                ?: System.getenv("ERA_NOVA_ANDROID_STORE_FILE")
            val storePassword = (keystoreProperties["storePassword"] as String?)
                ?: System.getenv("ERA_NOVA_ANDROID_STORE_PASSWORD")
            val keyAlias = (keystoreProperties["keyAlias"] as String?)
                ?: System.getenv("ERA_NOVA_ANDROID_KEY_ALIAS")
                ?: "upload"
            val keyPassword = (keystoreProperties["keyPassword"] as String?)
                ?: System.getenv("ERA_NOVA_ANDROID_KEY_PASSWORD")
                ?: storePassword

            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            this.storePassword = storePassword
            this.keyAlias = keyAlias
            this.keyPassword = keyPassword
        }
    }


    defaultConfig {
        applicationId = "com.eranova.babylog"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutterVersionCode
        versionName = flutterVersionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
        }
    }
    
    buildFeatures {
        buildConfig = true
    }
}

flutter {
    source = "../.."
}

dependencies {
    val kotlinVersion = rootProject.extra.get("kotlinVersion") as String
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlinVersion")
    implementation(platform("com.google.firebase:firebase-bom:32.1.1"))
    implementation("com.google.firebase:firebase-analytics-ktx")
}
