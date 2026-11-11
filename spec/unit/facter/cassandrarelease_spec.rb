# frozen_string_literal: true

require 'spec_helper'

describe 'cassandrarelease' do
  before { Facter.clear }

  after { Facter.clear }

  context 'without nodetool' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('nodetool').and_return(nil)
      allow(Facter::Core::Execution).to receive(:execute)
    end

    it 'does not run nodetool' do
      expect(Facter.fact(:cassandrarelease)&.value).to be_nil
      expect(Facter::Core::Execution).not_to have_received(:execute).with('nodetool version')
    end
  end

  context 'with nodetool' do
    before do
      allow(Facter::Core::Execution).to receive(:which).with('nodetool').and_return('/usr/bin/nodetool')
      allow(Facter::Core::Execution).to receive(:execute).with('nodetool version').and_return('ReleaseVersion: 5.0.4')
    end

    it { expect(Facter.fact(:cassandrarelease).value).to eq '5.0.4' }
  end
end
