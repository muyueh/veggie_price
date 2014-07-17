{drop, each, take, map, keys, lists-to-obj} = require "prelude-ls"


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

lsveggie = ["LI萵苣菜","FY玉米","LA甘藍","SG大蒜","LC包心白","FG苦瓜","SE青蔥","LG芹菜","FV辣椒","FL豌豆","FN敏豆","FK甜椒","FI茄子","FH扁蒲","FF絲瓜","FJ番茄","LJ芥菜","LB小白菜","SP薑","SA蘿蔔","FT南瓜","FB花椰菜","SJ芋","SX芽菜類","FM菜豆","FC胡瓜","SB胡蘿蔔","FD花胡瓜","SO甘薯","FE冬瓜","LF蕹菜","LK芥藍菜","SV蘆筍","LM莧菜","FR青花苔","SF韭菜","SU薯蕷","LH菠菱菜","SD洋蔥","OX其他","SQ茭白筍","LD青江白菜","SC馬鈴薯","SF3韭菜(韭菜花)","LX蕨菜","SW球莖甘藍","FU準人瓜","LN油菜","FP萊豆","SH1竹筍(麻竹筍)","OA鹹菜","LL茼蒿","LE皇宮菜","SM牛蒡","FZ落花生","SN蓮藕","LP2九層塔","SS大心菜","OH桶筍","SF2韭菜(韭菜黃)","FQ毛豆","LO甘薯葉","LP芫荽","LQ紅鳳菜","LT海菜","FA1黃秋葵","SL1豆薯","MA洋菇","ME金絲菇","OE醃瓜","LZ薺菜","SH2竹筍(綠竹筍)","MC木耳","SH5竹筍(烏殼綠)","MD香菇","SR菱角","MI秀珍菇","MJ杏鮑菇","MF蠔菇","MB草菇","SI萵苣莖","SK荸薺","LS茴香","OG熟筍","FS越瓜","LV巴西利","OB雪里紅","OD蘿蔔乾","MX其他菇類","MK鴻禧菇","SH4竹筍(孟宗筍)","FU3石蓮花","ML珊瑚菇","FW金針花","OC榨菜","FX2虎豆(福豆)","SZ3金針筍","OI4筍茸","MN柳松菇","SH7竹筍(去殼)","OI3筍片","OI1筍乾","OI2筍絲","LU菾菜","LY1西洋菜","SZ1半天筍","FX1花豆","SZ4百合","OL朴菜","ST蕎頭","SH3竹筍(桂竹筍)","MH松茸","LY2黑甜仔菜","MG白菇","SH6竹筍(箭竹筍)","FA0其他花類","MM猴頭菇","FW2洛神花","SZ5草石蠶","LY5珍珠菜","LT3水蓮","LY6香椿","SZ6半天花","FA9百果(進口)","FO蠶豆","LY3豬母菜","LY4人參葉","SZ2甘蔗筍","LR塌棵塔","FA2樊花","SY慈菇","SL2菊芋(雪蓮薯)","FA4瓊花","SH9竹筍(進口)","ZZ其他"]
enname = ["Lettuce","Corn","Cabbage","Garlic","White Heart Bag","Bitter","Scallion","Celery","Chili","Peas","Min beans","Sweet pepper","Eggplant","Flat Po","Loofah","Tomatoes","Mustard","Cabbage","Ginger","Radish","Pumpkin","Cauliflower","Taro","Sprouts class","Kidney bean","Cucumber","Carrot","Flowers cucumber","Sweet","Melon","Ipomoea","Kale","Asparagus","Amaranth","Blue moss","Chives","Yam","Bo Ling dish","Onion","Other","Coba","Bok cabbage","Potato","Leek ( chives )","Bracken","Kohlrabi","Quasi- human melon","Cole","Lima bean","Bamboo ( bamboo shoot )","Pickle","Chrysanthemum","Palace dish","Burdock","Groundnut","Lotus","Basil","Big cabbage","Barrel shoots","Leek ( leek yellow )","Edamame","Sweet potato leaves","Coriander","Gynura","Seaweed","Okra","Yam bean","Mushroom","Watkins mushrooms","Pickled melon","Shepherd's purse","Shoots ( green shoots )","Fungus","Bamboo shoots ( black shell Green )","Mushrooms","Water chestnut","Oyster mushrooms","Mushroom","Oyster mushrooms","Straw mushroom","Stem lettuce","Water chestnuts","Fennel","Cooked bamboo shoots","Pickling melon","Basili","Potherb mustard","Radish","Other mushrooms","Hongxi mushrooms","Bamboo shoots ( Meng Zong shoots )","Stone Lotus","Coral mushroom","Daylily","Mustard","Tiger beans ( beans Fu )","Lily shoots","Velvet shoots","Liu pine mushrooms","Bamboo shoots ( shelled )","Sunpian","Bamboo shoots","Sunsi","Chard","Watercress","Half-day shoot","Bean flowers","Lily","Pak dish","Shallots","Bamboo ( bamboo shoots )","Matsutake","Aberdeen black sweet dish","White mushrooms","Bamboo ( bamboo shoots )","Other flowers","Hericium","Roselle","Chinese artichoke","Lysimachia","Shuilian","Toon","Spend half a day","Mince ( import )","Broad bean","Sow vegetables","Ginseng leaf","Bamboo cane","Narinosa tower","Fan Flower","Arrowhead","Jerusalem artichoke ( lotus potato )","Viburnum","Bamboo shoots ( import )","Other"]

lsenname = lists-to-obj lsveggie, enname

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

name = "FQ毛豆"

if window.location.hash
	input = window.location.hash.split("#")[1]

	lsveggie.map (d,i)-> if ((d.indexOf input) > -1) then name := lsveggie[i]
		# console.log ((d.indexOf input) > -1)
		# console.log (d)
		
	

