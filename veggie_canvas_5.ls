{flatten, sum, drop, each, take, map, keys, lists-to-obj} = require "prelude-ls"


max-mlt = 1.5

# circular implementation of months
# temperature
# same market order

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


ggl = {}

ggl.red = "rgb(255, 0, 71)"
ggl.brown = "rgb(255, 110, 100)"
ggl.green = "rgb(0,249,153)"
ggl.blue = "rgb(104,126,255)"
ggl.white = "rgb(226,211,255)"
ggl.grey = "rgb(59,50,78)"
ggl.purple = "rgb(164, 51, 216)"
ggl.orange = "rgb(255,79,32)"
ggl.pink = "rgb(255, 130, 162)"
ggl.bck = "rgb(39,39,39)"

# color = d3.scale.ordinal!.range [ggl.red, ggl.brown, ggl.green, ggl.blue, ggl.white, ggl.purple, ggl.orange, ggl.pink]

c = d3.scale.category20!
color = ->	
	d3.rgb (c it) .brighter 1


view = "middleprice"

lsmkt = {}
lssbtype = {}
lstyphon = {}
lscolor = {}

lsveggie = ["LI萵苣菜","FY玉米","LA甘藍","SG大蒜","LC包心白","FG苦瓜","SE青蔥","LG芹菜","FV辣椒","FL豌豆","FN敏豆","FK甜椒","FI茄子","FH扁蒲","FF絲瓜","FJ番茄","LJ芥菜","LB小白菜","SP薑","SA蘿蔔","FT南瓜","FB花椰菜","SJ芋","SX芽菜類","FM菜豆","FC胡瓜","SB胡蘿蔔","FD花胡瓜","SO甘薯","FE冬瓜","LF蕹菜","LK芥藍菜","SV蘆筍","LM莧菜","FR青花苔","SF韭菜","SU薯蕷","LH菠菱菜","SD洋蔥","OX其他","SQ茭白筍","LD青江白菜","SC馬鈴薯","SF3韭菜(韭菜花)","LX蕨菜","SW球莖甘藍","FU準人瓜","LN油菜","FP萊豆","SH1竹筍(麻竹筍)","OA鹹菜","LL茼蒿","LE皇宮菜","SM牛蒡","FZ落花生","SN蓮藕","LP2九層塔","SS大心菜","OH桶筍","SF2韭菜(韭菜黃)","FQ毛豆","LO甘薯葉","LP芫荽","LQ紅鳳菜","LT海菜","FA1黃秋葵","SL1豆薯","MA洋菇","ME金絲菇","OE醃瓜","LZ薺菜","SH2竹筍(綠竹筍)","MC木耳","SH5竹筍(烏殼綠)","MD香菇","SR菱角","MI秀珍菇","MJ杏鮑菇","MF蠔菇","MB草菇","SI萵苣莖","SK荸薺","LS茴香","OG熟筍","FS越瓜","LV巴西利","OB雪里紅","OD蘿蔔乾","MX其他菇類","MK鴻禧菇","SH4竹筍(孟宗筍)","FU3石蓮花","ML珊瑚菇","FW金針花","OC榨菜","FX2虎豆(福豆)","SZ3金針筍","OI4筍茸","MN柳松菇","SH7竹筍(去殼)","OI3筍片","OI1筍乾","OI2筍絲","LU菾菜","LY1西洋菜","SZ1半天筍","FX1花豆","SZ4百合","OL朴菜","ST蕎頭","SH3竹筍(桂竹筍)","MH松茸","LY2黑甜仔菜","MG白菇","SH6竹筍(箭竹筍)","FA0其他花類","MM猴頭菇","FW2洛神花","SZ5草石蠶","LY5珍珠菜","LT3水蓮","LY6香椿","SZ6半天花","FA9百果(進口)","FO蠶豆","LY3豬母菜","LY4人參葉","SZ2甘蔗筍","LR塌棵塔","FA2樊花","SY慈菇","SL2菊芋(雪蓮薯)","FA4瓊花","SH9竹筍(進口)","ZZ其他"]
lsgdname = ["萵苣菜" "玉米" "甘藍" "大蒜" "包心白" "苦瓜" "青蔥" "芹菜" "辣椒" "豌豆" "敏豆" "甜椒" "茄子" "扁蒲" "絲瓜" "番茄" "芥菜" "小白菜" "薑" "蘿蔔" "南瓜" "花椰菜" "芋" "芽菜類" "菜豆" "胡瓜" "胡蘿蔔" "花胡瓜" "甘薯" "冬瓜" "蕹菜" "芥藍菜" "蘆筍" "莧菜" "青花苔" "韭菜" "薯蕷" "菠菱菜" "洋蔥" "其他" "茭白筍" "青江白菜" "馬鈴薯" "韭菜(韭菜花)" "蕨菜" "球莖甘藍" "準人瓜" "油菜" "萊豆" "竹筍(麻竹筍)" "鹹菜" "茼蒿" "皇宮菜" "牛蒡" "落花生" "蓮藕" "九層塔" "大心菜" "桶筍" "韭菜(韭菜黃)" "毛豆" "甘薯葉" "芫荽" "紅鳳菜" "海菜" "黃秋葵" "豆薯" "洋菇" "金絲菇" "醃瓜" "薺菜" "竹筍(綠竹筍)" "木耳" "竹筍(烏殼綠)" "香菇" "菱角" "秀珍菇" "杏鮑菇" "蠔菇" "草菇" "萵苣莖" "荸薺" "茴香" "熟筍" "越瓜" "巴西利" "雪里紅" "蘿蔔乾" "其他菇類" "鴻禧菇" "竹筍(孟宗筍)" "石蓮花" "珊瑚菇" "金針花" "榨菜" "虎豆(福豆)" "金針筍" "筍茸" "柳松菇" "竹筍(去殼)" "筍片" "筍乾" "筍絲" "菾菜" "西洋菜" "半天筍" "花豆" "百合" "朴菜" "蕎頭" "竹筍(桂竹筍)" "松茸" "黑甜仔菜" "白菇" "竹筍(箭竹筍)" "其他花類" "猴頭菇" "洛神花" "草石蠶" "珍珠菜" "水蓮" "香椿" "半天花" "百果(進口)" "蠶豆" "豬母菜" "人參葉" "甘蔗筍" "塌棵塔" "樊花" "慈菇" "菊芋(雪蓮薯)" "瓊花" "竹筍(進口)" "其他"]
tbgdname = lists-to-obj lsveggie, lsgdname

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
				# console.log "bad: " +	tp #JSON.stringify it
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
		
	

