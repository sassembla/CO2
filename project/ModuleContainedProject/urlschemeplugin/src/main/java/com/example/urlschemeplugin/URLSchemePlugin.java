package com.example.urlschemeplugin;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.unity3d.player.UnityPlayer;
import com.unity3d.player.UnityPlayerActivity;

import java.io.File;
import java.io.FileOutputStream;


public class URLSchemePlugin extends Activity {

    // URLSchemeからの起動時Activity
    private static Activity bootActivity;
    private static String schemeData;

    //
    private Handler bootMainActivityAndSendMessageToUnity = new Handler() {
        @Override
        public void handleMessage(Message msg) {
            if (bootActivity != null) {
                Intent i = new Intent(bootActivity.getApplication(), UnityPlayerActivity.class);
                bootActivity.startActivity(i);
                bootActivity.finish();
                bootActivity = null;

                // ここでSendMessageを実行
                UnityPlayer.UnitySendMessage("AutoyaMainthreadDispatcher", "OnNativeEvent", "URLScheme:" + schemeData);
            }
        }
    };

    // 生成時
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Uri data = getIntent().getData();
        schemeData = data.toString();

        // autoyascheme:// + params.

        // ファイルの保存
        String basePath = this.getApplicationContext().getExternalFilesDir(null).getPath();
        String fileContents = "URLScheme:" + schemeData;


        try {
            FileOutputStream outputStream;

            File folder = new File(basePath);
            boolean createDir = folder.mkdirs();
//            System.out.println("path:" + folder.getAbsolutePath() + " createDir:" + createDir);

            File path = new File(basePath, "URLSchemeFile");
            boolean fileMake = path.createNewFile();

//            for (final File fileEntry : folder.listFiles()) {
//                if (fileEntry.isDirectory()) {
//                    System.out.println("dir:" + fileEntry.getName());
//                } else {
//                    System.out.println("file:" + fileEntry.getName());
//                }
//            }

            //openFileOutput なんとこのメソッドはパスを指定できない。
//            outputStream = this.getBaseContext().openFileOutput(basePath + "/URLSchemeFile", Context.MODE_PRIVATE);

            outputStream = new FileOutputStream(basePath + "/URLSchemeFile");
            outputStream.write(fileContents.getBytes());
            outputStream.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 起動時アクティビティを保持
        bootActivity = this;

        // 時間差で別のActivityを起動
        bootMainActivityAndSendMessageToUnity.sendEmptyMessageDelayed(0, 1);
    }

}