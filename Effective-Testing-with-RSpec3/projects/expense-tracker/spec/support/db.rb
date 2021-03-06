# configure database for test use
RSpec.configure do |c|
	# suite hook, runs once before the first spec is run
	c.before(:suite) do
		# run the migrations making sure all tables exist
		Sequel.extension :migration
		Sequel::Migrator.run(DB, 'db/migrations', :use_transactions=>false)
		# clear any lingering data
		DB[:expenses].truncate
	end

	# ensure that the database is cleared of all transactions between runs
	c.around(:example, :db) do |example|
		DB.transaction(rollback: :always) {example.run}
	end

end
