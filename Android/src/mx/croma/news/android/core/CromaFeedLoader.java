package mx.croma.news.android.core;

import java.io.IOException;
import java.util.concurrent.atomic.AtomicBoolean;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.SAXException;

import mx.croma.news.android.R;
import mx.croma.news.android.SplashScreen;

import android.content.res.Resources;
import android.widget.ProgressBar;
import android.widget.SlidingDrawer;

public class CromaFeedLoader implements Runnable {

	private ProgressBar _progressBar;
	private Resources _resources;
	private SplashScreen _splash;
	public static AtomicBoolean loaded = new AtomicBoolean(false);
	public CromaFeedLoader(SplashScreen splash, Resources r, ProgressBar p) {
		_progressBar = p;
		_resources = r;
		_splash = splash;
	}

	public void run() {
		try {
			if (CromaFeedHandler.cacheNoticias == null) {
				_progressBar.setProgress(30);
				CromaFeedHandler cfh = new CromaFeedHandler();
				String _feedUrl = _resources.getString(R.string.feed_prensa);
				SAXParserFactory spf = SAXParserFactory.newInstance();
				_progressBar.setProgress(50);
				SAXParser sp = spf.newSAXParser();
				_progressBar.setProgress(60);
				sp.parse(_feedUrl, cfh);
				_progressBar.setProgress(90);
				loaded.set(true);
				
				_splash.cargaLista();
			}
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
