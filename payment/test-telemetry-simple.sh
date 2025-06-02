#!/bin/bash

echo "🚀 Testing Payment Service with Telemetry"
echo "=========================================="

# Test the working endpoint multiple times to generate traces
echo "Generating payment traces..."

for i in {1..5}; do
    echo "Request $i: Processing payment for amount \$${i}0"
    response=$(curl -s -X POST "http://localhost:9080/payment/api/authorize?amount=${i}0")
    echo "Response: $response"
    sleep 1
done

echo ""
echo "✅ Generated multiple payment traces!"
echo ""
echo "🔍 To view traces in Jaeger:"
echo "   1. Open http://localhost:16686 in your browser"
echo "   2. In the Service dropdown, select 'payment-service'"
echo "   3. Click 'Find Traces' to see all traces"
echo "   4. Click on individual traces to see detailed spans"
echo ""
echo "🎯 What you'll see in Jaeger:"
echo "   • Each payment request creates a trace"
echo "   • Spans show method execution times"  
echo "   • Fault tolerance retries (when failures occur)"
echo "   • Custom attributes like payment amounts"
echo "   • Error traces (marked in red)"
echo ""
