require 'rack/test'
require 'json'
require_relative '../../app/api'

module ExpenseTracker

  RSpec.describe 'Expense Tracker API' do
    include Rack::Test::Methods

    def app
      ExpenseTracker::API.new
    end

    def post_expense(expense)
      post '/expenses', JSON.generate(expense)
      expect(last_response.status).to eq(200)
      parsed = JSON.parse(last_response.body)
      expect(parsed).to include('expense_id' => a_kind_of(Integer))
      expense.merge('id' => parsed['expense_id']) # add an ID key to the hash
    end

    it "records submitted expenses" do
      pending 'Need to persist expenses'
      coffee = post_expense(
        'payee' => 'Starbucks',
        'amount' => 5.75,
        'date' => '2017-06-10'
      )
      zoo = post_expense(
        'payee' => 'Zoo',
        'amount' => 95.20,
        'date' => '2017-06-10'
      )
      groceries = post_expense(
        'payee' => 'Whole Foods',
        'amount' => 95.20,
        'date' => '2017-06-11'
      )
      get '/expenses/2017-06-10'

      expect(last_response.status).to eq(200)
      expect(JSON.parse(last_response.body)).to contain_exactly(coffee, zoo)
    end
  end
end
