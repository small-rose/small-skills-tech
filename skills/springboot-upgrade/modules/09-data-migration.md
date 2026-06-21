# 数据层组件升级迁移指南

> **适用场景**: 传统 Spring MVC 升级到 Spring Boot 时，缓存/数据层组件的升级。
> **核心问题**: Spring Data 版本断代升级、API 不兼容、自定义缓存类适配

---

## 1. Spring Data Redis 1.x → 2.x 迁移

### 1.1 API 断代变化总览

| 维度 | 1.x（Sprig Data Redis 1.x） | 2.x（Spring Data Redis 2.x） |
|------|---------------------------|---------------------------|
| RedisCacheManager 构造器 | `(RedisTemplate)` | `(RedisCacheWriter, RedisCacheConfiguration)` |
| RedisCache 构造器 | `(name, prefix, redisOperations, expiration)` | `(name, cacheWriter, cacheConfig)` |
| createRedisCache 方法 | `public RedisCache createCache(String)` | `protected RedisCache createRedisCache(String, @Nullable RedisCacheConfiguration)` |
| JedisConnectionFactory 构造器 | 默认无参 + setter | `(RedisStandaloneConfiguration)` |
| RedisCacheConfiguration | 可变类（有 setter） | **不可变类**（仅 builder 方法） |

### 1.2 RedisCacheConfiguration — 不可变类适配

`RedisCacheConfiguration` 所有字段为 `private final`，构造器为 `private`。配置必须通过 builder 模式方法，每个方法返回新实例。

**问题**: Spring XML 的 `<property>` 会调用 setter → 不存在 → `BeanProperty 'entryTtl' is not writable`。

**方案**: 创建 `FactoryBean` 包装类:

```java
public class RedisCacheConfigurationFactory implements FactoryBean<RedisCacheConfiguration> {
    private Duration entryTtl = Duration.ofHours(36);
    private boolean disableCachingNullValues = true;

    public void setEntryTtl(Duration v) { this.entryTtl = v; }
    public void setDisableCachingNullValues(boolean v) { this.disableCachingNullValues = v; }

    @Override
    public RedisCacheConfiguration getObject() {
        RedisCacheConfiguration config = RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(entryTtl)
                .serializeKeysWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new StringRedisSerializer()))
                .serializeValuesWith(RedisSerializationContext.SerializationPair
                        .fromSerializer(new FastJsonRedisSerializer()));
        if (disableCachingNullValues) {
            config = config.disableCachingNullValues();
        }
        return config;
    }

    @Override
    public Class<?> getObjectType() { return RedisCacheConfiguration.class; }
}
```

XML 配置:

```xml
<!-- 改造前（1.x）— 直接使用 RedisCacheConfiguration，无法注入属性 -->
<bean id="redisCacheConfiguration" class="org.springframework.data.redis.cache.RedisCacheConfiguration"
      factory-method="defaultCacheConfig">
    <property name="entryTtl" value="PT36H"/>         <!-- ❌ 不可写 -->
    <property name="disableCachingNullValues" value="true"/> <!-- ❌ 不可写 -->
</bean>

<!-- 改造后（2.x）— 使用 FactoryBean -->
<bean id="redisCacheConfiguration" class="com.cpic.fms.common.cache.redis.RedisCacheConfigurationFactory">
    <property name="entryTtl" value="PT36H"/>
    <property name="disableCachingNullValues" value="true"/>
</bean>
```

### 1.3 自定义 RedisCacheManager 适配

```java
// ❌ 1.x 方式
public class MyRedisCacheManager extends RedisCacheManager {
    public MyRedisCacheManager(RedisTemplate redisTemplate) {
        super(redisTemplate); // 1.x 构造器
    }
    @Override
    public RedisCache createCache(String cacheName) { // public, 1个参数
        return new MyRedisCache(cacheName, ...);
    }
}

// ✅ 2.x 方式
public class MyRedisCacheManager extends RedisCacheManager {
    private final RedisCacheWriter cacheWriter;
    private final RedisCacheConfiguration defaultCacheConfiguration;

    public MyRedisCacheManager(RedisCacheWriter cacheWriter,
                               RedisCacheConfiguration defaultCacheConfiguration) {
        super(cacheWriter, defaultCacheConfiguration);
        this.cacheWriter = cacheWriter;
        this.defaultCacheConfiguration = defaultCacheConfiguration;
    }

    @Override
    protected RedisCache createRedisCache(String name,
                                          @Nullable RedisCacheConfiguration cacheConfig) {
        // cacheConfig 可能为 null，回退到 default
        RedisCacheConfiguration config = cacheConfig != null ? cacheConfig : defaultCacheConfiguration;
        return new MyRedisCache(name, cacheWriter, config);
    }
}
```

**关键 API 变化**:

