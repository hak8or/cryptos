// Description: Retreieves the large amount of BTC data, just BTC prices over time, via a gon 
//  variable from rails. This is used just for the BTC price data on the homepage, not the modal 
//  version. This will eventually get taken out later on and merged with the remaining gon values 
//  to decrease the total ajax requests. The output is a single member array because d3js for some
//  reason demands that the data be in an array. 
//   
// NOTE --- get_BTC_prices(), asset_prices(), and asset_values() will be merged eventually.
// Input: list of BTC prices with dates via gon variable
// Output: Single member array a has for data name and another hash containing the data itself.
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

// Description: This is used ONLY for the bar graph. Sets up the data for bar graph by
// 	fetching the most important groups of assets. The grouping is done because d3js bargraph
// 	does not like more than four items per date. Goes through the gon.shortassets array and pushes 
// 	specific data into seperate array with the associated dates.
// NOTE --- get_BTC_prices(), asset_prices(), and asset_values() will be merged eventually.
// 
// Input: latest assets with dates via gon variable
// Output: Multi-member array, each member containing a major asset(s) data and dates.
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

// Description: This is used for each individual graph to provide data and dates. Goes through
//  the gon.shortassets array and pushes specific data into seperate array with the associated dates.
// NOTE --- get_BTC_prices(), asset_prices(), and asset_values() will be merged eventually.
// 	All other similar functions will be merged into this one.
// 	
// Input: Latest assets with dates via gon variable, string to determine which asset to fetch.
// Output: Single member array, each member containing major asset data and dates.
// 
// 							/- A string denoting what asset data to fetch. Look at the underlying
// 							|  switch .. case to see possible strings.
// 							|
function asset_values(asset_option)
{
	var data = [];
	
	for (var i = 0; i < gon.short_assets.length; i++ ) 
	{
		var asset = gon.short_assets[i]
		var date = new Date(asset.time_changed);

		// I currently do not know how to have a string turn into a variable name, so I am stuck
		// with doing this as a massive switch case statement inside the loop. Once I find out
		// how to convert a string to a variable name I will just copy asset.LTC to another var
		// so I don't have to do this case statement everytime I go through this loop, saving
		// a good bit of preformance (hopefully).
		switch (asset_option)
		{
			case "LTC":
				data.push({ x: date.getTime(), y: asset.LTC }); 
				break;
			case "BTC":
				data.push({ x: date.getTime(), y: asset.BTC });
				break;
			case "XPM":
				data.push({ x: date.getTime(), y: asset.XPM });
				break;
			case "PPC":
				data.push({ x: date.getTime(), y: asset.PPC });
				break;
			case "NMC":
				data.push({ x: date.getTime(), y: asset.NMC });
				break;
			case "AsicMiner":
				data.push({ x: date.getTime(), y: asset.AsicMiner });
				break;
			case "AsicMiner_small":
				data.push({ x: date.getTime(), y: asset.AsicMiner_small });
				break;
			case "Advanced_Mining_Corp":
				data.push({ x: date.getTime(), y: asset.Advanced_Mining_Corp });
				break;
			case "BTC_Total":
				data.push({ x: date.getTime(), y: 
					gon.user_info.BTC + 
					(gon.user_info.LTC * asset.LTC) + 
					(gon.user_info.PPC * asset.PPC) +
					(gon.user_info.NMC * asset.NMC) +
					(gon.user_info.XPM * asset.XPM) +
					(gon.user_info.AsicMiner * asset.AsicMiner) +
					(gon.user_info.AsicMiner_small * asset.AsicMiner_small) +
					(gon.user_info.Advanced_Mining_Corp * asset.Advanced_Mining_Corp)
				});
				break;
			case "USD_Total":
				data.push({ x: date.getTime(), y: 
					(gon.user_info.BTC + 
					(gon.user_info.LTC * asset.LTC) + 
					(gon.user_info.PPC * asset.PPC) +
					(gon.user_info.NMC * asset.NMC) +
					(gon.user_info.XPM * asset.XPM) +
					(gon.user_info.AsicMiner * asset.AsicMiner) +
					(gon.user_info.AsicMiner_small * asset.AsicMiner_small) +
					(gon.user_info.Advanced_Mining_Corp * asset.Advanced_Mining_Corp)) * asset.BTC
				});
				break;
			default:
				data.push({ x: date.getTime(), y: 0 });
				break;
		}
	}
	return [{ values: data, key: asset_option }];
}

