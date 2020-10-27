package org.devio.flutter.hybrid;

import androidx.appcompat.app.AppCompatActivity;
import io.flutter.embedding.android.FlutterActivity;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        final EditText paramInput = findViewById(R.id.paramInput);
        findViewById(R.id.jump).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                String inputParams = paramInput.getText().toString().trim();
                FlutterAppActivity.start(MainActivity.this, inputParams);
//                startActivity(
//                    FlutterActivity
//                        .withNewEngine()
//                        .initialRoute("route1")
//                        .build(MainActivity.this)
//                );
            }
        });
    }
}
