Description
================================
Very Unfinished CryptoCurrency dashboard. Still in Pre Alpha

A rails based application meant to allow a user to see their cryptocurrency related investments over time in one place instead of having to navigate to various websites. It currently fetches information by the API's provided by bitfunder, BTCT, and BTC-E, bitcoinaverage.com and stores them in a database within the rails framework. This project is meant as a way for me to learn Ruby on Rails!

Tools Used
================================
<dl>
	<dt>gon & gon.watch [https://github.com/gazay/gon]</dt>
	<dd>Send variables from your rails application to variables which can be used in javascript easily and quickly. Gon.watch is a fantastic way to periodically refresh variables, with gon doing all the heavy lifting for you. Has a very kind and active developer!</dd>

	<dt>Zurb-Foundation [http://foundation.zurb.com/]</dt>
	<dd>An alternative framework instead of twitter bootstrap. Fluid grid, mobile first (I don't really utilize this), lots of awesome JS plugins such as tooltips, modals, and interchange. Also has fantastic documentation!</dd>

	<dt>SideKiq [http://sidekiq.org/]</dt>
	<dd>Awesome lightweight gem for managing cron jobs. Used to set what time or how often to run each cron job, which in this case are sidekiq workers. Very low learning curve, lightweight, and provides pretty much any time custimization you need. Works with Sidekiq.</dd>

	<dt>clockwork [https://github.com/tomykaira/clockwork]</dt>
	<dd>An alternative framework instead of twitter bootstrap. Fluid grid, mobile first (I don't really utilize this), lots of awesome JS plugins such as tooltips, modals, and interchange. Also has fantastic documentation!</dd>

	<dt>Slim [https://github.com/slim-template/slim]</dt>
	<dd>A gem which allows you to write your html based views in a much more readable mannar, using less tags, and makes inline ruby look much more readable when mixed with your html. Currently this is used only for the web ui for sidekiq, but I am considering shifting all the HTML views over to slim.</dd>

	<dt>Better Errors [https://github.com/charliesome/better_errors]</dt>
	<dd>A total godsend for debugging your rails code. When there is an error in your rails code, this gem replaces the standard "WHAT ARE YOU DOING!?!?" page with a more friendly page showing the backtrace, the error message in a much more readable state, and the best part, a console allowing you to run ruby code directly in the console! Uses the binding_of_caller gem for the console functionality.</dd>

	<dt>PG [https://bitbucket.org/ged/ruby-pg/wiki/Home]</dt>
	<dd>Gem for interfacing active record with postgresql instead of the default development database (nosql). For transfering data from the old nosql database, the Taps gem was used as shown here: http://railscasts.com/episodes/342-migrating-to-postgresql The taps gem unfortunatly has a unfixed bug which prevents the data migration, with my fix posted here: https://github.com/ricardochimal/taps/issues/128#issuecomment-21049046</dd>
</dl>






Author: Hak8or

*License: [GPL](https://github.com/hak8or/cryptos/GPL.TXT).*