// Draws all the charts for the homepage when the page loads. 
// 
// Read http://stackoverflow.com/questions/588040/window-onload-vs-document-onload for more info.
// .onload only allows one function, so a singlefunction containing many other functions is called.
function Stuff_todo_on_page_load() {
	draw_chart("BTC", "no-modal");
	draw_chart("USD", "no-modal");
	draw_chart("BTC", "modal");
	draw_chart("XPM", "modal");
	draw_chart("PPC", "modal");
	draw_chart("NMC", "modal");
	draw_chart("LTC", "modal");
	draw_chart("AsicMiner", "modal");
	draw_chart("AsicMiner_small", "modal");
	draw_chart("Advanced_Mining_Corp", "modal");
	draw_chart("BTC_Total", "modal");
	draw_chart("USD_Total", "modal");

	// This is here because you cannot use css (from what I know) to set the width of an element based
	// on the screen resolution, and instead can base the percentage only on the parent element.
		document.getElementById("BTC_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("LTC_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("PPC_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("NMC_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("XPM_Modal_SVG").style.width= window.innerWidth * 0.74;

	// Same as above, but solely for securities.
		document.getElementById("AsicMiner_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("AsicMiner_small_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("Advanced_Mining_Corp_Modal_SVG").style.width= window.innerWidth * 0.74;

	// Again, same as above but solely for totals.
		document.getElementById("BTC_Total_Modal_SVG").style.width= window.innerWidth * 0.74;
		document.getElementById("USD_Total_Modal_SVG").style.width= window.innerWidth * 0.74;
};

// Since it seems jquery is throwing something alread to window.onload, this short script appends
// my function to the window.onload function.
// Taken from: http://ckon.wordpress.com/2008/07/25/stop-using-windowonload-in-javascript/
window.addEventListener ? 
window.addEventListener("load",Stuff_todo_on_page_load,false) : 
window.attachEvent && window.attachEvent("onload",Stuff_todo_on_page_load);

// Turbolinks are enabled on this rails server, resulting in window.onload not firing when a link
// is clicked due to the page not actually fully reloading. Page:load is from turbolinks, which
// fires when the page is reloaded in turbolinks terms.
// https://github.com/rails/turbolinks/#events <-- for more information
$(document).on('page:load', Stuff_todo_on_page_load)

// Description: Draws each chart on the homepage, including both in modal charts and instantly
//  visible homepage charts. Currently contains large amounts of if conditional just for two edge 
//  cases, not sure if I should just make a new function specifically for the edge cases instead of 
//  one function for all cases. Must fix these horrific if trees! ... Eventually ... Hopefully ...
//  The combination of asset and if it is based within a modal is the deciding factor for what chart
//  spot the graph will be drawn in.
//  
//  Input: Asset name to be drawn, if the asset is based within a modal.
//  Output: Chart drawn within the selected element.
//  
//  					/- The asset name which will be graphed. For possible options, look at the 
//  					|  elements containing a svg in the homepage html.
//  					|
//  					|		/- Is this chart within a modal? If not, it means the chart is 
//  					|		|  instantly visible on the homepage.
//  					|		|
function draw_chart (asset, has_modal) {
	// General cleanup of the has_modal input string.
	if (has_modal == "no-modal" || has_modal == "no_modal" || has_modal == null)
		var modal_state = "_no_Modal";
	else
		var modal_state = "_Modal";

	// We do the graph drawing in this massive convaluted function.
	nv.addGraph(function() {
		// The USD_Total bargraph on the homepage requires the chart be a .. bar graph! If the graph
		// being drawn is not a bar graph, use a normal line chart.
		if (asset == "USD" && modal_state == "_no_Modal")
			var chart = nv.models.multiBarChart();
		else
			var chart = nv.models.lineChart();

		// Sets the tick format for each axis and what data fetch function to use for each graph.
		if ( (asset == "BTC" || asset == "USD" ) && modal_state == "_no_Modal")
		{
			// The non Modal (instantly visible) graphs require the Y axis (time) to display the hour
			// as well as day, hence a seperate .tickformat configuration.
			chart.xAxis.tickFormat(function(d) {return d3.time.format('%b %d %I:%M')(new Date(d))});
			chart.yAxis.tickFormat(function(d) {return "$" + d3.format(',.2f')(d) });

			// I am here to give the two non Modal (instantly visible) graphs their currently
			// specific data. This will be nicer when I merge the get_BTC_prices(), asset_prices(), 
			// and asset_values() functions.
			if (asset == "USD")
				var data = asset_prices();
			else if (asset == "BTC")
				var data = get_BTC_prices();
		}
		else
		{
			// The modal graphs (visible when individual asset is clicked) get their own chart
			// configuration as well as using the new and proper data fetching function.
			chart.xAxis.tickFormat(function(d) { return d3.time.format('%b %d')(new Date(d)) });
			chart.yAxis.tickFormat(function(d) { return d3.format(',.5f')(d) });
			var data = asset_values(asset)
		};		

		// I am here for the modal graph showing total USD in assets over time when the user clicks
		// the Total USD "asset".
		if (asset == "USD_Total")
		{
			chart.yAxis.tickFormat(function(d) {return "$" + d3.format(',.2f')(d) });
			var data = asset_values(asset);
		}

		// Logs what the current chart being drawn is. Will keep this here while adding in extra
		// assets since this helps significantly for finding out which graph is screwed.
		console.log("d3.select " + '#' + asset + modal_state + ' svg');

		// Where to draw the graph, data source, and how long animating takes.
		d3.select('#' + asset + modal_state + ' svg') 
		.datum(data)				// What data to use for the graph.
		.transition().duration(500) // How long the animation for any changes and initial drawing is.
		.call(chart); 				// Chart is actually drawn here!

		// Removing the starting labels for in modal charts because when in modal the starting 
		// label and first label crowd over each other.
		if (modal_state == "_Modal")
			d3.select('#' + asset + modal_state + ' svg').selectAll('g.nv-axisMaxMin').remove();

		// If the window is resized, the chart gets redrawn.
		nv.utils.windowResize(chart.update);

		return chart;
	});
};