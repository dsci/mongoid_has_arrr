class Author < ActiveRecord::Base

end

class Label < ActiveRecord::Base

end

class City < ActiveRecord::Base

end

class Publisher < ActiveRecord::Base

end

class Editor < ActiveRecord::Base

end

module Publishing
  class Price < ActiveRecord::Base
    self.table_name="prices"
  end
end