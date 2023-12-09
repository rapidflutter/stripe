exports.paymentSheet = asyncHandler(async (req, res) => {
  try {
    console.log('strip')
  // Use an existing Customer ID if this is a returning customer.
  const customer = await stripe.customers.create();
  const ephemeralKey = await stripe.ephemeralKeys.create(
    {customer: customer.id},
    {apiVersion: '2023-10-16'}
  );
  const paymentIntent = await stripe.paymentIntents.create({
    amount: 109,
    currency: 'inr',
    customer: customer.id,
    description: 'Your transaction description here',
    // In the latest version of the API, specifying the `automatic_payment_methods` parameter is optional because Stripe enables its functionality by default.
    automatic_payment_methods: {
      enabled: true,
    },
  });

  res.json({
    paymentIntent: paymentIntent.client_secret,
    ephemeralKey: ephemeralKey.secret,
    customer: customer.id,
    publishableKey: process.env.STRIPE_PBLK_KET_TST,
  });

  } catch (error) {
    console.log(error);
    logger.error(`stripe: ${error.message}`);
    return res.json({ error: true, message: error.message, data: null });
  }
});
