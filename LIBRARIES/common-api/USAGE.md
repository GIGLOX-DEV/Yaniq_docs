# Common API Library - Usage

This guide explains how to use the `common-api` library in your services.

## 1. Add the Dependency

Ensure that your service's `pom.xml` includes a dependency on the `common-api` module.

```xml
<dependency>
    <groupId>com.yaniq</groupId>
    <artifactId>common-api</artifactId>
    <version>1.0.0</version>
</dependency>
```

## 2. Creating API Responses

The `ApiResponseFactory` provides a convenient way to create standardized API responses.

### Success Response

```java
import com.yaniq.common_api.response.ApiResponseFactory;
import com.yaniq.common_api.response.ApiResponse;

// ...

@GetMapping("/my-endpoint")
public ApiResponse<MyData> getMyData() {
    MyData data = // ... get your data
    return ApiResponseFactory.success(data);
}
```

### Success Response with Metadata

```java
import com.yaniq.common_api.response.ApiResponseFactory;
import com.yaniq.common_api.response.ApiResponse;
import com.yaniq.common_api.response.ApiMeta;

// ...

@GetMapping("/my-endpoint")
public ApiResponse<MyData> getMyData() {
    MyData data = // ... get your data
    ApiMeta meta = new ApiMeta("some-info");
    return ApiResponseFactory.success(data, meta);
}
```

### Error Response

```java
import com.yaniq.common_api.response.ApiResponseFactory;
import com.yaniq.common_api.response.ApiResponse;
import com.yaniq.common_api.response.ApiError;

// ...

@GetMapping("/my-endpoint")
public ApiResponse<MyData> getMyData() {
    try {
        // ... something fails
    } catch (Exception e) {
        ApiError error = new ApiError("error-code", "A description of the error.");
        return ApiResponseFactory.error(error);
    }
}
```

### Paginated Response

```java
import com.yaniq.common_api.response.ApiResponseFactory;
import com.yaniq.common_api.response.ApiResponse;
import com.yaniq.common_api.response.ApiPagination;

// ...

@GetMapping("/my-endpoint")
public ApiResponse<List<MyData>> getMyData() {
    // ... get your paginated data
    List<MyData> data = // ...
    ApiPagination pagination = new ApiPagination(1, 10, 100);
    return ApiResponseFactory.success(data, pagination);
}
```

