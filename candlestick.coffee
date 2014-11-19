d3.chart = {} unless d3.chart?
console.log d3.chart
console.log d3

class d3.chart.Candlestick extends d3.chart.BaseChart
    _draw: (element, data, i) ->

        console.log this

        x_scale = d3.time.scale()
            .domain d3.extent data, (d) -> d.time
            .range [0, width]

        y_scale = d3.scale.linear()
            .domain d3.extent data, (d) -> d.closeMid
            .range [height, 0]

        # select svg if it exists
        svg = d3.select element
            .selectAll "svg"
            .data [data]

        # otherwise create skeletal chart
        g_enter = svg.enter()
            .append "svg"
            .append "g"

        g_enter.append "g"
            .classed "candlesticks", true

        # update size
        svg
            .width @width + @margin.left + @margin.right
            .height @height + @margin.top + @margin.bottom

        g = svg.select "g"
            .attr "transform", "translate(#{@margin.left}, #{@margin.top})"

        boxes = g.select ".candlesticks"
            .selectAll "rect"
            .data (d) -> d

        boxes
            .enter()
            .append "rect"
            .classed "bar", true
            .attr "x", (d) -> x_scale d.x
            .attr "y", (d) -> y_scale d3.min [d.openMid, d.closeMid]
            .attr "width", 2
            .attr "height", -> y_scale Math.abs(d.openMid - d.closeMid)

        boxes.exit().remove()

console.log "inherit me"
