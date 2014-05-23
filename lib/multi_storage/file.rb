require 'fileutils'
require 'multi_storage/base'

class MultiStorage
  class File < Base
    def initialize(options = {})
      @root_path  = options[:file_root] || fail('require file_root')
    end

    def get_content(stored_path)
      stored_file_path = "#{@root_path}/#{stored_path}"
      return nil unless ::File.exist? stored_file_path
      { type: :path, body: stored_file_path }
    end

    def create(stored_path, body)
      stored_file_path = "#{@root_path}/#{stored_path}"
      stored_dir = ::File.dirname stored_file_path
      FileUtils.mkdir stored_dir unless Dir.exist? stored_dir
      # over write
      ::File.open(stored_file_path, 'wb') { |f| f.write(body) }
    end

    def delete(stored_path)
      stored_file_path = "#{@root_path}/#{stored_path}"
      ::File.unlink stored_file_path
    end
  end
end
