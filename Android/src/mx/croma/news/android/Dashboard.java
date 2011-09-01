package mx.croma.news.android;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;


public class Dashboard extends Activity {

	@Override
	public void onCreate(Bundle bundle){
		super.onCreate(bundle);
		setContentView(R.layout.dashboard);
	
		
		OnClickListener listener=new OnClickListener(){
			public void onClick(View view){
				Intent intent=new Intent(Dashboard.this, CromaNews.class);
				int index=0;
				if(view.getId()==R.id.btnIndicadores)
					index=0;
				else if(view.getId()==R.id.btnConferencias)
					index=1;
				else if(view.getId()==R.id.btnNotas)
					index=2;
				else if(view.getId()==R.id.btnReciente)
					index=3;
				else if(view.getId()==R.id.btnPublicaciones)
					index=4;
				
				intent.putExtra("index",index);
				
				startActivity(intent);
			}};
		
		ImageButton btnIndicadores=(ImageButton)findViewById(R.id.btnIndicadores);
		btnIndicadores.setOnClickListener(listener);
		ImageButton btnPublicaciones=(ImageButton)findViewById(R.id.btnPublicaciones);
		btnPublicaciones.setOnClickListener(listener);
		ImageButton btnNotas=(ImageButton)findViewById(R.id.btnNotas);
		btnNotas.setOnClickListener(listener);
		ImageButton btnConferencias=(ImageButton)findViewById(R.id.btnConferencias);
		btnConferencias.setOnClickListener(listener);
		ImageButton btnReciente=(ImageButton)findViewById(R.id.btnReciente);
		btnReciente.setOnClickListener(listener);
		
	}
}
