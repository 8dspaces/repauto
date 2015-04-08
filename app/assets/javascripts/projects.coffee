# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


window.draw_trend = (selection, data) ->
  #console.log(data)

  svg = dimple.newSvg('#trend', 800, 600)
  chart = new dimple.chart(svg, data)
  chart.setBounds(60, 30, 705, 505)
  x = chart.addCategoryAxis('x', 'time')
  x.addOrderRule('time')
  y = chart.addMeasureAxis("y", "number")
  y.tickFormat = ',.1d'
  s = chart.addSeries("status", dimple.plot.area)
  #s.interpolation = "cardinal"
  chart.addLegend(60, 10, 500, 20, "right")
  chart.assignColor("passed", "#5cb85c")
  chart.assignColor("broken", "#f0ad4e")
  chart.assignColor("failed", "#d9534f")
  chart.draw()