err, tsvData <- d3.tsv "./wo_out_data/" + name + ".tsv"

tsvData = tsvData
	.filter ->
		for tp of it
			if (isNaN it[tp])	is not sh-NaN[tp]
				# console.log "bad: " +	JSON.stringify it
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

		it.status =	if typhon is not undefined then typhon else "na"
		
		return true
	.sort (a, b) -> a.date - b.date



fltrData = tsvData #.filter -> if it.mktname is "台中市" then true else false	



weekDayTable = ["Sun.", "Mon.", "Tue.", "Wed.", "Thu.", "Fri.", "Sat."]


barPriYear = dc.barChart('.pricePerYear')
barPriMonth = dc.barChart('.pricePerMonth')
# barPriWeek = dc.barChart('.pricePerWeekDay')
barPriMkt = dc.barChart('.pricePerMkt')
barPriSb = dc.barChart('.pricePerSb')
barPriTyp = dc.barChart('.pricePerTyp')


barQuanYear = dc.barChart('.quanPerYear')
barQuanMonth = dc.barChart('.quanPerMonth')
# barQuanWeek = dc.barChart('.quanPerWeekDay')
barQuanMkt = dc.barChart('.quanPerMkt')
barQyanSb = dc.barChart('.quanPerSb')
barQuanTyp = dc.barChart('.quanPerTyp')


ndx = crossfilter tsvData
all = ndx.groupAll!

sml = {}

yearDim = ndx.dimension -> it.date.getFullYear!
monthDim = ndx.dimension -> it.date.getMonth!
# weekdayDim = ndx.dimension -> weekDayTable[it.date.getDay!]
mktDim = ndx.dimension -> it.mktname
sbDim = ndx.dimension -> it.sbtype
tyDim = ndx.dimension -> it.status

dateDim = ndx.dimension -> new Date it.date
mdlpDim = ndx.dimension -> it.middleprice

