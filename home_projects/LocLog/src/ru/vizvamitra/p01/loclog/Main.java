package ru.vizvamitra.p01.loclog;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.app.Activity;
import android.app.Notification;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Resources.NotFoundException;
import android.text.InputFilter;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.widget.TextView;
import android.widget.Toast;

public class Main extends Activity {

	private Toast informationToast;
	final String LOG_TAG = "LocLog_LOGS";
	
	private Intent intent;
	private PendingIntent pIntent;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		
		informationToast = Toast.makeText(this, "", Toast.LENGTH_SHORT);
		SharedPreferences prefs = getSharedPreferences("LocLog", 0);
		
		intent = new Intent(this, Main.class);
		pIntent = PendingIntent.getActivity(this, 0, intent, 0);
		
		if (prefs.getBoolean("initialized", false)) {
			initialize();
		}
	}

	public void onClickStart(View v){
		startService(new Intent(this, LocLogService.class));
		showToast("Service started");
	}
	
	public void onClickStop(View v){
		stopService(new Intent(this, LocLogService.class));
		showToast("Service stopped");
	}
	
	public void onClickEmail(View v){
		//showToast("Email sending imitation");
		if ( !isSDCardMounted() ){
			showToast("SD-card is unreachable.");
		} else {
			deleteExternalLogFile();
			copyNewLogFile();			
			sendEmail();
		}
	}
	
	public void onClickDeleteLog(View v){
		File logfile = new File(getFilesDir()+"/"+getResources().getString(R.string.log_file_name));
		logfile.delete();
		showToast("Log file was deleted");
	}
	
	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		// Inflate the menu; this adds items to the action bar if it is present.
		getMenuInflater().inflate(R.menu.main, menu);
		return true;
	}
	
	private void showToast(String text) {
		//informationToast.cancel();
		informationToast.setText(text);
		informationToast.show();
	}
	
	private String getCurrentTimeString(){
		SimpleDateFormat sdt = new SimpleDateFormat("HH:mm:ss dd/MM/yy Z");
		Calendar cal = Calendar.getInstance();
		return sdt.format(cal.getTime());
	}
	
	private void sendEmail(){
		final Intent emailIntent = new Intent(android.content.Intent.ACTION_SEND);
		
		emailIntent.setType("plain/text");
		//emailIntent.putExtra(Intent.EXTRA_EMAIL, new String[] {"vizvamitra@gmail.com"}); // vizvamitra@gmail.com
		emailIntent.putExtra(Intent.EXTRA_SUBJECT, getResources().getString(R.string.email_subject));
		emailIntent.putExtra(Intent.EXTRA_TEXT, getResources().getString(R.string.email_body) + " " + getCurrentTimeString());
		emailIntent.putExtra(
	            Intent.EXTRA_STREAM,
	            Uri.parse("file://"
	            	+ Environment.getExternalStorageDirectory()
	            	+ "/LocLog/"
	                + getResources().getString(R.string.log_file_name)));
		
		try {
			Main.this.startActivity(Intent.createChooser(emailIntent, "Отправка лога..."));
		} catch (android.content.ActivityNotFoundException ex) {
			showToast("There are no email clients installed.");
		}
	}
	
	private void copyNewLogFile(){
		try {
			// opening input log file
			InputStream in = new FileInputStream(getFilesDir()+"/"+getResources().getString(R.string.log_file_name));
			
			// creating and opening output log file
			File logfile = new File(Environment.getExternalStorageDirectory()
					+ "/LocLog/"
					+ getResources().getString(R.string.log_file_name));
			logfile.createNewFile();
			logfile.setReadable(true);
			logfile.setWritable(true);
			OutputStream out = new FileOutputStream(logfile);
			
			byte[] buf = new byte[1024];
			int len;
			while ((len = in.read(buf)) > 0) {
		        out.write(buf, 0, len);
		    }
		    in.close();
		    out.close();
		} catch (Throwable e){
			e.printStackTrace();
		}
	}
	
	private void deleteExternalLogFile(){
		File logfile = new File (Environment.getExternalStorageDirectory() + "/LocLog/"
			+ getResources().getString(R.string.log_file_name));
		logfile.delete();
	}
	
	private boolean isSDCardMounted(){
		return (Environment.MEDIA_MOUNTED).equals(Environment.getExternalStorageState()) && Environment.isExternalStorageRemovable();
	}
	
	private void initialize(){
		try {
			// creating internal log file
			OutputStream log_file = openFileOutput(getResources().getString(R.string.log_file_name), MODE_PRIVATE);
			log_file.close();
			
			// creating external log directory (if doesn't exist)
			File dir = new File(Environment.getExternalStorageDirectory() + "/LocLog/");
			dir.mkdirs();
			dir.setReadable(true);
			dir.setWritable(true);
			
			SharedPreferences prefs = getSharedPreferences("LocLog", 0);
			SharedPreferences.Editor editor = prefs.edit();
			editor.putBoolean("initialized", true);
		} catch (Throwable e) {
			Log.d(LOG_TAG, "ERROR: can't initialize!");
		}
	}
	
	private Notification createNotif(String text){
		Notification notif = new Notification(R.drawable.ic_launcher, text, System.currentTimeMillis());
		notif.setLatestEventInfo(this, "LocLog service", text, pIntent);
		return notif;		
	}
}
