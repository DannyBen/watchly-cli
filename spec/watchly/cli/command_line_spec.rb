describe Watchly::CLI::CommandLine do
  describe '.router' do
    it 'builds a MisterBin runner with the correct configuration' do
      runner = described_class.router

      expect(runner).to be_a(MisterBin::Runner)
      expect(runner.handler).to eq(Watchly::CLI::Command)
    end
  end
end
