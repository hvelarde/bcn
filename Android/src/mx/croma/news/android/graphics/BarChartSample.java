package mx.croma.news.android.graphics;

import java.util.ArrayList;
import java.util.List;

import mx.croma.news.android.R;

import org.achartengine.ChartFactory;
import org.achartengine.GraphicalView;
import org.achartengine.chart.BarChart;
import org.achartengine.chart.LineChart;
import org.achartengine.chart.PointStyle;
import org.achartengine.model.XYMultipleSeriesDataset;
import org.achartengine.model.XYSeries;
import org.achartengine.renderer.XYMultipleSeriesRenderer;
import org.achartengine.renderer.XYSeriesRenderer;

import android.app.Activity;
import android.graphics.Color;
import android.graphics.Paint.Align;
import android.os.Bundle;
import android.widget.LinearLayout;

public class BarChartSample extends Activity {

	
	private GraphicalView mChartView;

	@Override
	public void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		setContentView(R.layout.chart_view);
		
		  String[] titles = new String[] { "Coloc. Bruta", "Tasa de rendimiento" };
		    List<double[]> x = new ArrayList<double[]>();
		    for (int i = 0; i < titles.length; i++) {
		      x.add(new double[] { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12 });
		    }
		    List<double[]> values = new ArrayList<double[]>();
		    values.add(new double[] { 12.3, 12.5, 13.8, 16.8, 20.4, 24.4, 26.4, 26.1, 23.6, 20.3, 17.2,
		        13.9 });
		    values.add(new double[] { 9, 10, 11, 15, 19, 23, 26, 25, 22, 18, 13, 10 });
		    int[] colors = new int[] { Color.GREEN, Color.rgb(200, 150, 0) };
		    PointStyle[] styles = new PointStyle[] { PointStyle.CIRCLE, PointStyle.DIAMOND };
		    XYMultipleSeriesRenderer renderer = buildRenderer(colors, styles);
		    renderer.setPointSize(5.5f);
		    
		    int length = renderer.getSeriesRendererCount();

		    for (int i = 0; i < length; i++) {
		      XYSeriesRenderer r = (XYSeriesRenderer) renderer.getSeriesRendererAt(i);
		      r.setLineWidth(5);
		      r.setFillPoints(true);
		    }
		    setChartSettings(renderer, "Operaciones mercado abierto", "Mes", "Millones de Dolares", 0.5, 12.5, -50, 40,
		        Color.LTGRAY, Color.LTGRAY);

		    renderer.setXLabels(12);
		    renderer.setYLabels(10);
		    renderer.setShowGrid(true);
		    renderer.setXLabelsAlign(Align.RIGHT);
		    renderer.setYLabelsAlign(Align.RIGHT);
		    renderer.setZoomButtonsVisible(true);
		    renderer.setPanLimits(new double[] { -10, 20, -10, 40 });
		    renderer.setZoomLimits(new double[] { -10, 20, -10, 40 });

		    
		    XYSeries waterSeries = new XYSeries("Coloc. Bruta");
		    waterSeries.add(1, 16);
		    waterSeries.add(2, 15);
		    waterSeries.add(3, -16);
		    waterSeries.add(4, -17);
		    waterSeries.add(5, 20);
		    waterSeries.add(6, 23);
		    waterSeries.add(7, 25);
		    waterSeries.add(8, 25.5);
		    waterSeries.add(9, 26.5);
		    waterSeries.add(10, -24);
		    waterSeries.add(11, -22);
		    waterSeries.add(12, -18);
		    renderer.setBarSpacing(0.5);
		    XYSeriesRenderer waterRenderer = new XYSeriesRenderer();
		    waterRenderer.setColor(Color.argb(250, 0, 210, 250));

		    XYMultipleSeriesDataset dataset = buildDataset(titles, x, values);
		    dataset.addSeries(0, waterSeries);
		    renderer.addSeriesRenderer(0, waterRenderer);
		    waterRenderer.setDisplayChartValues(true);
		    waterRenderer.setChartValuesTextSize(10);
		    
		    String[] types = new String[] { BarChart.TYPE,  LineChart.TYPE,
		        LineChart.TYPE };
		    
		    
		    if (mChartView == null) {
				LinearLayout layout = (LinearLayout) findViewById(R.id.barchartSample);
				mChartView = ChartFactory.getCombinedXYChartView(this, dataset, renderer, types);
				layout.addView(mChartView);

			} else {
				mChartView.repaint();
			}
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
	
	 protected XYMultipleSeriesRenderer buildRenderer(int[] colors, PointStyle[] styles) {
		    XYMultipleSeriesRenderer renderer = new XYMultipleSeriesRenderer();
		    setRenderer(renderer, colors, styles);
		    return renderer;
		  }
	
}
