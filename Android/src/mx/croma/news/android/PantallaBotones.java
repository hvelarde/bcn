package mx.croma.news.android;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;

public class PantallaBotones extends Activity implements OnClickListener{

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.pantalla_botones);
		findViewById(R.id.btnConferencias).setOnClickListener(this);
		findViewById(R.id.btnIndEconomicos).setOnClickListener(this);
		findViewById(R.id.btnMarcadores).setOnClickListener(this);
		findViewById(R.id.btnNotas).setOnClickListener(this);
		findViewById(R.id.btnPublicaciones).setOnClickListener(this);
		findViewById(R.id.btnReciente).setOnClickListener(this);
	}

	public void onClick(View v) {
		if(v instanceof Button){
			int categoria = 0;
			switch(v.getId()){
			case R.id.btnConferencias:
				categoria = 1;
				break;	
			case R.id.btnNotas:
				categoria = 2;
				break;
			case R.id.btnPublicaciones:
				categoria = 4;
				break;
			case R.id.btnMarcadores:
				categoria = 3;
				break;
			}
			Intent i = new Intent(this, CromaNews.class);
				i.putExtra("__tabId__", categoria);
			startActivity(i);
			finish();
		}
	}
	
}
