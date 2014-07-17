{take, map, keys} = require "prelude-ls"


parse-date = (string)->
	y = (string.split "年")[0]
	m = ((string.split "年")[1].split "月")[0]
	d = ((string.split "月")[1].split "日")[0]

	new Date(((+y) + 1911) + " " + m + " " + d)


sh-NaN = {
	"date":true
	"mktname":true
	"sbtype":true
	"transformation":true
	"middleprice": false
	"quantity": false
}

typ-sh-NaN = {
	"alertDate": true
	"force7km": null
	"force10km": null
	"id": false
	"level": true
	"maxMS": false
	"minhPa": false
	"name": true
	"nameEn": true
	"numAlert": false
	"path": null
	"year": false
}


view = "middleprice"

lsmkt = {}
lssbtype = {}
lstyphon = {}
lscolor = {}

datechage = (date, inc)->
	d = new Date(date)
	return new Date(d.setDate(d.getDate! + inc))
	# itrdate = new Date(itrdate.getFullYear!, itrdate.getMonth!, itrdate.getDate! + 1)

datebetween = (start, end)->
# includig start and end
	result = []
	itrdate = new Date(start)

	while end - itrdate > 0
		result.push itrdate
		itrdate = datechage(itrdate, 1)

	result.push itrdate

	result


## LI萵苣菜
## FY玉米
err, typhonData <- d3.tsv "./typhon.tsv"

typhonData = typhonData
	.filter ->

		# if it.path is "null" then return false

		for tp of it
			if typ-sh-NaN[tp] is not null and (isNaN it[tp])	is not typ-sh-NaN[tp]
				# console.log "bad: " +  tp #JSON.stringify it
				return false
			else if not typ-sh-NaN[tp]
				it[tp] = +it[tp]


		alert = it.alertDate.split "～"

		it.start = new Date(it.year, alert[0].split("/")[0], alert[0].split("/")[1])
		it.end = new Date(it.year, alert[1].split("/")[0], alert[1].split("/")[1])

		it.during = datebetween(it.start, it.end)
		it.waybefore = datebetween(datechage(it.start, -10), datechage(it.start, -5))
		it.before = datebetween(datechage(it.start, -5), it.start)
		it.after = datebetween(it.end, datechage(it.end, +5))

		it.waybefore.map -> lstyphon[it] := "-10"
		it.before.map -> lstyphon[it] := "-5"
		it.after.map -> lstyphon[it] := "+5"
		it.during.map -> lstyphon[it] := "T"

		return true

# console.log typhonData

color = d3.scale.category20!

# SE青蔥
# LI萵苣菜
# LY6香椿
# LC包心白
# FQ毛豆
# SD洋蔥
err, tsvData <- d3.tsv "./data/SD洋蔥.tsv"

tsvData = tsvData
	.filter ->
		for tp of it
			if (isNaN it[tp])	is not sh-NaN[tp]
				# console.log "bad: " +  JSON.stringify it
				return false
			else if not sh-NaN[tp]
				it[tp] = +it[tp]

		if it.mktname is "台北一"
			it.mktname = "北一"
		else if it.mktname is "台北二"
			it.mktname = "北二"
		else 
			it.mktname = take 2, it.mktname	

		if lsmkt[it.mktname] is undefined then lsmkt[it.mktname] := true
		if lssbtype[it.sbtype] is undefined then lssbtype[it.sbtype] := true

		it.date = parse-date it.date		



		typhon = lstyphon[it.date + ""]

		it.status =  if typhon is not undefined then typhon else "na"
		
		return true
	.sort (a, b) -> a.date - b.date

console.log tsvData

margin = {top: 10, left: 10, right: 20, bottom: 20}
w = 2000 - margin.left - margin.right
h = 400 - margin.top - margin.bottom




scale-x = d3.time.scale!
	.range [0, w]
	.domain d3.extent tsvData.map -> it.date

scale-y = d3.scale.linear!
	.domain [0,150]
	# d3.extent tsvData.map -> it[view]
	.range [h, 0]

line = d3.svg.line!
	.x -> scale-x it.date
	.y -> scale-y it.middleprice





fltrData = tsvData #.filter -> if it.mktname is "台中市" then true else false	



d3.select "body"
	.append "canvas"
	.attr {
		"width": w
		"height": h
		"id": "yearvsvalue"
	}

