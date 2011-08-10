package mx.croma.news.android.graphics;

import java.util.ArrayList;
import java.util.List;

import mx.croma.news.android.R;

import org.achartengine.ChartFactory;
import org.achartengine.GraphicalView;
import org.achartengine.chart.PointStyle;
import org.achartengine.model.SeriesSelection;
import org.achartengine.model.XYMultipleSeriesDataset;
import org.achartengine.model.XYSeries;
import org.achartengine.renderer.XYMultipleSeriesRenderer;
import org.achartengine.renderer.XYSeriesRenderer;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Paint.Align;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.LinearLayout;
import android.widget.Toast;

public class AChartEngineSampleActivity extends Activity {
	/** Called when the activity is first created. */

	private GraphicalView mChartView;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.chart_view);

		String[] titles = new String[] { "2009", "2010","2011"};
		List<double[]> x = new ArrayList<double[]>();
		
		for (int i = 0; i < titles.length; i++) {
			x.add(new double[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 });
		}
		
		List<double[]> values = new ArrayList<double[]>();
		values.add(new double[] { 12.3, 12.5, 13.8, 16.8, 20.4, 24.4, 26.4,
				26.1, 23.6, 20.3, 17.2, 13.9 });
		values.add(new double[] { 10, 10, 12, 15, 21, 24, 26, 26, 23, 18, 14,
				11 });
		values.add(new double[] { 5, 1, 6, 21, 12, 7, 6, 21});
		
		int[] colors = new int[] { Color.BLUE, Color.GREEN, getResources().getColor(R.color.orange)};
		
		PointStyle[] styles = new PointStyle[] { PointStyle.CIRCLE,
				PointStyle.CIRCLE,PointStyle.CIRCLE};

		XYMultipleSeriesRenderer renderer = new XYMultipleSeriesRenderer();
		setRenderer(renderer, colors, styles);

		int length = renderer.getSeriesRendererCount();
		for (int i = 0; i < length; i++) {
			((XYSeriesRenderer) renderer.getSeriesRendererAt(i))
					.setFillPoints(true);
		}

		setChartSettings(renderer, "Inflacion Acumulada", "Mes",
				"Porcentaje", 0.5, 12.5, 0, 32, Color.LTGRAY, Color.LTGRAY);

		renderer.setXLabels(12);
		renderer.setYLabels(10);
		renderer.setXLabelsAlign(Align.RIGHT);
		renderer.setYLabelsAlign(Align.RIGHT);
		renderer.setZoomButtonsVisible(true);
		renderer.setPanLimits(new double[] { -10, 20, -10, 40 });
		renderer.setZoomLimits(new double[] { -10, 20, -10, 40 });

		if (mChartView == null) {
			LinearLayout layout = (LinearLayout) findViewById(R.id.barchartSample);
			mChartView = ChartFactory.getLineChartView(this,
					buildDataset(titles, x, values), renderer);
			layout.addView(mChartView);

		} else {
			mChartView.repaint();
		}

		renderer.setClickEnabled(true);
		renderer.setSelectableBuffer(100);
		mChartView.setOnClickListener(new OnClickListener() {
		
			public void onClick(View v) {
				SeriesSelection seriesSelection = mChartView.getCurrentSeriesAndPoint();
				double[] xy = mChartView.toRealPoint(0);
				if (seriesSelection == null) {
					
				} else {
					double x_close=Math.abs(seriesSelection.getXValue()-xy[0]);
					double y_close=Math.abs(seriesSelection.getValue()-xy[1]);
					Log.d("BCN","xclose "+x_close+" y_close"+y_close);
					if(x_close<2 && y_close<2)
					Toast.makeText(
							AChartEngineSampleActivity.this,
							"Indice del elemento "
									+ seriesSelection.getSeriesIndex()
									+ " indice de punto de dato "
									+ seriesSelection.getPointIndex()
									+ " punto mas cercano X="
									+ seriesSelection.getXValue() + ", Y="
									+ seriesSelection.getValue()
									+ " punto clickeado value X=" + (float) xy[0]
									+ ", Y=" + (float) xy[1],
							Toast.LENGTH_SHORT).show();
				}
			}
		});

	}

	protected void setChartSettings(XYMultipleSeriesRenderer renderer,
			String title, String xTitle, String yTitle, double xMin,
			double xMax, double yMin, double yMax, int axesColor,
			int labelsColor) {
		renderer.setChartTitle(title);
		renderer.setXTitle(xTitle);
		renderer.setYTitle(yTitle);
		renderer.setXAxisMin(xMin);
		renderer.setXAxisMax(xMax);
		renderer.setYAxisMin(yMin);
		renderer.setYAxisMax(yMax);
		renderer.setAxesColor(axesColor);
		renderer.setLabelsColor(labelsColor);
	}

	protected void setRenderer(XYMultipleSeriesRenderer renderer, int[] colors,
			PointStyle[] styles) {
		renderer.setAxisTitleTextSize(16);
		renderer.setChartTitleTextSize(20);
		renderer.setLabelsTextSize(15);
		renderer.setLegendTextSize(15);
		renderer.setPointSize(5f);
		renderer.setMargins(new int[] { 20, 30, 15, 20 });
		int length = colors.length;
		for (int i = 0; i < length; i++) {
			XYSeriesRenderer r = new XYSeriesRenderer();
			r.setColor(colors[i]);
			r.setPointStyle(styles[i]);
			renderer.addSeriesRenderer(r);
		}
	}

	protected XYMultipleSeriesDataset buildDataset(String[] titles,
			List<double[]> xValues, List<double[]> yValues) {
		XYMultipleSeriesDataset dataset = new XYMultipleSeriesDataset();
		addXYSeries(dataset, titles, xValues, yValues, 0);
		return dataset;
	}

	public void addXYSeries(XYMultipleSeriesDataset dataset, String[] titles,
			List<double[]> xValues, List<double[]> yValues, int scale) {
		int length = titles.length;
		
		for (int i = 0; i < length; i++) {
			XYSeries series = new XYSeries(titles[i], scale);
			double[] xV = xValues.get(i);
			double[] yV = yValues.get(i);
			int seriesLength = yV.length;
			for (int k = 0; k < seriesLength; k++) {
				series.add(xV[k], yV[k]);
			}
			dataset.addSeries(series);
		}
		
	}

}