# dateDim.filter [new Date "2010/01/01", new Date "2013/01/01"]
	

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
priceMkt = mktDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceSb = sbDim.group!.reduce(averageAdd, averageRemove, averageInitial)
priceTy = tyDim.group!.reduce(averageAdd, averageRemove, averageInitial)
# priceWeekDay = weekdayDim.group!.reduce(averageAdd, averageRemove, averageInitial)

quanYear = yearDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanMonth = monthDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanMkt = mktDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanSb = sbDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
quanTy = tyDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)
# quanWeekDay = weekdayDim.group!.reduce(averageQuanAdd, averageQuanRemove, averageQuanInitial)


# console.log (quanYear.top Infinity).map -> it.value.average

ls-p-chrt = [priceYear, priceMonth, priceMkt, priceSb, priceTy]
ls-q-chrt = [quanYear, quanMonth, quanMkt, quanSb, quanTy]

get-max = (ls)->
	max = - Infinity
	ls.map ->
		(it. top Infinity).map ->
			# console.log it.value.average
			if it.value.average > max then max := it.value.average
	max

chrt-p-max = (get-max ls-p-chrt) * max-mlt
chrt-q-max = (get-max ls-q-chrt) * max-mlt


# barHeight = 80

barWidth = 150
barHeight = 160

# barWidth = 250
# barHeight = 200


marginJson =	{
	"top": 10
	"right": 0
	"left": 38
	"bottom": 50
}



 
colorBike = d3.rgb "\#1f77b4" .brighter 1.5
colorBike2 = d3.rgb "\#ff7f0e" .brighter 1.5
year-ext = d3.extent tsvData.map -> it.date.getFullYear!


render-act = ->
	it.selectAll "g.x text"
		.attr {
			"dx": "10"
			"transform": "rotate(45)"
		}

empty-c = (it, color)-> 
	# it.selectAll "rect.bar" 
	# 	.attr {
	# 		"style": "fill:" + ggl.bck + "; stroke:" + color
	# 	}

remove-zero = ->
	it.selectAll ".axis.x .tick"
		.style {
			"opacity": (d,i)-> if i is 0 then 0 else 1
		}

own-color = -> 
	it.selectAll "rect.bar" .each (d)-> 
		d3.select this 
			.attr {
				"style": -> if this.classList.contains "deselected" then "fill:\#ccc" else "fill:" + color d.x					
			}

# console.log priceYear.reduceSum 1

barMkt_width = (keys lsmkt).length * 25 + marginJson.left + marginJson.right
barSb_width = (keys lssbtype).length * 25 + marginJson.left + marginJson.right
barTy_width = barWidth
barMt_width = barWidth
baYr_width = barWidth	

sum_barwidth = sum [barMkt_width, barSb_width, barTy_width, barMt_width, baYr_width]

# console.log sum_barwidth
# console.log [barMkt_width, barSb_width, barTy_width, barMt_width, baYr_width]


# canvas 
margin = {top: 10, left: 15, right: 40, bottom: 30}
margin_sm = {top: 10, left: 3, right: 0, bottom: 30}

w_sm = 100 - margin_sm.left - margin_sm.right
w = sum_barwidth - margin.left - margin.right - (w_sm + margin_sm.left + margin_sm.right)
h = 200 - margin.top - margin.bottom

domain-q = d3.extent tsvData.map -> it.quantity
domain-p = d3.extent tsvData.map -> it.middleprice

scale-x = d3.time.scale!
	.range [0, w]
	.domain d3.extent tsvData.map -> it.date

scale-q = d3.scale.linear!
	.domain domain-q
	.range [0, w]

scale-y = d3.scale.linear!
	.domain [0, domain-p[1] * 1.1]
	.range [h, 0]

line = d3.svg.line!
	.x -> scale-x it.date
	.y -> scale-y it.middleprice


d3.select "body"
	.selectAll ".pvsq"
	.append "canvas"
	.attr {
		"width": w + margin.left + margin.right
		"height": h + margin.top + margin.bottom
		"id": "yearvsvalue"
	}

d3.select "body"
	.selectAll ".pvsq"
	.append "canvas"
	.attr {
		"width": w_sm + margin_sm.left + margin_sm.right
		"height": h + margin_sm.top + margin_sm.bottom
		"id": "yearvsvalue_sm"
	}

