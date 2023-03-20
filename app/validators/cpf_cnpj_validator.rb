require 'cpf_cnpj'

class CpfCnpjValidator < ActiveModel::EachValidator
  def validate_each(records, attributes, value)
    return unless value.present?
    unless CPF.valid?(value) || CNPJ.valid?(value)
      records.errors.add(attributes, :invalid_cpf_cnpj)
    end
  end
end