class CleanTimedAssets
	include Sidekiq::Worker
	sidekiq_options :retry => false

	# Various DB actions go on here. Meant to be used when writing out a cleaning
	# procedure in the rails console would be too much of a PITA.
	def perform
		puts "Preform running!"
		# Example of a super simple DB clean
		#TimedAsset.update_all :XPM => 0
	end
end