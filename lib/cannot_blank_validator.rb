class Cannot_Blank < ActiveModel::EachValidator
    def validate_each(object, attribute, value)
          if  value == nil or value == ""
            object.errors.add(attribute, :cannot_blank, options)
          end
    end
end
