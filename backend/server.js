const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// M-Pesa Configuration
const MPESA_CONSUMER_KEY = process.env.MPESA_CONSUMER_KEY;
const MPESA_CONSUMER_SECRET = process.env.MPESA_CONSUMER_SECRET;
const MPESA_PASSKEY = process.env.MPESA_PASSKEY;
const BUSINESS_SHORT_CODE = process.env.BUSINESS_SHORT_CODE;
const CALLBACK_URL = process.env.CALLBACK_URL;

// Generate M-Pesa Access Token
async function generateAccessToken() {
  try {
    const auth = Buffer.from(
      `${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`
    ).toString('base64');

    const response = await axios.get(
      'https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials',
      {
        headers: {
          Authorization: `Basic ${auth}`,
        },
      }
    );

    return response.data.access_token;
  } catch (error) {
    console.error('Error generating access token:', error.message);
    throw error;
  }
}

// Generate Password for STK Push
function generatePassword(shortCode, passkey, timestamp) {
  const data = shortCode + passkey + timestamp;
  return Buffer.from(data).toString('base64');
}

// Generate Timestamp
function generateTimestamp() {
  const date = new Date();
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');
  return `${year}${month}${day}${hours}${minutes}${seconds}`;
}

// STK Push Route
app.post('/mpesa/stkpush', async (req, res) => {
  try {
    const { phoneNumber, amount, orderId } = req.body;

    if (!phoneNumber || !amount || !orderId) {
      return res.status(400).json({
        success: false,
        message: 'Phone number, amount, and order ID are required',
      });
    }

    const accessToken = await generateAccessToken();
    const timestamp = generateTimestamp();
    const password = generatePassword(BUSINESS_SHORT_CODE, MPESA_PASSKEY, timestamp);

    const stkPushData = {
      BusinessShortCode: BUSINESS_SHORT_CODE,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: Math.round(amount),
      PartyA: phoneNumber,
      PartyB: BUSINESS_SHORT_CODE,
      PhoneNumber: phoneNumber,
      CallBackURL: CALLBACK_URL,
      AccountReference: orderId,
      TransactionDesc: `Payment for GoCart Order ${orderId}`,
    };

    const response = await axios.post(
      'https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest',
      stkPushData,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
      }
    );

    res.json({
      success: true,
      message: 'STK Push initiated successfully',
      data: response.data,
    });
  } catch (error) {
    console.error('STK Push Error:', error.response?.data || error.message);
    res.status(500).json({
      success: false,
      message: 'Failed to initiate STK Push',
      error: error.response?.data || error.message,
    });
  }
});

// Query Transaction Status
app.post('/mpesa/query', async (req, res) => {
  try {
    const { checkoutRequestId } = req.body;

    if (!checkoutRequestId) {
      return res.status(400).json({
        success: false,
        message: 'Checkout Request ID is required',
      });
    }

    const accessToken = await generateAccessToken();
    const timestamp = generateTimestamp();
    const password = generatePassword(BUSINESS_SHORT_CODE, MPESA_PASSKEY, timestamp);

    const queryData = {
      BusinessShortCode: BUSINESS_SHORT_CODE,
      Password: password,
      Timestamp: timestamp,
      CheckoutRequestID: checkoutRequestId,
    };

    const response = await axios.post(
      'https://sandbox.safaricom.co.ke/mpesa/stkpushquery/v1/query',
      queryData,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`,
          'Content-Type': 'application/json',
        },
      }
    );

    res.json({
      success: true,
      data: response.data,
    });
  } catch (error) {
    console.error('Query Error:', error.response?.data || error.message);
    res.status(500).json({
      success: false,
      message: 'Failed to query transaction',
      error: error.response?.data || error.message,
    });
  }
});

// M-Pesa Callback Route
app.post('/mpesa/callback', async (req, res) => {
  console.log('--- M-Pesa Callback ---');
  console.log(JSON.stringify(req.body, null, 2));

  try {
    const callbackData = req.body;

    // Process the callback data
    // Update order status in Firebase based on the callback

    res.json({
      ResultCode: 0,
      ResultDesc: 'Success',
    });
  } catch (error) {
    console.error('Callback Error:', error.message);
    res.status(500).json({
      ResultCode: 1,
      ResultDesc: 'Failed',
    });
  }
});

// Health Check
app.get('/health', (req, res) => {
  res.json({
    status: 'OK',
    message: 'GoCart Backend is running',
    timestamp: new Date().toISOString(),
  });
});

// Start Server
app.listen(PORT, () => {
  console.log(`🚀 GoCart Backend running on port ${PORT}`);
  console.log(`📱 M-Pesa Integration Active`);
});