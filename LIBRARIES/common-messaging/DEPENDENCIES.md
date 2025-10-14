# Common Messaging Library - Dependencies

This library relies on the following dependencies:

*   **Spring Cloud Stream**: The core framework for building message-driven microservices.
*   **Spring Cloud Stream Binder for Kafka** (optional): For connecting to an Apache Kafka message broker.
*   **Spring Cloud Stream Binder for RabbitMQ** (optional): For connecting to a RabbitMQ message broker.
*   **Lombok**: To reduce boilerplate code in model classes.
*   **Jackson**: For JSON serialization and deserialization.
# Common Messaging Library

## Overview

The `common-messaging` library provides a unified interface for sending and receiving messages using different messaging systems like Apache Kafka and RabbitMQ. It abstracts the underlying implementation details, allowing services to produce and consume messages without being tightly coupled to a specific message broker.

### Core Features

*   **Broker Agnostic**: Supports multiple message brokers (Kafka, RabbitMQ) through a common interface.
*   **Standardized Payloads**: Defines a standard `NotificationPayload` for consistent message structures.
*   **Producer and Consumer Abstractions**: Provides simple interfaces for producing and consuming messages.
*   **Spring Cloud Stream Integration**: Built on top of Spring Cloud Stream to leverage its powerful features for building message-driven microservices.

