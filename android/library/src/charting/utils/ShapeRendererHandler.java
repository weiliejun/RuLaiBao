package charting.utils;

import charting.charts.ScatterChart;
import charting.renderer.scatter.ChevronDownShapeRenderer;
import charting.renderer.scatter.ChevronUpShapeRenderer;
import charting.renderer.scatter.CircleShapeRenderer;
import charting.renderer.scatter.CrossShapeRenderer;
import charting.renderer.scatter.ShapeRenderer;
import charting.renderer.scatter.SquareShapeRenderer;
import charting.renderer.scatter.TriangleShapeRenderer;
import charting.renderer.scatter.XShapeRenderer;

import java.util.HashMap;

/**
 * Created by Philipp Jahoda on 27/06/16.
 * Class allowing to determine the corresponding ShapeRenderer for a given ScatterShape.
 */
public final class ShapeRendererHandler {

    /**
     * Dictionary of ShapeRenderer which are responsible for drawing custom shapes.
     * Can add to it your custom shapes.
     * CustomShapeRenderer Implements ShapeRenderer{}
     */
    protected HashMap<String, ShapeRenderer> shapeRendererList;

    /**
     * Constructor
     */
    public ShapeRendererHandler() {
        initShapeRenderers();
    }

    /**
     * Returns the corresponding ShapeRenderer for a given ScatterShape.
     *
     * @param shape
     * @return
     */
    public ShapeRenderer getShapeRenderer(ScatterChart.ScatterShape shape) {
        return shapeRendererList.get(shape.toString());
    }

    /**
     * Init default ShapeRenderers.
     */
    protected void initShapeRenderers() {
        shapeRendererList = new HashMap<>();

        shapeRendererList.put(ScatterChart.ScatterShape.SQUARE.toString(), new SquareShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.CIRCLE.toString(), new CircleShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.TRIANGLE.toString(), new TriangleShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.CROSS.toString(), new CrossShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.X.toString(), new XShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.CHEVRON_UP.toString(), new ChevronUpShapeRenderer());
        shapeRendererList.put(ScatterChart.ScatterShape.CHEVRON_DOWN.toString(), new ChevronDownShapeRenderer());
    }
}
