package org.devio.fluttertrip;

import android.os.Bundle;

import org.devio.flutter.plugin.asr.AsrPlugin;
import org.devio.flutter.splashscreen.SplashScreen;

import androidx.annotation.NonNull;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.plugins.shim.ShimPluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        //flutter sdk >= v1.17.0 时使用下面方法注册自定义plugin
        AsrPlugin.registerWith(this, flutterEngine.getDartExecutor().getBinaryMessenger());
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        SplashScreen.show(this, true);
        super.onCreate(savedInstanceState);
    }
}
