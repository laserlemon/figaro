require 'figaro/capistrano_helper'

describe Figaro::CapistranoHelper do

  class DummyDSL
    include Figaro::CapistranoHelper

    # Replace capistrano core methods
    def fetch(key)
      'staging'
    end
  end

  subject { DummyDSL.new }

  let(:yaml) do
    <<-YAML
foo: bar
bar: baz
baz: foo

staging:
  bar: foo

production:
  bar: bar
  other: other
YAML
  end

  let(:configuration_file) do
    Tempfile.open('figaro') do |file|
      file.write(yaml)
      file.path
    end
  end

  before do
    # Stub file path with dummy configuration file
    allow_any_instance_of(Figaro::Application).to receive(:path).and_return(configuration_file)
  end

  describe '#fetch_secret' do

    it 'loads keys from application.yml' do
      expect(subject.fetch_secret 'baz').to eq('foo')
    end

    it 'returns nil when key is not present' do
      expect(subject.fetch_secret 'not_there').to be_nil
    end

    it 'returns selected environment settings' do
      expect(subject.fetch_secret 'bar').to eq('foo')
      expect(subject.fetch_secret 'other').to be_nil
    end

    it 'works with symbols' do
      expect(subject.fetch_secret :bar).to eq('foo')
    end

  end

  describe '#fetch_secret!' do

    it 'loads keys from application.yml' do
      expect(subject.fetch_secret! 'baz').to eq('foo')
    end

    it 'raise Figaro::MissingKeys when key is not present' do
      expect { subject.fetch_secret! 'not_there' }.to raise_error Figaro::MissingKeys
    end

  end

end
