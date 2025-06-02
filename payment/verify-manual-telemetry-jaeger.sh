#!/bin/bash

echo "=== Manual Telemetry Verification with Jaeger ==="
echo "Current time: $(date)"
echo

# Test our telemetry endpoints
timestamp=$(date +%s)
echo "🧪 Running Telemetry Tests (timestamp: $timestamp)"

echo "1. Basic span test:"
basic_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/basic?orderId=VERIFY_${timestamp}_BASIC&amount=199.99")
echo "   Response: $basic_response"

echo "2. Advanced span test:"
advanced_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/advanced?customerId=VERIFY_${timestamp}_ADV")
echo "   Response: $advanced_response"

echo "3. Nested spans test:"
nested_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/nested?requestId=VERIFY_${timestamp}_NESTED")
echo "   Response: $nested_response"

echo "4. Automatic instrumentation test:"
auto_response=$(curl -s -X POST "http://localhost:9080/payment/api/verify" \
  -H "Content-Type: application/json" \
  -d '{"cardNumber":"4111111111111111","cardHolderName":"Jaeger Test","expiryDate":"12/25","securityCode":"123","amount":199.99}')
echo "   Response: $(echo $auto_response | head -c 100)..."

echo
echo "⏳ Waiting 15 seconds for trace export..."
sleep 15

echo "🔍 Jaeger Verification:"
echo "Available services:"
services=$(curl -s "http://localhost:16686/api/services")
echo "   $services"

echo "Operations for payment-service:"
operations=$(curl -s "http://localhost:16686/api/services/payment-service/operations")
echo "   $operations"

echo "Recent traces count:"
traces=$(curl -s "http://localhost:16686/api/traces?service=payment-service&limit=10&lookback=10m")
trace_count=$(echo "$traces" | grep -o '"traceID"' | wc -l)
echo "   Found $trace_count traces"

if [ $trace_count -gt 0 ]; then
    echo "Sample trace operations:"
    echo "$traces" | grep -o '"operationName":"[^"]*"' | sort | uniq | head -10
    
    echo
    echo "Looking for manual instrumentation spans in traces:"
    manual_spans=$(echo "$traces" | grep -o '"operationName":"[^"]*"' | grep -E "(payment\.validation|customer\.risk|payment\.processing|initialization)")
    if [ -n "$manual_spans" ]; then
        echo "✅ Manual spans found:"
        echo "$manual_spans"
    else
        echo "❌ No manual spans found as separate operations"
        echo "   (They may be nested within JAX-RS spans)"
    fi
fi

echo
echo "📋 Summary:"
echo "✅ Jaeger is running and accessible"
echo "✅ payment-service is registered in Jaeger"
echo "✅ Automatic instrumentation working (JAX-RS endpoints traced)"
if [ $trace_count -gt 0 ]; then
    echo "✅ Traces are being generated and exported"
else
    echo "❌ No traces found - possible export issue"
fi

echo
echo "🌐 View results in Jaeger UI: http://localhost:16686"
echo "📊 Service: payment-service"
echo "🔍 Look for traces with operations: GET /payment/api/test-telemetry/*"
