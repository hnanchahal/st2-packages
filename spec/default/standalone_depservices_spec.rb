require 'spec_helper'

shared_examples 'start st2 services' do
  WAITFORSTART = 10

  before(:context) do
    ST2Specs[:services].each do |svc|
      cmd = ST2Specs.backend.command.get(:start_service, svc)
      ST2Specs.backend.run_command(cmd)
    end
    puts '===> Started st2 services and wait for them to start' \
         " #{WAITFORSTART} sec..."
    sleep WAITFORSTART
  end
end

describe 'St2 services' do
  include_examples 'start st2 services'

  # buggy buggy netcat and serverspec!
  describe host(ENV['RABBITMQHOST']) do
    it { is_expected.to be_reachable }
    # the next is buggy :(, thus disabled
    # it { is_expected.to be_reachable.with(port: 5672) }
  end

  describe host(ENV['MONGODBHOST']) do
    it { is_expected.to be_reachable }
    # it { is_expected.to be_reachable.with(port: 27_017) }
  end

  ST2Specs[:services].each do |svc|
    describe service(svc) do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end
  end
end