| 旧 1.x | 新 2.x |
|--------|--------|
| `createCache(String)` | `createRedisCache(String, @Nullable RedisCacheConfiguration)` |
| `public` 可见性 | `protected` 可见性 |
| 构造器参数 `(RedisTemplate)` | 构造器参数 `(RedisCacheWriter, RedisCacheConfiguration)` |

### 1.4 JedisConnectionFactory 适配

Spring Data Redis 2.x 中 JedisConnectionFactory 不再提供 `setHostName()`/`setPort()`/`setPassword()` setter 方法，改为通过 `RedisStandaloneConfiguration` 构造器传入。

```xml
<!-- ❌ 1.x 方式 — setter 注入 -->
<bean id="jedisConnectionFactory"
      class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>

<!-- ✅ 2.x 方式 — RedisStandaloneConfiguration + 构造器注入 -->
<bean id="redisStandaloneConfiguration"
      class="org.springframework.data.redis.connection.RedisStandaloneConfiguration">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
</bean>

<bean id="jedisConnectionFactory"
      class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <constructor-arg ref="redisStandaloneConfiguration"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

### 1.5 XML Redis Cache Manager 配置全面改造

```xml
<!-- ✅ 2.x 完整配置 -->
<!-- Redis 连接配置 -->
<bean id="redisStandaloneConfiguration"
      class="org.springframework.data.redis.connection.RedisStandaloneConfiguration">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
</bean>

<bean id="jedisPoolConfig" class="redis.clients.jedis.JedisPoolConfig">
    <property name="maxTotal" value="${redis.maxTotal}"/>
    <property name="maxIdle" value="${redis.maxIdle}"/>
    <property name="minIdle" value="${redis.minIdle}"/>
</bean>

<bean id="jedisConnectionFactory"
      class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <constructor-arg ref="redisStandaloneConfiguration"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>

<!-- RedisCacheWriter（2.x 新增） -->
<bean id="redisCacheWriter"
      class="org.springframework.data.redis.cache.RedisCacheWriter"
      factory-method="nonLockingRedisCacheWriter">
    <constructor-arg ref="jedisConnectionFactory"/>
</bean>

<!-- RedisCacheConfiguration（通过 FactoryBean） -->
<bean id="redisCacheConfiguration"
      class="com.cpic.fms.common.cache.redis.RedisCacheConfigurationFactory">
    <property name="entryTtl" value="PT36H"/>
    <property name="disableCachingNullValues" value="true"/>
</bean>

<!-- RedisCacheManager（自定义子类） -->
<bean id="redisCacheManager"
      class="com.cpic.fms.common.cache.redis.MyRedisCacheManager">
    <constructor-arg ref="redisCacheWriter"/>
    <constructor-arg ref="redisCacheConfiguration"/>
</bean>
```

---

## 2. CompositeCacheManager 兼容性

### 2.1 问题

Spring 5.3.x 的 `CacheManager.getCacheNames()` 返回 `Collections.unmodifiableSet()`:

```java
// ❌ 错误 — 直接 retainAll 会抛 UnsupportedOperationException
Collection<String> names1 = levelOneCacheManager.getCacheNames(); // 不可修改
names1.retainAll(names2);
```

### 2.2 修复

```java
// ✅ 正确 — 复制到可变 Set 后再操作
Set<String> names = new LinkedHashSet<>(levelOneCacheManager.getCacheNames());
names.retainAll(levelTwoCacheManager.getCacheNames());
return Collections.unmodifiableSet(names);
```

---

## 3. EhCache 版本冲突

### 3.1 问题

classpath 上存在两个 EhCache 版本:

| 版本 | 来源 | 处理 |
|------|------|------|
| `ehcache-core:2.6.9` | 项目显式声明（旧） | **移除** |
| `ehcache:2.10.9.2` | `hibernate-ehcache` 传递（新） | **保留** |

两者 `net.sf.ehcache` 包名相同但 API 版本不兼容。旧版本被优先加载时导致 `NoSuchMethodError`。

### 3.2 解决

移除 pom.xml 中显式声明的 `ehcache-core:2.6.9` 依赖，仅保留 `hibernate-ehcache` 传递的 `ehcache:2.10.9.2`。

---

## 4. Hibernate 大版本断代升级

### 4.1 Hibernate 5.0→5.2 API 合并

| 变化 | 5.0 | 5.2+ |
|------|-----|------|
| `hibernate-java8` 模块 | 独立 JAR | **合并到 hibernate-core** |
| `hibernate-entitymanager` 模块 | 独立 JAR | **合并到 hibernate-core** |
| `SessionFactory` | 独立接口 | **扩展了 `javax.persistence.EntityManagerFactory`** |
| `Session` | 独立接口 | **扩展了 `javax.persistence.EntityManager`** |
| `org.hibernate.Query` | 正常 | **@Deprecated** → 使用 `org.hibernate.query.Query` |
| `HibernateException` | 独立 | 扩展了 `javax.persistence.PersistenceExceptions` |

**影响**: 升级到 Hibernate 5.2+ 后，`SessionFactory` 和 `EntityManagerFactory` 指向同一个实现。

#### SessionFactory/EntityManagerFactory 双 Bean 冲突

```java
// ❌ 错误:
// NoUniqueBeanDefinitionException: No qualifying bean of type
// 'javax.persistence.EntityManagerFactory' available: expected single
// matching bean but found 2: sessionFactory,entityManagerFactory