err, tsvData <- d3.tsv "./data/" + name + ".tsv"

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
w = 1200 - margin.left - margin.right
h = 200 - margin.top - margin.bottom


scale-x = d3.time.scale!
	.range [0, w]
	.domain d3.extent tsvData.map -> it.date

scale-q = d3.scale.linear!
	.domain d3.extent tsvData.map -> it.quantity
	.range [0, w]

scale-y = d3.scale.linear!
	.domain [0,300]
	# .domain d3.extent tsvData.map -> it[view]	
	.range [h, 0]

line = d3.svg.line!
	.x -> scale-x it.date
	.y -> scale-y it.middleprice





fltrData = tsvData #.filter -> if it.mktname is "台中市" then true else false	



d3.select "body"
	.selectAll ".pvsq"
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

#  much more faster with buf8
buf8 = new Uint8ClampedArray(new ArrayBuffer canvasData.data.length)

drawPixel = (x, y, r, g, b, a)->
	index = (x + y * canvasWidth) * 4

	canvasData.data[index + 0] = r
	canvasData.data[index + 1] = g
	canvasData.data[index + 2] = b
	canvasData.data[index + 3] = a



clear = -> 
	canvasData.data.set buf8

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


# barWidth = 300
# barHeight = 150

barWidth = 150
barHeight = 80


marginJson =	{
	"top": 10
	"right": 10
	"left": 50
	"bottom": 30
}

# marginJson =	{
# 	"top": 10
# 	"right": 10
# 	"left": 80
# 	"bottom": 20
# }


 
colorBike = d3.rgb "\#1f77b4" .brighter 1
# d3.rgb "rgb(255, 127, 14)" .darker 1
colorBike2 = d3.rgb "\#ff7f0e" .brighter 1
# d3.rgb "rgb(255, 127, 14)" .darker 2
# '#de2d26'
	
year-ext = d3.extent tsvData.map -> it.date.getFullYear!

# console.log year-ext

bpy = barPriYear.width barWidth
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(45)"
			}		
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


bpm = barPriMonth.width barWidth + 60
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
	.dimension monthDim
	.group priceMonth
	.valueAccessor -> it.value.average
	.x(d3.scale.linear!.domain([0, 12]))
	# .x(d3.scale.ordinal!.domain(d3.range(1,13)))
		# .xUnits dc.units.ordinal
	.elasticY true
	.colors -> colorBike
	.on("filtered", -> updateGraph!)
	

bpm
	.yAxis!
	.ticks 3
	


barPriWeek.width barWidth 
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
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

barPriMkt.width (keys lsmkt).length * 25 + marginJson.left + marginJson.right
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}

		it.selectAll "rect.bar" .each -> d3.select this .attr "style", "fill:" + color it.x
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

barPriSb.width (keys lssbtype).length * 25 + marginJson.left + marginJson.right
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
	.dimension sbDim
	.group priceSb
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 15
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barPriTyp.width barWidth
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
	.dimension tyDim
	.group priceTy
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 10
	.elasticY true
	.colors colorBike
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

# -----



bqy = barQuanYear.width barWidth
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
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
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
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
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
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


barQuanMkt.width (keys lsmkt).length * 25 + marginJson.left + marginJson.right
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
		it.selectAll "rect.bar" .each -> d3.select this .attr "style", "fill:" + color it.x
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


barQyanSb.width (keys lssbtype).length * 25 + marginJson.left + marginJson.right
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
	.dimension sbDim
	.valueAccessor -> it.value.average
	.group quanSb
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 15
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barQuanTyp.width barWidth
	.height barHeight
	.margins marginJson
	.renderlet ->
		it.selectAll "g.x text"
			.attr {
				"dx": "10"
				"transform": "rotate(30)"
			}
	.dimension tyDim
	.group quanTy
	.valueAccessor -> it.value.average
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 10
	.elasticY true
	.colors colorBike2
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3	

updateGraph = -> 
	# canvasData := ctx.getImageData(0, 0, canvasWidth, canvasHeight)
	clear!
	# console.log monthDim.top(Infinity).length
	all = monthDim.top(Infinity)
	all
		.map ->
			if lscolor[color it.mktname] is undefined then lscolor[color it.mktname] := d3.rgb color it.mktname

			c = lscolor[color it.mktname]
			drawPixel( ~~(scale-x it.date), ~~(scale-y it[view]), c.r, c.g, c.b, 255)
			# drawPixel( ~~(scale-q it.quantity), ~~(scale-y it[view]), c.r, c.g, c.b, 255)

	d3.selectAll ".count"
		.text '#' + numberWithCommas all.length

	updateCanvas!

	

dc.renderAll!
updateGraph!

d3.selectAll ".title"
	.text ((drop 2, name) + lsenname[name] )

function numberWithCommas(x)
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");


set-list = (holder-name,list-data, on-click)->
	uls = d3.selectAll holder-name .append "ul"
		.attr "class" "dropdown-menu"
		.attr "role" "menu"

	uls.selectAll "li"
		.data list-data
		.enter!
		.append "li"
		# .attr "class" -> 
		# 	if it.act is null then return "divider"
		# 	if it.act is "header" then return "disabled dropdown-header "
		# 	if it.type is "viewsubind" then return "disabled subind-able"
		.append "a"
		.style "cursor" "pointer"
		.attr "data-target" "#"
		.attr "class" "dropdown-action"
		# .attr "id" -> "action" + it.act
		# .attr "href" "./scale.html"
		.text -> it
		.on "click" -> on-click(it)


set-list(".index-holder", lsveggie, -> window.open('./index.html#' + it,'_blank') )


