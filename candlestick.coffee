class d3.chart.Candlestick extends d3.chart.BaseChart
    _draw: (element, data, i) ->

        width = @width()
        height = @height()
        margin = @margin()

        x_scale = d3.time.scale()
            .domain d3.extent data, (d) -> new Date(d.time)
            .range [0, width]

        y_scale = d3.scale.linear()
            .domain [
                d3.min data, (d) -> d.lowMid
                d3.max data, (d) -> d.highMid
            ]
            .range [height, 0]

        console.log y_scale.domain()
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
            .attr "width", width + margin.left + margin.right
            .attr "height", height + margin.top + margin.bottom

        g = svg.select "g"
            .attr "transform", "translate(#{margin.left}, #{margin.top})"

        stems = g.select ".candlesticks"
            .selectAll "line.stem"
            .data (d) -> d

        stems
            .enter()
            .append "line"
            .classed "stem", true
            .classed "stem-up", (d) -> d.openMid < d.closeMid
            .attr "x1", (d) -> x_scale(new Date d.time) + 0.5 * width / data.length
            .attr "x2", (d) -> x_scale(new Date d.time) + 0.5 * width / data.length
            .attr "y1", (d) -> y_scale(d.highMid)
            .attr "y2", (d) -> y_scale(d.lowMid)

        stems.exit().remove()

        boxes = g.select ".candlesticks"
            .selectAll "rect"
            .data (d) -> d

        boxes
            .enter()
            .append "rect"
            .classed "candlestick-rect", true
            .classed "candlestick-up", (d) -> d.openMid < d.closeMid
            .attr "x", (d) -> x_scale new Date d.time
            .attr "y", (d) -> y_scale d3.max [d.openMid, d.closeMid]
            .attr "width", width / data.length
            .attr "height", (d) -> Math.abs(y_scale(d.openMid) - y_scale(d.closeMid))

        boxes.exit().remove()
