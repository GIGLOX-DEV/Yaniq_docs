#!/bin/bash

# Script to automatically generate service documentation pages
# This script scans the apps directory and creates documentation pages for each service

DOCS_DIR="/mnt/projects/yaniQ/docs"
APPS_DIR="/mnt/projects/yaniQ/apps"
SERVICES_DIR="$DOCS_DIR/services"
LIBS_DIR="/mnt/projects/yaniQ/libs"
LIBRARIES_DIR="$DOCS_DIR/LIBRARIES"

echo "🚀 Generating YaniQ Documentation..."

# Create services directory if it doesn't exist
mkdir -p "$SERVICES_DIR"
mkdir -p "$LIBRARIES_DIR"

# Counter for services
service_count=0

# Generate service documentation
echo ""
echo "📦 Scanning services in $APPS_DIR..."

for service_dir in "$APPS_DIR"/*/ ; do
    if [ -d "$service_dir" ]; then
        service_name=$(basename "$service_dir")
        service_title=$(echo "$service_name" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
        service_doc="$SERVICES_DIR/${service_name^^}.md"
        
        # Check if pom.xml exists to confirm it's a Java service
        if [ -f "$service_dir/pom.xml" ]; then
            echo "  ✓ Found service: $service_name"
            
            # Extract information from pom.xml if available
            description=""
            port=""
            
            # Try to find application.yml for port info
            if [ -f "$service_dir/src/main/resources/application.yml" ]; then
                port=$(grep -A 1 "server:" "$service_dir/src/main/resources/application.yml" | grep "port:" | awk '{print $2}')
            fi
            
            # Only create if doesn't exist
            if [ ! -f "$service_doc" ]; then
                cat > "$service_doc" <<EOF
---
layout: default
title: $service_title
parent: Services
nav_order: $((service_count + 1))
description: "$service_title microservice documentation"
---

# $service_title
{: .no_toc }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

The **$service_title** is a core microservice in the YaniQ e-commerce platform.

### Key Features

- Feature 1
- Feature 2
- Feature 3

## Configuration

### Application Properties

\`\`\`yaml
server:
  port: ${port:-8080}
spring:
  application:
    name: $service_name
\`\`\`

## API Endpoints

### Base URL

\`\`\`
http://localhost:${port:-8080}/api
\`\`\`

### Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| GET | /health | Health check endpoint |
| GET | /info | Service information |

## Dependencies

This service depends on:

- Discovery Service (Eureka)
- Config Service
- Database

## Local Development

### Prerequisites

- Java 21+
- Maven 3.9+
- Docker (optional)

### Running Locally

\`\`\`bash
cd apps/$service_name
mvn clean install
mvn spring-boot:run
\`\`\`

### Running with Docker

\`\`\`bash
docker build -t yaniq/$service_name .
docker run -p ${port:-8080}:${port:-8080} yaniq/$service_name
\`\`\`

## Testing

### Unit Tests

\`\`\`bash
mvn test
\`\`\`

### Integration Tests

\`\`\`bash
mvn verify
\`\`\`

## Monitoring

### Health Check

\`\`\`bash
curl http://localhost:${port:-8080}/actuator/health
\`\`\`

### Metrics

\`\`\`bash
curl http://localhost:${port:-8080}/actuator/metrics
\`\`\`

## Troubleshooting

### Common Issues

1. **Service fails to start**
   - Check if required dependencies are running
   - Verify configuration in Config Service

2. **Connection timeouts**
   - Verify network connectivity
   - Check firewall settings

## Related Services

- [Gateway Service](GATEWAY_SERVICE.md)
- [Discovery Service](DISCOVERY_SERVICE.md)
- [Auth Service](AUTH_SERVICE.md)

## Additional Resources

- [Architecture Overview](../ARCHITECTURE.md)
- [Configuration Guide](../CONFIGURATION.md)
- [Deployment Guide](../DEPLOYMENT.md)

---

**Last Updated:** $(date +"%Y-%m-%d")
EOF
                echo "    ✓ Created documentation: $service_doc"
                ((service_count++))
            else
                echo "    ℹ Documentation already exists: $service_doc"
                ((service_count++))
            fi
        fi
    fi
done

# Generate libraries documentation
echo ""
echo "📚 Scanning libraries in $LIBS_DIR..."

lib_count=0
for lib_dir in "$LIBS_DIR"/*/ ; do
    if [ -d "$lib_dir" ]; then
        lib_name=$(basename "$lib_dir")
        lib_title=$(echo "$lib_name" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
        lib_doc_dir="$LIBRARIES_DIR/$lib_name"
        lib_doc="$lib_doc_dir/index.md"
        
        mkdir -p "$lib_doc_dir"
        
        if [ -f "$lib_dir/pom.xml" ]; then
            echo "  ✓ Found library: $lib_name"
            
            # Only create if doesn't exist
            if [ ! -f "$lib_doc" ]; then
                cat > "$lib_doc" <<EOF
---
layout: default
title: $lib_title
parent: Libraries
nav_order: $((lib_count + 1))
description: "$lib_title library documentation"
---

# $lib_title
{: .no_toc }

## Table of Contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

The **$lib_title** provides shared functionality across YaniQ microservices.

## Installation

Add the following dependency to your \`pom.xml\`:

\`\`\`xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>$lib_name</artifactId>
    <version>\${yaniq.version}</version>
</dependency>
\`\`\`

## Features

- Feature 1
- Feature 2
- Feature 3

## Usage

### Basic Example

\`\`\`java
// Example usage
import com.yaniq.*;

public class Example {
    // Your code here
}
\`\`\`

## Configuration

### Application Properties

\`\`\`yaml
# Configuration properties
yaniq:
  $lib_name:
    enabled: true
\`\`\`

## API Reference

### Main Classes

#### Class 1

Description of the class.

\`\`\`java
public class ExampleClass {
    // Methods
}
\`\`\`

## Best Practices

1. Best practice 1
2. Best practice 2
3. Best practice 3

## Examples

### Example 1: Basic Usage

\`\`\`java
// Code example
\`\`\`

## Testing

### Unit Tests

\`\`\`bash
mvn test
\`\`\`

## Troubleshooting

### Common Issues

1. **Issue 1**
   - Solution 1

## Related Libraries

- [Common Utils](../common-utils/index.md)
- [Common Config](../common-config/index.md)

## Additional Resources

- [Library Overview](../libraries.md)
- [Architecture Guide](../../ARCHITECTURE.md)

---

**Last Updated:** $(date +"%Y-%m-%d")
EOF
                echo "    ✓ Created documentation: $lib_doc"
                ((lib_count++))
            else
                echo "    ℹ Documentation already exists: $lib_doc"
                ((lib_count++))
            fi
        fi
    fi
done

# Summary
echo ""
echo "✅ Documentation generation complete!"
echo ""
echo "Summary:"
echo "  📦 Services documented: $service_count"
echo "  📚 Libraries documented: $lib_count"
echo ""
echo "Next steps:"
echo "  1. Review generated documentation in $SERVICES_DIR"
echo "  2. Update service-specific details"
echo "  3. Add API endpoints and examples"
echo "  4. Run 'bundle exec jekyll serve' to preview"
echo ""
