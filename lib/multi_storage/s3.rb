require 'aws-sdk-core'
require 'multi_storage/base'

class MultiStorage
  class S3 < Base
    def initialize(options = {})
      @root_path          = options[:s3_root]           || fail('require s3_root')
      access_key_id       = options[:access_key_id]     || fail('require access_key_id')
      secret_access_key   = options[:secret_access_key] || fail('require secret_access_key')
      @bucket             = options[:bucket]            || fail('require bucket_name')
      @s3 = Aws::S3.new(
        access_key_id:     access_key_id,
        secret_access_key: secret_access_key
      )
    end

    def get_content(stored_path)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      # 存在しないkeyにアクセスするとAws::S3::Errors::NoSuchKeyで例外を吐く
      # あとで例外chatchしてnil返すようにする
      entity = @s3.get_object(bucket: @bucket, key: stored_s3_path)
      { type: :entity, body: entity.body.string }
    end

    def create(stored_path, body)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      # over write
      @s3.put_object(bucket: @bucket, key: stored_s3_path, body: body)
    end

    def delete(stored_path)
      stored_s3_path = "#{@root_path}/#{stored_path}"
      @s3.delete_object(bucket: @bucket, key: stored_s3_path)
    end
  end
end