canvasXAxis = d3.svg.axis!
	.scale scale-x
	.orient "bottom"
	.ticks 10

canvasYAxis = d3.svg.axis!
	.scale scale-y
	.orient "right"
	.ticks 3


svg = d3.select "body"
	.selectAll ".pvsq"
	.append "svg"
	.attr {
		"width": w + margin.left + margin.right
		"height": h + margin.top + margin.bottom
		"class": "oversvg"
	}
	.append "g"
	.attr {
		"transform": "translate(" + margin.left + ", " + margin.top + ")"
	}

svg
	.append "g"
	.attr {
		"class": "axis x"
		"transform": "translate(0," + h + ")"
	}
	.call canvasXAxis


svg
	.append "g"
	.attr {
		"class": "axis y"
		"transform": "translate(" + w + ", 0)"
	}
	.call canvasYAxis


d3.select "body"
	.selectAll ".pvsq"
	.append "svg"
	.attr {
		"width": w_sm + margin_sm.left + margin_sm.right
		"height": h + margin_sm.top + margin_sm.bottom
		"class": "oversvg_sm"
	}
	.append "g"
	.attr {
		"transform": "translate(" + margin_sm.left + ", " + margin_sm.top + ")"
	}



canvas = document.getElementById("yearvsvalue")
canvasWidth = canvas.width
canvasHeight = canvas.height
ctx = canvas.getContext "2d"
canvasData = ctx.getImageData(0, 0, canvasWidth, canvasHeight)


canvas_sm = document.getElementById("yearvsvalue_sm")
canvasWidth_sm = canvas_sm.width
canvasHeight_sm = canvas_sm.height
ctx_sm = canvas_sm.getContext "2d"
canvasData_sm = ctx_sm.getImageData(0, 0, canvasWidth_sm, canvasHeight_sm)

#	much more faster with buf8
buf8 = new Uint8ClampedArray(new ArrayBuffer canvasData.data.length)
buf8_sm = new Uint8ClampedArray(new ArrayBuffer canvasData_sm.data.length)

drawPixel = (x, y, r, g, b, a)->
	index = ((x + margin.left) + (y + margin.top) * canvasWidth) * 4

	canvasData.data[index + 0] = r
	canvasData.data[index + 1] = g
	canvasData.data[index + 2] = b
	canvasData.data[index + 3] = a

clear = -> 
	canvasData.data.set buf8

updateCanvas = ->	
	ctx.putImageData(canvasData, 0, 0)


drawPixel_sm = (x, y, r, g, b, a)->
	for idx from 0 to 4
		index = ((idx + x + margin_sm.left + 2) + (y + margin_sm.top) * canvasWidth_sm) * 4 ## + 2

		canvasData_sm.data[index + 0] = r
		canvasData_sm.data[index + 1] = g
		canvasData_sm.data[index + 2] = b
		canvasData_sm.data[index + 3] = a

clear_sm = -> 
	canvasData_sm.data.set buf8_sm

updateCanvas_sm = ->	
	ctx_sm.putImageData(canvasData_sm, 0, 0)



# crossfilter

bpy = barPriYear.width baYr_width
	.height barHeight
	.margins marginJson
	.renderlet -> 
		render-act it		
		empty-c it, colorBike
	.dimension yearDim
	.group priceYear
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-p-max]
	.x(d3.scale.linear!.domain(year-ext))
	.colors -> colorBike
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)

bpy
	.yAxis!
	.ticks 3

bpy
	.xAxis!
	.ticks 3

bpm = barPriMonth.width barMt_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension monthDim
	.group priceMonth
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-p-max]
	.x(d3.scale.linear!.domain([-1 , 12]))
	.centerBar true
	.colors -> colorBike
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)

bpm
	.xAxis!
	.tickFormat -> if (it + 1) <= 12 then (it + 1) else ""
	.ticks 3

bpm
	.yAxis!
	.ticks 3
	
