#!/bin/bash

echo "=== Manual Telemetry Jaeger Diagnostic ==="
echo "Timestamp: $(date)"
echo

# Check Jaeger container
echo "🐳 Jaeger Container Status:"
docker ps | grep jaeger
echo

# Check OTLP endpoints
echo "🔗 OTLP Endpoint Tests:"
echo "HTTP endpoint (4318):"
curl -s -o /dev/null -w "Status: %{http_code}, Time: %{time_total}s\n" "http://localhost:4318" || echo "Failed"

echo "gRPC endpoint (4317) - basic connectivity:"
timeout 2 bash -c 'echo > /dev/tcp/localhost/4317' && echo "Port 4317 accessible" || echo "Port 4317 not accessible"
echo

# Check service configuration
echo "📋 Service Configuration:"
echo "microprofile-config.properties OTLP settings:"
grep -E "otel\." /workspaces/liberty-rest-app/payment/src/main/resources/META-INF/microprofile-config.properties
echo

echo "server.xml telemetry settings:"
grep -A 10 "mpTelemetry" /workspaces/liberty-rest-app/payment/src/main/liberty/config/server.xml
echo

# Test service endpoints with clear identifiers
echo "🧪 Testing Service Endpoints:"
timestamp=$(date +%s)

echo "Test 1 - Basic span:"
response1=$(curl -s "http://localhost:9080/payment/api/test-telemetry/basic?orderId=DIAG_${timestamp}_001&amount=100.00")
echo "Response: $response1"

echo "Test 2 - Advanced span:"
response2=$(curl -s "http://localhost:9080/payment/api/test-telemetry/advanced?customerId=DIAG_${timestamp}_002")
echo "Response: $response2"

echo "Test 3 - Nested spans:"
response3=$(curl -s "http://localhost:9080/payment/api/test-telemetry/nested?requestId=DIAG_${timestamp}_003")
echo "Response: $response3"

echo "Test 4 - Automatic instrumentation:"
response4=$(curl -s "http://localhost:9080/payment/api/payment-config")
echo "Response: $response4"
echo

# Wait for export
echo "⏳ Waiting 15 seconds for trace export..."
sleep 15

# Check Jaeger
echo "🔍 Jaeger Analysis:"
echo "Available services:"
services=$(curl -s "http://localhost:16686/api/services")
echo "$services"

if echo "$services" | grep -q "payment-service"; then
    echo "✅ payment-service found in Jaeger"
    
    echo "Operations available:"
    operations=$(curl -s "http://localhost:16686/api/services/payment-service/operations")
    echo "$operations"
    
    echo "Recent traces:"
    traces=$(curl -s "http://localhost:16686/api/traces?service=payment-service&limit=5&lookback=20m")
    if echo "$traces" | grep -q '"data"' && echo "$traces" | grep -q '"traceID"'; then
        trace_count=$(echo "$traces" | grep -o '"traceID"' | wc -l)
        echo "✅ Found $trace_count traces"
        
        # Show trace operations
        echo "Trace operations found:"
        echo "$traces" | grep -o '"operationName":"[^"]*"' | sort | uniq
    else
        echo "❌ No traces found"
    fi
else
    echo "❌ payment-service not found in Jaeger"
fi

echo
echo "🌐 Jaeger UI: http://localhost:16686"
echo "📊 Service: payment-service"
echo "✅ Diagnostic complete"
