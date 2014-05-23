class MultiStorage
  class Base
    def initialize(*)
    end

    def get_content(*)
      fail 'Override get_content method'
    end

    def create(*)
      fail 'Override create method'
    end

    def delete(*)
      fail 'Override delete method'
    end
  end
end