# barPriWeek.width barWidth 
# 	.height barHeight
# 	.margins marginJson
# 	.renderlet ->
# 		render-act it
# 		empty-c it, colorBike
# 	.dimension weekdayDim
# 	.group priceWeekDay
# 	.valueAccessor -> it.value.average
# 	.y d3.scale.linear!.domain [0, chrt-p-max]
# 	.x(d3.scale.ordinal!.domain(weekDayTable))
# 	.xUnits dc.units.ordinal
# 	.gap 4
# 	.colors colorBike
# .renderHorizontalGridLines true
# 	.on("filtered", -> updateGraph!)
# 	.yAxis!
# 	.ticks 3



barPriMkt.width barMkt_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		own-color it		
	.dimension mktDim
	.group priceMkt
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-p-max]
	.x(d3.scale.ordinal!.domain(keys lsmkt))
	.xUnits dc.units.ordinal
	.gap 10
	.colors colorBike
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

barPriSb.width barSb_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension sbDim
	.group priceSb
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-p-max]
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 15
	.colors colorBike
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3


barPriTyp.width barTy_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension tyDim
	.group priceTy
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-p-max]
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 10
	.colors colorBike
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!
	.ticks 3

# -----



bqy = barQuanYear.width baYr_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension yearDim
	.group quanYear
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-q-max]
	.x(d3.scale.linear!.domain(year-ext))	
	.colors -> colorBike2
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)

bqy
	.yAxis!
	.tickFormat -> fmt000 it
	.ticks 3

bqy
	.xAxis!
	.ticks 3


bqm = barQuanMonth.width barMt_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension monthDim
	.valueAccessor -> it.value.average
	.group quanMonth
	.y d3.scale.linear!.domain [0, chrt-q-max]
	.x(d3.scale.linear!.domain([-1, 12]))
	.centerBar true
	.colors -> colorBike2
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	

bqm
	.yAxis!
	.tickFormat -> fmt000 it
	.ticks 3

bqm
	.xAxis!
	.tickFormat -> if (it + 1) <= 12 then (it + 1) else ""
	.ticks 3
	# .tickValues [2 to 11 by 2]

# barQuanWeek.width barWidth 
# 	.height barHeight
# 	.margins marginJson
# 	.renderlet ->
# 		render-act it
# 		empty-c it, colorBike
# 	.dimension weekdayDim
# 	.valueAccessor -> it.value.average
# 	.group quanWeekDay
# 	.y d3.scale.linear!.domain [0, chrt-q-max]
# 	.x(d3.scale.ordinal!.domain(weekDayTable))
# 	.xUnits dc.units.ordinal
# 	.gap 4
# 	.colors colorBike2
# .renderHorizontalGridLines true
# 	.on("filtered", -> updateGraph!)
# 	.yAxis!
# 	.ticks 3




barQuanMkt.width barMkt_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		own-color it
	.dimension mktDim
	.valueAccessor -> it.value.average
	.group quanMkt
	.y d3.scale.linear!.domain [0, chrt-q-max]
	.x(d3.scale.ordinal!.domain(keys lsmkt))
	.xUnits dc.units.ordinal
	.gap 10
	.colors colorBike2
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!
	.tickFormat -> fmt000 it
	.ticks 3


barQyanSb.width barSb_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension sbDim
	.valueAccessor -> it.value.average
	.group quanSb
	.y d3.scale.linear!.domain [0, chrt-q-max]
	.x(d3.scale.ordinal!.domain(keys lssbtype))
	.xUnits dc.units.ordinal
	.gap 15
	.colors colorBike2
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!
	.tickFormat -> fmt000 it
	.ticks 3


barQuanTyp
	.width barTy_width
	.height barHeight
	.margins marginJson
	.renderlet ->
		render-act it
		empty-c it, colorBike
	.dimension tyDim
	.group quanTy
	.valueAccessor -> it.value.average
	.y d3.scale.linear!.domain [0, chrt-q-max]
	.x(d3.scale.ordinal!.domain(["na", "-10", "-5", "T", "+5" ]))
	.xUnits dc.units.ordinal
	.gap 10
	.colors colorBike2
	.renderHorizontalGridLines true
	.on("filtered", -> updateGraph!)
	.yAxis!	
	.tickFormat -> fmt000 it
	.ticks 3	


fmt = d3.format "02d"
fmt000 = d3.format ".2s"

fmtpnq = ->
	r = ~~ it
	if r > 1000
		r = 
			~~(r / 1000) + 
			"<span class='c_k'> k </span>"
	r


