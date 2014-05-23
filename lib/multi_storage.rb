require 'logger'

require 'multi_storage/file'
require 'multi_storage/s3'

class MultiStorage

  def initialize(devices, options = {})
    @logger  = options.delete(:logger) || Logger.new(STDOUT)
    @token   = options.delete(:token)  || 'multi_storage'
    @devices = []
    devices.each do |device|
      @devices.push Object.const_get("MultiStorage::#{device}").new(options)
    end
  end

  # devicesの配列の順番に試行して最初に存在するデータを返す
  # response は実体 or pathを返す {type: :path, body: path<String>} or {type: :entity, body: entity<IO>}
  def get_content(nonce)
    digested_file_path = get_digested_file_path(nonce)
    @devices.each do |device|
      content = device.get_content(digested_file_path)
      return content unless content.nil?
    end
  end

  def create(nonce, body)
    digested_file_path = get_digested_file_path(nonce)
    # create
    @devices.each do |device|
      res = device.create(digested_file_path, body)
      @logger.info res.inspect
    end
    @logger.info "CREATE: #{digested_file_path}"
    digested_file_path
  end

  def delete(nonce)
    digested_file_path = get_digested_file_path(nonce)
    # delete
    @devices.each do |device|
      res = device.delete digested_file_path
      @logger.info res.inspect
    end
    @logger.info "DELETE: #{digested_file_path}"
    true
  end

  def get_digested_file_path(nonce)
    digest_name = Digest::MD5.hexdigest(@token + nonce.to_s)
    stored_dir_name  = digest_name.slice!(0..1)
    stored_file_name = digest_name
    "#{stored_dir_name}/#{stored_file_name}"
  end
end
