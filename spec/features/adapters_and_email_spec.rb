require 'spec_helper'

describe 'Adapters act the same' do
  [:sendgrid, :postmark, :cloudmailin].each do |adapter|
    context adapter do
      it "wraps recipients in an array and passes them to Email by #{adapter}" do
        Griddler.configuration.email_service = adapter

        normalized_params = Griddler.configuration.email_service.normalize_params(params_for[adapter])
        email = Griddler::Email.new(normalized_params)

        email.to.should eq(['hi'])
      end
    end
  end
end

def params_for
  {
    cloudmailin: {
      envelope: {
        to: 'Hello World <hi@example.com>',
        from: 'There <there@example.com>',
      },
      plain: 'hi',
    },
    postmark: {
      FromFull: {
        Email: 'there@example.com',
        Name: 'There',
      },
      ToFull: [{
        Email: 'hi@example.com',
        Name: 'Hello World',
      }],
      TextBody: 'hi',
    },
    sendgrid: {
      text: 'hi',
      to: 'Hello World <hi@example.com>',
      from: 'There <there@example.com>',
    },
  }
end
