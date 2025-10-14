# Common Messaging Library - Usage

This guide explains how to use the `common-messaging` library in your services.

## 1. Add the Dependency

Ensure that your service's `pom.xml` includes a dependency on the `common-messaging` module.

```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-messaging</artifactId>
    <version>1.0.0</version>
</dependency>
```

You will also need to add the appropriate Spring Cloud Stream binder dependency for your chosen message broker (Kafka or RabbitMQ).

**For Kafka:**
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-kafka</artifactId>
</dependency>
```

**For RabbitMQ:**
```xml
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-stream-binder-rabbit</artifactId>
</dependency>
```

## 2. Configuration

Configure the message broker connection details and bindings in your `application.yml`.

**Example for Kafka:**
```yaml
spring:
  cloud:
    stream:
      kafka:
        binder:
          brokers: localhost:9092
      bindings:
        sendNotification-out-0:
          destination: notifications
        receiveNotification-in-0:
          destination: notifications
```

**Example for RabbitMQ:**
```yaml
spring:
  cloud:
    stream:
      rabbit:
        binder:
          nodes: localhost:5672
      bindings:
        sendNotification-out-0:
          destination: notifications
        receiveNotification-in-0:
          destination: notifications
```

## 3. Sending Messages (Producing)

Inject the `MessageProducer` interface into your services and use it to send messages.

```java
import com.yaniq.common_messaging.producer.MessageProducer;
import com.yaniq.common_messaging.payloads.NotificationPayload;
import com.yaniq.common_messaging.payloads.enums.NotificationType;
import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    private final MessageProducer<NotificationPayload> notificationProducer;

    public NotificationService(MessageProducer<NotificationPayload> notificationProducer) {
        this.notificationProducer = notificationProducer;
    }

    public void sendWelcomeNotification(String email) {
        NotificationPayload payload = NotificationPayload.builder()
                .email(email)
                .title("Welcome!")
                .content("Thank you for signing up.")
                .type(NotificationType.EMAIL)
                .build();
        notificationProducer.send("sendNotification-out-0", payload);
    }
}
```

## 4. Receiving Messages (Consuming)

To consume messages, create a class that implements the `MessageConsumer<T>` interface and register it as a Spring bean.

```java
import com.yaniq.common_messaging.consumer.MessageConsumer;
import com.yaniq.common_messaging.payloads.NotificationPayload;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

@Component
public class NotificationHandler {

    @Bean
    public MessageConsumer<NotificationPayload> receiveNotification() {
        return payload -> {
            // Process the received notification payload
            System.out.println("Received notification: " + payload);
        };
    }
}
```

