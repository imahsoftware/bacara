# Paperclip 6.1.0 + Rails 7 / Ruby 3.x compatibility fixes
#
# Problema 1 – AttachmentSizeValidator:
#   Hereda de NumericalityValidator cuyo CHECKS en Rails 7 devuelve arrays
#   [operador, clave] en vez de símbolos. Además llama errors.add con hash posicional.
#
# Problema 2 – AttachmentContentTypeValidator:
#   mark_invalid llama errors.add(attr, :invalid, options_hash) con 3 args posicionales.
#   En Rails 7 errors.add acepta máximo 2 posicionales + **kwargs → ArgumentError.

Rails.application.config.after_initialize do
  # ── Fix 1: AttachmentContentTypeValidator#mark_invalid ───────────────────────
  if defined?(Paperclip::Validators::AttachmentContentTypeValidator)
    Paperclip::Validators::AttachmentContentTypeValidator.class_eval do
      def mark_invalid(record, attribute, types)
        record.errors.add attribute, :invalid, **options.merge(types: types.join(', '))
      end
    end
  end

  # ── Fix 2: AttachmentSizeValidator#validate_each ─────────────────────────────
  klass = defined?(Paperclip::Validators::AttachmentSizeValidator) &&
          Paperclip::Validators::AttachmentSizeValidator
  if klass
    unless klass.const_defined?(:SIZE_OPERATORS, false)
      klass.const_set(:SIZE_OPERATORS, {
        less_than:                :<,
        less_than_or_equal_to:    :<=,
        greater_than:             :>,
        greater_than_or_equal_to: :>=
      }.freeze)
    end

    available_checks = klass::AVAILABLE_CHECKS
    size_operators   = klass::SIZE_OPERATORS

    klass.send(:define_method, :validate_each) do |record, attr_name, value|
      base_attr_name = attr_name
      attr_name      = :"#{attr_name}_file_size"
      value          = record.send(:read_attribute_for_validation, attr_name)

      return if value.blank?

      options.slice(*available_checks).each do |option, option_value|
        option_value = option_value.call(record) if option_value.is_a?(Proc)
        option_value = send(:extract_option_value, option, option_value)

        operator = size_operators[option]
        next unless operator

        unless value.send(operator, option_value)
          error_key = options[:in] ? :in_between : option
          [attr_name, base_attr_name].each do |err_attr|
            record.errors.add(
              err_attr, error_key,
              **send(:filtered_options, value).merge(
                min:   send(:min_value_in_human_size, record),
                max:   send(:max_value_in_human_size, record),
                count: send(:human_size, option_value)
              )
            )
          end
        end
      end
    end
  end
end
