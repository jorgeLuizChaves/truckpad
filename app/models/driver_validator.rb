class DriverValidator < ActiveModel::Validator
  def validate(record)
    if record.age != nil && record.age < 18
      record.errors.add(:age, "It's too young, You can't driver a truck legally.")
    end

    if record.gender != nil && is_not_valid?(record.gender)
      record.errors.add(:gender, "Invalid gender options.")
    end

  end

  private 
  def is_not_valid?(gender)
    !["MALE", "FEMALE", "OTHER"].include?(gender)
  end
end