canvas = document.getElementById("yearvsvalue")
canvasWidth = canvas.width
canvasHeight = canvas.height


ctx = canvas.getContext "2d"

canvasData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)

drawPixel = (x, y, r, g, b, a)->
	index = (x + y * canvasWidth) * 4

	canvasData.data[index + 0] = r
	canvasData.data[index + 1] = g
	canvasData.data[index + 2] = b
	canvasData.data[index + 3] = a

updateCanvas = ->
	ctx.putImageData(canvasData, 0, 0)






# svg = d3.select "body"
# 	.append "svg"
# 	.attr {
# 		"width": w + margin.left + margin.right
# 		"height": h + margin.top + margin.bottom
# 	}
# 	.append "g"
# 	.attr "transform", "translate(" + margin.left + ", " + margin.top + ")"

# svg
# 	.selectAll "rect"
# 	.data fltrData
# 	.enter!
# 	.append "rect"
# 	.attr {
# 		"height": 1
# 		"width": 1
# 		"x": -> scale-x it.date
# 		"y": -> scale-y it[view]
# 		"class": "marker"
# 	}
# 	.style {
# 		"fill": -> color it.mktname
# 	}

# svg
# 	.selectAll "path"
# 	.data [fltrData]
# 	.enter!
# 	.append "path"
# 	.attr {
# 		"d": -> line it
		

# 	}
# 	.style {
# 		"fill": "none"
# 		"stroke": "orange"
# 		"stroke-width": 1px
# 		"opacity": 0.3
# 	}

weekDayTable = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]


barPriYear = dc.barChart('.pricePerYear')
barPriMonth = dc.barChart('.pricePerMonth')
barPriWeek = dc.barChart('.pricePerWeekDay')
barPriMkt = dc.barChart('.pricePerMkt')
barPriSb = dc.barChart('.pricePerSb')
barPriTyp = dc.barChart('.pricePerTyp')


barQuanYear = dc.barChart('.quanPerYear')
barQuanMonth = dc.barChart('.quanPerMonth')
barQuanWeek = dc.barChart('.quanPerWeekDay')
barQuanMkt = dc.barChart('.quanPerMkt')
barQyanSb = dc.barChart('.quanPerSb')
barQuanTyp = dc.barChart('.quanPerTyp')


ndx = crossfilter tsvData
all = ndx.groupAll!

sml = {}

yearDim = ndx.dimension -> it.date.getFullYear!
monthDim = ndx.dimension -> it.date.getMonth!
weekdayDim = ndx.dimension -> weekDayTable[it.date.getDay!]
mktDim = ndx.dimension -> it.mktname
sbDim = ndx.dimension -> it.sbtype
tyDim = ndx.dimension -> it.status
	

averageAdd = (p, v)->
	++p.count
	p.sum += v.middleprice
	p.average = if p.count then Math.floor(p.sum / p.count) else 0
	p

averageRemove = (p, v)->
	--p.count
	p.sum -= v.middleprice
	p.average = if p.count then Math.floor(p.sum / p.count) else 0
	p 

averageInitial = ->
	{
		count: 0
		sum: 0
		average: 0
	}


averageQuanAdd = (p, v)->
	++p.count
	p.sum += v.quantity
	p.average = if p.count then Math.floor(p.sum / p.count) else 0
	p

averageQuanRemove = (p, v)->
	--p.count
	p.sum -= v.quantity
	p.average = if p.count then Math.floor(p.sum / p.count) else 0
	p 

averageQuanInitial = ->
	{
		count: 0
		sum: 0
		average: 0
	}

# should use average price
priceYear = yearDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceMonth = monthDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceWeekDay = weekdayDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceMkt = mktDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceSb = sbDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceTy = tyDim.group!.reduce(averageAdd, averageRemove, averageInitial)

quanYear = yearDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanMonth = monthDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanWeekDay = weekdayDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanMkt = mktDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanSb = sbDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanTy = tyDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)


barWidth = 300
barHeight = 150
marginJson =	{
	"top": 10
	"right": 10
	"left": 80
	"bottom": 20
}


colorBike = d3.rgb "rgb(255, 127, 14)" .darker 1
colorBike2 = d3.rgb "rgb(255, 127, 14)" .darker 2
# '#de2d26'
	
