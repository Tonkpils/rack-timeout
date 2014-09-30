require 'spec_helper'

if defined?(Rails)
  include Rails3Generator if Rails::VERSION::MAJOR == 3
  include Rails4Generator if Rails::VERSION::MAJOR == 4

  RACK_TIMEOUT_TIME = 2
  describe "Rails #{Rails::VERSION::MAJOR} Integration", type: :feature do
    before :all do
      create_app
      add_rack_timeout(RACK_TIMEOUT_TIME)
      set_log_level(:fatal)
      create_sleep_controller
      start_app
    end
    
    after :all do
      destroy_app
    end

    it "returns 200 for a short request" do
      time = 1
      response_time = Benchmark.realtime { Capybara.visit "/sleep/#{time}" }
      expect(Capybara.page.status_code).to eq(200)
      expect(response_time).to be_within(0.5).of(time)
    end

    it "returns 500 in the correct amount of time for a long request" do
      time = 4
      timeout_time = RACK_TIMEOUT_TIME
      response_time = Benchmark.realtime { Capybara.visit "/sleep/#{time}" }
      expect(Capybara.page.status_code).to eq(500)
      expect(Capybara.page).to have_content("Request ran for longer")
      # allow an extra 0.5s
      expect(response_time).to be_within(0.5).of(timeout_time)
    end
  end
end