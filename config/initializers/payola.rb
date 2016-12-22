Payola.configure do |config|

  if Rails.env.development?
    config.secret_key = "sk_test_d7IxwPNsxUZm3DUnemxzKZqM"
    config.publishable_key = "pk_test_m1qT4u49pPqliYXWOCCXMd6k"
  else
    config.secret_key = "sk_live_NSXg9kkefTQSe8rqdY9xSZK0"
    config.publishable_key = "pk_live_3GnDWMS8iGK9jiP0NWVhgr8W"
  end

  # config.secret_key = "sk_test_d7IxwPNsxUZm3DUnemxzKZqM"
  # config.publishable_key = "pk_test_m1qT4u49pPqliYXWOCCXMd6k"

  # Example subscription:
  # 
  # config.subscribe 'payola.package.sale.finished' do |sale|
  #   EmailSender.send_an_email(sale.email)
  # end
  # 
  # In addition to any event that Stripe sends, you can subscribe
  # to the following special payola events:
  #
  #  - payola.<sellable class>.sale.finished
  #  - payola.<sellable class>.sale.refunded
  #  - payola.<sellable class>.sale.failed
  #
  # These events consume a Payola::Sale, not a Stripe::Event
  #
  # Example charge verifier:
  #
  # config.charge_verifier = lambda do |sale|
  #   raise "Nope!" if sale.email.includes?('yahoo.com')
  # end

  # Keep this subscription unless you want to disable refund handling
  config.subscribe 'charge.refunded' do |event|
    sale = Payola::Sale.find_by(stripe_id: event.data.object.id)
    sale.refund! unless sale.refunded?
  end

  config.subscribe('payola.subscription.active') do |sub|
    admin = Admin.find_by(email: sub.email)

    if admin.nil?
      raw_token, enc_token = Devise.token_generator.generate(
                   Admin, :reset_password_token)
      password = SecureRandom.hex(32)

      admin = Admin.create!(
        email: sub.email,
        password: password,
        password_confirmation: password,
        reset_password_token: enc_token,
        reset_password_sent_at: Time.now
      )
      # WhateverYourPasswordMailerIsNamed.whatever_the_mail_method_is(user, raw_token).deliver
    end

    sub.owner = admin
    sub.save!
  end

end
