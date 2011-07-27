package mx.croma.news.android;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;

public class CromaNews extends Activity {
	/** Called when the activity is first created. */
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		findViewById(R.id.btnNoticias).setOnClickListener(
				new View.OnClickListener() {

					public void onClick(View arg0) {
						Intent i = new Intent(getApplicationContext(),
								ListaNoticias.class);
						i.putExtra("_feed_",
								getResources().getString(R.string.feed_prensa));
						startActivity(i);
						finish();
					}
				});
		/**findViewById(R.id.btnNoticias2).setOnClickListener(
				new View.OnClickListener() {

					public void onClick(View arg0) {
						Intent i = new Intent(getApplicationContext(),
								ListaNoticias.class);
						i.putExtra("_feed_",
								getResources().getString(R.string.feed_warp));
						startActivity(i);
						finish();
					}
				});*/
	}
}