#!/bin/bash

echo "=== Manual Telemetry Jaeger Verification Test ==="
echo "Timestamp: $(date)"
echo

# Function to check Jaeger connectivity
check_jaeger() {
    echo "🔍 Checking Jaeger connectivity..."
    if curl -s -f "http://localhost:16686/api/services" > /dev/null; then
        echo "✅ Jaeger UI is accessible at http://localhost:16686"
        echo "📊 Available services:"
        curl -s "http://localhost:16686/api/services" | sed 's/,/\n/g'
        echo
    else
        echo "❌ Jaeger UI not accessible"
        return 1
    fi
}

# Function to test each manual telemetry endpoint
test_manual_spans() {
    echo "🧪 Testing Manual Telemetry Endpoints..."
    local timestamp=$(date +%s)
    
    echo "1️⃣ Basic Span Test:"
    response1=$(curl -s "http://localhost:9080/payment/api/test-telemetry/basic?orderId=JAEGER_BASIC_${timestamp}&amount=199.99")
    echo "Response: $response1"
    echo
    
    echo "2️⃣ Advanced Span Test:"
    response2=$(curl -s "http://localhost:9080/payment/api/test-telemetry/advanced?customerId=JAEGER_ADV_${timestamp}")
    echo "Response: $response2"
    echo
    
    echo "3️⃣ Nested Spans Test:"
    response3=$(curl -s "http://localhost:9080/payment/api/test-telemetry/nested?requestId=JAEGER_NESTED_${timestamp}")
    echo "Response: $response3"
    echo
    
    echo "4️⃣ Automatic Instrumentation Test:"
    response4=$(curl -s -X POST "http://localhost:9080/payment/api/verify" \
        -H "Content-Type: application/json" \
        -d '{"cardNumber":"4111111111111111","cardHolderName":"Jaeger Auto","expiryDate":"12/25","securityCode":"123","amount":199.99}')
    echo "Response: $response4"
    echo
}

# Function to wait and check for traces
check_traces() {
    echo "⏳ Waiting 15 seconds for trace export..."
    sleep 15
    
    echo "🔍 Checking for traces in Jaeger..."
    
    # Check operations
    echo "📋 Available operations for payment-service:"
    operations=$(curl -s "http://localhost:16686/api/services/payment-service/operations" 2>/dev/null)
    if [ -n "$operations" ] && [ "$operations" != "null" ]; then
        echo "$operations" | sed 's/,/\n/g'
    else
        echo "❌ No operations found"
    fi
    echo
    
    # Check recent traces
    echo "📈 Recent traces for payment-service:"
    traces=$(curl -s "http://localhost:16686/api/traces?service=payment-service&limit=10&lookback=10m" 2>/dev/null)
    if [ -n "$traces" ] && echo "$traces" | grep -q '"data"'; then
        trace_count=$(echo "$traces" | grep -o '"traceID"' | wc -l)
        echo "✅ Found $trace_count traces"
        echo "First trace preview:"
        echo "$traces" | head -c 500
        echo "..."
    else
        echo "❌ No traces found"
    fi
}

# Function to verify Jaeger UI accessibility
verify_jaeger_ui() {
    echo "🌐 Jaeger UI Access Information:"
    echo "URL: http://localhost:16686"
    echo "Service: payment-service"
    echo "Expected Operations:"
    echo "  - Manual spans: payment.validation, customer.risk.assessment, payment.processing.workflow"
    echo "  - Automatic spans: JAX-RS endpoints"
    echo
}

# Main execution
main() {
    check_jaeger
    if [ $? -eq 0 ]; then
        test_manual_spans
        check_traces
        verify_jaeger_ui
        echo "✅ Verification test complete!"
        echo "🔗 Open Jaeger UI: http://localhost:16686"
    else
        echo "❌ Cannot proceed - Jaeger not accessible"
        exit 1
    fi
}

# Run the test
main
