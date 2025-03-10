package com.example.scan_app

import android.net.Uri
import android.os.Build
import android.provider.MediaStore
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "gallery_manager"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "deleteImage" -> {
                    val uri = call.argument<String>("imageUri") ?: ""
                    if (uri.isNotEmpty()) {
                        val deleted = deleteImageFromGallery(uri)
                        result.success(deleted)
                    } else {
                        result.error("INVALID_URI", "URI không hợp lệ", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun deleteImageFromGallery(imageUri: String): Boolean {
        return try {
            val uri = Uri.parse(imageUri)
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                contentResolver.delete(uri, null, null) > 0
            } else {
                contentResolver.delete(uri, null, null)
                true
            }
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }
}
