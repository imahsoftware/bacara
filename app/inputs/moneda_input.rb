class MonedaInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    input_options = input_html_options.merge({data: {autonumeric: true}})
    merged_input_options = merge_wrapper_options(input_options, wrapper_options)

    template.content_tag(:div) do
      template.concat @builder.text_field(attribute_name, merged_input_options)
    end
  end
end
