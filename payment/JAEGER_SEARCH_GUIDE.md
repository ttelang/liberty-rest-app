# Jaeger Trace Search Guide

## 🔍 How to Search Traces in Jaeger

### 1. Basic Search Interface

**Access Jaeger UI:** http://localhost:16686

### 2. Search Parameters

#### **Service Selection**
- **Service:** Select `payment-service` from dropdown
- This filters traces to only show traces from our Payment service

#### **Operation Selection**
- **Operation:** Choose specific operations like:
  - `GET /payment/api/authorize` - Basic payment authorization
  - `POST /payment/api/payments` - Full payment processing
  - `POST /payment/api/verify` - Payment verification workflow
  - Leave blank to see all operations

#### **Time Range**
- **Lookback:** Choose from dropdown (Last hour, Last 6 hours, Last day, etc.)
- **Custom Range:** Use date/time picker for specific periods
- **Default:** Last hour (most recent traces)

#### **Advanced Filters**

**Tags (Key:Value pairs):**
```
http.method:POST           # Only POST requests
http.status_code:200       # Only successful requests
error:true                 # Only error traces
payment.amount:50          # Specific payment amounts
payment.cardNumber:****1234 # Specific card patterns
```

**Min/Max Duration:**
- **Min Duration:** Show only traces longer than X seconds
- **Max Duration:** Show only traces shorter than X seconds
- **Limit Results:** Number of traces to return (default: 20)

### 3. Search Examples

#### **Find All Recent Payment Traces**
```
Service: payment-service
Operation: [blank]
Lookback: Last hour
Tags: [none]
```

#### **Find Failed Payment Attempts**
```
Service: payment-service
Tags: error:true
```

#### **Find Slow Payment Processing**
```
Service: payment-service
Min Duration: 2s
```

#### **Find Specific Payment Amounts**
```
Service: payment-service
Tags: payment.amount:100
```

#### **Find Fraud Detection Triggers**
```
Service: payment-service
Tags: fraud.detected:true
```

### 4. Understanding Search Results

#### **Trace List View**
- **Trace ID:** Unique identifier for the trace
- **Duration:** Total time for the entire trace
- **Services:** Number of services involved
- **Spans:** Number of spans in the trace
- **Start Time:** When the trace began

#### **Color Coding**
- **Blue:** Normal successful traces
- **Red:** Error traces (exceptions/failures)
- **Orange:** Traces with warnings

#### **Sorting Options**
- **Most Recent:** Default sorting by start time
- **Longest First:** Sort by duration (descending)
- **Shortest First:** Sort by duration (ascending)

### 5. Trace Details Navigation

#### **Clicking on a Trace Opens:**
1. **Timeline View:** Shows spans on a timeline
2. **Span Details:** Click any span to see:
   - Tags (metadata)
   - Logs (events during span)
   - Process information
   - Stack traces (for errors)

#### **Useful Keyboard Shortcuts**
- **←/→:** Navigate between spans
- **↑/↓:** Expand/collapse span details
- **ESC:** Close span details

### 6. Advanced Search Patterns

#### **Finding Performance Issues**
```
Service: payment-service
Min Duration: 1s
Tags: http.status_code:200
```

#### **Debugging Specific User Issues**
```
Service: payment-service
Tags: user.id:12345
```

#### **Monitoring Retry Patterns**
```
Service: payment-service
Tags: retry.attempt:>1
```

#### **Tracking Database Operations**
```
Service: payment-service
Operation: contains:database
```

### 7. Trace Comparison

- Select multiple traces using checkboxes
- Click "Compare" to see side-by-side analysis
- Useful for comparing successful vs failed operations

### 8. Exporting and Sharing

- **JSON Export:** Download trace data as JSON
- **Share Trace:** Copy URL to share specific trace
- **Deep Links:** URL includes all search parameters

## 🎯 Quick Start Checklist

1. ✅ Open http://localhost:16686
2. ✅ Select "payment-service" from Service dropdown
3. ✅ Set time range (Last hour is usually good)
4. ✅ Click "Find Traces"
5. ✅ Click on any trace to explore details
6. ✅ Use tags to filter specific scenarios

## 🔧 Common Search Queries

```bash
# All payment traces in last hour
Service: payment-service

# Only error traces
Service: payment-service, Tags: error:true

# High-value payments
Service: payment-service, Tags: payment.amount:>1000

# Slow operations
Service: payment-service, Min Duration: 2s

# Specific HTTP methods
Service: payment-service, Tags: http.method:POST
```
