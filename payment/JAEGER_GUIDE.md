# Viewing Traces in Jaeger - Complete Guide

## Overview
This guide shows you how to set up Jaeger and view distributed traces from your MicroProfile Telemetry-enabled Payment Service.

## Prerequisites
- Docker installed and running
- Payment service with MicroProfile Telemetry configured

## Step 1: Start Jaeger

### Option A: Using the provided script (Recommended)
```bash
cd /workspaces/liberty-rest-app/payment
./start-jaeger-demo.sh
```

### Option B: Manual setup
```bash
# Start Jaeger
docker-compose -f docker-compose-jaeger.yml up -d

# Verify Jaeger is running
curl http://localhost:16686
```

## Step 2: Start Your Payment Service
```bash
cd /workspaces/liberty-rest-app/payment
mvn liberty:dev
```

## Step 3: Generate Some Traces

### Test the new endpoints:

1. **Basic Payment Processing**:
```bash
curl -X POST http://localhost:9080/payment/payments \
     -H "Content-Type: application/json" \
     -d '{
         "cardNumber": "4111111111111111",
         "expiryDate": "12/25",
         "cvv": "123",
         "amount": 99.99,
         "currency": "USD",
         "merchantId": "MERCHANT_001"
     }'
```

2. **Payment Verification with Telemetry**:
```bash
curl -X POST http://localhost:9080/payment/verify \
     -H "Content-Type: application/json" \
     -d '{
         "cardNumber": "4111111111111111",
         "expiryDate": "12/25",
         "cvv": "123",
         "amount": 150.00,
         "currency": "USD",
         "merchantId": "MERCHANT_002"
     }'
```

3. **Generate Different Scenarios**:
```bash
# Fraud scenario (card ending in 0000)
curl -X POST http://localhost:9080/payment/verify \
     -H "Content-Type: application/json" \
     -d '{
         "cardNumber": "4111111111110000",
         "expiryDate": "12/25",
         "cvv": "123",
         "amount": 50.00,
         "currency": "USD"
     }'

# Insufficient funds scenario (amount > 1000)
curl -X POST http://localhost:9080/payment/verify \
     -H "Content-Type: application/json" \
     -d '{
         "cardNumber": "4111111111111111",
         "expiryDate": "12/25",
         "cvv": "123",
         "amount": 1500.00,
         "currency": "USD"
     }'
```

## Step 4: View Traces in Jaeger UI

### Access Jaeger UI
1. Open your browser and go to: **http://localhost:16686**

### Navigate the Jaeger Interface

#### 1. Service Selection
- In the left panel, find the **"Service"** dropdown
- Select **"payment-service"** from the list

#### 2. Find Traces
- Click the **"Find Traces"** button
- You should see a list of recent traces

#### 3. Examine Individual Traces
Click on any trace to see:

**Trace Timeline View:**
- Shows the complete request flow
- Each span represents a method call or operation
- Color-coded by service/component

**Span Details:**
- **Duration**: How long each operation took
- **Tags**: Metadata like payment amounts, card numbers (masked)
- **Logs**: Structured log events from your application
- **Process**: Service information

### What You'll See

#### 1. Payment Processing Traces
- **Root Span**: `processPayment` method
- **Child Spans**: 
  - `maskCardNumber` operation
  - `simulateDelay` operation
  - Fault tolerance retries (if failures occur)

#### 2. Payment Verification Traces
- **Root Span**: `verifyPaymentWithTelemetry` method
- **Child Spans**:
  - `validatePaymentDetails`
  - `performFraudCheck`
  - `verifyFundsAvailability`
  - `recordTransaction`
  - `simulateNetworkCall` (multiple instances)

#### 3. Error Traces
- Failed operations will show in red
- Error details in span logs and tags
- Exception stack traces captured

### Understanding the Trace Data

#### Span Tags (Key-Value Pairs)
- `payment.amount`: Transaction amount
- `payment.gateway.endpoint`: Gateway URL
- `payment.cardNumber.masked`: Secured card number
- `transaction.id`: Unique transaction identifier

#### Span Logs (Events)
- Payment processing started/completed
- Validation results
- Fraud check outcomes
- Network call simulations

#### Service Dependencies
- Shows how your payment service interacts with:
  - External payment gateways (simulated)
  - Fraud detection services (simulated)
  - Banking services (simulated)

## Step 5: Advanced Trace Analysis

### Filter Traces
- **By operation**: Look for specific method calls
- **By duration**: Find slow operations
- **By tags**: Filter by payment amounts, error types
- **By time range**: Focus on specific time periods

### Compare Traces
- Compare successful vs failed payments
- Analyze performance differences
- Identify bottlenecks

### Search Features
- Use the search box to find specific traces
- Search by trace ID, operation name, or tags
- Use advanced filters for complex queries

## Troubleshooting

### No Traces Appearing?
1. **Check Jaeger Connection**:
   ```bash
   curl http://localhost:14268/api/traces
   ```

2. **Verify Service Configuration**:
   - Ensure `mpTelemetry` feature is enabled
   - Check Jaeger endpoint in server.xml
   - Verify service name matches

3. **Check Application Logs**:
   ```bash
   # Look for telemetry-related messages
   tail -f target/liberty/wlp/usr/servers/mpServer/logs/messages.log
   ```

### Traces Not Detailed Enough?
- Our implementation uses automatic tracing
- MicroProfile Telemetry creates spans for public methods
- Logging statements provide additional context

### Performance Impact
- Telemetry has minimal overhead
- Sampling can be configured for production
- Traces help identify actual performance bottlenecks

## Cleanup
When you're done exploring:
```bash
# Stop Jaeger
docker-compose -f docker-compose-jaeger.yml down

# Stop Liberty (if running with liberty:dev, use Ctrl+C)
```

## Next Steps
- Explore distributed tracing across multiple services
- Configure trace sampling for production
- Set up alerts based on trace data
- Integrate with APM tools
