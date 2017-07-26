# frozen_string_literal: true

module SoapyCake
  class RequestMassConversionInsert < Request
    private

    # There is a bug in MassConversionInsert version 2 API in cake,
    # in which xmlns is still using version 1.
    def xml_namespaces
      {
        'xmlns:env' => 'http://www.w3.org/2003/05/soap-envelope',
        'xmlns:cake' => 'http://cakemarketing.com/api/1/'
      }
    end
  end
end