# dc.dataTable ".datatable"
# 	.dimension dateDim
# 	.group -> "->" + it.date.getFullYear! + "/" + fmt(it.date.getMonth! + 1)
# 	.size 40
# 	.columns [
# 		->
# 			n = (it.date.getFullYear! % 100) 
# 			"'" + (if n < 10 then ("0" + n) else n) + "/" + (it.date.getMonth! + 1) + "/" + it.date.getDate!
# 		,
# 		-> fmtpnq it.middleprice,
# 		-> fmtpnq it.quantity,
# 		-> it.mktname,
# 		-> it.sbtype
# 	]


addzero = (n)->
	if n < 10 then ("0" + n) else n

obj-to-td = ->
	n = (it.date.getFullYear! % 100) 
	[
		{
			"txt": "'" + addzero(n) + "/" + addzero(it.date.getMonth! + 1) + "/" + addzero(it.date.getDate!)
			"class": "dc-table-column _0"
		},
		{
			"txt": it.mktname
			"class": "dc-table-column _1"
			},
		{
			"txt": fmtpnq it.middleprice
			"class": "dc-table-column _2"
		},
		{
			"txt": fmtpnq it.quantity
			"class": "dc-table-column _3"
			},
		{
			"txt": it.sbtype
			"class": "dc-table-column _4"
		}
	]


# d3.selectAll ".datatable"
# 	.selectAll "tr"
# 	.data monthDim.top 50
# 	.enter!
# 	.append "tr"
# 	.style {
# 		"opacity":->	it.middleprice / 100
# 	}
# 	.attr {
# 		"class": "datatr"
# 	}
# 	.selectAll "td"
# 	.data -> obj-to-td it
# 	.enter!
# 	.append "td"
# 	.html -> it.txt
# 	.attr {
# 		"class": -> it.class
# 	}

mktorder = {}

do -> 
	odr = 0
	for mkt of lsmkt
		mktorder[mkt] := odr
		++odr

updateGraph = -> 
	# canvasData := ctx.getImageData(0, 0, canvasWidth, canvasHeight)
	clear!
	clear_sm!
	# console.log monthDim.top(Infinity).length
	d3.selectAll ".count"
		.text yearDim.top(Infinity).length

	chrt-p-max := (get-max ls-p-chrt) * max-mlt
	chrt-q-max := (get-max ls-q-chrt) * max-mlt
	# cannot figure out how to redraw axis
	

	all = yearDim.bottom(Infinity)

	all
		.map ->
			if lscolor[color it.mktname] is undefined
				lscolor[color it.mktname] := d3.rgb color it.mktname

			# if mxp < it[view] then mxp := it[view]
			# if mxq < it[view] then mxq := it.quantity
			
			c = lscolor[color it.mktname]
			drawPixel( ~~(scale-x it.date), ~~(scale-y it[view]), c.r, c.g, c.b, 255)


			drawPixel_sm(mktorder[it.mktname] * 7, ~~(scale-y it[view]), c.r, c.g, c.b, 255)

			# drawPixel( ~~(scale-x it.date), ~~(scale-y it[view]) + 1, c.r, c.g, c.b, 255)
			# drawPixel( ~~(scale-x it.date), ~~(scale-y it[view]) + 1, c.r, c.g, c.b, 255)
			# drawPixel( ~~(scale-x it.date) + 1, ~~(scale-y it[view]) + 1, c.r, c.g, c.b, 255)			
			# drawPixel( ~~(scale-x it.date) + 1, ~~(scale-y it[view]), c.r, c.g, c.b, 255)

			# drawPixel( ~~(scale-q it.quantity), ~~(scale-y it[view]), c.r, c.g, c.b, 255)

	# .data(monthDim.top 50)

