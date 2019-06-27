class TruckValidator < ActiveModel::Validator
  def validate(record)
    if !['SIMPLE', 'EXTENDED_AXIS', 'TRUCK', 'TOCO', 'THREE_QUARTERS' ].include?(record.category)
      record.errors.add(:category, "This truck category isn't valid")
    end
  end
end