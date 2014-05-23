require File.dirname(__FILE__) + '/spec_helper'

require 'digest/md5'

class MultiStorage
  class Mock
    def initialize(*)
    end

    def get_content(*)
      { type: :mock, body: 'mock' }
    end

    def create(*)
    end

    def delete(*)
    end
  end
end

describe MultiStorage do
  let(:nonce) { 123 }
  describe :get_content do
    context 'valid' do
      subject { MultiStorage.new(%w(Mock Mock)) }
      it do
        expect(subject.get_content(nonce)).to eq(type: :mock, body: 'mock')
      end
    end
  end

  describe :create do
    context 'valid' do
      subject { MultiStorage.new(%w(Mock Mock)) }
      it do
        expect(subject.create(nonce, 'modk')).to eq subject.get_digested_file_path(nonce)
      end
    end
  end

  describe :delete do
    context 'valid' do
      subject { MultiStorage.new(%w(Mock Mock)) }
      it do
        expect(subject.delete(nonce)).to be_true
      end
    end
  end

  describe :get_digested_file_path do
    context 'valid' do
      subject { MultiStorage.new(['Mock']) }
      it do
        test_file_name = Digest::MD5.hexdigest("multi_storage#{nonce}")
        test_dir = test_file_name.slice!(0..1)
        test_file_path = "#{test_dir}/#{test_file_name}"
        expect(subject.get_digested_file_path(nonce)).to eq test_file_path
      end
    end
  end
end
