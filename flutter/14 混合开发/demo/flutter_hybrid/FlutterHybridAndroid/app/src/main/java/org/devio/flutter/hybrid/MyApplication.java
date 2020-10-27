package org.devio.flutter.hybrid;

import android.app.Application;

import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.embedding.engine.FlutterEngineCache;
import io.flutter.embedding.engine.dart.DartExecutor;

public class MyApplication extends Application {
    public static final String CACHED_ENGINE_ID = "MY_CACHED_ENGINE_ID";

    @Override
    public void onCreate() {
        super.onCreate();
        //在MyApplication中预先初始化Flutter引擎以提升Flutter页面打开速度
        FlutterEngine flutterEngine = new FlutterEngine(this);

        // Start executing Dart code to pre-warm the FlutterEngine.
        flutterEngine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint.createDefault());
        // Cache the FlutterEngine to be used by FlutterActivity.
        FlutterEngineCache.getInstance().put(CACHED_ENGINE_ID, flutterEngine);
    }
}