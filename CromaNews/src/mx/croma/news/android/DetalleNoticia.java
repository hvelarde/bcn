package mx.croma.news.android;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import mx.croma.news.android.core.Noticia;
import android.app.Activity;
import android.content.Intent;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

public class DetalleNoticia extends Activity {

	private TextView _titulo;
	private TextView _detalle;
	private ImageView _imagen;
	private Noticia _noticia;
	
	@Override
	public void onCreate(Bundle instance){
		super.onCreate(instance);
		setContentView(R.layout.detalle_noticia);
		_titulo = (TextView)findViewById(R.id.txtTitulo);
		_detalle = (TextView)findViewById(R.id.txtDetalle);
		_imagen = (ImageView)findViewById(R.id.imgNoticia);
		
		_noticia = (Noticia)this.getIntent().getExtras().get("_noticia_");
		
		_titulo.setText(_noticia.getTitulo());
		_detalle.setText(_noticia.getDescripcion());
		_imagen.setImageDrawable(imageFromUrl(_noticia.getImgUrl()));
		
		findViewById(R.id.btnCompleto).setOnClickListener(new View.OnClickListener() {
			
			public void onClick(View arg0) {
				Intent i = new Intent(Intent.ACTION_VIEW, Uri.parse(_noticia.getLink()));
				startActivity(i);
			}
		});
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
