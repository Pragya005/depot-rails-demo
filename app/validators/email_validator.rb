class EmailValidator < ActiveModel::EachValidator
  EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  def validate_each(record, attribute, value)
    if value.blank?
      record.errors.add(attribute, "can't be blank")
      return
    end
    unless value.match?(EMAIL_REGEX)
      record.errors.add(attribute, "is not a valid email address")
    end
  end
end
