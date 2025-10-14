# Inter-Service Messaging Guide

This guide explains how to send messages between services using RabbitMQ and Kafka in the YaniQ microservices architecture.

## Overview

The common-messaging library provides a unified way to send messages between services using both Kafka and RabbitMQ message brokers. The system supports:

- **Kafka**: High-throughput, partitioned messaging for event streaming
- **RabbitMQ**: Traditional message queuing with routing and exchange patterns

## Quick Start

### 1. Inject the Messaging Service

```java
@Service
public class YourService {
    
    private final InterServiceMessagingService messagingService;
    
    public YourService(InterServiceMessagingService messagingService) {
        this.messagingService = messagingService;
    }
}
```

### 2. Send Messages

#### Kafka Examples (Event Streaming)

```java
// Send notification event
NotificationPayload notification = NotificationPayload.builder()
    .title("Order Shipped")
    .content("Your order #12345 has been shipped")
    .recipientId("user-123")
    .correlationId(UUID.randomUUID())
    .build();

messagingService.sendNotificationViaKafka(notification);

// Send user event (fanout to multiple services)
UserEventPayload userEvent = UserEventPayload.builder()
    .userId(UUID.fromString("user-123"))
    .eventType("PROFILE_UPDATED")
    .email("user@example.com")
    .build();

messagingService.sendUserEventViaKafka(userEvent, "profile-updated");

// Send analytics event with partitioning
Map<String, Object> analyticsData = Map.of(
    "userId", "user-123",
    "action", "purchase",
    "amount", 99.99
);

messagingService.sendAnalyticsEvent(analyticsData, "user-123");
```

#### RabbitMQ Examples (Point-to-Point Messaging)

```java
// Send order event to inventory service
OrderEventPayload orderEvent = OrderEventPayload.builder()
    .orderId(UUID.randomUUID())
    .customerId(UUID.randomUUID())
    .status("CREATED")
    .totalAmount(new BigDecimal("99.99"))
    .build();

messagingService.sendOrderEventToInventory(orderEvent, "created");

// Send payment event to billing service
PaymentEventPayload paymentEvent = PaymentEventPayload.builder()
    .paymentId(UUID.randomUUID())
    .orderId(UUID.randomUUID())
    .status("COMPLETED")
    .amount(new BigDecimal("99.99"))
    .build();

messagingService.sendPaymentEventToBilling(paymentEvent, "COMPLETED");

// Send email notification with priority routing
Map<String, Object> emailData = Map.of(
    "to", "user@example.com",
    "subject", "Order Confirmation",
    "template", "order-confirmation"
);

messagingService.sendEmailNotification(emailData, "high");
```

## Message Routing Patterns

### Kafka Partitioning

Kafka messages are partitioned based on keys for:
- **Ordering**: Messages with the same key go to the same partition
- **Load balancing**: Even distribution across partitions
- **Scalability**: Parallel processing by multiple consumers

```java
// Partition by user ID for user events
messagingService.sendUserEventViaKafka(userEvent, "user-updated");

// Partition by recipient ID for notifications
messagingService.sendNotificationViaKafka(notification);
```

### RabbitMQ Routing

RabbitMQ uses exchanges and routing keys for message routing:
- **Topic Exchange**: Route based on routing key patterns
- **Direct Exchange**: Route to queues with exact routing key match
- **Fanout Exchange**: Broadcast to all bound queues

```java
// Routing key examples:
// order.created -> routes to order creation handlers
// order.cancelled -> routes to order cancellation handlers
// email.high -> routes to high-priority email queue
// email.normal -> routes to normal-priority email queue
```

## Available Message Destinations

### Kafka Topics
- `notification-events`: User notifications
- `user-events`: User lifecycle events
- `analytics-events`: Analytics and tracking data
- `audit-logs`: System audit logs
- `order-events`: Order lifecycle events
- `cart-events`: Shopping cart events
- `product-events`: Product catalog events

### RabbitMQ Exchanges
- `inventory.exchange`: Inventory management
- `billing.exchange`: Billing and payments
- `notifications.exchange`: Email notifications
- `orders.exchange`: Order processing
- `payments.exchange`: Payment processing
- `shipping.exchange`: Shipping and delivery

## Configuration

The messaging system is configured in `application.yml`:

```yaml
spring:
  cloud:
    stream:
      kafka:
        binder:
          brokers: server_ip:29092
      rabbit:
        binder:
          nodes: server_ip:5672
          username: admin
          password: giglox123
```

## Best Practices

1. **Use Kafka for**:
   - Event streaming
   - High-throughput scenarios
   - When message ordering is important
   - Analytics and logging

2. **Use RabbitMQ for**:
   - Point-to-point messaging
   - When you need complex routing
   - Request-response patterns
   - When message acknowledgment is critical

3. **Include correlation IDs** for distributed tracing
4. **Set appropriate partition keys** for Kafka messages
5. **Use meaningful routing keys** for RabbitMQ messages
6. **Handle failures gracefully** with retry mechanisms

## Error Handling

The messaging system includes automatic retry and error handling. Failed messages are typically:
- Retried with exponential backoff
- Sent to dead letter queues after max retries
- Logged for monitoring and debugging

## Monitoring

Monitor your messaging infrastructure using:
- Kafka Manager or Kafdrop for Kafka
- RabbitMQ Management UI at http://server_ip:15672
- Application logs for message processing status
