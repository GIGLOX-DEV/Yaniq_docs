---
layout: default
title: Messaging Guide
nav_order: 11
description: "Event-driven architecture and messaging patterns"
permalink: /MESSAGING_GUIDE/
---

# 📨 Messaging Guide

Comprehensive guide to event-driven architecture and messaging patterns in YaniQ.

## 🎯 Overview

YaniQ uses **Apache Kafka** for asynchronous, event-driven communication between microservices.

## 📋 Event Types

### Order Events
- `order.created` - New order placed
- `order.confirmed` - Order confirmed
- `order.shipped` - Order shipped
- `order.delivered` - Order delivered
- `order.cancelled` - Order cancelled

### Payment Events
- `payment.initiated` - Payment started
- `payment.completed` - Payment successful
- `payment.failed` - Payment failed
- `payment.refunded` - Payment refunded

### Inventory Events
- `inventory.reserved` - Stock reserved
- `inventory.released` - Stock released
- `inventory.low` - Low stock alert

## 🔧 Configuration

```yaml
spring:
  kafka:
    bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS:localhost:9092}
    producer:
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
    consumer:
      group-id: ${spring.application.name}-group
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
```

## 📤 Publishing Events

```java
@Service
public class OrderEventPublisher {
    
    @Autowired
    private KafkaTemplate<String, OrderEvent> kafkaTemplate;
    
    public void publishOrderCreated(Order order) {
        OrderEvent event = OrderEvent.builder()
            .orderId(order.getId())
            .userId(order.getUserId())
            .total(order.getTotal())
            .timestamp(Instant.now())
            .build();
            
        kafkaTemplate.send("order-events", event);
    }
}
```

## 📥 Consuming Events

```java
@Service
public class InventoryEventListener {
    
    @KafkaListener(topics = "order-events", groupId = "inventory-service")
    public void handleOrderCreated(OrderEvent event) {
        // Reserve inventory for the order
        inventoryService.reserveStock(event.getOrderId());
    }
}
```

## 🔄 Saga Pattern

YaniQ implements the Saga pattern for distributed transactions:

1. Order created → Inventory reserved
2. Payment processed → Order confirmed
3. If payment fails → Inventory released

## 📊 Monitoring

```bash
# List topics
docker exec kafka kafka-topics.sh --list --bootstrap-server localhost:9092

# View consumer groups
docker exec kafka kafka-consumer-groups.sh --list --bootstrap-server localhost:9092

# Check consumer lag
docker exec kafka kafka-consumer-groups.sh --describe --group inventory-service-group --bootstrap-server localhost:9092
```

## 🔗 Related Documentation

- [Architecture](/ARCHITECTURE)
- [Services](/services)
- [Configuration](/CONFIGURATION)

---

[⬆ Back to Top](#-messaging-guide) | [📖 Home](/)
---
layout: default
title: Contributing
nav_order: 10
description: "Contributing guidelines for YaniQ platform"
permalink: /CONTRIBUTING
---

# 🤝 Contributing to YaniQ

Thank you for your interest in contributing to the YaniQ E-Commerce Platform! This guide will help you get started.

## 📋 Code of Conduct

- Be respectful and inclusive
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 Getting Started

1. **Fork the repository**
2. **Clone your fork**
   ```bash
   git clone https://github.com/YOUR_USERNAME/YaniQ.git
   cd YaniQ
   ```
3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```
4. **Make your changes**
5. **Test your changes**
   ```bash
   mvn clean test
   ```
6. **Commit your changes**
   ```bash
   git commit -m "feat: add your feature description"
   ```
7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Create a Pull Request**

## 📝 Commit Message Convention

We follow [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting)
- `refactor:` - Code refactoring
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

## 🧪 Testing Requirements

- Unit tests for new functionality
- Integration tests where applicable
- Maintain or improve code coverage
- All tests must pass before PR approval

## 📖 Documentation

- Update relevant documentation
- Add Javadoc comments for public APIs
- Update README if needed
- Include examples for new features

## 🔍 Code Review Process

1. Automated checks must pass (CI/CD)
2. Code review by at least one maintainer
3. All comments addressed
4. Approved and merged

## 📞 Questions?

- Open an issue for bugs or feature requests
- Use GitHub Discussions for questions
- Join our community chat

Thank you for contributing! 🎉
