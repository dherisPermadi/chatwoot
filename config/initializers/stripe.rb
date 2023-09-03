require 'stripe'

api_key = ENV.fetch('STRIPE_SECRET_KEY', nil)

Stripe.api_key = api_key if api_key.present?