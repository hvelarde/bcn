package mx.croma.news.android.core;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import mx.croma.news.android.ListaNoticias;
import mx.croma.news.android.db.FavoritosHelper;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.drawable.Drawable;
import android.text.Html;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;

public class NoticiaView extends LinearLayout {

	private Noticia _noticia;
	private TextView _titulo;
	private TextView _descripcion;
	private ImageView _imagen;
	private Drawable _drawable;
	private class FavoritosLongClickListener implements OnLongClickListener {
		
		public boolean onLongClick(View v) {
			NoticiaView view = (NoticiaView) v;
			new AlertDialog.Builder(NoticiaView.this.getContext()).setIcon(android.R.drawable.ic_delete)
			.setTitle("Eliminar favorito").setMessage("Esto eliminara el marcador para siempre")
			.setPositiveButton("Si", new DialogInterface.OnClickListener() {
				
				public void onClick(DialogInterface dialog, int which) {
					new FavoritosHelper(NoticiaView.this.getContext()).eliminaNoticia(NoticiaView.this.getNoticia().getId());
					NoticiaView.this.setVisibility(GONE);
				}
			}).setNegativeButton("No", null).show();
			Log.d("BCN", "Favorito: " + view.getNoticia().getId());
			return true;
		}
	};
	public Noticia getNoticia(){
		return _noticia;
	}

	public NoticiaView(Context context, Noticia n) {
		super(context);
		if(n.getId() != 0){
			setLongClickable(true);
			setOnLongClickListener(new FavoritosLongClickListener());
		}
		setOrientation(VERTICAL);
		_noticia = n;
		if (n.getImgUrl() != null) {
			_imagen = new ImageView(context);
			_imagen.setMaxWidth(100);
			_imagen.setMaxHeight(100);
			_drawable = imageFromUrl(n.getImgUrl());
			_imagen.setImageDrawable(_drawable);
			addView(_imagen);

		}
		_titulo = new TextView(context);
		_titulo.setHeight(55);
		_titulo.setText(Html.fromHtml("<b>" + n.getTitulo().trim() + "</b>"));
		addView(_titulo);
		// _descripcion = new TextView(context);
		// _descripcion.setText(n.getDescripcion());
		// addView(_descripcion);
	}
	

	public void update(Noticia n) {
		_titulo.setText(Html.fromHtml("<b>" + n.getTitulo().trim() + "</b>"));
		if (_imagen != null) {
			_imagen.setImageDrawable(imageFromUrl(n.getImgUrl()));
		}
		_noticia = n;
		// _descripcion.setText(n.getDescripcion());
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
