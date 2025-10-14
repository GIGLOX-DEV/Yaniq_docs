---
layout: default
title: Troubleshooting
nav_order: 9
description: "Common issues and solutions for YaniQ platform"
permalink: /TROUBLESHOOTING
---

# 🔧 Troubleshooting Guide

Common issues and their solutions for the YaniQ platform.

## 🐛 Service Discovery Issues

### Services not registering with Eureka

**Problem:** Services don't appear in Eureka dashboard

**Solutions:**
1. Check Eureka URL configuration
2. Verify network connectivity
3. Wait 30-60 seconds for registration
4. Check service logs for errors
5. Ensure `eureka.client.register-with-eureka=true`

```bash
# Check Eureka dashboard
curl http://localhost:8761/eureka/apps
```

## 🗄️ Database Connection Issues

### Cannot connect to PostgreSQL

**Solutions:**
```bash
# Check if PostgreSQL is running
docker ps | grep postgres

# Check PostgreSQL logs
docker logs postgres

# Test connection
docker exec -it postgres psql -U yaniq -c "\l"
```

## 🔴 Redis Connection Issues

### Redis connection refused

**Solutions:**
```bash
# Check if Redis is running
docker ps | grep redis

# Test Redis connection
docker exec -it redis redis-cli ping
```

## 🔌 Port Already in Use

**Error:** `Port 8761 is already in use`

**Solutions:**
```bash
# Find process using the port (Linux/Mac)
lsof -i :8761

# Kill the process
kill -9 <PID>

# Windows
netstat -ano | findstr :8761
taskkill /PID <PID> /F
```

## 💾 Out of Memory Errors

**Error:** `java.lang.OutOfMemoryError`

**Solutions:**
```bash
# Increase JVM heap size
export MAVEN_OPTS="-Xmx2048m"
mvn spring-boot:run

# Or when running JAR
java -Xmx2g -Xms512m -jar target/service.jar
```

## 🔒 JWT Token Issues

### Invalid JWT token

**Solutions:**
1. Check token expiration
2. Verify JWT secret matches across services
3. Ensure proper token format: `Bearer <token>`
4. Check for token tampering

## 🌐 CORS Errors

**Error:** CORS policy blocking requests

**Solutions:**
1. Check Gateway CORS configuration
2. Verify allowed origins list
3. Enable credentials if needed
4. Check request headers

## 📊 Performance Issues

### Slow response times

**Solutions:**
1. Enable database query logging
2. Check database indexes
3. Review N+1 query problems
4. Enable Redis caching
5. Check network latency

## 🔄 Build Failures

### Maven build errors

**Solutions:**
```bash
# Clean Maven cache
mvn clean

# Force update dependencies
mvn clean install -U

# Skip tests temporarily
mvn clean install -DskipTests
```

## 🐳 Docker Issues

### Docker build failures

**Solutions:**
```bash
# Clean Docker cache
docker system prune -a

# Build without cache
docker-compose build --no-cache

# Check Docker resources
docker system df
```

## 📞 Getting Help

If you can't find a solution:

1. Check [GitHub Issues](https://github.com/GIGLOX-DEV/YaniQ/issues)
2. Search [GitHub Discussions](https://github.com/GIGLOX-DEV/YaniQ/discussions)
3. Create a new issue with:
   - Detailed problem description
   - Steps to reproduce
   - Error logs
   - Environment details

---

[⬆ Back to Top](#-troubleshooting-guide) | [📖 Home](/)