year-ext = d3.extent tsvData.map -> it.date.getFullYear!

console.log year-ext



bpy = barPriYear.width barWidth + 100
	.height barHeight
	.margins marginJson
	.dimension yearDim
	.group priceYear
	.valueAccessor -> it.value.average
	.x(d3.scale.linear!.domain(year-ext))
	.elasticY true
	.colors -> colorBike
	.on("filtered", -> updateGraph!)

bpy
	.yAxis!
	.ticks 3

bpy
	.xAxis!
	.ticks 3

barPriMonth.width barWidth + 60
	.height barHeight
	.margins marginJson
	.dimension monthDim
	.group priceMonth
	.valueAccessor -> it.value.average
	.x(d3.scale.linear!.domain([0, 12]))
	# .x(d3.scale.ordinal!.domain(d3.range(1,13)))
		# .xUnits dc.units.ordinal
	.elasticY true
	.colors -> colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barPriWeek.width barWidth 
	.height barHeight
	.margins marginJson
	.dimension weekdayDim
	.group priceWeekDay
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(weekDayTable))
	.xUnits dc.units.ordinal
	.gap 4
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barPriMkt.width (keys lsmkt).length * 65
	.height barHeight
	.margins marginJson
	.dimension mktDim
	.group priceMkt
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(keys lsmkt))
	.xUnits dc.units.ordinal
	.gap 10
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barPriSb.width (keys lssbtype).length * 60
	.height barHeight
	.margins marginJson
	.dimension sbDim
	.group priceSb
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 4
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barPriTyp.width 400
	.height barHeight
	.margins marginJson
	.dimension tyDim
	.group priceTy
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 30
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

# -----



bqy = barQuanYear.width barWidth + 100
	.height barHeight
	.margins marginJson
	.dimension yearDim
	.group quanYear
	.valueAccessor -> it.value.average
	.x(d3.scale.linear!.domain(year-ext))
	# .x(d3.scale.ordinal!.domain(d3.range(1,13)))
	# .xUnits dc.units.ordinal
	.elasticY true
	.colors -> colorBike2
	.on("filtered", -> updateGraph!)

bqy
	.yAxis!
	.ticks 3

bqy
	.xAxis!
	.ticks 3

barQuanMonth.width barWidth + 60
	.height barHeight
	.margins marginJson
	.dimension monthDim
	.valueAccessor -> it.value.average
	.group quanMonth
	.x(d3.scale.linear!.domain([0, 12]))
	.elasticY true
	.colors -> colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barQuanWeek.width barWidth 
	.height barHeight
	.margins marginJson
	.dimension weekdayDim
	.valueAccessor -> it.value.average
	.group quanWeekDay
	.x(d3.scale.ordinal!.domain(weekDayTable))
	.xUnits dc.units.ordinal
	.gap 4
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barQuanMkt.width (keys lsmkt).length * 65
	.height barHeight
	.margins marginJson
	.dimension mktDim
	.valueAccessor -> it.value.average
	.group quanMkt
	.x(d3.scale.ordinal!.domain(keys lsmkt))
	.xUnits dc.units.ordinal
	.gap 10
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barQyanSb.width (keys lssbtype).length * 60
	.height barHeight
	.margins marginJson
	.dimension sbDim
	.valueAccessor -> it.value.average
	.group quanSb
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 4
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barQuanTyp.width 400
	.height barHeight
	.margins marginJson
	.dimension tyDim
	.group quanTy
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 30
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3	

updateGraph = -> 
	monthDim.top Infinity
		.map ->
			if lscolor[color it.mktname] is undefined then lscolor[color it.mktname] := d3.rgb color it.mktname

			c = lscolor[color it.mktname]
			drawPixel( ~~(scale-x it.date), ~~(scale-y it[view]), c.r, c.g, c.b, 255)

	updateCanvas!

	# d3.selectAll ".marker"
	# 	.style "display" "none"


	# d3.selectAll ".marker"
	# 	.data monthDim.top Infinity
	# 	.attr {
	# 		"width": 1
	# 		"height": 1
	# 		"x": -> scale-x it.date
	# 		"y": -> scale-y it[view]
	# 		"class": "marker"
	# 	}
	# 	.style {
	# 		"fill": -> color it.mktname
	# 		"display": "inline"
	# 	}
	

dc.renderAll!
updateGraph!
