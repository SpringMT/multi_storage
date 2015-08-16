require 'aws-sdk'
require 'multi_storage/base'

class MultiStorage
  class S3 < Base
    # root_pathにはenvを入れて下さい
    def initialize(options = {})
      @root_path          = options[:s3_root]           || fail('require s3_root')
      @access_key_id       = options[:access_key_id]     || fail('require access_key_id')
      @secret_access_key   = options[:secret_access_key] || fail('require secret_access_key')
      @bucket             = options[:bucket]            || fail('require bucket_name')
      #Aws.config[:region] = options[:region]            || 'ap-northeast-1'
    end

    def get_content(stored_path)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      # 存在しないkeyにアクセスするとAws::S3::Errors::NoSuchKeyで例外を吐く
      # あとで例外chatchしてnil返すようにする
      s3 = AWS::S3.new(
        access_key_id:     @access_key_id,
        secret_access_key: @secret_access_key
      )
      url_string = s3.buckets[@bucket].objects[stored_s3_path].url_for(:read).to_s
      #{ type: :entity, body: entity.read }
      { type: :reproxy, body: url_string }
    end

    def create(stored_path, body)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      # 上書きする
      s3 = AWS::S3.new(
        access_key_id:     @access_key_id,
        secret_access_key: @secret_access_key
      )
      s3.buckets[@bucket].objects.create(stored_s3_path, body)
    end

    def delete(stored_path)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      s3 = AWS::S3.new(
        access_key_id:     @access_key_id,
        secret_access_key: @secret_access_key
      )
      s3.buckets[@bucket].objects[stored_s3_path].delete
    end
  end
end
