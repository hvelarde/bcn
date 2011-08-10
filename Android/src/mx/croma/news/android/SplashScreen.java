package mx.croma.news.android;

import mx.croma.news.android.core.CromaFeedLoader;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.widget.ProgressBar;

public class SplashScreen extends Activity {
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.splash);
		//cargaNoticias();
	}
	
	@Override
	public void onResume(){
		super.onResume();
		cargaNoticias();
	}
	
	public void cargaNoticias(){
		ProgressBar progreso = (ProgressBar)findViewById(R.id.progressMain);
		progreso.setProgress(10);
		Runnable r = new CromaFeedLoader(this, getResources(), progreso);
		final Handler handler = new Handler();
	    handler.postDelayed(r, 3000);
		
	}
	
	public void cargaLista(){
		startActivity(new Intent(this, PantallaBotones.class));
		finish();
	}
	
	
}
