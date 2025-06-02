#!/bin/bash

echo "🎯 Generating Diverse Traces for Jaeger Search Demo"
echo "=================================================="

# Check if Liberty server is running
echo "Checking if Liberty server is running..."
if ! curl -s http://localhost:9080/health > /dev/null; then
    echo "❌ Liberty server is not running. Please start it with: mvn liberty:dev"
    exit 1
fi

echo "✅ Liberty server is running"
echo ""

echo "🔄 Generating different types of traces..."

# 1. Successful payment traces with different amounts
echo "1. Creating successful payment traces..."
for amount in 25.99 75.50 125.00 250.75 499.99; do
    echo "   → Processing payment for \$${amount}"
    curl -s -X POST "http://localhost:9080/payment/payments" \
         -H "Content-Type: application/json" \
         -d "{
             \"cardNumber\": \"4111111111111111\",
             \"expiryDate\": \"12/25\",
             \"cvv\": \"123\",
             \"amount\": ${amount},
             \"currency\": \"USD\",
             \"merchantId\": \"MERCHANT_001\"
         }" > /dev/null
    sleep 1
done

# 2. Fraud detection scenarios (cards ending in 0000)
echo "2. Creating fraud detection traces..."
for amount in 50.00 100.00 200.00; do
    echo "   → Fraud check for \$${amount} (card ****0000)"
    curl -s -X POST "http://localhost:9080/payment/verify" \
         -H "Content-Type: application/json" \
         -d "{
             \"cardNumber\": \"4111111111110000\",
             \"expiryDate\": \"12/25\",
             \"cvv\": \"123\",
             \"amount\": ${amount},
             \"currency\": \"USD\",
             \"merchantId\": \"MERCHANT_FRAUD\"
         }" > /dev/null
    sleep 1
done

# 3. High-value transactions (insufficient funds)
echo "3. Creating high-value transaction traces..."
for amount in 1500.00 2000.00 5000.00; do
    echo "   → High-value payment \$${amount} (insufficient funds)"
    curl -s -X POST "http://localhost:9080/payment/verify" \
         -H "Content-Type: application/json" \
         -d "{
             \"cardNumber\": \"4111111111111111\",
             \"expiryDate\": \"12/25\",
             \"cvv\": \"123\",
             \"amount\": ${amount},
             \"currency\": \"USD\",
             \"merchantId\": \"MERCHANT_HIGH_VALUE\"
         }" > /dev/null
    sleep 1
done

# 4. Different merchants
echo "4. Creating traces for different merchants..."
merchants=("AMAZON_STORE" "WALMART_ONLINE" "BESTBUY_RETAIL" "TARGET_EXPRESS")
for merchant in "${merchants[@]}"; do
    echo "   → Payment for merchant ${merchant}"
    curl -s -X POST "http://localhost:9080/payment/payments" \
         -H "Content-Type: application/json" \
         -d "{
             \"cardNumber\": \"4111111111111111\",
             \"expiryDate\": \"12/25\",
             \"cvv\": \"123\",
             \"amount\": 89.99,
             \"currency\": \"USD\",
             \"merchantId\": \"${merchant}\"
         }" > /dev/null
    sleep 1
done

# 5. Different currencies
echo "5. Creating traces with different currencies..."
currencies=("EUR" "GBP" "CAD" "AUD")
amounts=(67.50 45.25 120.00 95.75)
for i in "${!currencies[@]}"; do
    currency="${currencies[$i]}"
    amount="${amounts[$i]}"
    echo "   → Payment in ${currency} for ${amount}"
    curl -s -X POST "http://localhost:9080/payment/payments" \
         -H "Content-Type: application/json" \
         -d "{
             \"cardNumber\": \"4111111111111111\",
             \"expiryDate\": \"12/25\",
             \"cvv\": \"123\",
             \"amount\": ${amount},
             \"currency\": \"${currency}\",
             \"merchantId\": \"INTERNATIONAL_STORE\"
         }" > /dev/null
    sleep 1
done

# 6. Basic authorization endpoint (legacy)
echo "6. Creating legacy authorization traces..."
for amount in 10 20 30 40 50; do
    echo "   → Legacy authorization for \$${amount}"
    curl -s -X POST "http://localhost:9080/payment/api/authorize?amount=${amount}" > /dev/null
    sleep 1
done

echo ""
echo "✅ Generated diverse traces for demonstration!"
echo ""
echo "🔍 Now you can search for traces in Jaeger:"
echo "   Open: http://localhost:16686"
echo ""
echo "📊 Search Examples to Try:"
echo ""
echo "🎯 BASIC SEARCHES:"
echo "   • Service: payment-service → Shows all traces"
echo "   • Service: payment-service + Lookback: Last 15m → Recent traces only"
echo ""
echo "🏷️  TAG-BASED SEARCHES:"
echo "   • Tags: payment.amount:75.50 → Specific amount"
echo "   • Tags: payment.currency:EUR → European payments"
echo "   • Tags: payment.merchantId:AMAZON_STORE → Amazon transactions"
echo "   • Tags: payment.cardNumber.masked:****-****-****-0000 → Fraud cards"
echo "   • Tags: fraud.check.result:FRAUD_DETECTED → Fraud cases"
echo "   • Tags: funds.availability:INSUFFICIENT → Failed high-value"
echo ""
echo "⚡ PERFORMANCE SEARCHES:"
echo "   • Min Duration: 1s → Slow operations"
echo "   • Max Duration: 500ms → Fast operations"
echo ""
echo "🚨 ERROR SEARCHES:"
echo "   • Tags: error:true → Failed operations"
echo "   • Tags: validation.result:FAILED → Validation errors"
echo ""
echo "🔄 OPERATION SEARCHES:"
echo "   • Operation: processPayment → Basic payment processing"
echo "   • Operation: verifyPaymentWithTelemetry → Full verification workflow"
echo ""
echo "💡 PRO TIP: Click on any trace to see detailed spans and timing!"
echo ""
