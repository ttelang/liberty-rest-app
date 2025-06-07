# JWT Authentication Troubleshooting Guide

## Overview

The Order Service is configured to use MicroProfile JWT for authentication and role-based access control. This guide helps you fix JWT authentication issues and test your configuration.

## The Error

You encountered this error:
```
CWWKS5523E: The MicroProfile JWT feature cannot authenticate the request because the token that is included in the request cannot be validated. CWWKS6029E: The JSON Web Token (JWT) cannot be validated because a signing key cannot be found. The configured signature algorithm [RS256] requires a key to validate the token.
```

## What We Fixed

1. **Updated the mpJwt Configuration in server.xml**:
   - Changed `jwksUri` to `publicKeyLocation`
   - Set the correct path to the public key (`${server.config.dir}/publicKey.pem`)

2. **Fixed the Public Key Format**:
   - Changed from `RSA PUBLIC KEY` format to `PUBLIC KEY` format
   - MicroProfile JWT expects a specific key format

3. **Enhanced MP-JWT Configuration**:
   - Added token header and cookie settings in microprofile-config.properties
   - Improved logging for JWT-related issues

## Steps to Apply the Fix

1. **Run the Copy & Restart Script**:
   ```bash
   cd /workspaces/liberty-rest-app/order
   ./copy-jwt-key.sh
   ```
   This script will:
   - Copy the corrected public key to the Liberty server configuration directory
   - Restart the Liberty server to apply the changes

2. **Test JWT Authentication**:
   ```bash
   cd /workspaces/liberty-rest-app/order
   ./test-jwt.sh
   ```
   This will:
   - Use the JWT token in tools/token.jwt to test the secured endpoint
   - Display the token payload for verification

## Understanding the Solution

### 1. Server.xml Configuration

The `mpJwt` element should use `publicKeyLocation` instead of `jwksUri`:

```xml
<mpJwt id="orderJwt" 
       issuer="mp-ecomm-store"
       publicKeyLocation="${server.config.dir}/publicKey.pem"
       userNameAttribute="upn" />
```

### 2. Public Key Format

The key must be in the standard `PUBLIC KEY` format, not the `RSA PUBLIC KEY` format:

```
-----BEGIN PUBLIC KEY-----
...key content...
-----END PUBLIC KEY-----
```

### 3. Key Location

The public key must be available at the location specified in:
- `publicKeyLocation` in server.xml
- `mp.jwt.verify.publickey.location` in microprofile-config.properties

## Testing Different Roles

1. **For User Role Access** (default):
   This allows access to GET /api/orders/{id}

2. **For Admin Role Access**:
   Edit the roles in the JWT token:
   ```bash
   # Edit the JWT payload file
   vi /workspaces/liberty-rest-app/tools/jwt-token.json
   # Change "groups": ["user"] to "groups": ["admin", "user"]
   
   # Regenerate the token
   cd /workspaces/liberty-rest-app/tools
   java -jar jwtenizr.jar
   
   # Test the admin endpoint
   curl -X DELETE -H "Authorization: Bearer $(cat token.jwt)" \
        http://localhost:8050/order/api/orders/1
   ```

## Common JWT Troubleshooting

If you still have issues:

1. **Check the Logs**:
   ```bash
   cd /workspaces/liberty-rest-app/order
   cat target/liberty/wlp/usr/servers/orderServer/logs/messages.log | grep -i jwt
   ```

2. **Verify Token Claims**:
   ```bash
   cat /workspaces/liberty-rest-app/tools/token.jwt | cut -d. -f2 | base64 -d | jq .
   ```
   Ensure:
   - The issuer (`iss`) is "mp-ecomm-store"
   - The token isn't expired
   - The groups/roles are correct

3. **Regenerate Token**:
   ```bash
   cd /workspaces/liberty-rest-app/tools
   java -Dverbose -jar jwtenizr.jar
   ```