// ✅ 解决: 兼容旧代码时，通过 unwrap 获取 SessionFactory
@Configuration
@EnableJpaRepositories
@EnableTransactionManagement
public class JpaConfig {

    @Bean
    public LocalContainerEntityManagerFactoryBean entityManagerFactory() {
        HibernateJpaVendorAdapter adapter = new HibernateJpaVendorAdapter();
        adapter.setGenerateDdl(true);
        LocalContainerEntityManagerFactoryBean factory = new LocalContainerEntityManagerFactoryBean();
        factory.setJpaVendorAdapter(adapter);
        factory.setPackagesToScan("com.acme.domain");
        factory.setDataSource(dataSource());
        return factory;
    }

    @Bean
    public PlatformTransactionManager transactionManager(EntityManagerFactory emf) {
        return new JpaTransactionManager(emf);
    }

    // 兼容旧代码中注入 SessionFactory 的地方
    @Bean
    public SessionFactory sessionFactory(EntityManagerFactory emf) {
        return emf.unwrap(SessionFactory.class);
    }
}
```

> 使用 `LocalContainerEntityManagerFactoryBean` 而非 `EntityManagerFactory`，因为前者除了创建 EntityManagerFactory 还参与异常转换。

#### Hibernate 5.2 其他关键变化

| 变化点 | 说明 |
|--------|------|
| `org.hibernate.Query` (旧) | `list()` → `getResultList()`, `uniqueResult()` → `getSingleResult()` |
| `org.hibernate.SessionFactory` | 缓存管理移至 `org.hibernate.Cache`（扩展 `javax.persistence.Cache`） |
| `org.hibernate.Metamodel` | 扩展 `javax.persistence.metamodel.Metamodel`，管理类型系统所有方面 |
| Java 8 日期/时间 | 原生支持 `LocalDate`/`LocalDateTime` 等（无需额外配置）|

### 4.3 Hibernate 5.4 → 5.6 配置变化

#### 4.3.1 已废弃的配置属性

| 属性 | 5.4 状态 | 5.6 状态 | 替代方案 |
|------|---------|---------|----------|
| `hibernate.show_sql` | 正常 | **@Deprecated** | 移除（通过日志配置代替） |
| `hibernate.use_sql_comments` | 正常 | **@Deprecated** | 移除 |
| `hibernate.query.sql.jdbc_style_params_base` | 正常 | **已移除** | 移除 |

#### 4.3.2 XML 配置迁移

```xml
<!-- 5.4 配置 -->
<prop key="hibernate.show_sql">true</prop>
<prop key="hibernate.format_sql">false</prop>
<prop key="hibernate.use_sql_comments">false</prop>
<prop key="hibernate.query.sql.jdbc_style_params_base">true</prop>

<!-- 5.6 配置 — 移除废弃/移除项 -->
<prop key="hibernate.format_sql">false</prop>
```

#### 4.3.3 可迁移到 application.properties 的配置

```properties
# application.properties
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.MySQL8Dialect
spring.jpa.properties.hibernate.jdbc.batch_size=25
spring.jpa.properties.hibernate.jdbc.fetch_size=50
spring.jpa.properties.hibernate.id.new_generator_mappings=true
spring.jpa.properties.hibernate.enable_lazy_load_no_trans=true
```

---

## 5. Spring AMQP 1.x → 2.x 配置变化

### 5.1 Publisher Confirm 配置

```xml
<!-- ❌ 1.x -->
<rabbit:connection-factory publisher-confirms="true"/>

<!-- ✅ 2.x -->
<rabbit:connection-factory publisher-confirm-type="correlated" publisher-returns="true"/>
```

### 5.2 Listener Container 配置

```xml
<!-- ✅ 2.x 推荐显式指定 container-type -->
<rabbit:listener-container connection-factory="connectionFactory"
                           acknowledge="manual"
                           concurrency="20"
                           prefetch="10"
                           container-type="simple">
```

### 5.3 属性配置变更

| 1.x | 2.x |
|-----|-----|
| `spring.rabbitmq.listener.concurrency` | `spring.rabbitmq.listener.simple.concurrency` |
| `spring.rabbitmq.listener.prefetch` | `spring.rabbitmq.listener.simple.prefetch` |
