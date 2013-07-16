class CleanAveragesDB
	include Sidekiq::Worker
	sidekiq_options :retry => false

	# Cleans up the average tables.
	# Todo: Delete TimedAsset rows which are closer than 5 seconds together
	# 		Fill gaps with averages of surrounding rows
	def perform
		puts "Cleaning averages DBs"
		FiveminuteTimedAsset.destroy_all
		ThirtyminuteTimedAsset.destroy_all
		TwohoursTimedAsset.destroy_all
		SixhoursTimedAsset.destroy_all
		puts "Done cleaning averages DBs"
	end
end