# flatten
# 	monthDim.top.map -> obj-to-td it
	
	setopa = (it,i)->
		if i is 2
			((+it.txt) / 100) + 0.1
		else if i is 3
			((+it.txt) / 1000) + 0.1
		else if i is 1
			1
		else
			0.5

	trs = d3.selectAll ".datatable"
			.selectAll ".datatr"
			.data monthDim.top 50

	trs.enter!
		.append "tr"
		.attr {
			"class": "datatr"
		}

	trs
		.style {
			"opacity": 0
		}
		.transition!
		.delay (d,i)-> i * 20
		.style {
			"opacity": 1
		}

	# trs.order!

	tds = trs.selectAll "td"
		.data -> obj-to-td it

	tds.enter!
		.append "td"

	
	tds		
		.html -> it.txt
		.attr {
			"class": -> it.class
		}
		.style {			
			"color": (it,i)-> if i is 1 then lscolor[color it.txt]
			"opacity": (it, i)-> setopa it, i
		}


		# .on "mouseover" -> 
		# 	d3.select this
		# 		.style {
		# 			"opacity": 1
		# 		}
		
					

	tds.exit!
		.remove!

	trs.exit!
		.remove!

	updateCanvas!
	updateCanvas_sm!

	

dc.renderAll!
updateGraph!



d3.selectAll ".title"
	.text ((drop 2, name) + lsenname[name] )

function numberWithCommas(x)
	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");


set-list = (holder-name,list-data, on-click)->
	uls = d3.selectAll holder-name
		.append "ul"
		.attr "class" "dropdown-menu"
		.attr "role" "menu"

	rw = uls
		.append "div"
		.attr {
			"class": "row"
		}
		.style {
			"width": "1400px"
		}

	lg = list-data.length
	ncut = 12
	cut = ~~(lg / ncut)

	rw.selectAll "ul"
		.data [0 to (ncut - 1)]
		.enter!
		.append "ul"
		.attr {
			"class": "list-unstyled col-lg-" + (~~(12 / ncut))
		}
		.each (c)-> 
			d3.select this
				.selectAll "li"
				.data (list-data.filter (it, i)-> i > (c * cut) and i < ((c + 1) * cut))
				.enter!
				.append "li"
				.append "a"
				.style "cursor" "pointer"
				.attr "data-target" "#"
				.attr "class" "dropdown-action"
				.text -> tbgdname[it]
				.on "click" -> on-click(it)

set-list(".index-holder", lsveggie, -> window.open('./crossfilter.html#' + it,'_blank') )


brushCell = null

# ## Clear the previously-active brush, if any.
brushstart = (p)->
	if brushCell is not @	
		d3.select brushCell .call brush.clear!
		brushCell := @

# ## Highlight the selected circles.
brushmove = (p)->
	e = brush.extent!

	dateDim.filter [(e[0][0]), (e[1][0])]
	mdlpDim.filter [e[0][1], e[1][1]]	

	# dc.renderAll! ## if render here will cost too much
	updateGraph!

# ## If the brush is empty, select all circles.
brushend = -> 
	if brush.empty! 
		dateDim.filter null
		mdlpDim.filter null

	dc.renderAll!
	updateGraph!


brush = d3.svg.brush!
	.x scale-x
	.y scale-y
	.on "brushstart", brushstart 
	.on "brush", brushmove
	.on "brushend", brushend




brushCell_sm = null

#-- price only
brushstart_sm = (p)->
	if brushCell_sm is not @	
		d3.select brushCell_sm .call brush_sm.clear!
		brushCell_sm := @

brushmove_sm = (p)->
	e = brush_sm.extent!
	# console.log e
	mdlpDim.filter [e[0], e[1]]
	updateGraph!


brushend_sm = -> 
	if brush_sm.empty! 
		dateDim.filter null
		mdlpDim.filter null

	dc.renderAll!
	updateGraph!


brush_sm = d3.svg.brush!
	# .x scale-x
	.y scale-y
	.on "brushstart", brushstart_sm
	.on "brush", brushmove_sm
	.on "brushend", brushend_sm


$ document .ready -> 
	cnvs = document.getElementById("yearvsvalue").getBoundingClientRect!
	d3.selectAll ".oversvg"
		.style {
			"position": "fixed"
			"top": cnvs.top
			"left": cnvs.left
		}
		.select "g"
		.call brush

	cnvs_sm = document.getElementById("yearvsvalue_sm").getBoundingClientRect!
	d3.selectAll ".oversvg_sm"
		.style {
			"position": "fixed"
			"top": cnvs_sm.top
			"left": cnvs_sm.left
		}
		.select "g"
		.call brush_sm
		.selectAll "rect"
		.attr {
			"x": 0
			"width": w_sm
		}

	