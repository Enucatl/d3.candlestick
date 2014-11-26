class d3.chart.Candlestick extends d3.chart.BaseChart

    constructor: ->
        @accessors = {} unless @accessors?
        @accessors.time_value = (d) -> new Date d.time
        @accessors.low_value = (d) -> d.lowMid
        @accessors.high_value = (d) -> d.highMid
        @accessors.open_value = (d) -> d.openMid
        @accessors.close_value = (d) -> d.closeMid
        super

    _draw: (element, data, i) ->

        # recall those for convenience:
        width = @width()
        height = @height()
        margin = @margin()
        x_scale = @x_scale()
        y_scale = @y_scale()
        time_value = @time_value()
        low_value = @low_value()
        high_value = @high_value()
        open_value = @open_value()
        close_value = @close_value()

        # scales fill up width and height
        x_scale.range [0, width]
        y_scale.range [height, 0]

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
            .classed "stem-up", (d) -> open_value(d) < close_value(d)
            .attr "x1", (d) -> x_scale(time_value(d)) + 0.5 * width / data.length
            .attr "x2", (d) -> x_scale(time_value(d)) + 0.5 * width / data.length
            .attr "y1", (d) -> y_scale high_value d  
            .attr "y2", (d) -> y_scale low_value d  

        stems.exit().remove()

        boxes = g.select ".candlesticks"
            .selectAll "rect"
            .data (d) -> d

        boxes
            .enter()
            .append "rect"
            .classed "candlestick-rect", true
            .classed "candlestick-up", (d) -> open_value(d) < close_value(d)
            .attr "x", (d) -> x_scale time_value d 
            .attr "y", (d) -> y_scale d3.max [open_value(d), close_value(d)]
            .attr "width", width / data.length
            .attr "height", (d) ->
                Math.abs(y_scale(open_value(d)) - y_scale(close_value(d)))
            .attr "title", (d) ->
                """
                low: #{low_value(d)}
                high: #{high_value(d)}
                open: #{open_value(d)}
                close: #{close_value(d)}
                """

        boxes.exit().remove()
