package ru.vizvamitra.p01.loclog;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;
import java.util.concurrent.TimeUnit;

import android.content.Context;
import android.content.Intent;
import android.content.res.Resources.NotFoundException;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;

public class LocLogService extends Service {
	
	private NotificationManager nm;
	private Notification notif;	
	private Intent intent;
	private PendingIntent pIntent;
	
	final String LOG_TAG = "LocLog_LOGS";
	final int ERROR_NOTIF = 1;
	final int RUNNING_NOTIF = 2;
	
	private boolean stopFlag = false;
	private boolean logTaskCreated = false;
	
	private File log_file;
	private FileWriter writer;
	
	private LocationManager locManager;
	StringBuilder sbGPS = new StringBuilder();
	StringBuilder sbNet = new StringBuilder();
	private String locString;

	public void onCreate() {
	    super.onCreate();
	    
	    nm = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
		intent = new Intent(this, Main.class);
		pIntent = PendingIntent.getActivity(this, 0, intent, 0);
		
		openLogFile();
	}
	  
	public int onStartCommand(Intent intent, int flags, int startId) {
		startForeground(RUNNING_NOTIF, createNotif("Logging your location...", R.drawable.ic_launcher));
	    Log.d(LOG_TAG, "onStartCommand");
	    if (!logTaskCreated) {
	    	createTask();
	    	logTaskCreated = true;
	    }
	    
	    locString = "";
	    locManager = (LocationManager) getSystemService(LOCATION_SERVICE);
	    
	    locManager.requestLocationUpdates(LocationManager.GPS_PROVIDER,
            1000 * 10, 10, locListener);
        locManager.requestLocationUpdates(
            LocationManager.NETWORK_PROVIDER, 1000 * 10, 10,
            locListener);
        
	    return super.onStartCommand(intent, flags, startId);
	}

	public void onDestroy() {
	    super.onDestroy();
	    stopFlag = true;
	    Log.d(LOG_TAG, "onDestroy");
	}

	public IBinder onBind(Intent intent) {
	    return null;
	}
	  
	private void createTask() {
		new Thread(new Runnable() {
			public void run() {
				try {
					enterLoop();
					
					onTaskEnd();
				}
				catch (Throwable e) { onError(); }
			}
		}).start();
	}
	
	private Notification createNotif(String text, int icon){
		notif = new Notification(icon, text, System.currentTimeMillis());
		notif.setLatestEventInfo(this, "LocLog service", text, pIntent);
		return notif;
	}
	
	private void enterLoop(){
		int i = 0;
		while (!stopFlag) {
			try {
				if (!log_file.exists()) throw new IOException();
				
//				if (locString != ""){
//					writer.write(getOutputString() + "\n");
//					writer.flush();
//				}
			} catch (IOException e1) {
				// ДОБАВЬ ОБРАБОТКУ ИСКЛЮЧЕНИЯ ПРИ НЕВОЗМОЖНОСТИ ЗАПИСИ!
				Log.d(LOG_TAG, "exception!");
				if (!log_file.exists()){
					openLogFile();
				}
				e1.printStackTrace();
			}

			i++;
		    try {
		    	TimeUnit.SECONDS.sleep(1);
		    } catch (InterruptedException e) {
		    	// ДОБАВЬ ОБРАБОТКУ ИСКЛЮЧЕНИЯ ПРИ НЕВОЗМОЖНОСТИ ПОСПАТЬ!
		    	e.printStackTrace();
		    }
	    }
	}
	
	private void onTaskEnd(){
		try { 
			writer.close();
		} catch (Throwable e) { e.printStackTrace(); }
		
		logTaskCreated = false;
		
		stopForeground(true);
		stopSelf();
	}
	
	private void openLogFile(){
		try {
			boolean newlyCreated = false;
			log_file = new File(getFilesDir()+"/"+getResources().getString(R.string.log_file_name));
			if (!log_file.exists()){
				log_file.createNewFile();
				newlyCreated = true;
			}
			writer = new FileWriter(log_file, true);
			
			if (newlyCreated){
				writer.write("date,latitude,longitude,provider\n");
				writer.flush();
			}
		}
		catch (Throwable e) { onError(); }
	}
	
	private void onError(){
		nm.notify(ERROR_NOTIF, createNotif("Error was detected, service stopped!", R.drawable.error));
		
		onTaskEnd();
	}
	
	private String getOutputString(){
		//return getCurrentTimeString() + "," + getGPSString();
		return locString;
	}
	
//	private String getTimeString(){
//		//return String.valueOf(System.currentTimeMillis());
//		return getCurrentTimeString();
//	}
	
	private String getGPSString(){
		return locString;
	}
	
	private LocationListener locListener = new LocationListener() {
		
		@Override
		public void onStatusChanged(String provider, int status, Bundle extras) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onProviderEnabled(String provider) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onProviderDisabled(String provider) {
			// TODO Auto-generated method stub
			
		}
		
		@Override
		public void onLocationChanged(Location location) {
			// TODO Auto-generated method stub
			if (location != null){
				locString = formatLocation(location);
				try {
					writer.write(getOutputString() + "\n");
					writer.flush();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	};
	
	private String formatLocation(Location location) {
		String out = String.format(Locale.US,
//    		"lat = %1$.4f, lon = %2$.4f",
//	        location.getLatitude(), location.getLongitude());
	        "%1$tF %1$tT,%2$.6f,%3$.6f", // da-t-e t:im:e,lat,lon
	        new Date(location.getTime()),
	        location.getLatitude(),
	        location.getLongitude());
	    if (location.getProvider().equals(LocationManager.GPS_PROVIDER)){
	    	out+=",GPS";
	    }
	    else if (location.getProvider().equals(LocationManager.NETWORK_PROVIDER)){
	    	out+=",NET";
	    }
	    
	    return out;
	}
	
	
	///// TEST /////
	
	private String getCurrentTimeString(){
		SimpleDateFormat sdt = new SimpleDateFormat("dd/MM/yy HH:mm:ss");
		Calendar cal = Calendar.getInstance();
		return sdt.format(cal.getTime());
	}
	
	
	///// OLD /////
	
//	private void removeNotif(){
//		nm.cancel(1);
//	}
	
//	private void createNotif(String text, boolean no_clear){
//		notif = new Notification(R.drawable.ic_launcher, text, System.currentTimeMillis());
//		notif.setLatestEventInfo(this, "LocLog service", text, pIntent);
//		
//		if (no_clear) notif.flags |= Notification.FLAG_NO_CLEAR;
//		
//		nm.notify(1, notif);
//	}
}