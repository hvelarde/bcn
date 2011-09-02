package mx.croma.news.android;

import android.app.TabActivity;
import android.content.Intent;
import android.content.res.Resources;
import android.os.Bundle;
import android.util.Log;
import android.widget.TabHost;

public class CromaNews extends TabActivity {
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

		Resources res = getResources(); // Resource object to get Drawables
		TabHost tabHost = getTabHost();
		TabHost.TabSpec spec; // Resusable TabSpec for each tab
		Intent intent; // Reusable Intent for each tab

		// Create an Intent to launch an Activity for the tab (to be reused)
		intent = new Intent().setClass(this, IndicadoresEconomicos.class);

		// Initialize a TabSpec for each tab and add it to the TabHost
		spec = tabHost
				.newTabSpec("indicadores")
				.setIndicator("Indicadores",
						res.getDrawable(R.drawable.ic_indicadores))
				.setContent(intent);

		tabHost.addTab(spec);

		intent = new Intent().setClass(this, ListaNoticias.class);
		// Do the same for the other tabs
		// intent = new Intent().setClass(this, ConferenciasActivity.class);
		spec = tabHost
				.newTabSpec("conferencia")
				.setIndicator("Conferencias",
						res.getDrawable(R.drawable.ic_conferencias))
				.setContent(
						intent.putExtra("__categoria__", "Video Conferencias"));
		tabHost.addTab(spec);
		intent = new Intent().setClass(this, ListaNoticias.class);
		// intent = new Intent().setClass(this, NotasActivity.class);
		spec = tabHost
				.newTabSpec("notas")
				.setIndicator("Notas", res.getDrawable(R.drawable.ic_notas))
				.setContent(intent.putExtra("__categoria__", "Notas de Prensa"));
		tabHost.addTab(spec);
		intent = new Intent().setClass(this, ListaNoticias.class);
		// intent = new Intent().setClass(this, ConferenciasActivity.class);
		spec = tabHost
				.newTabSpec("Favoritos")
				.setIndicator("Favoritos",
						res.getDrawable(R.drawable.ic_favoritos))
				.setContent(intent.putExtra("__categoria__", "Favoritos"));
		tabHost.addTab(spec);
		intent = new Intent().setClass(this, ListaNoticias.class);
		// intent = new Intent().setClass(this, RecienteActivity.class);
		spec = tabHost
				.newTabSpec("publicaciones")
				.setIndicator("Documentos",
						res.getDrawable(R.drawable.ic_publicaciones))
				.setContent(intent.putExtra("__categoria__", "Documentos"));
		tabHost.addTab(spec);
		spec = tabHost
				.newTabSpec("recientes")
				.setIndicator("Recientes",
						res.getDrawable(R.drawable.ic_reciente))
				.setContent(intent.putExtra("__categoria__", "Recientes"));
		tabHost.addTab(spec);
		tabHost.setCurrentTab(getIntent().getExtras().getInt("index"));
	}
}