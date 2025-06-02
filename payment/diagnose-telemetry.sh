#!/bin/bash

echo "🔍 Diagnosing Payment Service and Jaeger Connectivity"
echo "===================================================="

echo "1. Checking Liberty server status..."
if curl -s http://localhost:9080/health > /dev/null; then
    echo "✅ Liberty server is responding"
    curl -s http://localhost:9080/health | jq 2>/dev/null || curl -s http://localhost:9080/health
else
    echo "❌ Liberty server is not responding on port 9080"
    exit 1
fi

echo ""
echo "2. Checking Jaeger UI status..."
if curl -s http://localhost:16686/api/services > /dev/null; then
    echo "✅ Jaeger UI is responding"
    echo "Current services in Jaeger:"
    curl -s http://localhost:16686/api/services | jq 2>/dev/null || curl -s http://localhost:16686/api/services
else
    echo "❌ Jaeger UI is not responding on port 16686"
    echo "Make sure to start Jaeger with: docker-compose -f docker-compose-jaeger.yml up -d"
fi

echo ""
echo "3. Testing basic payment endpoint..."
response=$(curl -s -w "%{http_code}" -o /tmp/payment_response.txt -X POST "http://localhost:9080/payment/api/authorize?amount=100")
if [ "$response" = "200" ]; then
    echo "✅ Basic payment endpoint is working"
    echo "Response: $(cat /tmp/payment_response.txt)"
else
    echo "❌ Basic payment endpoint failed with HTTP code: $response"
    echo "Response: $(cat /tmp/payment_response.txt)"
fi

echo ""
echo "4. Testing OpenAPI endpoint..."
response=$(curl -s -w "%{http_code}" -o /tmp/openapi_response.txt "http://localhost:9080/openapi")
if [ "$response" = "200" ]; then
    echo "✅ OpenAPI endpoint is working"
    echo "Available endpoints:"
    curl -s "http://localhost:9080/openapi" | grep -o '"\/[^"]*"' | head -10 | sort | uniq
else
    echo "❌ OpenAPI endpoint failed with HTTP code: $response"
fi

echo ""
echo "5. Generating test trace..."
echo "Calling payment endpoint to generate traces..."
for i in {1..3}; do
    echo "  Request $i..."
    curl -s -X POST "http://localhost:9080/payment/api/authorize?amount=${i}0" > /dev/null
    sleep 2
done

echo ""
echo "6. Checking if traces appeared in Jaeger..."
sleep 5  # Wait for traces to be processed
services=$(curl -s "http://localhost:16686/api/services" | grep -o '"payment-service"' || echo "not found")
if [ "$services" = '"payment-service"' ]; then
    echo "✅ SUCCESS: payment-service now appears in Jaeger!"
    echo ""
    echo "🎯 To view traces:"
    echo "   1. Open http://localhost:16686"
    echo "   2. Select 'payment-service' from the Service dropdown"
    echo "   3. Click 'Find Traces'"
else
    echo "❌ payment-service still not appearing in Jaeger"
    echo ""
    echo "Current services:"
    curl -s "http://localhost:16686/api/services"
    echo ""
    echo ""
    echo "🔧 Troubleshooting steps:"
    echo "   1. Check server logs: tail -f target/liberty/wlp/usr/servers/mpServer/logs/messages.log"
    echo "   2. Restart Liberty server: Ctrl+C then mvn liberty:dev"
    echo "   3. Check if Jaeger collector is accessible: curl http://localhost:14268/api/traces"
fi

echo ""
echo "🏁 Diagnosis complete!"
