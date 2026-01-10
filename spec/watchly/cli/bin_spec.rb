describe 'bin/watchly' do
  it 'runs' do
    expect(`bin/watchly`).to match_approval('bin')
  end
end
