function get_BTC_prices() {
    	var my_data = [];

		for (var i = 0; i < gon.short_BTC_prices.length; i++) {
			price = gon.short_BTC_prices[i][0];

			date = new Date(gon.short_BTC_prices[i][1]);
			
			my_data.push({x: date.getTime(), y: price })
		};

		return [{
			values: my_data,
			key: "BTC USD"
		}];
	}
	
	function asset_prices() {
		var LTC_and_XPM_worth_in_USD = [];
		var BTC_worth_in_USD = [];
		var AMC_worth_in_USD = [];
		var AsicMiner_worth_in_USD = [];

		for (var i = 0; i < gon.short_assets.length; i++) {
			asset = gon.short_assets[i];
			
			date = new Date(asset.time_changed);
			
			LTC_and_XPM_worth_in_USD.push({
				x: date, 
				y: (gon.user_info.LTC * asset.LTC * asset.BTC) + 
				   (gon.user_info.XPM * asset.XPM * asset.BTC) })

			BTC_worth_in_USD.push({
				x: date, 
				y: gon.user_info.BTC * asset.BTC})

			AMC_worth_in_USD.push({
				x: date, 
				y: gon.user_info.Advanced_Mining_Corp * asset.Advanced_Mining_Corp * asset.BTC})

			AsicMiner_worth_in_USD.push({
				x: date, 
				y: (gon.user_info.AsicMiner * asset.AsicMiner * asset.BTC) + 
				   (gon.user_info.AsicMiner_small * asset.AsicMiner_small * asset.BTC)  })
		};			

	return [
		{	values: LTC_and_XPM_worth_in_USD,
			key: "LTC & XPM"},

		{	values: BTC_worth_in_USD,
			key: "BTC"},

		{	values: AMC_worth_in_USD,
			key: "AMC"},

		{	values: AsicMiner_worth_in_USD,
			key: "AsicMiner"}
		];
	}

	nv.addGraph(function() {
	  chart = nv.models.lineChart();

	  chart.yAxis.tickFormat(function(d) { return '$' + d3.format(',.2f')(d) });

		chart.xAxis.tickFormat(function(d) {
			return d3.time.format('%a %H:%M')(new Date(d))
		});

	  d3.select('#chart1 svg')
	    .datum(get_BTC_prices())
	    .transition().duration(500)
	    .call(chart);

	  nv.utils.windowResize(chart.update);

	  return chart;
	});

	nv.addGraph({
	  generate: function() {
		chart = nv.models.multiBarChart();

		chart.yAxis.tickFormat(function(d) { return '$' + d3.format(',.2f')(d) });

		chart.xAxis.tickFormat(function(d) {
			return d3.time.format('%b %d %I:%M')(new Date(d))
		});

	    var svg = d3.select('#test1 svg')
	    .datum(asset_prices())
	    .transition().duration(500)
	    .call(chart);

	    nv.utils.windowResize(chart.update);

	    return chart;
	  },
	});