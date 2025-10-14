---
layout: default
title: Common Messaging
parent: Libraries
permalink: /libraries/common-messaging/
---

# Common Messaging

Kafka producers/consumers, serialization, DLQ and retries.

## What this library provides

- Type-safe event contracts and serializers/deserializers
- Producer and consumer abstractions with error handling
- Retry and Dead Letter Queue (DLQ) patterns
- Topic naming and partitioning helpers
- Tracing and logging correlation headers support
- Test utilities (embedded Kafka/Testcontainers)

## Add dependency

```xml
<dependency>
  <groupId>com.yaniq</groupId>
  <artifactId>common-messaging</artifactId>
</dependency>
```

## Quick start (YAML configuration)

```yaml
spring:
  kafka:
    bootstrap-servers: ${KAFKA_BOOTSTRAP_SERVERS:localhost:9092}
    client-id: ${spring.application.name}
    properties:
      # Correlation & tracing headers pass-through
      spring.json.add.type.headers: false
      spring.kafka.producer.value.serializer: org.springframework.kafka.support.serializer.JsonSerializer
      spring.kafka.consumer.value.deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
    producer:
      acks: all
      retries: 3
      properties:
        enable.idempotence: true
      key-serializer: org.apache.kafka.common.serialization.StringSerializer
      value-serializer: org.springframework.kafka.support.serializer.JsonSerializer
    consumer:
      group-id: ${spring.application.name}
      auto-offset-reset: earliest
      key-deserializer: org.apache.kafka.common.serialization.StringDeserializer
      value-deserializer: org.springframework.kafka.support.serializer.JsonDeserializer
      properties:
        spring.json.trusted.packages: "*"

# Common topics (example)
yaniq:
  messaging:
    topics:
      order-created: order.created.v1
      order-paid: order.paid.v1
      order-cancelled: order.cancelled.v1
    dlq-suffix: .dlq
    retry:
      attempts: 3
      backoff: 200ms
```

## Produce an event

```java
import com.yaniq.common.messaging.EventPublisher;
import com.yaniq.common.messaging.events.OrderCreatedEvent;

@Service
@RequiredArgsConstructor
public class OrderService {
  private final EventPublisher publisher;

  public void createOrder(Order order) {
    // ... domain logic, persist order
    OrderCreatedEvent event = new OrderCreatedEvent(
      order.getId(), order.getUserId(), order.getTotal()
    );
    publisher.publish("order.created.v1", event); // topic from config
  }
}
```

## Consume an event

```java
import com.yaniq.common.messaging.annotations.KafkaEventHandler;
import com.yaniq.common.messaging.events.OrderCreatedEvent;

@Component
public class OrderCreatedHandler {

  @KafkaEventHandler(topics = "order.created.v1")
  public void onOrderCreated(OrderCreatedEvent event) {
    // handle business logic
  }
}
```

## Topic naming conventions

- Use domain.action.version, for example: `order.created.v1`
- Version bump on breaking payload changes
- Prefer consistent partitions (key = aggregateId)

## Retry and DLQ strategy

- Synchronous retries: up to N attempts with exponential backoff (configurable)
- On permanent failure, route to `<topic>.dlq`
- Include headers: `x-error`, `x-stacktrace`, `x-original-partition`, `x-original-offset`

DLQ listener example:

```java
@KafkaListener(topics = "order.created.v1.dlq", groupId = "dlq-listener")
public void onDlq(ConsumerRecord<String, byte[]> record) {
  // log, alert, or trigger compensating action
}
```

## Observability

- Structured logs include correlationId and eventId
- Micrometer timers for publish/consume latency: `messaging.publish`, `messaging.consume`
- Counters for success/failure and DLQ routed messages

## Testing

With Testcontainers (recommended):

```java
@SpringBootTest
@Testcontainers
class MessagingIT {
  @Container
  static KafkaContainer kafka = new KafkaContainer(DockerImageName.parse("confluentinc/cp-kafka:7.5.0"));

  @DynamicPropertySource
  static void kafkaProps(DynamicPropertyRegistry r) {
    r.add("spring.kafka.bootstrap-servers", kafka::getBootstrapServers);
  }
}
```

Embedded Kafka (fast unit-level tests):

```java
@EmbeddedKafka(partitions = 1, topics = {"order.created.v1"})
@SpringBootTest
class EmbeddedKafkaTest { /* ... */ }
```

---

## Deep dives

- README: [View]({{ site.baseurl }}/LIBRARIES/common-messaging/README.md)
- USAGE: [View]({{ site.baseurl }}/LIBRARIES/common-messaging/USAGE.md)
- MESSAGING GUIDE: [View]({{ site.baseurl }}/LIBRARIES/common-messaging/MESSAGING_GUIDE.md)
- DEPENDENCIES: [View]({{ site.baseurl }}/LIBRARIES/common-messaging/DEPENDENCIES.md)
