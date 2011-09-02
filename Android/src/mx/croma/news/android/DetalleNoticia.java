package mx.croma.news.android;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import mx.croma.news.android.core.Noticia;
import mx.croma.news.android.db.FavoritosHelper;
import mx.croma.news.android.object.Publicacion;
import mx.croma.news.android.object.PublicacionStorage;
import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class DetalleNoticia extends Activity {

	private TextView _titulo;
	private TextView _detalle;
	private ImageView _imagen;
	private Noticia _noticia;
	private Publicacion _publicacion;

	@Override
	public boolean onCreateOptionsMenu(Menu menu) {
		MenuInflater inflater = getMenuInflater();
		inflater.inflate(R.menu.mmenu, menu);
		return true;
	}

	public boolean onOptionsItemSelected(MenuItem item) {
		switch (item.getItemId()) {

		case R.id.m_tweet:
			invoke_share("twitter");
			return true;
		case R.id.m_face:
			invoke_share("face");
			return true;
		case R.id.m_mail:
			invoke_share("mail");
			return true;

		default:
			return super.onOptionsItemSelected(item);
		}
	}

	public void invoke_share(String method) {
		Intent myIntent = new Intent(this.getBaseContext(), Share.class);
		myIntent.putExtra("sharing_method", method);
		myIntent.putExtra("content_url", _noticia.getLink());
		myIntent.putExtra("content_title", _noticia.getTitulo());
		startActivityForResult(myIntent, 0);
	}

	public void invoke_principal() {
		Intent myIntent = new Intent(this.getBaseContext(), CromaNews.class);
		startActivityForResult(myIntent, 0);
		this.finish();
	}

	public void invoke_close() {
		this.finish();
	}

	@Override
	public void onCreate(Bundle instance) {
		super.onCreate(instance);
		setContentView(R.layout.detalle_noticia);
		_titulo = (TextView) findViewById(R.id.txtTitulo);
		_detalle = (TextView) findViewById(R.id.txtDetalle);
		_imagen = (ImageView) findViewById(R.id.imgNoticia);
		LinearLayout layout = (LinearLayout) findViewById(R.id.noticiaMainLayout);
		_noticia = (Noticia) this.getIntent().getExtras().get("_noticia_");
		_titulo.setText(_noticia.getTitulo());
		_detalle.setText(_noticia.getDescripcion());
		_imagen.setImageDrawable(imageFromUrl(_noticia.getImgUrl()));
		if (_noticia instanceof Publicacion) {
			layout.removeView(findViewById(R.id.btnCompleto));
			for (Publicacion p : PublicacionStorage.getInstance()
					.getByCategory(_noticia.getTitulo())) {
				_publicacion = p;
				Button btn = new Button(this);
				btn.setText(p.getFecha());
				btn.setOnClickListener(new View.OnClickListener() {

					public void onClick(View v) {
						Intent i = new Intent(Intent.ACTION_VIEW, Uri
								.parse(_publicacion.getLink()));
						startActivity(i);
					}
				});
				layout.addView(btn);
			}
		} else {
			_detalle.setText(_noticia.getFecha() + " - " + _detalle.getText());
			findViewById(R.id.btnCompleto).setOnClickListener(
					new View.OnClickListener() {

						public void onClick(View arg0) {
							Intent i = new Intent(Intent.ACTION_VIEW, Uri
									.parse(_noticia.getLink()));
							startActivity(i);
						}
					});
		}
		if (getIntent().getBooleanExtra("_marcable_", true)) {
			findViewById(R.id.btnFavoritos).setOnClickListener(
					new View.OnClickListener() {

						public void onClick(View v) {
							new FavoritosHelper(DetalleNoticia.this)
									.agregaNoticia(_noticia);
							Toast.makeText(DetalleNoticia.this,
									"Agregado a favoritos", Toast.LENGTH_LONG)
									.show();
						}
					});
		} else {
			layout.removeView(findViewById(R.id.btnFavoritos));
		}
	}

	private Drawable imageFromUrl(String url) {
		Drawable d = null;
		InputStream is = null;
		try {
			is = (InputStream) new URL(url).getContent();
			d = Drawable.createFromStream(is, "x");
		} catch (Throwable t) {
			t.printStackTrace();
		} finally {
			if (is != null) {
				try {
					is.close();
				} catch (IOException e) {
				}
			}
		}
		return d;
	}
}
