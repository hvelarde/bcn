package mx.croma.news.android;

import android.app.Activity;
import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.view.View;
import android.widget.TabHost;

public class CromaNews extends TabActivity {
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
	//	findViewById(R.id.btnNoticias).setOnClickListener(
		//			new View.OnClickListener() {
		//
		//		public void onClick(View arg0) {
		//			Intent i = new Intent(getApplicationContext(),
		//					ListaNoticias.class);
		//			i.putExtra("_feed_",
		//					getResources().getString(R.string.feed_prensa));
		//			startActivity(i);
		//			finish();
		//		}
		//	});
		Resources res = getResources(); // Resource object to get Drawables
		TabHost tabHost = getTabHost();
		TabHost.TabSpec spec; // Resusable TabSpec for each tab
		Intent intent; // Reusable Intent for each tab

		// Create an Intent to launch an Activity for the tab (to be reused)
		intent = new Intent().setClass(this, ListaNoticias.class);

		// Initialize a TabSpec for each tab and add it to the TabHost
		spec = tabHost
				.newTabSpec("indicadores")
				.setIndicator("Indicadores",
						res.getDrawable(R.drawable.ic_indicadores))
				.setContent(intent);
		
		tabHost.addTab(spec);

		// Do the same for the other tabs
		//intent = new Intent().setClass(this, ConferenciasActivity.class);
		spec = tabHost
				.newTabSpec("conferencia")
				.setIndicator("Conferencias",
						res.getDrawable(R.drawable.ic_conferencias))
				.setContent(intent);
		tabHost.addTab(spec);

		//intent = new Intent().setClass(this, NotasActivity.class);
		spec = tabHost
				.newTabSpec("notas")
				.setIndicator("Notas", res.getDrawable(R.drawable.ic_notas))
				.setContent(intent);
		tabHost.addTab(spec);
		
		//intent = new Intent().setClass(this, ConferenciasActivity.class);
		spec = tabHost
				.newTabSpec("conferencia")
				.setIndicator("Conferencias", res.getDrawable(R.drawable.ic_conferencias))
				.setContent(intent);
		tabHost.addTab(spec);
		
		//intent = new Intent().setClass(this, RecienteActivity.class);
		spec = tabHost
				.newTabSpec("reciente")
				.setIndicator("Lo mas reciente", res.getDrawable(R.drawable.ic_reciente))
				.setContent(intent);
		tabHost.addTab(spec);

		tabHost.setCurrentTab(0);
	}
}