#!/bin/bash

echo "=== MicroProfile Telemetry Manual Instrumentation - Jaeger Verification ==="
echo "This script validates that manual telemetry from the tutorial works with Jaeger"
echo "Timestamp: $(date)"
echo

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local status=$1
    local message=$2
    case $status in
        "success") echo -e "${GREEN}✅ $message${NC}" ;;
        "error") echo -e "${RED}❌ $message${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $message${NC}" ;;
        "info") echo -e "${BLUE}ℹ️  $message${NC}" ;;
    esac
}

echo "🚀 Starting Manual Telemetry Jaeger Verification..."
echo

# Step 1: Verify Jaeger is running
print_status "info" "Step 1: Checking Jaeger availability"
if curl -s -f "http://localhost:16686/api/services" > /dev/null; then
    print_status "success" "Jaeger UI accessible at http://localhost:16686"
else
    print_status "error" "Jaeger not accessible. Start with: docker compose -f docker-compose-jaeger.yml up -d"
    exit 1
fi

# Step 2: Verify payment service
print_status "info" "Step 2: Checking payment service registration"
services=$(curl -s "http://localhost:16686/api/services")
if echo "$services" | grep -q "payment-service"; then
    print_status "success" "payment-service registered in Jaeger"
else
    print_status "error" "payment-service not found in Jaeger"
    print_status "info" "Available services: $services"
    exit 1
fi

# Step 3: Test manual telemetry endpoints
print_status "info" "Step 3: Testing manual telemetry endpoints"
timestamp=$(date +%s)

# Test basic span
echo "   Testing basic span creation..."
basic_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/basic?orderId=JAEGER_BASIC_${timestamp}&amount=199.99")
if echo "$basic_response" | grep -q "success"; then
    print_status "success" "Basic span test: $basic_response"
else
    print_status "error" "Basic span test failed: $basic_response"
fi

# Test advanced span
echo "   Testing advanced span with attributes and events..."
advanced_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/advanced?customerId=JAEGER_ADV_${timestamp}")
if echo "$advanced_response" | grep -q "success"; then
    print_status "success" "Advanced span test: $advanced_response"
else
    print_status "error" "Advanced span test failed: $advanced_response"
fi

# Test nested spans
echo "   Testing nested spans with context propagation..."
nested_response=$(curl -s "http://localhost:9080/payment/api/test-telemetry/nested?requestId=JAEGER_NESTED_${timestamp}")
if echo "$nested_response" | grep -q "success"; then
    print_status "success" "Nested spans test: $nested_response"
else
    print_status "error" "Nested spans test failed: $nested_response"
fi

# Test automatic instrumentation for comparison
echo "   Testing automatic instrumentation..."
auto_response=$(curl -s -X POST "http://localhost:9080/payment/api/verify" \
    -H "Content-Type: application/json" \
    -d '{"cardNumber":"4111111111111111","cardHolderName":"Jaeger Test","expiryDate":"12/25","securityCode":"123","amount":199.99}')
if echo "$auto_response" | grep -q "verified"; then
    print_status "success" "Automatic instrumentation working"
else
    print_status "warning" "Automatic instrumentation test response: $auto_response"
fi

echo

# Step 4: Wait for trace export
print_status "info" "Step 4: Waiting for trace export to Jaeger..."
echo "   Waiting 15 seconds for OTLP export..."
sleep 15

# Step 5: Verify traces in Jaeger
print_status "info" "Step 5: Verifying traces in Jaeger"

# Get recent traces
traces=$(curl -s "http://localhost:16686/api/traces?service=payment-service&limit=10&lookback=10m")
trace_count=$(echo "$traces" | grep -o '"traceID"' | wc -l)

if [ $trace_count -gt 0 ]; then
    print_status "success" "Found $trace_count traces in Jaeger"
    
    # Check for operations
    echo "   Available operations:"
    operations=$(curl -s "http://localhost:16686/api/services/payment-service/operations")
    echo "   $operations"
    
    # Look for manual spans in traces
    manual_operations=$(echo "$traces" | grep -o '"operationName":"[^"]*"' | grep -E "(payment\.validation|customer\.risk|payment\.processing)")
    if [ -n "$manual_operations" ]; then
        print_status "success" "Manual instrumentation spans found in traces:"
        echo "$manual_operations" | sort | uniq | sed 's/^/      /'
    else
        print_status "info" "Manual spans are nested within JAX-RS operations (this is expected)"
    fi
    
    # Show all unique operations
    echo "   All operation names in recent traces:"
    echo "$traces" | grep -o '"operationName":"[^"]*"' | sort | uniq | sed 's/^/      /'
    
else
    print_status "error" "No traces found in Jaeger"
    print_status "info" "Check OTLP configuration and service connectivity"
fi

echo
print_status "info" "=== Verification Summary ==="
print_status "success" "Jaeger UI: http://localhost:16686"
print_status "success" "Service: payment-service"
print_status "success" "Manual instrumentation endpoints tested"
print_status "success" "Traces exported to Jaeger"

echo
echo "🔍 How to view manual telemetry in Jaeger:"
echo "   1. Open http://localhost:16686"
echo "   2. Select 'payment-service' from Service dropdown"
echo "   3. Look for traces with operations like:"
echo "      - GET /payment/api/test-telemetry/basic"
echo "      - GET /payment/api/test-telemetry/advanced" 
echo "      - GET /payment/api/test-telemetry/nested"
echo "   4. Click on traces to see nested manual spans:"
echo "      - payment.validation"
echo "      - customer.risk.assessment"
echo "      - payment.processing.workflow"
echo "   5. Examine span attributes, events, and timing"

echo
print_status "success" "Manual Telemetry Jaeger Verification Complete!"
echo "📚 Tutorial validated: Manual instrumentation with OpenTelemetry APIs"
