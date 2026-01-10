describe Watchly::CLI::Command do
  let(:watcher_double) { instance_double Watchly::Watcher }
  let(:argv) { ['echo hello'] }

  let(:changes) do
    instance_double(
      Watchly::Changeset,
      added:    %w[added.rb],
      modified: %w[modified.rb],
      removed:  %w[removed.rb],
      files:    %w[added.rb modified.rb]
    )
  end

  let(:env_vars) do
    {
      'WATCHLY_FILES'    => changes.files.join("\n"),
      'WATCHLY_ADDED'    => changes.added.join("\n"),
      'WATCHLY_MODIFIED' => changes.modified.join("\n"),
      'WATCHLY_REMOVED'  => changes.removed.join("\n"),
    }
  end

  before do
    allow(subject).to receive(:watcher).and_return(watcher_double)
    allow(watcher_double).to receive(:on_change).and_yield(changes).and_raise(Interrupt)
  end

  it 'shows usage' do
    expect { subject.execute }.to output_approval('command/usage')
  end

  it 'shows help' do
    expect { subject.execute ['--help'] }.to output_approval('command/help')
  end

  it 'executes the command when files change' do
    expect(subject).to receive(:system) do |_env, command|
      expect(command).to eq 'echo hello'
    end

    expect { subject.execute argv }.to output_approval('command/run')
  end

  it 'passes the correct WATCHLY_* variables to the command' do
    expect(subject).to receive(:system) do |env, _command|
      expect(env).to include(env_vars)
    end

    expect { subject.execute argv }.to output_approval('command/run')
  end

  context 'with command and glob arguments' do
    let(:argv) { ['echo hello', 'lib/**/*.rb', 'spec/**/*.rb'] }

    before do
      # temporarily disable the watcher stub
      allow(subject).to receive(:watcher).and_call_original
    end

    it 'passes the globs to the watcher' do
      allow(Watchly::Watcher).to receive(:new).and_return(watcher_double)

      expect(Watchly::Watcher).to receive(:new)
        .with(['lib/**/*.rb', 'spec/**/*.rb'], hash_including(:interval))

      expect(subject).to receive(:system)

      expect { subject.execute argv }.to output_approval('command/run')
    end
  end

  context 'with --each' do
    let(:argv) { ['echo hello', '--each'] }

    it 'executes the command for each file change' do
      expect(subject).to receive(:system).with(anything, 'echo hello')
        .exactly(changes.files.size).times

      expect { subject.execute argv }.to output_approval('command/run')
    end
  end

  context 'with --quiet' do
    let(:argv) { ['echo hello', '--quiet'] }

    it 'does not output change events' do
      allow(subject).to receive(:system)

      expect { subject.execute argv }.to output_approval('command/run-quiet')
    end
  end

  context 'with --immediate' do
    let(:argv) { ['echo hello', '--immediate'] }

    it 'runs the command once before watching' do
      allow(watcher_double).to receive(:on_change).and_raise(Interrupt)

      expect(subject).to receive(:system).with(anything, 'echo hello')
      expect { subject.execute argv }.to output_approval('command/run-immediate')
    end
  end
end
