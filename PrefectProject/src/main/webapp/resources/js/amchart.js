am5.ready(function() {

// Create root element
// https://www.amcharts.com/docs/v5/getting-started/#Root_element

var root = am5.Root.new("chartdiv1");

// Set themes
// https://www.amcharts.com/docs/v5/concepts/themes/
root.setThemes([
  am5themes_Animated.new(root)
]);

// Generate and set data
// https://www.amcharts.com/docs/v5/charts/radar-chart/#Setting_data
var cat = -1;
var value = 10;

function generateData() {
  value = Math.round(Math.random() * 10);
  cat++;
  return {
    category: "cat" + cat,
    value: value
  };
}

function generateDatas(count) {
  cat = -1;
  var data = [];
  for (var i = 0; i < count; ++i) {
    data.push(generateData());
  }
  return data;
}

// Create chart
// https://www.amcharts.com/docs/v5/charts/radar-chart/
var chart = root.container.children.push(
  am5radar.RadarChart.new(root, {
    panX: false,
    panY: false,
    wheelX: "panX",
    wheelY: "zoomX",
    innerRadius: am5.p50,
    layout: root.verticalLayout
  })
);

// Create axes and their renderers
// https://www.amcharts.com/docs/v5/charts/radar-chart/#Adding_axes
var xRenderer = am5radar.AxisRendererCircular.new(root, {});
xRenderer.labels.template.setAll({
  textType:"adjusted"
});

var xAxis = chart.xAxes.push(
  am5xy.CategoryAxis.new(root, {
    maxDeviation: 0,
    categoryField: "category",
    renderer: xRenderer,
    tooltip: am5.Tooltip.new(root, {})
  })
);

var yAxis = chart.yAxes.push(
  am5xy.ValueAxis.new(root, {
    renderer: am5radar.AxisRendererRadial.new(root, {})
  })
);

// Create series
// https://www.amcharts.com/docs/v5/charts/radar-chart/#Adding_series
for (var i = 0; i < 1; i++) {  
  var series = chart.series.push(
    am5radar.RadarColumnSeries.new(root, {
      stacked: true,
      name: "성적 ",
      xAxis: xAxis,
      yAxis: yAxis,
      valueYField: "value",
      categoryXField: "category"
    })
  );

  series.columns.template.setAll({
    tooltipText: "{name}: {valueY}"
  });

  series.data.setAll(generateDatas(6));
  series.appear(1000);
}

// slider
var slider = chart.children.push(
  am5.Slider.new(root, {
    orientation: "horizontal",
    start: 0.5,
    width: am5.percent(60),
    centerY: am5.p50,
    centerX: am5.p50,
    x: am5.p50
  })
);
slider.events.on("rangechanged", function () {
  var start = slider.get("start");
  var startAngle = 270 - start * 179 - 1;
  var endAngle = 270 + start * 179 + 1;

  chart.setAll({ startAngle: startAngle, endAngle: endAngle });
  yAxis.get("renderer").set("axisAngle", startAngle);
});

var data = generateDatas(6);
xAxis.data.setAll(data);

// Animate chart
// https://www.amcharts.com/docs/v5/concepts/animations/#Initial_animation
chart.appear(1000, 100);

}); // end am5.ready()
