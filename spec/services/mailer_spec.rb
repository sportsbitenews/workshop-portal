require "rails_helper"

RSpec.describe Mailer, type: :service do
  let(:recipients) { ['test@example.de', 'test2@example.de'] }
  let(:recipients_string) { 'test@example.de, test2@example.de' }
  let(:reply_to) { ['test3@example.de'] }
  let(:subject) {'Subject'}
  let(:content) {'Awesome content'}

  describe 'mail sending with direct addressing' do
    it 'sends right amount of emails' do
      expect{Mailer.send_generic_email(false, recipients, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(1)
    end
  end

  describe 'mail sending with indirect addressing' do
    it 'sends right amount of emails' do
      expect{Mailer.send_generic_email(true, recipients, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(recipients.count)
    end

    it 'sends right amount of emails' do
      expect{Mailer.send_generic_email(true, recipients_string, reply_to, subject, content)}.to change{ActionMailer::Base.deliveries.count}.by(recipients.count)
    end

    it 'hides recipients from each other with array' do
      Mailer.send_generic_email(true, recipients, reply_to, subject, content)
      ActionMailer::Base.deliveries.last(recipients.count).each do |delivery|
        expect(delivery.to.count).to eq(1)
      end
    end

    it 'hides recipients from each other with string' do
      Mailer.send_generic_email(true, recipients_string, reply_to, subject, content)
      ActionMailer::Base.deliveries.last((recipients_string.count ',') + 1).each do |delivery|
        expect(delivery.to.count).to eq(1)
      end
    end
  end
end