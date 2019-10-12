class AttachedFileValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, file)
    expected_type = options.fetch(:is)
    type_checker_method = "#{expected_type}?"

    return if file.blob.send(type_checker_method.to_sym)

    file.purge_later

    record.errors.add(attribute, :invalid_type, valid_type: expected_type)
  end
end
