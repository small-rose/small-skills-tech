# FMS��Ŀ Spring Boot 2.7.18 ����������ϸ����

> **�ĵ��汾**: v1.25  
> **����ʱ��**: 2026��6��21��  
> **������Ŀ**: FMS���ø���ϵͳ  
> **����Ŀ��**: Spring Boot 2.7.18 + Spring Framework 5.3.x  
> **���¼�¼**:
> - v1.25 �޸�Dorado UploadAction ��������δע�ᣨsystem scope JAR �� DoradoLoader ���֣����� @ImportResource ��ʾ���� uploader context.xml
> - v1.1 ����webappĿ¼������classpath���ط������
> - v1.2 ����Dorado Resources���ʻ��ļ�����˵��
> - v1.3 ����classpath·������WEB-INF/dorado-home��
> - v1.4 �޸�pom.xml��Դ�������⣬ȷ��application.properties��ȷ����
> - v1.5 �޸�Spring Data Redis 2.x���������⣨MyRedisCache��MyRedisCacheManager��
> - v1.6 ��ȫMyRedisCacheManager.createRedisCache����ǩ���޸���������������ʾ��
> - v1.7 ����Maven Profiles�໷�����ã�FMS_PRD_DEV/PRO/LOCAL�������DecryptPropertyPlaceholderConfigurer����application-context.properties��FileNotFoundException����
> - v1.8 �޸�logback.xml���ô���filterԪ�طŴ�λ�ã�Ӧ��appenderֱ���Ӽ�����rollingPolicy�ڣ�������appender FileNamePattern��ͻ
> - v1.9 �޸�application-context.xmlȱ��jdbc.properties���أ�����${jdbc.driverClass}��ռλ���޷�����
> - v1.10 ����components.properties���أ����solr ${richdata.url}ռλ�������޸�redis.password������ƥ��
> - v1.11 �޸�Dorado����Contextδ���ص���`dorado.globalResourceSearchPathRegister` Beanȱʧ
> - v1.12 �޸�ѭ������������fndsoft����������`activitiExtendService`?`WFTaskService`����������Spring Boot 2.6+Ĭ�Ͻ�ֹѭ������
> - v1.13 �޸�RedisCacheConfiguration���ɱ�������ע�뱨�����½�RedisCacheConfigurationFactory��builderģʽ����
> - v1.14 �޸�`dataTypeView`ռλ���޷��������������dorado-home/configure.properties
> - v1.15 ����Dorado data/view/web Context���أ��޸�`DataTypeDefinitionManager`��Beanȱʧ
> - v1.16 ����Dorado config Context���أ��޸�`dorado.dispatchableXmlParser` parent beanȱʧ
> - v1.17 ����Dorado common Context���أ��޸�`dorado.exposedServiceRegister` Beanȱʧ
> - v1.18 �޸�Dorado Context���׻���δ��ʼ������`DataOutputter`��̬��ʼ��NPE
> - v1.19 �޸�Woodstox�汾��ͻ���Դ������ų�jackson-dataformat-xml������Ŀ��ʽ�������������������ˣ�
> - v1.20 �޸�Woodstox�汾��ͻ�����⣩���ų�cxf-core��woodstox-core-asl��solr-solrj��wstx-asl�Ͼɴ�������
> - v1.21 �޸���̬��Դ·����ƥ�䣺����/resources/static/**ӳ�䵽classpath:/static/
> - v1.22 �����ϲ�profileģʽ
> - v1.23 web.xml ȫ�� 24 Servlet + 4 Filter + 4 Listener Ǩ���� Spring Boot Java ���ã�7 �� @Configuration �ࣩ��Ƕ��ʽ Tomcat �� DoradoServlet ע�����հ�ҳ����
> - v1.24 �޸�DoradoServlet.createWebApplicationContext()��ȡConfigure store����servletContext���ԣ�����dorado-child-context.xml���أ����ս����¼��`*.d` 404

---

## Ŀ¼

1. [��������](#1-��������)
2. [��һ�׶Σ�POM��������](#2-��һ�׶�pom��������)
3. [�ڶ��׶Σ�Spring���Ŀ������](#3-�ڶ��׶�spring���Ŀ������)
4. [�����׶Σ����ݲ��������](#4-�����׶����ݲ��������)
5. [���Ľ׶Σ������������](#5-���Ľ׶λ����������)
6. [����׶Σ���Ϣ�����������](#6-����׶���Ϣ�����������)
7. [�����׶Σ���ʱ�����������](#7-�����׶ζ�ʱ�����������)
8. [���߽׶Σ�WebService�������](#8-���߽׶�webservice�������)
9. [�ڰ˽׶Σ�Web������Servlet����](#9-�ڰ˽׶�web������servlet����)
10. [�ھŽ׶Σ���־�����������](#10-�ھŽ׶���־�����������)
11. [��ʮ�׶Σ������������](#11-��ʮ�׶ι����������)
12. [��ʮһ�׶Σ�webappĿ¼������classpath���ط���](#12-��ʮһ�׶�webappĿ¼������classpath���ط���) **��������**
13. [��ʮ���׶Σ������������ø��죨��ϸ��](#13-��ʮ���׶������������ø�����ϸ)
14. [��ʮ���׶Σ�����JAR�����Դ���](#14-��ʮ���׶α���jar�����Դ���)
15. [��ʮ�Ľ׶Σ�����ʽ����](#15-��ʮ�Ľ׶β���ʽ����)
16. [��¼A��ȫ�������汾���ձ�](#��¼aȫ�������汾���ձ�)
17. [��¼B��API�仯�������](#��¼bapi�仯�������)
18. [��¼C�����վ����뻺���ʩ](#��¼c���վ����뻺���ʩ)
19. [��¼D����֤�嵥](#��¼d��֤�嵥)
20. [��ʮ�߽׶Σ�web.xml ȫ��Ǩ�Ƶ� Spring Boot Java ����](#17-��ʮ���׶�web-xml-ȫ��Ǩ�Ƶ�-spring-boot-java-����v123-����)
21. [��ʮ�˽׶Σ�DoradoServlet��Context�����޸�](#18-��ʮ�߽׶��޸�doradoservlet��contextδ���ص���-d-404v124-����)

---

## 2. ��һ�׶Σ�POM��������

### 2.1 ����Ŀ��
����Ŀ�Ӷ���Spring Framework��������ΪSpring Boot 2.7.18 BOMͳһ������

### 2.2 �Ķ��ļ�
- `pom.xml`

### 2.3 ��ϸ�Ķ���

#### 2.3.1 ����Spring Boot Parent

**�Ķ�λ��**: `pom.xml` ������`<modelVersion>` ֮��

**�Ķ�ǰ**:
```xml
<modelVersion>4.0.0</modelVersion>
<groupId>com.cpic</groupId>
<artifactId>fms</artifactId>
<packaging>war</packaging>
```

**�Ķ���**:
```xml
<modelVersion>4.0.0</modelVersion>

<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.7.18</version>
    <relativePath/>
</parent>

<groupId>com.cpic</groupId>
<artifactId>fms</artifactId>
<packaging>war</packaging>
```

#### 2.3.2 �����汾����

**�Ķ�λ��**: `<properties>` ����

**��������**:
```xml
<properties>
    <!-- ����ԭ������ -->
    <hibernate.version>5.6.15.Final</hibernate.version>
    <activiti.version>5.16.3</activiti.version>
    <restlet.version>2.1.4</restlet.version>
    <hibernate.validator.version>5.4.1.Final</hibernate.validator.version>
    <mysql.version>8.0.33</mysql.version>
    <protostuff.version>1.4.3</protostuff.version>
    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    <fndsoft.lib.path>H:/work/project_code/dongwu/fms/src/main/webapp/WEB-INF/lib</fndsoft.lib.path>
    
    <!-- �������ų�BootĬ�ϰ汾������ʹ��ָ���汾 -->
    <jackson.version>2.12.7.1</jackson.version>
</properties>
```

> **ע��**��`spring-data.version` �������Ƴ�����Ϊ `spring-data-redis` �İ汾�� Spring Boot BOM ͳһ������2.7.18���������ֶ�ָ����

#### 2.3.3 ����Spring Boot Starter����

**�Ķ�λ��**: `<dependencies>` �鶥��

**��������**:
```xml
<!-- Spring Boot��������������Web������WAR����ʽ�� -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter</artifactId>
    <exclusions>
        <!-- �ų�Ĭ����־��ʹ��logback -->
        <exclusion>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-logging</artifactId>
        </exclusion>
    </exclusions>
</dependency>

<!-- Spring Boot Web����ǶTomcat�����ڱ��������� -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
    <scope>provided</scope>
</dependency>

<!-- Spring Boot Actuator����ض˵㣩 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

#### 2.3.4 �Ƴ��ֶ��汾����������

������������Spring Boot BOM�������Ƴ��ֶ��汾������

**�Ķ�ǰ**:
```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
    <version>2.9.8</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
    <version>2.9.10.8</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
    <version>2.9.8</version>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-xml</artifactId>
    <version>2.9.8</version>
</dependency>
```

**�Ķ���**���Ƴ��汾�ţ���Boot������:
```xml
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-core</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-databind</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.core</groupId>
    <artifactId>jackson-annotations</artifactId>
</dependency>
<dependency>
    <groupId>com.fasterxml.jackson.dataformat</groupId>
    <artifactId>jackson-dataformat-xml</artifactId>
</dependency>
```

#### 2.3.5 Spring��������汾�Ƴ�

����Spring Data��������Boot�������Ƴ��ֶ��汾��

**�Ķ�ǰ**:
```xml
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-commons</artifactId>
    <version>1.13.12.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
    <version>1.6.1.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <version>1.7.2.RELEASE</version>
</dependency>
<dependency>
    <groupId>org.springframework.amqp</groupId>
    <artifactId>spring-rabbit</artifactId>
    <version>1.3.9.RELEASE</version>
</dependency>
```

**�Ķ���**���Ƴ��汾�ţ�:
```xml
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-commons</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-jpa</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.amqp</groupId>
    <artifactId>spring-rabbit</artifactId>
</dependency>
```

#### 2.3.6 ��־�����汾�Ƴ�

**�Ķ�ǰ**:
```xml
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
    <version>1.2.13</version>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
    <version>1.2.13</version>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-access</artifactId>
    <version>1.2.13</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jcl-over-slf4j</artifactId>
    <version>1.7.25</version>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>log4j-over-slf4j</artifactId>
    <version>1.7.25</version>
</dependency>
```

**�Ķ���**���Ƴ��汾�ţ�:
```xml
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-classic</artifactId>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-core</artifactId>
</dependency>
<dependency>
    <groupId>ch.qos.logback</groupId>
    <artifactId>logback-access</artifactId>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>jcl-over-slf4j</artifactId>
</dependency>
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>log4j-over-slf4j</artifactId>
</dependency>
```

#### 2.3.7 Servlet API�汾����

**�Ķ�ǰ**:
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>3.0.1</version>
    <scope>provided</scope>
</dependency>
```

**�Ķ���**:
```xml
<dependency>
    <groupId>javax.servlet</groupId>
    <artifactId>javax.servlet-api</artifactId>
    <version>4.0.1</version>
    <scope>provided</scope>
</dependency>
```

#### 2.3.8 Redis�ͻ�������

**�Ķ�ǰ**:
```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
    <version>2.9.0</version>
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
    <version>2.0</version>
</dependency>
```

**�Ķ���**����Boot������:
```xml
<dependency>
    <groupId>redis.clients</groupId>
    <artifactId>jedis</artifactId>
</dependency>
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-pool2</artifactId>
</dependency>
```

#### 2.3.9 Hibernate�汾����

**�Ķ�ǰ**:
```xml
<properties>
    <hibernate.version>5.4.33.Final</hibernate.version>
</properties>
```

**�Ķ���**:
```xml
<properties>
    <hibernate.version>5.6.15.Final</hibernate.version>
</properties>
```

#### 2.3.10 ��Դ�ļ������޸�����Ҫ��

**����˵��**��ԭ��pom.xml��`src/main/resources`����Դ����ֻ������`.bar`��`.drl`��`.bpmn`�ļ�������`application.properties`�������ļ��޷����뵽targetĿ¼��

**�Ķ�λ��**: `pom.xml` �� `<build><resources>` ��

**�Ķ�ǰ**:
```xml
<resource>
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*.bar</include>
        <include>**/*.drl</include>
        <include>**/*.bpmn</include>
    </includes>
</resource>
```

**�Ķ���**:
```xml
<resource>
    <directory>src/main/resources</directory>
    <includes>
        <include>**/*</include>
    </includes>
</resource>
```

**Ӱ��**��
- `application.properties` ����ȷ���뵽 `target/classes/`
- `logback.xml` ����־��������ȷ����
- `spring.main.allow-bean-definition-overriding=true` ��������������Ч

#### 2.3.11 Spring Data Redis�汾�����޸�����Ҫ��

**����˵��**��`spring-data-redis` ��ʽ�����˰汾 `1.7.2.RELEASE`���� Spring Boot 2.7.18 ������ `spring-data-commons 2.7.18` �����ݣ����� `RepositoryConfigurationSource.getAttribute()` �����Ҳ�����

**������Ϣ**��
```
An attempt was made to call a method that does not exist.
org.springframework.data.repository.config.RepositoryConfigurationSource.getAttribute()
```

**�������**��
1. �Ƴ� `spring-data-redis` �����İ汾�ţ��� Spring Boot BOM ͳһ����
2. �Ƴ� `<spring-data.version>2.5.8</spring-data.version>` ���ԣ�������δ��ʹ�ã�ʵ�ʰ汾��Boot����Ϊ2.7.18��

**�Ķ�λ��**: `pom.xml`

**�Ķ�1 �� dependencies��**:
```xml
<!-- �Ķ�ǰ -->
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <version>1.7.2.RELEASE</version>
</dependency>

<!-- �Ķ��� -->
<dependency>
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <!-- �Ƴ��汾�ţ���Spring Boot������2.7.18�� -->
</dependency>
```

**�Ķ�2 �� properties��**:
```xml
<!-- �Ƴ������ԣ�δ��ʹ�ã�Spring Boot BOM�����汾�� -->
<!-- <spring-data.version>2.5.8</spring-data.version> -->
```
    <groupId>org.springframework.data</groupId>
    <artifactId>spring-data-redis</artifactId>
    <!-- �Ƴ��汾�ţ���Spring Boot������2.7.18�� -->
</dependency>
```

**Ӱ�췶Χ**��
- Spring Data Redis �� 1.7.2 ������ 2.7.18
- Jedis �ͻ��˱��ֲ���
- XML ���÷�ʽ���ֲ���

### 2.4 �������ķ�������ݳ̶�

| ���� | ���������� | ���ݳ̶� | ˵�� |
|------|-----------|----------|------|
| Spring Boot | N/A����ǰ�ޣ� | N/A | �������� |
| Jackson | **��** - ��ȫ©��CVE-2022-42003�� | �� | 2.9.x������֪��ȫ©������������ |
| Spring Data JPA | **��** - API������ | �� | 1.x��2.x����Breaking Changes |
| Spring Data Redis | **��** - API������ | �� | 1.x��2.x����Breaking Changes |
| Spring Rabbit | **��** - �������Ա仯 | �� | 1.x������2.x�в���ʧЧ |
| Jedis | **��** - API�仯 | �� | 3.x����API��� |
| Hibernate | **��** - 5.4��5.6���ڲ��� | �� | 5.6Ҫ��Java 8+������API�仯 |
| Logback | **��** - ������ | �� | 1.2.xϵ�������� |
| Servlet API | **��** - ������ | �� | 3.0.1��4.0.1������ |

---

## 3. �ڶ��׶Σ�Spring���Ŀ������

### 3.1 ����Ŀ��
Spring Framework��5.2.24������5.3.31����Boot 2.7.18��������

### 3.2 �Ķ��ļ�
- ����ֱ�ӸĶ�����Boot Parent������
- ��Ҫ��֤XML Schema������

### 3.3 API�仯�������

#### 3.3.1 Spring MVC�仯

| �仯�� | ��API/��Ϊ | ��API/��Ϊ | Ӱ�췶Χ |
|--------|-----------|-----------|----------|
| `@RequestParam` Ĭ����Ϊ | ����nullֵ | nullֵ��Ϊȱʧ���� | Controller�� |
| `PathPatternParser` | ������ | ����URLƥ��ѡ�� | ���ò� |
| `ServerHttpResponse` | `setStatusCode()` | `setStatusCode(HttpStatusCode)` | WebFilter |
| `DefaultParameterNameDiscoverer` | ����ASM | ����Standard���� | AOP���� |

#### 3.3.2 Spring Context�仯

| �仯�� | ��API/��Ϊ | ��API/��Ϊ | Ӱ�췶Χ |
|--------|-----------|-----------|----------|
| `AbstractBeanFactory` | `isTypeMatch()`��Ϊ | ֧�ַ�������ƥ�� | Bean���� |
| `GenericApplicationContext` | ����ˢ�� | ֧��refresh() | ������ |
| `@EventListener` | ��֧��`@Transactional` | ֧��`@TransactionalEventListener` | �¼����� |

#### 3.3.3 Spring ORM�仯

| �仯�� | ��API/��Ϊ | ��API/��Ϊ | Ӱ�췶Χ |
|--------|-----------|-----------|----------|
| `HibernateJpaSessionFactoryBean` | ֧�� | **@Deprecated** | SessionFactory���� |
| `HibernateTransactionManager` | `setJpaDialect()` | �Ľ���JPA���Դ��� | ������� |
| `LocalSessionFactoryBean` | �������� | ����`hibernate5`��ר��֧�� | SessionFactory |

### 3.4 ��������֤�嵥

- [ ] Spring XML Schema�汾��飨`spring-beans-3.0.xsd` �� ��ȷ�ϼ����ԣ�
- [ ] `@Autowired`ע����Ϊ��֤
- [ ] AOP����ִ��˳����֤
- [ ] ���񴫲���Ϊ��֤
- [ ] �¼�����������֤

---

## 4. �����׶Σ����ݲ��������

### 4.1 ����Ŀ��
����Hibernate��5.6.15��Spring Data JPA��2.5.8��

### 4.2 �Ķ��ļ�
- `pom.xml`������ɰ汾������
- `application-context.xml`��Hibernate���ã�

### 4.3 Hibernate 5.4 �� 5.6 API�仯

#### 4.3.1 Breaking Changes

| �仯�� | ��API | ��API | Ǩ�Ʒ��� |
|--------|-------|-------|----------|
| `org.hibernate.Query` | `list()` | `getResultList()` | ȫ���滻 |
| `org.hibernate.Query` | `uniqueResult()` | `getSingleResult()` | ȫ���滻 |
| `org.hibernate.Query` | `executeUpdate()` | `executeUpdate()` | ����仯 |
| `org.hibernate.Criteria` | `add(Restrictions)` | JPA Criteria API | ��Ҫ�ع� |
| `org.hibernate.Session` | `createCriteria()` | `createQuery()` | ��Ҫ�ع� |
| `hibernate.show_sql` | ֧�� | **@Deprecated** | ʹ��`format_sql` |
| `hibernate.format_sql` | ֧�� | ֧�� | ����仯 |
| `hibernate.use_sql_comments` | ֧�� | **@Deprecated** | �Ƴ����� |

#### 4.3.2 ��������

| �¹��� | ˵�� | ʹ�ó��� |
|--------|------|----------|
| `@NaturalId` | ��Ȼ����֧�� | ʵ����ע�� |
| `@Filter`/`@FilterDef` | ������֧�� | ��̬��ѯ |
| `StatelessSession` | ��״̬�Ự | �������� |
| `MutationQuery` | д������ѯ | �����޸� |

#### 4.3.3 ���ñ仯

**�Ķ�λ��**: `application-context.xml`

**�Ķ�ǰ**:
?```xml
<property name="hibernateProperties">
    <props>
        <prop key="hibernate.dialect">org.hibernate.dialect.MySQL8Dialect</prop>
        <prop key="hibernate.jdbc.batch_size">25</prop>
        <prop key="hibernate.jdbc.fetch_size">50</prop>
        <prop key="hibernate.show_sql">true</prop>
        <prop key="hibernate.format_sql">false</prop>
        <prop key="hibernate.use_sql_comments">false</prop>
        <prop key="javax.persistence.validation.mode">none</prop>
        <prop key="hibernate.id.new_generator_mappings">true</prop>
        <prop key="hibernate.id.optimizer.pooled.prefer_lo">true</prop>
        <prop key="hibernate.enable_lazy_load_no_trans">true</prop>
        <prop key="hibernate.query.sql.jdbc_style_params_base">true</prop>
    </props>
</property>
```

**�Ķ���**:
```xml
<property name="hibernateProperties">
    <props>
        <prop key="hibernate.dialect">org.hibernate.dialect.MySQL8Dialect</prop>
        <prop key="hibernate.jdbc.batch_size">25</prop>
        <prop key="hibernate.jdbc.fetch_size">50</prop>
        <prop key="hibernate.format_sql">false</prop>
        <prop key="javax.persistence.validation.mode">none</prop>
        <prop key="hibernate.id.new_generator_mappings">true</prop>
        <prop key="hibernate.id.optimizer.pooled.prefer_lo">true</prop>
        <prop key="hibernate.enable_lazy_load_no_trans">true</prop>
        <!-- �Ƴ��ѷ��������� -->
        <!-- <prop key="hibernate.show_sql">true</prop> �ѷ��� -->
        <!-- <prop key="hibernate.use_sql_comments">false</prop> �ѷ��� -->
        <!-- <prop key="hibernate.query.sql.jdbc_style_params_base">true</prop> ���Ƴ� -->
    </props>
</property>
```

### 4.4 Spring Data JPA 1.6 �� 2.5 API�仯

#### 4.4.1 Breaking Changes

| �仯�� | ��API | ��API | Ǩ�Ʒ��� |
|--------|-------|-------|----------|
| `CrudRepository.findOne()` | `T findOne(ID)` | `Optional<T> findById(ID)` | ����ֵ��װ |
| `CrudRepository.delete()` | `void delete(ID)` | `void deleteById(ID)` | ���������� |
| `JpaRepository.getOne()` | `T getOne(ID)` | `T getReferenceById(ID)` | ���������� |
| `PageRequest.of()` | ��֧�� | ������̬���� | ����仯 |
| `@Query` ע�� | ֧�� | ֧�� | ����仯 |

#### 4.4.2 ��������

| �¹��� | ˵�� | ʹ�ó��� |
|--------|------|----------|
| `Projection` | ͶӰ��ѯ | �ֶ�ѡ�� |
| `@EntityGraph` | ʵ��ͼ | N+1��ѯ�Ż� |
| `Sort.by()` | ����API | �����ѯ |
| `Specification` | �淶��ѯ | ��̬��ѯ |

### 4.5 ��������

| ������ | ���յȼ� | Ӱ�췶Χ | �����ʩ |
|--------|---------|----------|----------|
| Hibernate Criteria API���� | **��** | ����ʹ��Criteria��ѯ�Ĵ��� | Ǩ�Ƶ�JPA Criteria��QueryDSL |
| Spring Data Repository���������� | **��** | ����Repository�ӿ� | �����鲢�滻������ |
| Optional����ֵ�仯 | **��** | ����findOne��ѯ | ����.orElse(null)���� |
| Lazy Loading��Ϊ�仯 | **��** | ���й�����ѯ | ��֤���������� |

---

## 5. ���Ľ׶Σ������������

### 5.1 ����Ŀ��
Spring Data Redis��1.7.2������2.7.18��Jedis��2.9.0������3.7.1��

### 5.2 �Ķ��ļ�
- `context-cache.spring.xml`

### 5.3 API�仯���

#### 5.3.1 Jedis 2.9 �� 3.7 Breaking Changes

| �仯�� | ��API | ��API | Ӱ�� |
|--------|-------|-------|------|
| `JedisPool`���캯�� | `new JedisPool(config, host, port)` | `new JedisPool(config, host, port, timeout, password)` | ���ӳ����� |
| `Jedis.set()` | `set(key, value)` | `set(key, value, SetParams)` | ������� |
| `Jedis.auth()` | `auth(password)` | ���캯������ | ������֤ |
| `Jedis.select()` | `select(index)` | ��Ҫ���»�ȡ���� | ���ݿ��л� |

#### 5.3.2 Spring Data Redis 1.7 �� 2.7 Changes

| �仯�� | ��API | ��API | Ǩ�Ʒ��� |
|--------|-------|-------|----------|
| `JedisConnectionFactory` | `setHostName()`/`setPort()` | `RedisStandaloneConfiguration` | ���캯���ع� |
| `RedisTemplate` | `setConnectionFactory()` | ֧�� | ����仯 |
| `RedisCacheManager` | `constructor(RedisTemplate)` | `RedisCacheManager(RedisCacheWriter, RedisCacheConfiguration)` | **���췽���ع�** |
| `RedisCache` | `RedisCache(name, prefix, redisOperations, expiration)` | `RedisCache(name, cacheWriter, cacheConfig)` | **���췽���ع�** |
| `RedisMessageListenerContainer` | `setConnectionFactory()` | ֧�� | ����仯 |

#### 5.3.3 �Զ�����Ķ�������ɣ�

**MyRedisCache.java** ���췽���޸ģ�

```java
// �Ķ�ǰ��1.x���� 4������
import org.springframework.data.redis.core.RedisOperations;

public MyRedisCache(String name, byte[] prefix,
        RedisOperations<? extends Object, ? extends Object> redisOperations, long expiration) {
    super(name, prefix, redisOperations, expiration);
}

// �Ķ���2.x���� 3��������ʹ��RedisCacheWriter���RedisOperations
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheWriter;

public MyRedisCache(String name, RedisCacheWriter cacheWriter, RedisCacheConfiguration cacheConfig) {
    super(name, cacheWriter, cacheConfig);
}
```

> **˵��**��`RedisCache` 2.x ֻ��һ�� `protected` ���췽�� `(String, RedisCacheWriter, RedisCacheConfiguration)`��1.x �� `(name, prefix, redisOperations, expiration)` ����ȫ�Ƴ���
> ���� `get/put/evict/clear` �� try-catch �ݴ��߼����ֲ��䡣

**MyRedisCacheManager.java** ���췽�� + createRedisCache �����޸ģ�

```java
// �Ķ�ǰ��1.x��
package com.cpic.fms.common.cache.redis;

import org.springframework.data.redis.cache.RedisCache;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.cache.RedisCacheWriter;

public class MyRedisCacheManager extends RedisCacheManager {
    private final RedisCacheWriter cacheWriter;
    private final RedisCacheConfiguration defaultCacheConfiguration;

    public MyRedisCacheManager(RedisCacheWriter cacheWriter, RedisCacheConfiguration defaultCacheConfiguration) {
        super(cacheWriter, defaultCacheConfiguration);
        this.cacheWriter = cacheWriter;
        this.defaultCacheConfiguration = defaultCacheConfiguration;
    }

    @Override
    public RedisCache createCache(String cacheName) {  // ? ��������ǩ�����ɼ��Ծ�����
        return new MyRedisCache(cacheName, this.cacheWriter, this.defaultCacheConfiguration);
    }
}

// �Ķ���2.x��
package com.cpic.fms.common.cache.redis;

import org.springframework.data.redis.cache.RedisCache;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.cache.RedisCacheWriter;
import org.springframework.lang.Nullable;

public class MyRedisCacheManager extends RedisCacheManager {
    private final RedisCacheWriter cacheWriter;
    private final RedisCacheConfiguration defaultCacheConfiguration;

    public MyRedisCacheManager(RedisCacheWriter cacheWriter, RedisCacheConfiguration defaultCacheConfiguration) {
        super(cacheWriter, defaultCacheConfiguration);
        this.cacheWriter = cacheWriter;
        this.defaultCacheConfiguration = defaultCacheConfiguration;
    }

    @Override
    protected RedisCache createRedisCache(String cacheName, @Nullable RedisCacheConfiguration cacheConfig) {
        RedisCacheConfiguration config = cacheConfig != null ? cacheConfig : this.defaultCacheConfiguration;
        return new MyRedisCache(cacheName, this.cacheWriter, config);
    }
}
```

> **�ؼ�����**��
> 1. ������ `createCache` �� `createRedisCache`
> 2. �ɼ��� `public` �� `protected`
> 3. ������1�� `(String)` ��Ϊ2�� `(String, @Nullable RedisCacheConfiguration)`
> 4. �账�� `cacheConfig` Ϊ null ����������˵� `defaultCacheConfiguration`

**context-cache.spring.xml** �����޸ģ�

```xml
<!-- �Ķ�ǰ��1.x�� -->
<bean id="redisCacheManager" class="com.cpic.fms.common.cache.redis.MyRedisCacheManager">
    <constructor-arg ref="redisTemplate"/>
    <property name="defaultExpiration" value="1296000"/>
    <property name="usePrefix" value="true"/>
    ...
</bean>

<!-- �Ķ���2.x�� -->
<bean id="redisCacheWriter" class="org.springframework.data.redis.cache.RedisCacheWriter"
      factory-method="nonLockingRedisCacheWriter">
    <constructor-arg ref="jedisConnectionFactory"/>
</bean>

<bean id="redisCacheConfiguration" class="org.springframework.data.redis.cache.RedisCacheConfiguration"
      factory-method="defaultCacheConfig">
    <property name="entryTtl" value="PT36H"/>
    <property name="disableCachingNullValues" value="true"/>
    <property name="serializeKeysWith">
        <bean class="org.springframework.data.redis.serializer.RedisSerializationContext$SerializationPair"
              factory-method="fromSerializer">
            <constructor-arg>
                <bean class="org.springframework.data.redis.serializer.StringRedisSerializer"/>
            </constructor-arg>
        </bean>
    </property>
    <property name="serializeValuesWith">
        <bean class="org.springframework.data.redis.serializer.RedisSerializationContext$SerializationPair"
              factory-method="fromSerializer">
            <constructor-arg>
                <bean class="com.cpic.fms.common.cache.redis.FastJsonRedisSerializer"/>
            </constructor-arg>
        </bean>
    </property>
</bean>

<bean id="redisCacheManager" class="com.cpic.fms.common.cache.redis.MyRedisCacheManager">
    <constructor-arg ref="redisCacheWriter"/>
    <constructor-arg ref="redisCacheConfiguration"/>
</bean>
```

#### 5.3.3 ���øĶ�

**�Ķ�λ��**: `context-cache.spring.xml`

**�Ķ�ǰ**:
```xml
<bean id="jedisConnectionFactory" class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

**�Ķ���**��Spring Data Redis 2.x�·�ʽ��:
```xml
<bean id="redisStandaloneConfiguration" class="org.springframework.data.redis.connection.RedisStandaloneConfiguration">
    <property name="hostName" value="${redis.host}"/>
    <property name="port" value="${redis.port}"/>
    <property name="password" value="${redis.password}"/>
</bean>

<bean id="jedisConnectionFactory" class="org.springframework.data.redis.connection.jedis.JedisConnectionFactory">
    <constructor-arg ref="redisStandaloneConfiguration"/>
    <property name="poolConfig" ref="jedisPoolConfig"/>
    <property name="timeout" value="${redis.timeout}"/>
</bean>
```

### 5.4 �Զ���������Լ��

��Ŀ�д��ڵ��Զ���Redis�������Ҫ��飺

| ���� | �ļ�λ�� | ����� | ������ |
|------|---------|--------|--------|
| `FastJsonRedisSerializer` | `com.cpic.fms.common.cache.redis` | �̳�`RedisSerializer` | ����ӿڱ仯 |
| `MyRedisCacheManager` | `com.cpic.fms.common.cache.redis` | �̳�`RedisCacheManager` | ���ع����캯�� |
| `MyJedisConnectionFactory` | `com.cpic.fms.common.cache.redis` | �̳�`JedisConnectionFactory` | ���ع� |
| `MyCompositeCacheManager` | `com.cpic.fms.common.cache` | �̳�`CacheManager` | ����ӿڱ仯 |
| `RedisUtil` | `com.cpic.fms.redis.util` | ʹ��`RedisTemplate` | ���鷽������ |

### 5.5 ��������

| ������ | ���յȼ� | Ӱ�췶Χ | �����ʩ |
|--------|---------|----------|----------|
| Jedis���캯���仯 | **��** | ����Redis�������� | �ع����ӹ������� |
| RedisCacheManager API�仯 | **��** | �Զ��建������� | �ع���������� |
| RedisSerializer�ӿڱ仯 | **��** | �Զ������л��� | ��鲢�����½ӿ� |
| ���ӳز����仯 | **��** | ���ӳ����� | ���²����� |

---

## 6. ����׶Σ���Ϣ�����������

### 6.1 ����Ŀ��
Spring Rabbit��1.3.9������2.4.17��

### 6.2 �Ķ��ļ�
- `context-rabbitmq.spring.xml`

### 6.3 API�仯���

#### 6.3.1 Breaking Changes

| �仯�� | ��API/��Ϊ | ��API/��Ϊ | Ǩ�Ʒ��� |
|--------|-----------|-----------|----------|
| `RabbitAdmin` | �Զ���� | ����ʽ���� | ����`<rabbit:admin>` |
| `SimpleMessageListenerContainer` | `concurrentConsumers` | `concurrency` | ���������� |
| `RabbitTemplate` | `setReturnCallback()` | `setReturnsCallback()` | ���������� |
| `RabbitTemplate` | `setConfirmCallback()` | `setConfirmCallback()` | ����仯 |
| `ConnectionFactory` | `setRequestedHeartBeat()` | `setRequestedHeartBeat()` | ����仯 |

#### 6.3.2 �������Ա仯

| ������ | ������ | ˵�� |
|--------|--------|------|
| `spring.rabbitmq.listener.concurrency` | `spring.rabbitmq.listener.simple.concurrency` | ������������ |
| `spring.rabbitmq.listener.prefetch` | `spring.rabbitmq.listener.simple.prefetch` | Ԥȡ��Ϣ�� |
| `spring.rabbitmq.listener.retry.enabled` | `spring.rabbitmq.listener.simple.retry.enabled` | ���Կ��� |

#### 6.3.3 XML���ñ仯

**�Ķ�λ��**: `context-rabbitmq.spring.xml`

**�Ķ�ǰ**:
```xml
<rabbit:connection-factory id="connectionFactory"
                           addresses="${rabbit.address}"
                           username="${rabbit.username}"
                           password="${rabbit.password}"
                           channel-cache-size="100" publisher-confirms="true"/>

<rabbit:listener-container connection-factory="connectionFactory"
                           acknowledge="manual"
                           concurrency="20"
                           prefetch="10">
```

**�Ķ���**:
```xml
<rabbit:connection-factory id="connectionFactory"
                           addresses="${rabbit.address}"
                           username="${rabbit.username}"
                           password="${rabbit.password}"
                           channel-cache-size="100" 
                           publisher-confirm-type="correlated"
                           publisher-returns="true"/>

<rabbit:listener-container connection-factory="connectionFactory"
                           acknowledge="manual"
                           concurrency="20"
                           prefetch="10"
                           container-type="simple">
```

#### 6.3.4 Publisher Confirm�仯

**�Ķ�ǰ**:
```xml
<rabbit:connection-factory ... publisher-confirms="true"/>
```

**�Ķ���**:
```xml
<rabbit:connection-factory ... publisher-confirm-type="correlated"/>
```

### 6.4 ��������

| ������ | ���յȼ� | Ӱ�췶Χ | �����ʩ |
|--------|---------|----------|----------|
| Publisher Confirm���ñ仯 | **��** | ��Ϣȷ�ϻ��� | ������������ |
| Listener Container���ͱ仯 | **��** | ��Ϣ���� | ��ʽָ��container-type |
| Return Callback���������� | **��** | ��Ϣ���ش��� | ���·������� |
| �Զ�Admin���仯 | **��** | �������� | ��ʽ����Admin |

---

## 7. �����׶Σ���ʱ�����������

### 7.1 ����Ŀ��
��֤Quartz 2.3.2��Spring Boot 2.7.18�µļ����ԡ�

### 7.2 �Ķ��ļ�
- `schedule-context.xml`������Ķ���

### 7.3 �����Է���

#### 7.3.1 Quartz 2.3.2������

| ��� | ������ | ˵�� |
|------|--------|------|
| `MethodInvokingJobDetailFactoryBean` | **����** | Spring�ṩ��Boot�����汾 |
| `CronTriggerFactoryBean` | **����** | Spring�ṩ��Boot�����汾 |
| `SchedulerFactoryBean` | **����** | Spring�ṩ��Boot�����汾 |
| `QuartzJobBean` | **����** | Spring�ṩ��Boot�����汾 |

#### 7.3.2 ���ñ仯

**����仯**����ǰ��Ŀʹ��Spring XML����Quartz��Boot 2.7.18��`spring-boot-starter-quartz`֧��XML���á�

### 7.4 ��ѡ�Ż�

���ϣ��ʹ��Boot�Զ����ã����ԣ�
1. ����`spring-boot-starter-quartz`����
2. ��XML����Ǩ�Ƶ�`application.properties`
3. ʹ��`@Scheduled`ע�����XML����

---

## 8. ���߽׶Σ�WebService�������

### 8.1 ����Ŀ��
��֤Apache CXF 3.1.4��Spring Boot 2.7.18�µļ����ԡ�

### 8.2 �Ķ��ļ�
- `webservice.spring.xml`������Ķ���

### 8.3 �����Է���

| ��� | ������ | ˵�� |
|------|--------|------|
| `cxf-core` 3.1.4 | **����** | CXF������Spring�汾 |
| `cxf-rt-transports-http` 3.1.4 | **����** | HTTP����� |
| `cxf-rt-frontend-jaxws` 3.1.4 | **����** | JAX-WSǰ�� |

### 8.4 ��������

| ������ | ���յȼ� | ˵�� |
|--------|---------|------|
| CXF��Spring�汾��� | **��** | CXFͨ��`cxf-spring-boot-starter`��Boot���ɣ�����ǰ��Ŀʹ�ö������� |
| Servlet API�汾 | **��** | CXF 3.1.4֧��Servlet 3.0+��������4.0.1������ |

---

## 9. �ڰ˽׶Σ�Web������Servlet����

### 9.1 ����Ŀ��
���ⲿTomcat WAR��������Ϊ��ǶTomcat������

### 9.2 �Ķ��ļ�
- `pom.xml`������ɣ�
- `web.xml`����Ҫ������Boot֧�֣�
- `FmsApplication.java`�������ࣩ
- `src/main/resources/application.properties`��������

### 9.3 ��ϸ�Ķ�

#### 9.3.1 ����application.properties

**�ļ�λ��**: `src/main/resources/application.properties`

**��������**:
```properties
# ========================
# Spring Boot Server Config
# ========================
server.port=8080
server.servlet.context-path=/
server.servlet.session.timeout=30m
server.servlet.session.cookie.name=FMSSESSIONID

# Tomcat����
server.tomcat.max-threads=200
server.tomcat.min-spare-threads=10
server.tomcat.max-connections=8192
server.tomcat.accept-count=100
server.tomcat.uri-encoding=UTF-8

# ========================
# Actuator Config
# ========================
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized

# ========================
# Logging Config (��ѡ������logback����)
# ========================
logging.level.root=INFO
logging.level.com.cpic.fms=DEBUG
```

#### 9.3.2 ���������

**�ļ�λ��**: `src/main/java/com/FmsApplication.java`

**�Ķ�ǰ**:
```java
package com;

@SpringBootApplication
@ServletComponentScan
public class FmsApplication {
    public static void main(String[] args) {
        SpringApplication.run(FmsApplication.class, args);
    }
}
```

**�Ķ���**:
```java
package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

@SpringBootApplication
@ServletComponentScan
@Configuration
@ImportResource({
    "classpath*:WEB-INF/dorado-home/application-context.xml"
})
@ComponentScan(basePackages = {"com.cpic.fms", "com.fndsoft"})
public class FmsApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(FmsApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(FmsApplication.class, args);
    }
}
```

#### 9.3.3 web.xml������˵��

**����Ķ�**��Spring Boot 2.7.18֧�ִ�ͳ`web.xml`���÷�ʽ����ǰ`web.xml`�ж����Filter��Servlet�ᱻ�Զ���⡣

### 9.4 Servlet API 3.0 �� 4.0 �仯

| �仯�� | Servlet 3.0 | Servlet 4.0 | Ӱ�� |
|--------|-------------|-------------|------|
| `@WebFilter` | ֧�� | ֧�� | ����仯 |
| `@WebServlet` | ֧�� | ֧�� | ����仯 |
| `@WebListener` | ֧�� | ֧�� | ����仯 |
| HTTP/2֧�� | ��֧�� | ֧�֣���ѡ�� | �������� |
| Server Push | ��֧�� | ֧�� | �������� |

### 9.5 ��������

| ������ | ���յȼ� | Ӱ�췶Χ | �����ʩ |
|--------|---------|----------|----------|
| ��ǶTomcat���ⲿTomcat���� | **��** | ����ʽ | ����WAR�������� |
| web.xml��Boot�Զ����ó�ͻ | **��** | �������� | ��ʽ����XML���� |
| Servlet Context��ʼ��˳�� | **��** | �������� | ����@ComponentScan |

---

## 10. �ھŽ׶Σ���־�����������

### 10.1 ����Ŀ��
ͳһ��־��ܰ汾������Actuator��ض˵㡣

### 10.2 �Ķ��ļ�
- `pom.xml`������ɣ�
- `logback.xml`����־���ã�
- `application.properties`������ɣ�

### 10.3 ��־��ܱ仯

#### 10.3.1 SLF4J 1.7.25 �� 1.7.36

| �仯�� | �ɰ汾 | �°汾 | Ӱ�� |
|--------|--------|--------|------|
| API | 1.7 API | 1.7 API | **����** |
| MDC | ֧�� | ֧�� | ����仯 |
| Marker | ֧�� | ֧�� | ����仯 |

#### 10.3.2 Logback 1.2.13 �� 1.2.12

| �仯�� | �ɰ汾 | �°汾 | Ӱ�� |
|--------|--------|--------|------|
| Configuration | 1.2.x | 1.2.x | **����** |
| Appender | ֧�� | ֧�� | ����仯 |
| Filter | ֧�� | ֧�� | ����仯 |

### 10.4 logback.xml�����Լ��

**����Ķ�**��Logback 1.2.xϵ���ڲ���ȫ���ݡ�

### 10.5 Actuator��ض˵�

��ͨ������`spring-boot-starter-actuator`���룬����������á�

---

## 11. ��ʮ�׶Σ������������

### 11.1 ����Ŀ��
�������й������汾���䡣

### 11.2 �����Լ��

| ���߿� | ��ǰ�汾 | Boot������ | ���� |
|--------|---------|-----------|------|
| Hutool | 5.7.15 | **����** | �� |
| Guava | 18.0 | **����** | �� |
| Apache Commonsϵ�� | ���汾 | **����** | �� |
| Jackson (Fastjson) | 1.2.83 | **����** | �� |
| Protostuff | 1.4.3 | **����** | �� |
| XStream | 1.4.17 | **����** | �� |
| Apache POI | 4.1.2 | **����** | �� |
| Velocity | 1.7 | **����** | �� |
| Drools | 5.6.0.Final | **����** | �� |
| Activiti | 5.16.3 | **����** | �� |

---

## 12. ��ʮһ�׶Σ�webappĿ¼������classpath���ط���

### 12.1 ��������

**����һ��webappĿ¼���������**

�𰸣�**�У���λ�ñ���**��

Maven WAR�����Ľṹ��
```
target/
������ fms/                          # ��ѹ���WAR�ṹ
��   ������ *.html, *.jsp, *.js      # webapp��Ŀ¼�ļ�
��   ������ img/
��   ������ WEB-INF/
��       ������ classes/              # ����src/main/resources
��       ������ lib/                  # ����JAR
��       ������ dorado-home/          # XML�����ļ�������ԭ�ṹ��
��           ������ application-context.xml
��           ������ datasource.spring.xml
��           ������ ...
������ fms.war                       # WAR���ļ�
```

**�ؼ���**��webapp�µ��ļ���WAR����Ŀ¼��**����classpath��**��

**�������@ImportResource�ܷ�ʹ��classpathģʽ��**

�𰸣�**Ĭ�ϲ���**��������ͨ��Maven��Դ����ʵ�֡�

### 12.2 XML�����ļ����ز���

#### ����һ��Maven��Դ������Ƶ�classpath���Ƽ���

**ԭ��**��ͨ��Maven��Դ�����webapp�µ�XML�ļ����Ƶ�classpath��ʹ`@ImportResource`����ʹ��classpath·����

**�Ķ�λ��**: `pom.xml`

**��������**:
```xml
<build>
    <resources>
        <!-- ԭ�����ã�src/main/resources -->
        <resource>
            <directory>src/main/resources</directory>
        </resource>
        <!-- ��������webapp�µ�XML���ø��Ƶ�classpath -->
        <resource>
            <directory>src/main/webapp/WEB-INF/dorado-home</directory>
            <targetPath>dorado-home</targetPath>
            <includes>
                <include>**/*.xml</include>
                <include>**/*.properties</include>
            </includes>
        </resource>
    </resources>
</build>
```

**Ч��**�������`dorado-home`Ŀ¼�������`target/classes/`�У�
```
target/classes/
������ dorado-home/
��   ������ application-context.xml
��   ������ datasource.spring.xml
��   ������ context-cache.spring.xml
��   ������ context-rabbitmq.spring.xml
��   ������ schedule-context.xml
��   ������ servlet-context.xml
��   ������ webservice.spring.xml
��   ������ workflow-context.xml
��   ������ ...
������ application.properties
```

**����������**:
```java
@ImportResource({"classpath*:WEB-INF/dorado-home/application-context.xml"})
```

#### ������������file:ģʽ����С�Ķ���

**���ó���**�����ؿ������������������

**����������**:
```java
@ImportResource({
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
```

**����**�������WAR�����ⲿTomcatʱ������Ŀ¼������Ŀ��Ŀ¼��·������ʧЧ��

#### ��������˫·�����ݣ��Ƽ���

**ԭ��**��ͬʱ����classpath��file·����ȷ�����ؿ����ʹ������������������

**����������**:
```java
@ImportResource({
    "classpath*:WEB-INF/dorado-home/application-context.xml",
    "file:src/main/webapp/WEB-INF/dorado-home/application-context.xml"
})
```

**˵��**��Spring�ᰴ˳����أ����classpath�д������classpath���أ������file·�����ء�

### 12.3 XML�����ļ�������ϵͼ

```
application-context.xml (���)
������ import �� datahub_server.spring.xml
������ import �� marshaller.xml
������ import �� datasource.spring.xml
������ import �� solr.spring.xml
������ import �� schedule-context.xml
������ import �� webservice.spring.xml
��   ������ import �� cxf-servlet.xml (classpath)
������ import �� servlet-context.xml
������ import �� callcenter-config.xml
������ import �� context-cache.spring.xml
������ import �� pcipe-context.xml (classpath, ����fndsoft JAR)
������ import �� activiti-context.xml (classpath, ����fndsoft JAR)
������ import �� workflow-context.xml
������ import �� common-context.xml (classpath, ����dorado JAR)
```

**�ؼ���**��
- `application-context.xml`�е����·��import�����������Ŀ¼����
- `classpath*:pcipe-context.xml`��`classpath*:activiti-context.xml`��fndsoft����JAR����
- `classpath:com/bstek/dorado/idesupport/common-context.xml`��dorado����JAR����

### 12.4 ��XML�ļ���������

| �����ļ� | �Ƿ���Ҫ���Ƶ�classpath | �Ƿ���Ҫ�޸� | ˵�� |
|----------|------------------------|-------------|------|
| `application-context.xml` | **��** | �� | ����ļ�������ɴ�classpath���� |
| `datasource.spring.xml` | **��** | �� | ���������Զ�import |
| `context-cache.spring.xml` | **��** | **��** | Redis���ӹ���������2.x |
| `context-rabbitmq.spring.xml` | **��** | **��** | Publisher Confirm������� |
| `schedule-context.xml` | **��** | �� | ��ȫ���� |
| `servlet-context.xml` | **��** | �� | ��ȫ���� |
| `webservice.spring.xml` | **��** | �� | ��ȫ���� |
| `workflow-context.xml` | **��** | �� | ��ȫ���� |
| `callcenter-config.xml` | **��** | �� | ��ȫ���� |
| `datahub_server.spring.xml` | **��** | �� | ��ȫ���� |
| `marshaller.xml` | **��** | �� | ��ȫ���� |
| `solr.spring.xml` | **��** | �� | ��ȫ���� |

### 12.5 webappĿ¼���սṹ����

#### ����ԭ�ṹ���Ƽ���

```
src/main/webapp/
������ *.html                           # ������HTMLҳ��
������ *.jsp                            # ������JSPҳ��
������ img/                             # ������ͼƬ��Դ
������ WEB-INF/
    ������ web.xml                      # ������Web������
    ������ weblogic.xml                 # ������WebLogic����
    ������ dorado-home/                 # ������Dorado����Ŀ¼
        ������ application-context.xml  # ��������Maven���Ƶ�classpath��
        ������ datasource.spring.xml    # ����
        ������ context-cache.spring.xml # ���������޸ģ�
        ������ context-rabbitmq.spring.xml # ���������޸ģ�
        ������ schedule-context.xml     # ����
        ������ servlet-context.xml      # ����
        ������ webservice.spring.xml    # ����
        ������ workflow-context.xml     # ����
        ������ configure.properties     # ������Dorado����
        ������ resources/               # ������Dorado���ʻ��ļ�������Ǩ�ƣ�
        ��   ������ Customer.zh_CN.properties
        ��   ������ Person.zh_CN.properties
        ��   ������ ...����20���ļ���
        ������ ...
```

### 12.6 application.properties����

**�ļ�λ��**: `src/main/resources/application.properties`

**��������**:
```properties
# ========================
# Spring Boot Server Config
# ========================
server.port=8080
server.servlet.context-path=/
server.servlet.session.timeout=30m
server.servlet.session.cookie.name=FMSSESSIONID

# Tomcat����
server.tomcat.max-threads=200
server.tomcat.min-spare-threads=10
server.tomcat.max-connections=8192
server.tomcat.accept-count=100
server.tomcat.uri-encoding=UTF-8

# ========================
# Bean Configuration
# ========================
# ����Bean���帲�ǣ�����XML�е�ͬ��Bean��
spring.main.allow-bean-definition-overriding=true
# ����ѭ�����ã����ݾɰ�XML���ã�
spring.main.allow-circular-references=true

# ========================
# ��̬��Դ����
# ========================
spring.web.resources.static-locations=classpath:/static/,file:src/main/webapp/

# ========================
# Actuator Config
# ========================
management.endpoints.web.exposure.include=health,info,metrics
management.endpoint.health.show-details=when-authorized

# ========================
# �ų��Զ����ã�ʹ���Զ������ã�
# ========================
spring.autoconfigure.exclude=\
    org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration,\
    org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration,\
    org.springframework.boot.autoconfigure.data.redis.RedisAutoConfiguration,\
    org.springframework.boot.autoconfigure.amqp.RabbitAutoConfiguration
```

### 12.7 ��������������

**�ļ�λ��**: `src/main/java/com/FmsApplication.java`

```java
package com;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;
import org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.ImportResource;

/**
 * FMSӦ��������
 */
@SpringBootApplication(exclude = {
    DataSourceAutoConfiguration.class,
    HibernateJpaAutoConfiguration.class
})
@ImportResource({
    "classpath*:WEB-INF/dorado-home/application-context.xml"
})
@ComponentScan(basePackages = {"com.cpic.fms", "com.fndsoft"})
@Configuration
public class FmsApplication extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
        return builder.sources(FmsApplication.class);
    }

    public static void main(String[] args) {
        SpringApplication.run(FmsApplication.class, args);
    }
}
```

### 12.8 static��̬��Դ����

**Ǩ�Ʒ���**����ǰ��JS/CSS�ļ���webapp�ƶ���resources/static

```
src/main/resources/
������ application.properties
������ static/
    ������ js/
    ��   ������ jquery-3.7.1.js
    ��   ������ jquery.easyui.min.js
    ��   ������ sensors.js
    ��   ������ ...
    ������ css/
    ��   ������ login.css
    ������ img/
        ������ ...
```

**˵��**����̬��ԴǨ�ƺ�HTML/JSP�е�·����Ҫ��Ӧ������

### 12.9 Dorado Resources���ʻ��ļ�����

#### 12.9.1 �ļ�����

`dorado-home/resources/`Ŀ¼�µ��ļ���**Dorado�������ģ�͹��ʻ��ļ�**������Spring��MessageSource�ļ���

```
dorado-home/resources/
������ Customer.zh_CN.properties    # �ͻ�ʵ���ֶ�����
������ Person.zh_CN.properties      # ��Աʵ���ֶ�����
������ Organization.zh_CN.properties # ��֯ʵ���ֶ�����
������ ...����20���ļ���
```

#### 12.9.2 �ļ�����ʾ��

```properties
# Customer.zh_CN.properties
orgCode=\u673A\u6783\u4EE3\u7801        # ��������
orgName=\u673A\u6783\u540D\u79F0        # ��������
customerCode=\u5BA2\u6237\u7F16\u7801    # �ͻ�����
customerName=\u5BA2\u6237\u540D\u79F0    # �ͻ�����
```

#### 12.9.3 �������ԣ�����ԭλ������Ǩ��

| ԭ�� | ˵�� |
|------|------|
| Dorado����Զ����� | ��DoradoServlet��ʼ��ʱɨ����� |
| ������Spring | ��ͨ��Spring��ResourceBundleMessageSource���� |
| ����Ŀ¼�ṹ | Dorado����`dorado-home`���·��ɨ�� |
| ��Ķ����� | �����κδ�������ñ�� |

#### 12.9.4 ��֤����

���������Dorado Viewҳ�棬��飺
- Grid��ͷ�Ƿ���ʾ�����ֶ���
- ������ǩ�Ƿ���ʾ��������

### 12.9 ���������Ų�

| ���� | ֢״ | ������� |
|------|------|----------|
| FileNotFoundException | ����ʱ���ļ��Ҳ��� | ��鹤��Ŀ¼�����classpath������Maven Profiles�Ƿ񼤻� |
| BeanDefinitionOverrideException | ����ʱ��Bean�ظ� | ����`spring.main.allow-bean-definition-overriding=true` |
| Circular reference detected | ����ʱ��ѭ������ | ����`spring.main.allow-circular-references=true` |
| ClassNotFoundException | ����ʱ�����Ҳ��� | ���Maven��Դ�������� |

### 12.10 Maven Profiles�໷�����ã�v1.7������

#### 12.10.1 ���ⱳ��

`application-context.xml` �� `DecryptPropertyPlaceholderConfigurer` �� classpath ���������ļ���

```xml
<property name="locations">
    <list>
        <value>classpath:application-context.properties</value>
        <value>classpath:redis.properties</value>
        <value>classpath:ESAPI.properties</value>
        <value>classpath:validation.properties</value>
    </list>
</property>
```

����Щ�ļ�λ�� `ServerConfiguration/profiles/FMS_PRD_DEV/` Ŀ¼������ `src/main/resources/` �У���������ʱ����
```
FileNotFoundException: class path resource [application-context.properties] cannot be opened because it does not exist
```

#### 12.10.2 �������

�� `pom.xml` ������ Maven Profiles��������������Ŀ¼��Ϊ������ԴĿ¼��

```xml
<profiles>
    <profile>
        <id>FMS_PRD_DEV</id>
        <activation>
            <activeByDefault>true</activeByDefault>
        </activation>
        <build>
            <resources>
                <resource>
                    <directory>ServerConfiguration/profiles/FMS_PRD_DEV</directory>
                    <includes>
                        <include>*.properties</include>
                        <include>*.xml</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </profile>
    <profile>
        <id>FMS_PRD_PRO</id>
        <build>
            <resources>
                <resource>
                    <directory>ServerConfiguration/profiles/FMS_PRD_PRO</directory>
                    <includes>
                        <include>*.properties</include>
                        <include>*.xml</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </profile>
    <profile>
        <id>FMS_PRD_LOCAL</id>
        <build>
            <resources>
                <resource>
                    <directory>ServerConfiguration/profiles/FMS_PRD_LOCAL</directory>
                    <includes>
                        <include>*.properties</include>
                        <include>*.xml</include>
                    </includes>
                </resource>
            </resources>
        </build>
    </profile>
</profiles>
```

#### 12.10.3 �����������ļ��ֲ�

| �ļ� | FMS_PRD_DEV | FMS_PRD_PRO | FMS_PRD_LOCAL | ������λ�� |
|------|:-----------:|:-----------:|:-------------:|-----------|
| `application-context.properties` | ? | ? | ? | `application-context.xml` |
| `redis.properties` | ? | ? | ? | `application-context.xml` |
| `jdbc.properties` | ? | ? | ? | `datasource.spring.xml` ���ʹ�� |
| `ESAPI.properties` | ?�������� | ? | ? | `application-context.xml` |
| `validation.properties` | ?�������� | ? | ? | `application-context.xml` |
| `components.properties` | ? | - | - | fndsoft JAR ���� |
| `schedule.properties` | ? | - | - | `schedule-context.xml` |
| `logback.xml` | ? | ? | ? | ��־��� |

> **ע��**��`ESAPI.properties` �� `validation.properties` �� DEV ����ԭ�����ڣ��Ѳ�����ռλ�ļ���

#### 12.10.4 IDEA ���ò���

1. Maven ���ߴ��� �� **Profiles** �� ��ѡ `FMS_PRD_DEV`
2. ���� **Run Configuration** �� **Active Maven Profiles** ���� `FMS_PRD_DEV`
3. **Reimport Maven Project**

#### 12.10.5 �������֤

ִ�� `mvn compile` ���� `target/classes/` Ŀ¼��

```
target/classes/
������ application-context.properties  �� Ӧ����
������ redis.properties                �� Ӧ����
������ jdbc.properties                 �� Ӧ����
������ ESAPI.properties                �� Ӧ����
������ validation.properties           �� Ӧ����
������ components.properties           �� Ӧ����
������ logback.xml                     �� Ӧ����
������ application.properties          �� Spring Boot����
������ dorado-home/                    �� XML�����ļ�
������ static/                         �� ǰ�˾�̬��Դ
```

### 12.11 logback.xml �����޸���v1.8������

#### 12.11.1 ���ⱳ��

Maven Profiles �� `ServerConfiguration/profiles/FMS_PRD_DEV/logback.xml` ���Ƶ� classpath ��Logback ��⵽���ô��󲢾ܾ�������

```
Logback configuration error detected:
ERROR - no applicable action for [filter], current ElementPath is [[configuration][appender][rollingPolicy][filter]]
ERROR - no applicable action for [level], current ElementPath is [[configuration][appender][rollingPolicy][filter][level]]
ERROR - 'FileNamePattern' option has the same value as that given for appender [FILE] defined earlier.
ERROR - Collisions detected with FileAppender/RollingAppender instances defined earlier. Aborting.
```

#### 12.11.2 ����ԭ��

**����һ��filter Ԫ�طŴ�λ��**

appender `FILE` �� `<filter>` ��Ƕ���� `<rollingPolicy>` �ڲ���Logback Ҫ�� `<filter>` ������ `<appender>` ��ֱ����Ԫ�أ�

```xml
<!-- ����д�� -->
<appender name="FILE">
    <rollingPolicy>
        <filter>          <!-- ? filter���ܷ���rollingPolicy�� -->
            <level>INFO</level>
        </filter>
        <fileNamePattern>...</fileNamePattern>
    </rollingPolicy>
</appender>

<!-- ��ȷд�� -->
<appender name="FILE">
    <filter>              <!-- ? filter��appender��ֱ����Ԫ�� -->
        <level>INFO</level>
    </filter>
    <rollingPolicy>
        <fileNamePattern>...</fileNamePattern>
    </rollingPolicy>
</appender>
```

**����������� appender �� FileNamePattern ��ȫ��ͬ**

- Appender `FILE`��`/applog/cxnxhxlog/fms.%d{yyyy-MM-dd}.log`
- Appender `logfile`��`/applog/cxnxhxlog/fms.%d{yyyy-MM-dd}.log`

���� `RollingFileAppender` д��ͬһ����־�ļ��������ļ�����ͻ��

#### 12.11.3 �޸�����

| �޸ĵ� | �޸�ǰ | �޸ĺ� |
|--------|--------|--------|
| `FILE` �� filter λ�� | `<rollingPolicy>` �ڲ� | �Ƶ� `<appender>` ֱ���Ӽ� |
| `FILE` �� FileNamePattern | `fms.%d{yyyy-MM-dd}.log` | `fms-file.%d{yyyy-MM-dd}.log` |

**�޸������� logback.xml**��

```xml
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
    <contextName>fms</contextName>

    <appender name="STDOUT" class="ch.qos.logback.core.ConsoleAppender">
        <encoder>
            <pattern>FMS:%d - %5p %m%n</pattern>
        </encoder>
    </appender>

    <appender name="FILE" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>INFO</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <fileNamePattern>/applog/cxnxhxlog/fms-file.%d{yyyy-MM-dd}.log</fileNamePattern>
            <maxHistory>15</maxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>FMS:%d - %5p %m%n</pattern>
        </encoder>
    </appender>

    <appender name="logfile" class="ch.qos.logback.core.rolling.RollingFileAppender">
        <filter class="ch.qos.logback.classic.filter.ThresholdFilter">
            <level>INFO</level>
        </filter>
        <rollingPolicy class="ch.qos.logback.core.rolling.TimeBasedRollingPolicy">
            <FileNamePattern>/applog/cxnxhxlog/fms.%d{yyyy-MM-dd}.log</FileNamePattern>
            <MaxHistory>15</MaxHistory>
        </rollingPolicy>
        <encoder>
            <pattern>FMS:%d - %5p %m%n</pattern>
        </encoder>
    </appender>

    <appender name="async" class="ch.qos.logback.classic.AsyncAppender">
        <discardingThreshold>80</discardingThreshold>
        <queueSize>512</queueSize>
        <appender-ref ref="logfile"/>
    </appender>

    <root level="INFO">
        <appender-ref ref="async"/>
        <appender-ref ref="STDOUT"/>
    </root>
</configuration>
```

#### 12.11.4 ����˵��

������**�� Spring Boot �����޹�**������Ŀ Tomcat ����ʱ `logback.xml` ���� classpath �ϣ�Logback δ���ظ��ļ���δ������Maven Profiles ���临�Ƶ� `target/classes/` ��ű���⵽��

### 12.12 application-context.xml ���� jdbc.properties ���أ�v1.9������

#### 12.12.1 ���ⱳ��

����ʱ������
```
Could not resolve placeholder 'jdbc.driverClass' in value "${jdbc.driverClass}"
```

`datasource.spring.xml` ��ʹ���� `${jdbc.*}` ռλ����
```xml
<property name="driverClassName" value="${jdbc.driverClass}" />
<property name="url" value="${jdbc.url}" />
<property name="username" value="${jdbc.username}" />
<property name="password" value="${jdbc.password}" />
```

#### 12.12.2 ����

`application-context.xml` �� `DecryptPropertyPlaceholderConfigurer` �� locations �б�**ȱ�� `jdbc.properties`**��

```xml
<!-- �޸�ǰ��ֻ����4���ļ�������jdbc.properties -->
<property name="locations">
    <list>
        <value>classpath:application-context.properties</value>
        <value>classpath:redis.properties</value>
        <value>classpath>ESAPI.properties</value>
        <value>classpath:validation.properties</value>
    </list>
</property>
```

`jdbc.properties` ��Ȼ�ѱ� Maven Profiles ���Ƶ� `target/classes/`����δ���κ� PropertyPlaceholderConfigurer ���أ����� `${jdbc.*}` ռλ���޷�������

#### 12.12.3 �޸�����

**�޸��ļ�**��`src/main/webapp/WEB-INF/dorado-home/application-context.xml` ��29-36��

```xml
<!-- �޸ĺ����� classpath:jdbc.properties -->
<property name="locations">
    <list>
        <value>classpath:application-context.properties</value>
        <value>classpath:jdbc.properties</value>
        <value>classpath:redis.properties</value>
        <value>classpath:ESAPI.properties</value>
        <value>classpath:validation.properties</value>
    </list>
</property>
```

#### 12.12.4 ��ǰ�����ļ������嵥

| �ļ� | ����˳�� | �ṩ������ | ������λ�� |
|------|---------|-----------|-----------|
| `application-context.properties` | 1 | `system=DEVELOP` | ȫ�ֻ�����ʶ |
| `jdbc.properties` | 2 | `jdbc.driverClass`, `jdbc.url`, `jdbc.username`, `jdbc.password` �� | `datasource.spring.xml` |
| `redis.properties` | 3 | `redis.host`, `redis.port`, `redis.pass` �� | `context-cache.spring.xml` |
| `ESAPI.properties` | 4 | ESAPI��ȫ������� | ESAPI��� |
| `validation.properties` | 5 | ESAPIУ�������� | ESAPIУ���� |

> **ע��**��v1.10 �д��嵥�Ѹ��£����� `components.properties`����� 12.13 �ڡ�

### 12.13 ���� components.properties ���� & redis �����޸���v1.10������

#### 12.13.1 ���ⱳ��

����ʱ������
```
Could not resolve placeholder 'richdata.url' in value "${richdata.url}"
```

`solr.spring.xml` ��������3������ `components.properties` �����ԣ�
```xml
<property name="richDataURL"><value>${richdata.url}</value></property>
<property name="richFileURL"><value>${richfile.url}</value></property>
<property name="pinyinURL"><value>${pinyin.url}</value></property>
```

�� `components.properties` δ�� `DecryptPropertyPlaceholderConfigurer` ���ء�

#### 12.13.2 �޸�����

**�޸�1��application-context.xml ������� components.properties**

```xml
<!-- �޸ĺ�locations �б���5�����ӵ�6�� -->
<property name="locations">
    <list>
        <value>classpath:application-context.properties</value>
        <value>classpath:jdbc.properties</value>
        <value>classpath:components.properties</value>    <!-- ���� -->
        <value>classpath:redis.properties</value>
        <value>classpath:ESAPI.properties</value>
        <value>classpath:validation.properties</value>
    </list>
</property>
```

**�޸�2��context-cache.spring.xml �޸� redis.password ������ƥ��**

`context-cache.spring.xml:256` �� `${redis.password}` �� `redis.properties` ��ʵ�ʼ���Ϊ `redis.pass`��

| �޸�λ�� | �޸�ǰ | �޸ĺ� |
|----------|--------|--------|
| `context-cache.spring.xml:256` | `${redis.password}` | `${redis.pass}` |

#### 12.13.3 ��ǰ���������ļ������嵥

| ˳�� | �ļ� | �ṩ������ | ������λ�� |
|------|------|-----------|-----------|
| 1 | `application-context.properties` | `system=DEVELOP` | ȫ�ֻ�����ʶ |
| 2 | `jdbc.properties` | `jdbc.driverClass`, `jdbc.url`, `jdbc.username`, `jdbc.password` �� | `datasource.spring.xml` |
| 3 | `components.properties` | `richdata.url`, `richfile.url`, `pinyin.url` | `solr.spring.xml` |
| 4 | `redis.properties` | `redis.host`, `redis.port`, `redis.pass` �� | `context-cache.spring.xml` |
| 5 | `ESAPI.properties` | ESAPI��ȫ������� | ESAPI��� |
| 6 | `validation.properties` | ESAPIУ�������� | ESAPIУ���� |

### 12.14 �޸�Dorado����Contextδ���ص���Beanȱʧ��v1.11������

#### 12.14.1 ���ⱳ��

����ʱ������
```
No bean named 'dorado.globalResourceSearchPathRegister' available
```

`solr.spring.xml` ��23�������� parent bean��
```xml
<bean parent="dorado.globalResourceSearchPathRegister">
    <property name="searchPath" value="home:resources/"/>
</bean>
```

#### 12.14.2 �������

**Dorado��ܵ�Context������·**����ͳSpring MVC���𣩣�

1. `DoradoServlet` / `SpringContextLoaderListener` ��ʼ��
2. ���� `com/bstek/dorado/core/context.xml`������ `dorado.globalResourceSearchPathRegister` �Ⱥ��� bean��
3. ���� `com/bstek/dorado/data/context.xml`��`view/context.xml`��`web/context.xml` ��
4. ���� `com/bstek/dorado/idesupport/common-context.xml`
5. ���ż���Ӧ�õ� `application-context.xml`

**Spring Boot ����Ķ���**��

1. `FmsApplication` ͨ�� `@ImportResource` ���� `application-context.xml`
2. `application-context.xml:22` ���� `classpath:com/bstek/dorado/idesupport/common-context.xml`
3. **�� `core/context.xml` ��δ������** �� `dorado.globalResourceSearchPathRegister` �Ⱥ��� bean ������

**����bean����λ��**��`dorado-core-7.4.1.0109.jar` �ڣ���
```xml
<!-- com/bstek/dorado/core/context.xml -->
<bean id="dorado.globalResourceBundleManager"
    class="com.bstek.dorado.core.resource.DefaultGlobalResourceBundleManager">
    <property name="cache" ref="dorado.globalResourceCache" />
</bean>
<bean id="dorado.globalResourceSearchPathRegister" abstract="true"
    class="com.bstek.dorado.core.resource.GlobalResourceSearchPathRegister">
    <property name="globalResourceBundleManager" ref="dorado.globalResourceBundleManager" />
</bean>
```

#### 12.14.3 �޸�����

**�޸��ļ�**��`src/main/java/com/FmsApplication.java`

**�Ķ�ǰ**��
```java
@ImportResource({
        "classpath*:WEB-INF/dorado-home/application-context.xml"
})
```

**�Ķ���**��
```java
@ImportResource({
        "classpath:com/bstek/dorado/core/context.xml",
        "classpath*:WEB-INF/dorado-home/application-context.xml"
})
```

**�޸�ԭ��**���ڼ���Ӧ�� XML ����֮ǰ���ȼ��� Dorado ���� Context��ʹ `dorado.globalResourceSearchPathRegister`��`dorado.xmlDocumentBuilder`��`dorado.globalResourceBundleManager` �Ⱥ��� bean ��ע�ᵽ Spring �����С�

#### 12.14.4 Dorado����Context�ļ��嵥

| �ļ� | ��Դ | ����ĺ���Bean |
|------|------|---------------|
| `com/bstek/dorado/core/context.xml` | `dorado-core-7.4.1.0109.jar` | `dorado.xmlDocumentBuilder`, `dorado.globalResourceBundleManager`, `dorado.globalResourceSearchPathRegister`(abstract), `dorado.scopeManager`, `dorado.beanFactoryRegistry` |
| `com/bstek/dorado/data/context.xml` | `dorado-core-7.4.1.0109.jar` | `dorado.dataTypeManager`, `dorado.dataProviderManager`, `dorado.dataResolverManager`, `dorado.dataConfigManager` |
| `com/bstek/dorado/view/context.xml` | `dorado-core-7.4.1.0109.jar` | `dorado.viewConfigManager`, `dorado.componentTypeRegistry`, `dorado.expressionHandler` |
| `com/bstek/dorado/web/context.xml` | `dorado-core-7.4.1.0109.jar` | `dorado.scopeManager`(web), `dorado.controllerResolver`, `dorado.resourceTypeManager` |
| `com/bstek/dorado/idesupport/common-context.xml` | `dorado-core-7.4.1.0109.jar` | `dorado.idesupport.ruleTemplateParser`, `dorado.idesupport.ruleSetBuilder` |

> **ע��**��`application-context.xml:22` ��ͨ�� `<import resource="classpath:com/bstek/dorado/idesupport/common-context.xml"/>` ������ idesupport context�������ļ�**������** `core/context.xml`�������Ҫ�� `@ImportResource` ����ʽ���ء�

#### 12.14.5 ��֤

�޸�������������`dorado.globalResourceSearchPathRegister` bean ����������`solr.spring.xml` �е� parent bean ���ý����ɹ���

---

### 12.15 �޸�ѭ������������allow-circular-references��v1.12������

#### 12.15.1 ���ⱳ��

����ʱ������
```
The dependencies of some of the beans in the application context form a cycle:

caclApportionmentRuleServlet �� calcApportionmentRuleService �� ruleCacheDaoImpl �� ruleManageBlhImpl
  �� WFRuntimeService �� activitiRuntimeServiceAdapter �� activitiExtendService
    �� WFTaskService �� activitiTaskServiceAdapter �� activitiExtendService (CIRCLE)
```

Spring Boot 2.6+ Ĭ�Ͻ�ֹѭ�����ã�`spring.main.allow-circular-references` Ĭ��Ϊ `false`�������ɰ� Spring Framework 5.2 ������

#### 12.15.2 �������

ѭ������������ fndsoft �����������ڲ���

```
activitiExtendService (@Component, com.fndsoft.workflow.activiti.extend.impl)
    �� �ֶ�ע�� wfTaskService
WFTaskService (workflow-context.xml:30, class TaskServiceImpl)
    �� ����ע�� taskServiceAdapter
activitiTaskServiceAdapter (@Component, com.fndsoft.workflow.engine.impl)
    �� �ֶ�ע�� activitiExtendService
activitiExtendService �� �ص����
```

���� fndsoft �������������ʷ��ƣ�`activitiExtendService` �� `WFTaskService` ͨ�����Ե�����������������

#### 12.15.3 �޸�����

**�޸��ļ�**��`src/main/resources/application.properties`

**��������**��
```properties
# ����ѭ�����ã�����fndsoft������������ʷ��ƣ�activitiExtendService?WFTaskService����������
spring.main.allow-circular-references=true
```

**����ѡ��**��
- **����A�����ã�**����������ѭ�����ã����Ķ��������
- **����B����ѡ��**���� `@Lazy` ע�����ѭ������Ķ� fndsoft ������������룬���ո�

---

### 12.16 �޸�RedisCacheConfiguration���ɱ�������ע�뱨����v1.13������

#### 12.16.1 ���ⱳ��

����ʱ������
```
Invalid property 'entryTtl' of bean class [org.springframework.data.redis.cache.RedisCacheConfiguration]:
Bean property 'entryTtl' is not writable or has an invalid setter method.
```

#### 12.16.2 ����

`RedisCacheConfiguration` ��**���ɱ���**��Immutable���������ֶ�Ϊ `private final`��������Ϊ `private`������ͨ�� builder ģʽ�������ã�ÿ������������ʵ����
- `entryTtl(Duration)` �� ������ʵ��
- `disableCachingNullValues()` �� �޲Σ�������ʵ��
- `serializeKeysWith(SerializationPair)` �� ������ʵ��
- `serializeValuesWith(SerializationPair)` �� ������ʵ��

**û���κ� setter ����**��Spring XML �� `<property>` ��ǩ�޷�ʹ�á�

#### 12.16.3 �޸�����

**�½��ļ�**��`src/main/java/com/cpic/fms/common/cache/redis/RedisCacheConfigurationFactory.java`

```java
package com.cpic.fms.common.cache.redis;

import java.time.Duration;
import org.springframework.beans.factory.FactoryBean;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.serializer.RedisSerializationContext;
import org.springframework.data.redis.serializer.StringRedisSerializer;

public class RedisCacheConfigurationFactory implements FactoryBean<RedisCacheConfiguration> {
    private Duration entryTtl = Duration.ofHours(36);
    private boolean disableCachingNullValues = true;

    public void setEntryTtl(Duration entryTtl) { this.entryTtl = entryTtl; }
    public void setDisableCachingNullValues(boolean v) { this.disableCachingNullValues = v; }

    @Override
    public RedisCacheConfiguration getObject() throws Exception {
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

**�޸��ļ�**��`context-cache.spring.xml:396-416`

```xml
<!-- �Ķ�ǰ -->
<bean id="redisCacheConfiguration" class="...RedisCacheConfiguration"
      factory-method="defaultCacheConfig">
    <property name="entryTtl" value="PT36H"/>
    <property name="disableCachingNullValues" value="true"/>
    <property name="serializeKeysWith">...</property>
    <property name="serializeValuesWith">...</property>
</bean>

<!-- �Ķ��� -->
<bean id="redisCacheConfiguration" class="...RedisCacheConfigurationFactory">
    <property name="entryTtl" value="PT36H"/>
    <property name="disableCachingNullValues" value="true"/>
</bean>
```

> **ע��**��`disableCachingNullValues()` ���޲� builder ���������� setter����FactoryBean ��ͨ�� `if` �жϵ��á�

---

### 12.17 �޸�dataTypeViewռλ���޷�������v1.14������

#### 12.17.1 ���ⱳ��

����ʱ������
```
Could not resolve placeholder 'dataTypeView' in value "${dataTypeView}"
```

`productController`������ `fndsoft-pcipe-1.0-SNAPSHOT.jar`���� `dataTypeView` �ֶ�ʹ�� `@Value("${dataTypeView}")` ע�롣

#### 12.17.2 ����

`${dataTypeView}` ������ `dorado-home/configure.properties:9`��

**��ͳ Spring MVC ������·**��
1. `DoradoServlet` ��ʼ�� �� ���� `configure.properties` �� `Configure.getStore()`
2. `ConfigureProperiesConfigurer`��`core/context.xml` �ж��壩��ȡ store ע������
3. Spring �ܽ��� `${dataTypeView}`

**Spring Boot ����**��
1. `ConfigureProperiesConfigurer` �Ѽ��أ�`core/context.xml` �� `@ImportResource` �У�
2. �� `Configure.getStore()` Ϊ�� �� Dorado `DoradoLoader` δ��ʼ��
3. `configure.properties` δ���κ� PropertyPlaceholderConfigurer ����

#### 12.17.3 �޸�����

**�޸��ļ�**��`application-context.xml` �� `DecryptPropertyPlaceholderConfigurer` locations

```xml
<!-- ���� -->
<value>classpath:WEB-INF/dorado-home/configure.properties</value>
```

> **ע��**��`configure.properties` �� `dorado-home/` Ŀ¼�£�Maven ��Դ���ƺ�λ�� `target/classes/WEB-INF/dorado-home/configure.properties`�����·��Ϊ `classpath:WEB-INF/dorado-home/configure.properties`������ `classpath:configure.properties`��

---

### 12.18 ����Doradoȫ��Context���أ�v1.15~v1.17��

#### 12.18.1 ���ⱳ��

v1.11 ֻ������ `core/context.xml`�����¶�� Dorado Bean ȱʧ��
- v1.15��`DataTypeDefinitionManager` ȱʧ �� ���� `data/context.xml`
- v1.16��`dorado.dispatchableXmlParser` ȱʧ �� ���� `config/context.xml`
- v1.17��`dorado.exposedServiceRegister` ȱʧ �� ���� `common/context.xml`

#### 12.18.2 Dorado Context������

```
core/context.xml
  ���� ����: dorado.xmlDocumentBuilder, dorado.globalResourceBundleManager, dorado.expressionHandler ��

common/context.xml
  ���� ����: dorado.exposedServiceManager, dorado.exposedServiceRegister, dorado.exposedServiceAnnotationBeanPostProcessor

config/context.xml
  ���� import �� config/text-parser-context.xml
  ���� import �� config/xml-parser-context.xml
       ���� ����: dorado.dispatchableXmlParser (���� dorado.expressionHandler)

data/context.xml
  ���� import �� data/xml-parser-context.xml
  ��    ���� ���� parent: dorado.dispatchableXmlParser (���� config)
  ���� ����: dorado.dataTypeDefinitionManager, dorado.dataProviderManager ��

view/context.xml
  ���� import �� view/parser-context.xml
  ��    ���� ���� parent: dorado.dispatchableXmlParser (���� config)
  ���� ����: dorado.viewConfigManager, dorado.componentTypeRegistry ��
  ���� ����: dorado.exposedServiceRegister (���� common)

web/context.xml
  ���� ����: dorado.scopeManager(web), dorado.controllerResolver ��
```

#### 12.18.3 ���� @ImportResource ����

**�޸��ļ�**��`FmsApplication.java`

```java
@ImportResource({
    "classpath:com/bstek/dorado/core/context.xml",       // 1. ��������
    "classpath:com/bstek/dorado/common/context.xml",      // 2. ��������exposedServiceRegister��
    "classpath:com/bstek/dorado/config/context.xml",      // 3. XML��������dispatchableXmlParser��
    "classpath:com/bstek/dorado/data/context.xml",        // 4. ���ݲ㣨����config��
    "classpath:com/bstek/dorado/view/context.xml",        // 5. ��ͼ�㣨����config+common��
    "classpath:com/bstek/dorado/web/context.xml",         // 6. Web��
    "classpath*:WEB-INF/dorado-home/application-context.xml"  // 7. Ӧ������
})
```

#### 12.18.4 ����˳����Ҫ��

| ˳�� | Context | ԭ�� |
|------|---------|------|
| 1 | core | �������bean��expressionHandler�ȣ�������������Context���� |
| 2 | common | ����exposedServiceRegister����view���� |
| 3 | config | ����dispatchableXmlParser����data��view���� |
| 4 | data | �������ݲ�bean������core��config |
| 5 | view | ������ͼ��bean������core��config��common |
| 6 | web | ����Web��bean������core |
| 7 | application-context | Ӧ�����ã���������Dorado bean |

### 12.19 �޸�Dorado Context���׻���δ��ʼ������DataOutputter��̬��ʼ��NPE��v1.18������

#### 12.19.1 ���ⱳ��

����ʱ������
```
Error creating bean with name 'dorado.dataOutputter' defined in class path resource [com/bstek/dorado/view/outputter-context.xml]: Instantiation of bean failed; nested exception is java.lang.ExceptionInInitializerError
Caused by: java.lang.RuntimeException: java.lang.NullPointerException
  at com.bstek.dorado.core.resource.ResourceManagerUtils.get(ResourceManagerUtils.java:29)
  at com.bstek.dorado.core.resource.ResourceManagerUtils.get(ResourceManagerUtils.java:34)
  at com.bstek.dorado.view.output.DataOutputter.<clinit>(DataOutputter.java:54)
```

#### 12.19.2 ����

`DataOutputter` �ľ�̬��ʼ��������� `ResourceManagerUtils.get()`���÷����ȵ��� `Context.getCurrent()`��

**`Context.getCurrent()` ��ʵ��**��
```java
public static Context getCurrent() {
    Context ctx = (threadLocal != null) ? threadLocal.get() : null;
    return (ctx != null) ? ctx : failSafeContext;
}
```

�Ȳ� ThreadLocal���ٲ� `failSafeContext` ��̬�ֶΡ����߶�Ϊ��ʱ���� null �� NPE��

**��ͳ Spring MVC ��·**��
1. `SpringContextLoaderListener.customizeContext()` ���� `DoradoLoader.preload(servletContext, true)`
2. `preload()` �ڲ���`DoradoContext.init(servletContext, false)` �� `Context.setFailSafeContext(context)`
3. `failSafeContext` ������ �� `Context.getCurrent()` ������ null
4. `getServiceBean("resourceManager")` �� �� ApplicationContext δ�������� `ApplicationContextNotInitException`
5. ���쳣�� `ResourceManagerUtils` ���񣬴��� `LazyInitResourceManager` ����

**Spring Boot ����**��
1. `DoradoLoader.preload()` **��δ������**���� servlet context listener��
2. `failSafeContext` = null
3. `Context.getCurrent()` ���� null �� NPE δ�� `ApplicationContextNotInitException` ���� �� �׳� `RuntimeException`

#### 12.19.3 �޸�����

**�޸��ļ�**��`FmsApplication.java`

**��������**��
```java
import com.bstek.dorado.core.Context;
import com.bstek.dorado.web.DoradoContext;
import org.springframework.boot.web.servlet.ServletContextInitializer;
import org.springframework.context.annotation.Bean;

@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        DoradoContext doradoContext = DoradoContext.init(servletContext, false);
        Context.setFailSafeContext(doradoContext);
    };
}
```

**�޸�ԭ��**��
- `ServletContextInitializer` �� Spring Boot �� `onRefresh()` �׶�ִ�У�Ƕ��ʽ Tomcat ������
- �ý׶����� `finishBeanFactoryInitialization()`������ Bean ʵ������
- �ȴ��� `DoradoContext`��ע��Ϊ failSafeContext
- ���� `DataOutputter` �� Bean ��ʼ��ʱ��`Context.getCurrent()` ��ȡ�� failSafeContext
- `getServiceBean()` ��ʱ ApplicationContext �Ѿ������������� Bean

#### 12.19.4 ִ��ʱ��

| ���� | Spring Boot �׶� | �¼� |
|------|-----------------|------|
| 1 | `onRefresh()` | ����Ƕ��ʽ Tomcat |
| 2 | `onRefresh()` �� createWebServer() | **���� ServletContextInitializer** �� ���� failSafeContext |
| 3 | `finishBeanFactoryInitialization()` | ʵ�������е��� Bean���� `dorado.dataOutputter`�� |
| 4 | Bean ��ʼ�� | `DataOutputter.<clinit>` �� `ResourceManagerUtils.get()` �� `Context.getCurrent()` �� **�ҵ� failSafeContext** �� �������� |

---

### 12.20 �޸�Woodstox�汾��ͻNoSuchMethodError��v1.19�Դ�+v1.20���⣩

#### 12.20.1 ���ⱳ��

������ҳʱ������
```
java.lang.NoSuchMethodError: org.codehaus.stax2.XMLStreamWriter2.writeLong(J)V
  at com.fasterxml.jackson.dataformat.xml.ser.ToXmlGenerator.writeNumber(ToXmlGenerator.java:1105)
```

#### 12.20.2 ����

classpath �ϴ��� **3 �� Woodstox �汾** ��ͻ��

| Woodstox �汾 | �������� | �� writeLong()? |
|--------------|---------|:---:|
| `woodstox-core:6.4.0` | `jackson-dataformat-xml:2.13.5`����Ŀ��ʽ������ | ? |
| `woodstox-core-asl:4.4.1` | `cxf-core:3.1.4` �������� | ? |
| `wstx-asl:3.2.7` | `solr-solrj:4.5.0` �������� | ? |

`XMLStreamWriter2` �ӿ��ھɰ���û�� `writeLong()` �������ɰ� JAR �����ȼ��ء�

#### 12.20.3 v1.19�Դ����ų�jackson-dataformat-xml��

��һ�γ����ų� `spring-boot-starter-web` �� `jackson-dataformat-xml` ����������������Ŀ**��ʽ������** `jackson-dataformat-xml` ��������Ҫ XML ���л������ų���Ч���������ˡ�

#### 12.20.4 v1.20���⣨�ų��ɰ�Woodstox����������

**�޸��ļ�**��`pom.xml`

**�Ķ�1**��`cxf-core` �ų� `woodstox-core-asl`
```xml
<dependency>
    <groupId>org.apache.cxf</groupId>
    <artifactId>cxf-core</artifactId>
    <version>3.1.4</version>
    <exclusions>
        <exclusion>
            <groupId>org.codehaus.woodstox</groupId>
            <artifactId>woodstox-core-asl</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

**�Ķ�2**��`solr-solrj` �ų� `wstx-asl`
```xml
<dependency>
    <groupId>org.apache.solr</groupId>
    <artifactId>solr-solrj</artifactId>
    <version>4.5.0</version>
    <exclusions>
        <exclusion>
            <groupId>org.codehaus.woodstox</groupId>
            <artifactId>wstx-asl</artifactId>
        </exclusion>
    </exclusions>
</dependency>
```

**�޸�ԭ��**������ `jackson-dataformat-xml`����Ŀ��Ҫ����ֻ�ų��ɰ� Woodstox���� `woodstox-core:6.4.0` ��ΪΨһʵ�֡�CXF �� Solr ʹ�� JRE ���� StAX ���°� woodstox ����������

#### 12.20.5 ��֤���

```maven dependency:tree -Dincludes="*woodstox*,*stax2*,*jackson-dataformat-xml*"
[INFO] com.cpic:fms:war:1.0
[INFO] \- com.fasterxml.jackson.dataformat:jackson-dataformat-xml:jar:2.13.5:compile
[INFO]    +- org.codehaus.woodstox:stax2-api:jar:4.2.1:compile
[INFO]    \- com.fasterxml.woodstox:woodstox-core:jar:6.4.0:compile
```

�� `woodstox-core-asl:4.4.1` �� `wstx-asl:3.2.7`��������ͻ������������֤ͨ����

---

### 12.21 �޸���̬��Դ·����ƥ�䣨v1.21������

#### 12.21.1 ���ⱳ��

`logincommon.html` �����õ� JS �ļ�·��Ϊ���·�� `../resources/static/XXX.js`���� `/fms/logincommon.html` ����Ϊ `/resources/static/XXX.js`���� Spring Boot ��̬��Դӳ��·��Ϊ `/fms/**`��·����ƥ�䵼�¾�̬��Դ 404��

ҳ�������嵥��
```html
<link rel="stylesheet" type="text/css" href="login.css">       <!-- ? ���·����ͬ��Ŀ¼ -->
<script src="../resources/static/jquery-3.7.1.js"></script>    <!-- ? ·�������� context-path �ⲿ -->
<script src="../resources/static/jquery.easyui.min.js"></script>
<script src="../resources/static/jquery.form.js"></script>
<script src="../resources/static/md5.js"></script>
<script src="../resources/static/sha256.js"></script>
<script src="../resources/static/sensors.js"></script>
```

#### 12.21.2 ����

HTML �е� `../resources/static/` ·���Ǵ�ͳ����ʽ�µ�д����Spring Boot �� `classpath:/static/` Ĭ��ӳ���� context-path �£��� HTML ���·����ƥ�䡣

#### 12.21.3 �޸�����

**�޸��ļ�**��`FmsApplication.java` ����Ӧ `@Configuration` ��

**��������**��
```java
@Bean
public WebMvcConfigurer staticResourceConfigurer() {
    return new WebMvcConfigurer() {
        @Override
        public void addResourceHandlers(ResourceHandlerRegistry registry) {
            registry.addResourceHandler("/resources/static/**")
                    .addResourceLocations("classpath:/static/");
        }
    };
}
```

**�޸�ԭ��**������ `/resources/static/**` ·��ӳ�䵽 `classpath:/static/`��ʹ HTML �е� `../resources/static/XXX.js` ����ȷ������ JS �ļ��������޸� 400 �� HTML ���롣

---## 13. ��ʮ���׶Σ������������ø��죨��ϸ��

### 13.1 ����Ŀ��
���Spring Boot���������ú�XML���õ��롣

### 13.2 �Ķ��ļ�
- `src/main/java/com/FmsApplication.java`
- `src/main/resources/application.properties`
- `pom.xml`��Maven��Դ���ã�

### 13.3 Spring����������

#### 13.3.1 XML���õ��뷽ʽ�Ա�

| ��ʽ | ���� | ���ó��� | ��ȱ�� |
|------|------|----------|--------|
| Maven��Դ���� + classpath | `@ImportResource("classpath*:WEB-INF/dorado-home/...")` | �������� | �Ƽ���classpath���ؿɿ� |
| file·�� | `@ImportResource("file:src/main/webapp/...")` | ���ؿ��� | �򵥣��������·��ʧЧ |
| ˫·������ | ͬʱ����classpath��file | ���л��� | ��ɿ����������Զ� |

#### 13.3.2 �Ƽ����ã�classpathģʽ

```java
@ImportResource({"classpath*:WEB-INF/dorado-home/application-context.xml"})
```

���Maven��Դ���������12.2�����ã���

#### 13.3.2 ���ɨ������

��ǰ`application-context.xml`�������ã�
```xml
<context:component-scan base-package="com.cpic.fms, com.fndsoft"/>
```

**�Ķ���**�����������б�����ͬ���ã�
```java
@ComponentScan(basePackages = {"com.cpic.fms", "com.fndsoft"})
```

### 13.4 ���Լ�������

��ǰ��Ŀʹ���Զ���`DecryptPropertyPlaceholderConfigurer`���������ļ���

**�Ķ�����**��
1. ��������XML���÷�ʽ
2. ��`application.properties`������Bootԭ������

**���ַ�ʽ���棬����Ӱ��**��

---

## 14. ��ʮ���׶Σ�����JAR�����Դ���

### 14.1 ����Ŀ��
ȷ��23������JAR��Spring Boot 2.7.18������������

### 14.2 ����JAR�嵥

#### 14.2.1 ���͵�(Fndsoft)���

| JAR | �汾 | �����Է��� | ����� |
|-----|------|-----------|--------|
| fndsoft-commons | 2.0-SNAPSHOT | **��** | ������Spring�汾 |
| fndsoft-pcipe | 1.0-SNAPSHOT | **��** | ��Ʒ����ӿ� |
| fndsoft-uie | 1.0 | **��** | UI���� |
| fndsoft-ibcs | 2.4.RELEASE | **��** | ҵ����� |
| fndsoft-interfaceengine | 1.0 | **��** | �ӿ����� |
| fndsoft-solr-interface | 2.0.6 | **��** | Solr�ӿ� |
| fndsoft-workflow-engine | 0.3.6.RELEASE | **��** | ���������� |
| fndsoft-activiti-engine | 5.16.3.0.1.RELEASE | **��** | Activiti��װ |
| fndsoft-mybatis | 3.2.2 | **��** | MyBatis��װ |
| fndsoft-adex | 1.0-SNAPSHOT | **��** | AD��չ |

#### 14.2.2 Dorado 7���

| JAR | �汾 | �����Է��� | ����� |
|-----|------|-----------|--------|
| dorado7-dcore | 1.0 | **��** | Dorado���� |
| dorado-core | 7.4.1.0109 | **��** | ���Ŀ�� |
| dorado-ueditor | 0.3.4 | **��** | UEditor���� |
| dorado-uploader | 1.0.15 | **��** | �ϴ���� |
| dorado-chart | 0.4.5-BETA | **��** | ͼ����� |
| dorado-xchart | 0.5.0-BETA | **��** | XChartͼ�� |

#### 14.2.3 ��������

| JAR | �汾 | �����Է��� |
|-----|------|-----------|
| rule | 1.0 | **��** |

### 14.3 �����Բ��Է���

#### 14.3.1 ���Բ���

1. **�������**��ȷ�����б���JAR�����������±���ͨ��
2. **����ز���**������Ƿ�������ͻ���ظ�����
3. **���ܲ���**����һ��֤�������������
4. **���ɲ���**������ҵ�����̲���

#### 14.3.2 Ǳ�����⼰���

| ���� | ֢״ | ������� |
|------|------|----------|
| ��汾��ͻ | `NoSuchMethodError` | ʹ��Maven�������������Ų� |
| Spring�汾��ƥ�� | `ClassNotFoundException` | �ų��ɰ汾Spring���� |
| Bean�����ͻ | `BeanDefinitionOverrideException` | ����`spring.main.allow-bean-definition-overriding=true` |

### 14.4 Dorado 7ר���

#### 14.4.1 ��֪����������

Dorado 7��ר��RIA��ܣ����ܶ�Spring�汾���ض�Ҫ��

**����嵥**��
- [ ] `DoradoServlet`��ʼ���Ƿ�����
- [ ] `DelegatingFilterProxy`�Ƿ���������
- [ ] `dorado-home`�����ļ��Ƿ���ȷ����
- [ ] View�����Ƿ�����
- [ ] ���ݰ��Ƿ�����

#### 14.4.2 Ӧ������

���Dorado 7�����ݣ��ɿ��ǣ�
1. ��ϵDorado��Ӧ�̻�ȡ���ݰ汾
2. ʹ��`spring.main.allow-bean-definition-overriding=true`����Bean����
3. ��Dorado������ö�����������XML�ļ���

---

## 15. ��ʮ�Ľ׶Σ�����ʽ����

### 15.1 ����Ŀ��
֧��WAR�������ǶTomcat���ַ�ʽ��

### 15.2 �Ķ��ļ�
- `pom.xml`������ɣ�

### 15.3 �������

#### 15.3.1 spring-boot-maven-plugin����

**�Ķ�λ��**: `pom.xml`

**�Ķ�ǰ**:
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
</plugin>
```

**�Ķ���**:
```xml
<plugin>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-maven-plugin</artifactId>
    <configuration>
        <!-- �ų�����JAR�������ظ���� -->
        <excludeSystemScope>true</excludeSystemScope>
    </configuration>
</plugin>
```

#### 15.3.2 maven-war-plugin����

�����������ã�ȷ��WAR���������ɡ�

### 15.4 ����ʽѡ��

| ����ʽ | ���� | ���ó��� |
|----------|------|----------|
| ��ǶTomcat | `java -jar fms.jar` | ���ؿ��������������� |
| �ⲿTomcat | WAR������ | ��ͳ���������� |

---

## 16. ��ʮ��׶Σ�Profile �����ϲ���v1.22+������

> **��Ӧ�Ự**: 2026-06-20 �����Ի�  
> **���췶Χ**: Maven Profile �� Spring Boot Profile�������ļ��鲢��������·�ؽ���SystemEnv �ع�  
> **�漰�ύ**: ���θ���δʹ�� git��Ϊֱ���ļ��޸�

### 16.1 ����Ŀ��

����ͳ Maven Profile��`FMS_PRD_DEV/PRO/LOCAL`��+ 7 ������ properties �ļ���������ϵ��Ǩ�Ƶ� Spring Boot ԭ���� `application.properties` + `application-{profile}.properties` Profile ��ϵ��ͬʱ������������·��������Զ�ȡ��ʽ���졣

### 16.2 ��ϵͳ���üܹ�

#### 16.2.1 Maven Profile ����

���� Maven profiles������ʱͨ�� resource �������ӦĿ¼�ļ����Ƶ� classpath��

| Profile ID | ���� | ��ӦĿ¼ |
|-----------|------|----------|
| `FMS_PRD_DEV` | ���� | `ServerConfiguration/profiles/FMS_PRD_DEV/` |
| `FMS_PRD_PRO` | ���� | `ServerConfiguration/profiles/FMS_PRD_PRO/` |
| `FMS_PRD_LOCAL` | ���� | `ServerConfiguration/profiles/FMS_PRD_LOCAL/` |

#### 16.2.2 �������ļ��嵥��7 �� �� 3 ���� = 21 ��Դ�ļ���

| # | �ļ��� | ������� | ˵�� |
|---|--------|---------|------|
| 1 | `application-context.properties` | �� | `system=LOCAL/DEVELOP/PRODUCT`�����У� |
| 2 | `jdbc.properties` | �� | JDBC ���ӣ�driverClass/url/username/password�� |
| 3 | `redis.properties` | �� | Redis ���ӣ�host/port/pass/timeout �ȣ� |
| 4 | `ESAPI.properties` | �� | ESAPI ��ȫ���ã�������ͬ���ࣩ |
| 5 | `validation.properties` | �� | ��֤������ã�������ͬ���ࣩ |
| 6 | `components.properties` | �� | Dorado ������ã�classpath �����أ� |
| 7 | `WEB-INF/dorado-home/configure.properties` | �� | Dorado ����ģʽ/Ƥ�� |

#### 16.2.3 �����ü�����·

```
application-context.xml:24-41
  ���� <bean class="DecryptPropertyPlaceholderConfigurer"> (extends PropertyPlaceholderConfigurer)
       ���� order=1, ignoreUnresolvablePlaceholders=true
       ���� locations: ���� 7 ���ļ�
       ���� postProcessBeanFactory():
            ���� ��������ļ��� Properties ����
            ���� ���� key �� endsWith("jdbc.password") �� 3DES ����
            ���� ���� Properties �� ���� ${...} ռλ��
```

### 16.3 ��ϵͳ���üܹ�

#### 16.3.1 Profile �ļ�����

```
src/main/resources/
������ application.properties            # �������ã����л���������
������ application-local.properties      # system=LOCAL + JDBC + Redis + cluster
������ application-dev.properties        # system=DEVELOP + JDBC + Redis
������ application-prod.properties       # system=PRODUCT + JDBC + Redis + cluster
```

���ʽ��ͨ�� `spring.profiles.active=local`��Ĭ�ϣ����������� `-Dspring.profiles.active=prod`��

#### 16.3.2 �ļ��鲢����

**`application.properties`���������֣�**��

| ��Դ | �鲢������ |
|------|-----------|
| hibernate ���ã����� application-context.xml hibernateProperties �У� | `hibernate.dialect`, `hibernate.showSql`, `hibernate.jdbc.batch_size` �� |
| server ���ã������� | `server.port`, `server.servlet.context-path`, session/tomcat ���� |
| Spring Boot ������������ | `spring.main.allow-bean-definition-overriding=true`, `allow-circular-references=true` |
| �� JAR �������� | `download`, `filePath`, `exportPath`, `excelService` |
| Solr ��ַ������ components.properties�� | `richdata.url`, `richfile.url`, `pinyin.url` |
| �쳣��Ϣ | `com.fndsoft.pcipe.model.ActualException` �� |
| ��ʱ���񿪹� | `managerSystemTrigger` �� 15 �� trigger ���� |
| configure.properties������ԭλ���أ� | `spring.config.import=classpath:WEB-INF/dorado-home/configure.properties` |

**`application-{profile}.properties`���������첿�֣�**��

| ������ | ���컯�� |
|--------|---------|
| `system` | LOCAL / DEVELOP / PRODUCT |
| `jdbc.*` | ��������ͬ�� IP/����/���� |
| `redis.*` | ��������ͬ�� IP/�˿�/����/��Ⱥ��ַ |
| `subswitch` | ��ֵ�����Ŀ��� |

**δǨ��**��

| ���ļ� | ������ʽ |
|--------|---------|
| `ESAPI.properties` | Spring Boot ��ʹ�ã���Ǩ�� |
| `validation.properties` | Spring Boot ��ʹ�ã���Ǩ�� |
| `components.properties` | ������ֱ�ӹ��� application.properties��Solr URL�����޴��ļ���Ӱ�� |
| `configure.properties` | ͨ�� `spring.config.import` ����ԭλ���� |

#### 16.3.3 �����ü�����·

```
Spring Boot Environment
  ���� application.properties
  ���� application-{profile}.properties  �� ���� active profile �Զ�����
  ���� WEB-INF/dorado-home/configure.properties  �� spring.config.import

DecryptPropertyPlaceholderConfigurer @Bean (extends PropertySourcesPlaceholderConfigurer)
  ���� postProcessBeanFactory():
       ���� ���� Environment ���� PropertySource
       ���� ǰ�ò��� DecryptedPropertySource װ����
       ��   ���� getProperty("jdbc.password"):
       ��        ���� rawValue = Environment.getProperty("jdbc.password")
       ��        ���� key.endsWith("jdbc.password") �� DesEncrypt.getDesString(rawValue)
       ��        ���� ���ؽ��ܺ������
       ���� ignoreUnresolvablePlaceholders=true
       ���� ���� ${...} ռλ�������� Dorado �ģ����� ConfigureProperiesConfigurer��
```

### 16.4 ������·�ؽ�

#### 16.4.1 ���⣺DB ����δ����

**����**: ����ʱ DataSource ʹ���˼������ģ��� `Xu8707OISto/ohNN2m1yhQ==`����Ϊ���룬�������ݿ�ʧ�ܡ�

**����**: `DecryptPropertyPlaceholderConfigurer` ���������Ľ����߼�����**��δע��Ϊ Spring Bean**��

```
���ü�飺
  ? �ඨ�壺DecryptPropertyPlaceholderConfigurer.java��extends PropertySourcesPlaceholderConfigurer��
  ? XML <bean>��application-context.xml �� 24-41 �� �� ��ע��
  ? @Bean �������� �� �ؼ�ȱʧ
  ? @Component/@Named����
```

Ĭ�ϵ� Spring Boot `PropertySourcesPlaceholderConfigurer` ֱ�Ӵ� Environment ��ȡֵ�������ܡ�

**�޸�**: �� `FmsConfig.java` ���� `@Bean`��

```java
@Bean
public static PropertySourcesPlaceholderConfigurer propertySourcesPlaceholderConfigurer() {
    DecryptPropertyPlaceholderConfigurer configurer = new DecryptPropertyPlaceholderConfigurer();
    configurer.setIgnoreUnresolvablePlaceholders(true);
    return configurer;
}
```

> `static` ���뱣������Ϊ `BeanFactoryPostProcessor` ���������ڽ׶δ�����

#### 16.4.2 DecryptPropertyPlaceholderConfigurer �����

**�ɰ�**���ѷ�������
- �̳� `PropertyPlaceholderConfigurer`
- `postProcessBeanFactory()` �ֶ����� properties �ļ� �� ���� �� ���� `Properties` ����
- `locations` �б�ָ�� 7 ���ļ�·��

**�°�**��
- �̳� `PropertySourcesPlaceholderConfigurer`��Spring Boot ԭ����
- `postProcessBeanFactory()` ���� Environment ���� PropertySource �� ǰ�ò��� `DecryptedPropertySource`
- `DecryptedPropertySource.getProperty()` ���� key �� `CommonContants.DB_PASSWORD_PROPS`��`"jdbc.password"`����β������ �� `DesEncrypt.getDesString()` ����
- `setPropertySources(merged)` �� �滻Ĭ�ϵ� PropertySources������ `locations`

#### 16.4.3 �����㷨ȷ�ϣ������룩

`com.fndsoft.commons.utils.encrypt.DesEncrypt`��

```
�㷨��DES/CBC/PKCS5Padding����Կ "64BitKEY"��
���ܣ����� �� GB2312 �ֽ� �� DES ���� �� Base64 ���� �� ����
���ܣ����� �� Base64 ���� �� DES ���� �� GB2312 �ֽ� �� ����
```

`CommonContants.DB_PASSWORD_PROPS = "jdbc.password"`��������ȷ�ϣ�

### 16.5 SystemEnv �ع�

#### 16.5.1 ���⣺ResourceBundle �޷��ҵ� application-context.properties

`application-context.properties` ɾ����16 �� Java �ļ�ͨ�� `ResourceBundle.getBundle("application-context")` ��ȡ `system` ����ȫ������ `MissingResourceException`��

#### 16.5.2 �޸������ݽ�

**v1 ��ƣ�������**��`SystemEnv.java` �� ��̬�ֶ� + `static get()` + `@Named` + `@Value("${system}")`

ȱ�ݣ�
- `static get()` ���� Spring bean ����ǰ���� �� `system` �ֶ�Ϊ `null`
- �� Spring �������ࣨ`HttpServlet`���޷� `@Inject`

**v2 ��ƣ�ʵʩ��**��`SystemEnvProp.java` �� ʵ���ֶ� + `@Component` + `@Value("${system}")`

```java
@Component
public class SystemEnvProp {
    @Value("${system}")
    private String system;

    public String getSystem() {
        return system;
    }
}
```

ʱ��֤��
```
prepareEnvironment() �� Environment ���� system=LOCAL
  �� (bean �����׶�)
SystemEnvProp �� @Value("${system}") �� system="LOCAL"
  �� (����ע��)
���� Bean �� @Inject SystemEnvProp �� getSystem() = "LOCAL"
```

#### 16.5.3 �����ļ��嵥

| �ļ� | ���� | ע�� | ���췽ʽ |
|------|------|------|---------|
| `config/SystemEnvProp.java` | SystemEnvProp | `@Component` | ���� |
| `config/SystemEnv.java` | SystemEnv | �� | ɾ�� |
| `utility/service/impl/SysTemparameterServiceImpl.java` | SysTemparameterServiceImpl | `@Named` | `@Inject SystemEnvProp` |
| `redis/listener/ApportionmentMessageListenerImpl.java` | ApportionmentMessageListenerImpl | XML bean | `@Inject SystemEnvProp` |
| `download/view/DownloadPR.java` | DownloadPR | `@Named` | `@Inject SystemEnvProp` |
| `schedule/ScheduleBean.java` | ScheduleBean | XML bean | `@Inject SystemEnvProp` |
| `download/servlet/DownloadServerServlet.java` | DownloadServerServlet | HttpServlet | `@Inject SystemEnvProp` |
| `code/dao/impl/SystemParameterDaoImpl.java` | SystemParameterDaoImpl | `@Component` | `@Inject SystemEnvProp` |

�� **5 �� Spring ���� + 1 ���� Spring ���� + 1 �����ⷢ��** = 7 ���ļ���

**δ����**��`rule/cache/listener/` �� 11 �� `ServletContextListener`�������� `web.xml` ����ȫ��ע�ͣ��������

### 16.6 Dorado �����Դ���

#### 16.6.1 ���⣺`BeanDefinitionStoreException` �� ռλ���޷�����

ע�� `DecryptPropertyPlaceholderConfigurer` ������������

```
Could not resolve placeholder 'core.globalResource.cache.timeToLive'
```

Dorado �� `core.context.xml` ���� 6 �� `${...}` ռλ������ Dorado �� `ConfigureProperiesConfigurer` ���������

**����**: `DecryptPropertyPlaceholderConfigurer`��extends `PropertySourcesPlaceholderConfigurer`��Ĭ�� `ignoreUnresolvablePlaceholders=false`������ Dorado ռλ��ʱ�쳣��

#### 16.6.2 ConfigureProperiesConfigurer ������ȷ��

```java
// dorado-core-7.4.1.0109.jar
public class ConfigureProperiesConfigurer extends PropertyPlaceholderConfigurer {
    public ConfigureProperiesConfigurer() {
        setIgnoreUnresolvablePlaceholders(true);  // �������� true
    }

    public void postProcessBeanFactory(ConfigurableListableBeanFactory beanFactory) {
        Properties properties = new Properties();
        ConfigureStore store = Configure.getStore();  // �� Dorado ���ô洢����
        for (String key : store.keySet()) {
            properties.setProperty(key, store.getString(key));
        }
        processProperties(beanFactory, properties);
    }
}
```

#### 16.6.3 ִ��ʱ�����޸�

```invokeBeanFactoryPostProcessors:
  1. PriorityOrdered: DecryptPropertyPlaceholderConfigurer
     ���� ignoreUnresolvablePlaceholders=true �� ���� Dorado ռλ�� �� �����ñز�����
  2. ��ͨ BFPP: ConfigureProperiesConfigurer
     ���� �� Dorado ConfigureStore �������� �� ���� core.* ��ռλ��
```

**�޸�**���� `@Bean` ע��ʱ�� `ignoreUnresolvablePlaceholders=true`������ 16.4.1 ���޸��а�������

### 16.7 ��ɾ���ľ����

| ��� | ״̬ | ˵�� |
|------|------|------|
| `ServerConfiguration/` Ŀ¼ | ? ��ɾ�� | ���� profile ��Ŀ¼ȫ���Ƴ� |
| pom.xml Maven `<profiles>` �� | ? ��ɾ�� | Լ 50 ���Ƴ� |
| `application-context.properties` | ? ��ɾ�� | �鲢�� `application-{profile}.properties` |
| `jdbc.properties` | ? ��ɾ�� | �鲢 |
| `redis.properties` | ? ��ɾ�� | �鲢 |
| `ESAPI.properties` | ? ����ʹ�� | Spring Boot ����Ҫ |
| `validation.properties` | ? ����ʹ�� | ���������� application.properties |
| `SystemEnv.java` | ? ��ɾ�� | �滻Ϊ `SystemEnvProp.java` |
| �� `<bean id="propertyConfigurer">` | ? ��ע�� | application-context.xml �� 24-42 ������ `<!-- -->` |
| `PropertiesInitializer.java` | ? ���账�� | �����룬`loadProperties()` �Ӳ������� |
| `ContextLoaderListener.java` �� getDataSourceLocation/getSolrLocation | ? ������ | ������ `/* */` ע�Ϳ��� |

### 16.8 ��������

| ���� | ���ȼ� | ˵�� |
|------|--------|------|
| `application-prod.properties` �� `redis.pass=Fnd123456` | **��** | �� DEV ��ͬ������Ӧ�л�Ϊ����ֵ `6bzEDbEXgC8PXIpGGbm/BQ==` |
| 11 �� cache listener ���� `ResourceBundle` | **��** | ȫע�ͣ������������ָ����Ϊ `@Inject SystemEnvProp` |

### 16.9 ��֤�嵥

- [x] `application.properties` ���������й�������
- [x] ���� `application-{profile}.properties` �����˻�������
- [x] Maven profiles ���Ѵ� pom.xml �Ƴ�
- [x] `ServerConfiguration/` Ŀ¼��ɾ��
- [x] �� `<bean>` �������� application-context.xml ��ע��
- [x] `SystemEnvProp` ��ȷע�뵽 7 �� Java �ļ�
- [x] `DecryptPropertyPlaceholderConfigurer` ��ͨ�� `@Bean` ע��
- [x] `ignoreUnresolvablePlaceholders=true`��Dorado ���ݣ�
- [x] `spring.config.import` ������ `configure.properties`
- [x] ���ؿ��� `mvn spring-boot:run` ����������Profile local ���
- [x] DB �������������DataSource ���ӳɹ�
- [x] Dorado ռλ���� `ConfigureProperiesConfigurer` ��������

> **ע��**: `spring-boot-starter-web` �� `<scope>provided</scope>` ���ܵ���Ƕ��ʽ Tomcat ���������Ų鷽������� `mvn dependency:tree` �� Tomcat �� scope����Ҫʱ�Ƴ� `<scope>provided</scope>`��

---

## 17. ��ʮ���׶Σ�web.xml ȫ��Ǩ�Ƶ� Spring Boot Java ���ã�v1.23 ������

> **��Ӧ�Ự**: 2026-06-20 �����Ի�  
> **���췶Χ**: web.xml �� 24 �� Servlet��4 �� Filter��4 �� Listener Ǩ�Ƶ� Spring Boot `ServletRegistrationBean` / `FilterRegistrationBean` / `ServletListenerRegistrationBean` Java ����  
> **��������**: Ƕ��ʽ Tomcat ������ `web.xml` �� `DoradoServlet` δע�� �� `*.d` ���� 404����¼��հ�ҳ��

### 17.1 �������

#### 17.1.1 ��������

��¼��֤�ɹ����������� `FMSSESSIONID`�������������ת�� `/fms/login.view.Main.d` ��ҳ����ȫ�հס����������̨��ʾ `404 Not Found`��

#### 17.1.2 ����ԭ��

`web.xml` �� WAR ������ר����������**Spring Boot Ƕ��ʽ Tomcat ��ȫ���� `web.xml`**������ Servlet/Filter/Listener ��ע�����ͨ����
1. `@WebServlet` / `@WebFilter` / `@WebListener` ע�� + `@ServletComponentScan`
2. `ServletRegistrationBean` / `FilterRegistrationBean` / `ServletListenerRegistrationBean` �� `@Configuration` ��������

FMS ��Ŀ������ 24 �� Servlet��4 �� Filter ��**��** `@WebServlet` / `@WebFilter` ע�⣬��ȫ���� `web.xml` ������`@ServletComponentScan` �Դ�����ע������Ч��

#### 17.1.3 Dorado URL �ַ���·

```
*.d ������ /login.view.Main.d��
  ���� web.xml: <servlet-class>com.bstek.dorado.web.servlet.DoradoServlet</servlet-class>
       ���� Ƕ��ʽ Tomcat ------> ��ע���� ------> 404
```

ͬ����ԭ���������� 24 �� Servlet�����桢�������桢�ļ�����WebService �ȣ�ȫ�����ɷ��ʡ�

### 17.2 ��������������ܷ���� Java ����

��� 7 �� `@Configuration` �࣬ÿ���ฺ��һ��������� Servlet/Filter/Listener ע�᣺

| ������ | ������ | ע������ | ˵�� |
|--------|--------|:-------:|------|
| `DoradoConfig` | Dorado ������ʩ | 1 Servlet + 2 Filter | DoradoServlet, DelegatingFilterProxy, LoginFilter |
| `RuleApiConfig` | �������� + �ӿ� | 15 Servlet | ����/�ǳ�/ũ��/����/��������/ǩ���� |
| `CacheConfig` | ������� | 2 Servlet | ������ء������ѯ |
| `FileServiceConfig` | �ļ����� | 3 Servlet | LoadFile/FileDownload/DownloadServerServlet |
| `KeyInfoConfig` | �ؼ���Ϣ���� | 2 Servlet | �ؼ���Ϣ���ò�ѯ/��ִ |
| `WebServiceConfig` | WebService | 1 Servlet | CXFServlet |
| `FilterAndListenerConfig` | ������������� | 1 Filter + 1 Listener | SqlEscapeFilter, LoginSessionListener |

#### 17.2.1 `DoradoConfig.java`

```java
@Configuration
public class DoradoConfig {

    @Bean
    public ServletRegistrationBean<DoradoServlet> doradoServlet() {
        ServletRegistrationBean<DoradoServlet> bean = new ServletRegistrationBean<>(new DoradoServlet());
        bean.addUrlMappings("*.d", "*.do", "*.c", "*.dpkg", "/dorado/*");
        bean.setLoadOnStartup(1);
        bean.setName("doradoServlet");
        return bean;
    }

    @Bean
    public FilterRegistrationBean<DelegatingFilterProxy> delegatingFilterProxy() {
        FilterRegistrationBean<DelegatingFilterProxy> bean = new FilterRegistrationBean<>(new DelegatingFilterProxy());
        bean.addUrlPatterns("/*");
        bean.setOrder(1);
        bean.setName("delegatingFilterProxy");
        return bean;
    }

    @Bean
    public FilterRegistrationBean<LoginFilter> loginFilter() {
        FilterRegistrationBean<LoginFilter> bean = new FilterRegistrationBean<>(new LoginFilter());
        bean.addUrlPatterns("*.d", "/dorado/view-service");
        bean.setOrder(2);
        bean.setName("loginFilter");
        return bean;
    }
}
```

> **�ؼ���**:
> - `setName("doradoServlet")` �� �� web.xml �� `<servlet-name>` һ�£�ȷ�� WAR ���𲻳�ͻ
> - `DoradoServlet` ���� `dorado-core-7.4.1.0109.jar`��`com.bstek.dorado.web.servlet`��
> - `DelegatingFilterProxy` �� **Dorado ��** `com.bstek.dorado.web.filter.DelegatingFilterProxy`���� Spring ͬ����
> - `setOrder(1)` / `setOrder(2)` ���� Filter ִ��˳���� web.xml ����˳��һ��

#### 17.2.2 `RuleApiConfig.java`

ע�� 15 �� API �� Servlet���������� `com.cpic.fms.rule.servlet` + `CaclApportionmentRuleServlet` ���� `webservice.apportionment.sevlet`����

| Servlet �� | URL ӳ�� | ���� |
|-----------|----------|------|
| `SellTubeServlet` | `/SellTubeServlet` | ���ܻ�ȡҵ����ӿ�Ŀ |
| `SellTubeAddedServiceServlet` | `/SellTubeAddedServiceServlet` | ������ֵ���� |
| `SignReportAutServlet` | `/SignReportAutServlet` | ǩ��������Ϣ���� |
| `SignReportAutCheckServlet` | `/SignReportAutCheckServlet` | ǩ��������ϢУ�� |
| `CaclApportionmentRuleServlet` | `/ApportionmentRuleServlet` | ���շ�̯���� |
| `AutCallCenterServlet` | `/AutCallCenterServlet` | ���պ������� |
| `FautCoreCallCenterServlet` | `/FautCoreCallCenterServlet` | �ǳ����ĺ��� |
| `AgriCallCenterServlet` | `/AgriCallCenterServlet` | ũ�պ������� |
| `TrialCallCenterServlet` | `/TrialCallCenterServlet` | ����ӿ� |
| `CarAgreementRuleServlet` | `/CarAgreementRuleServlet` | ����Э����� |
| `MergeCallCenterServlet` | `/MergeCallCenterServlet` | �����ںϽӿ� |
| `TrialMergeCallCenterServlet` | `/TrialMergeCallCenterServlet` | �����ںϽӿ� |
| `MarketCallCenterServlet` | `/MarketCallCenterServlet` | �ǳ����ܹ��� |
| `RuleTrailServlet` | `/ruleTrailServlet` | �������� |
| `AutoPolicyServerServlet` | `/AutoPolicyServerServlet` | ���ش��ӿ� |

#### 17.2.3 `CacheConfig.java`

| Servlet �� | URL ӳ�� | loadOnStartup |
|-----------|----------|:-------------:|
| `CacheLoadServlet` | `/cacheLoad.do` | �� |
| `CacheQueryServlet` | `/cacheQuery.do` | 1 |

#### 17.2.4 `FileServiceConfig.java`

| Servlet �� | URL ӳ�� | loadOnStartup | ��ע |
|-----------|----------|:-------------:|------|
| `LoadFile` | `/LoadFile` | �� | `com.cpic.fms.download.common.LoadFile` |
| `FileDownload` | `/download.do` | �� | `com.cpic.fms.upload.view.FileDownload`�����빦�ܣ� |
| `DownloadServerServlet` | `/download.server` | 2 | ������������������ |

#### 17.2.5 `KeyInfoConfig.java`

| Servlet �� | URL ӳ�� | ���� |
|-----------|----------|------|
| `CallKeysInfoManageServlet` | `/CallKeysInfoManageServlet` | �ؼ���Ϣչʾ���� |
| `CallBackKeysInfoManageServlet` | `/CallBackKeysInfoManageServlet` | �ؼ���Ϣ���û�ִ |

#### 17.2.6 `WebServiceConfig.java`

| Servlet �� | URL ӳ�� | ���� |
|-----------|----------|------|
| `CXFServlet` | `/webservice/*` | Apache CXF WebService �˵� |

#### 17.2.7 `FilterAndListenerConfig.java`

```java
@Configuration
public class FilterAndListenerConfig {

    @Bean
    public FilterRegistrationBean<SqlEscapeFilter> sqlEscapeFilter() {
        FilterRegistrationBean<SqlEscapeFilter> bean = new FilterRegistrationBean<>(new SqlEscapeFilter());
        bean.addUrlPatterns("*.d");
        bean.setOrder(3);
        bean.setName("SqlEscapeFilter");
        return bean;
    }

    @Bean
    public ServletListenerRegistrationBean<LoginSessionListener> loginSessionListener() {
        ServletListenerRegistrationBean<LoginSessionListener> bean = new ServletListenerRegistrationBean<>(new LoginSessionListener());
        return bean;
    }
}
```

### 17.3 ����ע����ձ�

#### 17.3.1 24 �� Servlet ȫ������

| # | web.xml servlet-name | Servlet �� | URL ӳ�� | ע��λ�� |
|:-:|---------------------|-----------|----------|---------|
| 1 | `doradoServlet` | `com.bstek.dorado.web.servlet.DoradoServlet` | `*.d / *.do / *.c / *.dpkg /dorado/*` | DoradoConfig |
| 2 | `CXFServlet` | `org.apache.cxf.transport.servlet.CXFServlet` | `/webservice/*` | WebServiceConfig |
| 3 | `cacheLoad.do` | `com.cpic.fms.common.cache.CacheLoadServlet` | `/cacheLoad.do` | CacheConfig |
| 4 | `cacheQuery.do` | `com.cpic.fms.common.cache.CacheQueryServlet` | `/cacheQuery.do` | CacheConfig |
| 5 | `LoadFile` | `com.cpic.fms.download.common.LoadFile` | `/LoadFile` | FileServiceConfig |
| 6 | `download.do` | `com.cpic.fms.upload.view.FileDownload` | `/download.do` | FileServiceConfig |
| 7 | `SellTubeServlet` | `com.cpic.fms.rule.servlet.SellTubeServlet` | `/SellTubeServlet` | RuleApiConfig |
| 8 | `SellTubeAddedServiceServlet` | `com.cpic.fms.rule.servlet.SellTubeAddedServiceServlet` | `/SellTubeAddedServiceServlet` | RuleApiConfig |
| 9 | `SignReportAutServlet` | `com.cpic.fms.rule.servlet.SignReportAutServlet` | `/SignReportAutServlet` | RuleApiConfig |
| 10 | `SignReportAutCheckServlet` | `com.cpic.fms.rule.servlet.SignReportAutCheckServlet` | `/SignReportAutCheckServlet` | RuleApiConfig |
| 11 | `ApportionmentRuleServlet` | `com.cpic.fms.webservice.apportionment.sevlet.CaclApportionmentRuleServlet` | `/ApportionmentRuleServlet` | RuleApiConfig |
| 12 | `AutCallCenterServlet` | `com.cpic.fms.rule.servlet.AutCallCenterServlet` | `/AutCallCenterServlet` | RuleApiConfig |
| 13 | `FautCoreCallCenterServlet` | `com.cpic.fms.rule.servlet.FautCoreCallCenterServlet` | `/FautCoreCallCenterServlet` | RuleApiConfig |
| 14 | `AgriCallCenterServlet` | `com.cpic.fms.rule.servlet.AgriCallCenterServlet` | `/AgriCallCenterServlet` | RuleApiConfig |
| 15 | `TrialCallCenterServlet` | `com.cpic.fms.rule.servlet.TrialCallCenterServlet` | `/TrialCallCenterServlet` | RuleApiConfig |
| 16 | `CarAgreementRuleServlet` | `com.cpic.fms.rule.servlet.CarAgreementRuleServlet` | `/CarAgreementRuleServlet` | RuleApiConfig |
| 17 | `MergeCallCenterServlet` | `com.cpic.fms.rule.servlet.MergeCallCenterServlet` | `/MergeCallCenterServlet` | RuleApiConfig |
| 18 | `TrialMergeCallCenterServlet` | `com.cpic.fms.rule.servlet.TrialMergeCallCenterServlet` | `/TrialMergeCallCenterServlet` | RuleApiConfig |
| 19 | `MarketCallCenterServlet` | `com.cpic.fms.rule.servlet.MarketCallCenterServlet` | `/MarketCallCenterServlet` | RuleApiConfig |
| 20 | `RuleTrailServlet` | `com.cpic.fms.rule.servlet.RuleTrailServlet` | `/ruleTrailServlet` | RuleApiConfig |
| 21 | `AutoPolicyServerServlet` | `com.cpic.fms.rule.servlet.AutoPolicyServerServlet` | `/AutoPolicyServerServlet` | RuleApiConfig |
| 22 | `CallKeysInfoManageServlet` | `com.cpic.fms.keysinfomanage.servlet.CallKeysInfoManageServlet` | `/CallKeysInfoManageServlet` | KeyInfoConfig |
| 23 | `CallBackKeysInfoManageServlet` | `com.cpic.fms.keysinfomanage.servlet.CallBackKeysInfoManageServlet` | `/CallBackKeysInfoManageServlet` | KeyInfoConfig |
| 24 | `DownloadServerServlet` | `com.cpic.fms.download.servlet.DownloadServerServlet` | `/download.server` | FileServiceConfig |

#### 17.3.2 4 �� Filter ����

| # | web.xml filter-name | Filter �� | URL ģʽ | ע��λ�� |
|:-:|-------------------|-----------|----------|---------|
| 1 | `delegatingFilterProxy` | `com.bstek.dorado.web.filter.DelegatingFilterProxy` | `/*` | DoradoConfig (order=1) |
| 2 | `loginFilter` | `com.cpic.fms.login.view.LoginFilter` | `*.d / /dorado/view-service` | DoradoConfig (order=2) |
| 3 | `SqlEscapeFilter` | `com.cpic.fms.sso.SqlEscapeFilter` | `*.d` | FilterAndListenerConfig (order=3) |
| 4 | `CharacterEncodingFilter` | **Spring Boot �Զ�����**������ע�� | `/*` | �� |

> `CharacterEncodingFilter` �� Spring Boot �� `OrderedCharacterEncodingFilter` �Զ��ṩ��UTF-8 ���룩���� web.xml ������һ�£������ظ�ע�ᡣ

#### 17.3.3 4 �� Listener ����

| # | web.xml listener-class | ������ʽ |
|:-:|----------------------|----------|
| 1 | `org.springframework.web.util.IntrospectorCleanupListener` | **����** �� Spring Boot 2.7 Ĭ��ע�ᣬ�����ֶ����� |
| 2 | `ch.qos.logback.ext.spring.web.LogbackConfigListener` | **����** �� Spring Boot ͨ�� `logging` starter �Զ����� Logback��`logback.xml` ���� WEB-INF ������� listener |
| 3 | `com.cpic.fms.common.init.ContextLoaderListener` | **����** �� �� listener ���ؾ� Spring XML ApplicationContext��Spring Boot ͨ�� `@ImportResource` ֱ�Ӽ��أ�������Ҫ�˼����� |
| 4 | `com.cpic.fms.login.listener.LoginSessionListener` | **��ע��** �� `ServletListenerRegistrationBean` �� FilterAndListenerConfig ��ע�� |

> 11 ������ `ServletContextListener`��`rule.cache.listener.*`���� web.xml ����ȫ��ע�ͣ��������ע�ᡣ

### 17.4 ��������

#### 17.4.1 Ϊʲô���� `@ServletComponentScan`��

`@ServletComponentScan` ֻ�ܷ��ִ� `@WebServlet`/`@WebFilter`/`@WebListener` ע����ࡣFMS ���� 24 �� Servlet ���޴���ע�⣬���� web.xml �Ĵ�����ʽע�ᡣ��˱���ʹ�� `ServletRegistrationBean` �ȱ��ʽע�ᡣ

#### 17.4.2 WAR �������

```java
bean.setName("doradoServlet");  // �� web.xml <servlet-name> ͬ��
```

WAR �����ⲿ Tomcat ʱ��
1. Tomcat �ȴ��� `web.xml` �� ע�� `doradoServlet`����Ϊ `doradoServlet`��
2. Spring Boot �� `ServletContextInitializer` �� ���� `servletContext.addServlet("doradoServlet", doradoServlet)`
3. `addServlet()` ���������Ѵ��� �� ����**�Ѵ��ڵ�** `ServletRegistration.Dynamic` �� ���� URL ӳ��
4. **����ͻ�����ظ�ע��**

> ע�⣺�ⲿ Tomcat �� web.xml �е� `<load-on-startup>` �� `<init-param>` �Ḳ�� Java ���á����ֲ���ʽ������������

#### 17.4.3 Filter ˳��֤

`FilterRegistrationBean.setOrder()` ���� Filter ִ��˳��ֵԽС���ȼ�Խ�ߣ���

| Order | Filter | ���� |
|:-----:|--------|------|
| 1 | `DelegatingFilterProxy` | Dorado ȫ�ִ������ˣ�`/*`�� |
| 2 | `LoginFilter` | ��¼�ỰУ�飨`*.d`�� |
| 3 | `SqlEscapeFilter` | SQL ע��/��վ����ת�루`*.d`�� |

#### 17.4.4 `DelegatingFilterProxy` �� Dorado �࣬�� Spring ��

·��ȷ�ϣ�`com.bstek.dorado.web.filter.DelegatingFilterProxy` ������ `dorado-core-7.4.1.0109.jar` �У��� Spring Framework �� `org.springframework.web.filter.DelegatingFilterProxy` ���ܲ�ͬ�����ɻ��á�

#### 17.4.5 `setServletName()` �� `setName()` API ����

Spring Boot 2.7 �� `ServletRegistrationBean` �� `FilterRegistrationBean` �����ṩ `setServletName()`/`setFilterName()` ������ʹ�ü̳��� `DynamicRegistrationBean` �� `setName(String)` ����ͳһ����ע������

### 17.5 ���� / �޸��ļ��嵥

| ���� | �ļ�·�� | ˵�� |
|------|---------|------|
| **����** | `src/main/java/com/cpic/fms/config/web/DoradoConfig.java` | Dorado ������ʩ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/RuleApiConfig.java` | 15 �� API Servlet ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/CacheConfig.java` | ������� Servlet ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/FileServiceConfig.java` | �ļ����� Servlet ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/KeyInfoConfig.java` | �ؼ���Ϣ���� Servlet ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/WebServiceConfig.java` | CXF WebService Servlet ���� |
| **����** | `src/main/java/com/cpic/fms/config/web/FilterAndListenerConfig.java` | ���� Filter + Listener ���� |
| **����** | `src/main/webapp/WEB-INF/web.xml` | ����ԭ�ļ���WAR ����ʱ��Ȼ��Ч |
| **����** | `src/main/java/com/cpic/fms/config/FmsConfig.java` | �������ã�DoradoContext ��ʼ�� + ���Խ��� + ��̬��Դӳ�䣩 |
| **����** | `src/main/java/com/FmsApplication.java` | �����ࣨ�����޸ģ� |

### 17.6 8 �׶��Ŵ�����

| �׶� | ���� | ��� |
|:----:|------|:----:|
| 1 | `web.xml` + Ƕ��ʽ Tomcat | ? Ƕ��ʽ Tomcat ���� `web.xml`��`*.d` 404 |
| 2 | `@ServletComponentScan` + �ٶ����� `@WebServlet` | ? FMS ���� Servlet ��ע�⣬���� |
| 3 | `ServletRegistrationBean` ��һ�ֶ�ע�� | ? ��ʼ�Ų�Դ��·�� |
| 4 | ȷ�� Dorado ��·����JAR �������� | ? `DoradoServlet`/`DelegatingFilterProxy` ȷ�ϴ��� |
| 5 | ���� 24 �� Servlet �������� URL ģʽ | ? ȫ��ȷ�� |
| 6 | ���� 7 �� `@Configuration` ��ֹ���ע�� | ? �ı���� |
| 7 | `mvn compile` ��֤ | ? ����ͨ�� |
| 8 | API �����޸���`setServletName` �� `setName`�� | ? Spring Boot 2.7 API ���� |

### 17.7 ��֤�嵥

- [x] `DoradoConfig.java` �� DoradoServlet 5 �� URL ģʽ��ȷע��
- [x] `DoradoConfig.java` �� DelegatingFilterProxy order=1��`/*` ����
- [x] `DoradoConfig.java` �� LoginFilter order=2��`*.d /dorado/view-service` ����
- [x] `RuleApiConfig.java` �� 15 �� Servlet ·���� web.xml ��ȫ����
- [x] `CacheConfig.java` �� cacheLoad.do + cacheQuery.do URL ��ȷ
- [x] `FileServiceConfig.java` �� LoadFile / download.do / download.server ��ȷ
- [x] `KeyInfoConfig.java` �� 2 ���ؼ���Ϣ Servlet ��ȷ
- [x] `WebServiceConfig.java` �� CXFServlet `/webservice/*` ��ȷ
- [x] `FilterAndListenerConfig.java` �� SqlEscapeFilter order=3 + LoginSessionListener
- [x] Filter ִ��˳������DelegatingFilterProxy �� LoginFilter �� SqlEscapeFilter��
- [x] `mvn compile` ����ͨ�����޴����޾���
- [x] `setName()` API �滻 `setServletName()`/`setFilterName()`��Spring Boot 2.7 ����
- [ ] **����������֤** �� `mvn spring-boot:run` ��¼�� `*.d` ���� 404����ִ�У�
- [ ] **WAR �����֤** �� `mvn package` �����ⲿ Tomcat��web.xml + Java ˫ע���޳�ͻ����ִ�У�

### 17.8 ��������

| ���� | ���ȼ� | ˵�� |
|------|--------|------|
| `DoradoServlet` ��ʼ��ʱ `DoradoContext` ���γ�ʼ�� | **��** | `FmsConfig` �е� `doradoContextInitializer()` ���� `ServletContextInitializer` �׶������� failSafeContext��`DoradoServlet.init()` ���ٴε��� `DoradoContext.init()`�����߼��ݣ������ظ���ʼ���� |
| `LoginFilter` �� Spring �й� | **��** | `new LoginFilter()` ����ʵ��������ֱ�ӹ�����`LoginFilter` ���� Spring ����ע�루���� Session ���� `RbacContext.KEY_USER` У�飩��`@Inject` �ֶβ��ᱻִ�С������� `SpringContextHolder.getBean()` ���ס� |
| 11 �� Cache Listener ��ע�� | **��** | ���輤�����Ϊ `ServletListenerRegistrationBean` ע�ᣬ����� `ResourceBundle.getBundle("application-context")` ���������� `@Inject SystemEnvProp`���� |

---

---

## 18. ��ʮ�߽׶Σ��޸�DoradoServlet��Contextδ���ص���`*.d` 404��v1.24 ������

> **��Ӧ�Ự**: 2026-06-20 �����Ի�  
> **���췶Χ**: `DoradoServlet.createWebApplicationContext()` ��ȷ��ȡ Configure store��`dorado-child-context.xml` ������أ�`UriResolverMapping` ���ȼ�����  
> **��������**: DoradoServlet ע��ɹ�����Ȼ `*.d` 404 �� �� Context δ���� `servlet-context.xml`��`UriResolverMapping` ȱʧ���� �� Context �� configLocation ����δ��ȷ����

### 18.1 ��������

v1.23 �� `DoradoServlet` ͨ�� `ServletRegistrationBean` ע��󣬵�¼ҳ��������ʾ������¼�ɹ���ת�� `/fms/login.view.Main.d` ��ҳ��հס����������̨��ʾ��

- `POST /fms/logincommon.html` �� 302 �� ҳ��������ת
- `GET /fms/login.view.Main.d` �� **404 Not Found**

`DoradoServlet` �Ѿ��յ�����Tomcat �� `*.d` ӳ��·�ɣ���Servlet ������ʼ����������**�Ҳ������� `*.d` ����� Handler**��

### 18.2 �������

#### 18.2.1 DoradoServlet ���� Context ������·

`DoradoServlet` �̳��� Spring �� `DispatcherServlet`���� `init()` ����ִ�����̣�

```
DoradoServlet.init(config)
  ���� super.init(config)                                    // HttpServletBean
       ���� initServletBean()
            ���� initWebApplicationContext()
                 ���� WebApplicationContext rootContext = ... // �� ServletContext ��ȡ ROOT Context
                 ���� createWebApplicationContext(rootContext)
                      ���� DoradoServlet.createWebApplicationContext() // �� �ؼ����Ƿ���
                      ��    ���� Configure.getString("core.servletContextConfigLocation")  // ��ȡ Configure �洢
                      ��    ���� setContextConfigLocation(config)                          // ���ø� FrameworkServlet
                      ���� super.createWebApplicationContext()                           // DispatcherServlet
                           ���� wac.setConfigLocation(getContextConfigLocation())         // ������ Context
                                ���� �� Context ���� config �е� XML �ļ�
                                    ���� classpath:com/bstek/dorado/web/servlet-context.xml  �� ���� UriResolverMapping
                                    ���� classpath:com/bstek/dorado/view/servlet-context.xml
                                    ���� classpath:com/bstek/dorado/console/required-servlet-context.xml
                                    ���� classpath:com/bstek/dorado/idesupport/servlet-context.xml
                                    ���� (+) ���ǵ� dorado-child-context.xml
                                          ���� ע�� DoradoUriResolverOrderPostProcessor
                                              ���� UriResolverMapping.order = HIGHEST_PRECEDENCE
```

**�ؼ�����**: `DoradoServlet.createWebApplicationContext()` �� **`Configure.getString("core.servletContextConfigLocation")`** ��ȡ�����ַ��������� `Configure` �洢�㣬**���� ServletContext ���Ի� init-param**��

#### 18.2.2 core.servletContextConfigLocation ����Դ

`DoradoLoader.preload(servletContext, true)` ����ִ���ڼ䣬����ռ� `servletContextLocations`��

| ��Դ | ��ʽ | ·�� |
|------|------|------|
| dorado-core package ���� | `META-INF/dorado-package.properties` | `classpath:com/bstek/dorado/web/servlet-context.xml` |
| dorado-core package ���� | ͬ�� | `classpath:com/bstek/dorado/view/servlet-context.xml` |
| dorado-core package ���� | ͬ�� | `classpath:com/bstek/dorado/console/required-servlet-context.xml` |
| dorado-core package ���� | ͬ�� | `classpath:com/bstek/dorado/idesupport/servlet-context.xml` |
| Ӧ���Զ��壨���ǵ��޸��� | ׷�ӵ� Configure �洢 | `classpath:com/cpic/fms/config/web/dorado-child-context.xml` |

`preload()` ���ִ�У�
```java
// getRealResourcesPath() ��Ϊ��ֵ���ˣ�classpath: ·��ԭ������
String joined = StringUtils.join(getRealResourcesPath(servletContextLocations), ';');
store.set("core.servletContextConfigLocation", joined);
```

#### 18.2.3 `getRealResourcesPath()` �ķ�����ȷ��

```java
// DoradoLoader.java �� ������ȷ��
public String[] getRealResourcesPath(List<String> locations) throws IOException {
    if (locations == null || locations.isEmpty()) { return null; }
    List<String> list = new ArrayList<>();
    for (String loc : locations) {
        if (StringUtils.isNotEmpty(loc)) {
            list.add(loc);     // �� ԭ�����ӣ����� filesystem ת��
        }
    }
    return list.toArray(new String[0]);
}
```

**��Ҫȷ��**: `classpath:` ǰ׺·��**��������**������ servletContext ��Դ·��ת����Spring �� `AbstractApplicationContext.setConfigLocations()` ����ȷʶ�� `classpath:` ǰ׺��

### 18.3 ��һ�γ��ԵĴ����޸�

�����޸�ʱ�������Ϊ `DoradoServlet` �� ServletContext ���Զ�ȡ���ã�

```java
// ? ����д�� �� д�� ServletContext Attribute
servletContext.setAttribute("core.servletContextConfigLocation", cscl + "," + custom);
```

�������� `DoradoServlet.createWebApplicationContext()` ȷ�ϣ�
```java
// DoradoServlet.java �� ʵ��ִ��
protected WebApplicationContext createWebApplicationContext(WebApplicationContext parent) {
    try {
        String config = Configure.getString("core.servletContextConfigLocation");  // �� �� Configure �洢��ȡ
        setContextConfigLocation(config);
    } catch (Exception e) {
        logger.error("Fail to setContextConfigLocation", e);
    }
    return super.createWebApplicationContext(parent);
}
```

**����**: д�� ServletContext ������ȫ��Ч��������� `Configure.getStore()`��

### 18.4 ��ȷ�޸�����

#### 18.4.1 `FmsConfig.java` �� �޸� Configure �洢����

**�Ķ�λ��**: `src/main/java/com/cpic/fms/config/FmsConfig.java`

**�Ķ�ǰ**:
```java
@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        try{
            DoradoLoader.getInstance().preload(servletContext, true);
            String cscl = servletContext.getInitParameter("core.servletContextConfigLocation");
            if (cscl == null) {
                cscl = (String) servletContext.getAttribute("core.servletContextConfigLocation");
            }
            if (cscl != null && !cscl.contains("dorado-child-context")) {
                String custom = "classpath:com/cpic/fms/config/web/dorado-child-context.xml";
                servletContext.setAttribute("core.servletContextConfigLocation", cscl + "," + custom);
            }
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    };
}
```

**�Ķ���**:
```java
@Bean
public ServletContextInitializer doradoContextInitializer() {
    return servletContext -> {
        try{
            DoradoLoader.getInstance().preload(servletContext, true);
            // DoradoServlet.createWebApplicationContext �� Configure �洢��ȡ������ servletContext
            String cscl = Configure.getString("core.servletContextConfigLocation");
            String custom = "classpath:com/cpic/fms/config/web/dorado-child-context.xml";
            if (cscl != null && !cscl.contains("dorado-child-context")) {
                // �ָ���ʹ�� ';'���� preload() �� StringUtils.join(..., ';') һ�£�
                Configure.getStore().set("core.servletContextConfigLocation", cscl + ";" + custom);
            } else if (cscl == null) {
                Configure.getStore().set("core.servletContextConfigLocation", custom);
            }
        }catch(Exception e){
            throw new RuntimeException(e);
        }
    };
}
```

**�ؼ�����**:

| ά�� | �����޸� | ��ȷ�޸� |
|------|---------|---------|
| ��ȡĿ�� | `servletContext.getInitParameter()` / `getAttribute()` | `Configure.getString()` |
| д��Ŀ�� | `servletContext.setAttribute()` | `Configure.getStore().set()` |
| �ָ��� | `,`�����ţ� | `;`���ֺţ��� preload() һ�£� |
| null ���� | ������ cscl != null �ķ�֧ | ׷�� cscl == null ʱֱ������ custom |

#### 18.4.2 `dorado-child-context.xml` �� ������ Context ����

**�ļ�λ��**: `src/main/resources/com/cpic/fms/config/web/dorado-child-context.xml`

```xml
<?xml version="1.0" encoding="UTF-8"?>
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans.xsd">
    <bean class="com.cpic.fms.config.web.DoradoUriResolverOrderPostProcessor" />
</beans>
```

���ļ��� `DoradoServlet` ���� Context �м��أ��� `UriResolverMapping` �� order ��Ϊ `HIGHEST_PRECEDENCE`��

#### 18.4.3 `DoradoUriResolverOrderPostProcessor.java` �� UriResolverMapping ���ȼ�

**�ļ�λ��**: `src/main/java/com/cpic/fms/config/web/DoradoUriResolverOrderPostProcessor.java`

```java
package com.cpic.fms.config.web;

import com.bstek.dorado.web.resolver.UriResolverMapping;
import org.springframework.beans.BeansException;
import org.springframework.beans.factory.config.BeanPostProcessor;
import org.springframework.core.Ordered;

public class DoradoUriResolverOrderPostProcessor implements BeanPostProcessor, Ordered {

    @Override
    public Object postProcessAfterInitialization(Object bean, String beanName) {
        if (bean instanceof UriResolverMapping) {
            ((UriResolverMapping) bean).setOrder(Ordered.HIGHEST_PRECEDENCE);
        }
        return bean;
    }

    @Override
    public int getOrder() {
        return 0;
    }
}
```

**˵��**:
- �� `BeanPostProcessor` ���� DoradoServlet ���� Context ����Ч��ͨ�� `dorado-child-context.xml` ע�ᣩ
- �� Context �е� `UriResolverMapping` Ĭ�� order Ϊ `LOWEST_PRECEDENCE`������������ `HIGHEST_PRECEDENCE`
- ȷ�� `*.d` ������������ `UriResolverMapping`�����Ǳ����� HandlerMapping ���ػ� fallback �� 404

### 18.5 ����ʱ��

```
Spring Boot ����
  ��
  ���� onRefresh() �� TomcatStarter.onStartup()
  ��    ���� ServletContextInitializer ����ִ��
  ��         ���� doradoContextInitializer()                              [FmsConfig.java]
  ��              ���� DoroadoLoader.preload(servletContext, true)
  ��              ��    ���� ��ȡ dorado-core package servletContextConfigLocations
  ��              ��    ���� �ռ� 4 �� classpath ·���� servletContextLocations
  ��              ��    ���� �洢�� Configure �洢: core.servletContextConfigLocation = "..."
  ��              ���� ׷�� dorado-child-context.xml �� Configure �洢     �� �ؼ��޸�
  ��
  ���� finishBeanFactoryInitialization()
  ��    ���� ʵ�������е��� Bean
  ��
  ���� Tomcat �������� �� ��ʼ��ע��� Servlet
       ���� DoradoServlet.init(config)
            ���� super.init() �� createWebApplicationContext()
            ��    ���� Configure.getString("core.servletContextConfigLocation")  �� ��ȷ������
            ��    ��    ���: "classpath:.../servlet-context.xml;...classpath:dorado-child-context.xml"
            ��    ���� setContextConfigLocation(combined);
            ��
            ���� �� Context ����
                 ���� ���� servlet-context.xml �� ���� UriResolverMapping
                 ���� ���� servlet-context.xml �� ���� ResolverRegisterProcessor
                 ���� ���� view/servlet-context.xml �� ���� View ��ش�����
                 ���� ���� dorado-child-context.xml �� ע�� BeanPostProcessor
                      ���� UriResolverMapping.order = HIGHEST_PRECEDENCE
                         
�û����� /fms/login.view.Main.d
  ���� Tomcat URL ƥ��: *.d �� DoradoServlet
       ���� DispatcherServlet ���� HandlerMapping
            ���� UriResolverMapping (order=HIGHEST_PRECEDENCE) ? ƥ�� �� ��������
            ���� ҳ��������Ⱦ
```

### 18.6 �ؼ�����

| ������ | ��ϸ˵�� |
|--------|---------|
| `Configure` �洢 vs ServletContext ���� | `DoradoServlet` ������ Context ʱ�� `Configure.getString()` ��ȡ������ ServletContext �� init-param �� attribute��v1.18 �� `DoradoContext.init()` �������� failSafeContext������δ��� `core.servletContextConfigLocation`����ֻ�� `preload()` ����� |
| `getRealResourcesPath()` ����·��ת�� | `DoradoLoader.getRealResourcesPath()` ������ null/���ַ�����`classpath:` ǰ׺������������ Context �� `setConfigLocations()` ����ȷʶ�� Spring Resource Э�� |
| `;` �ָ��� | `preload()` �ڲ�ʹ�� `StringUtils.join(list, ';')`��׷��ʱ����ʹ�� `;` ����һ�� |
| `BeanPostProcessor` ������ | `DoradoUriResolverOrderPostProcessor` ͨ�� `dorado-child-context.xml` ע���� **�� Context** �У������� Context �ڵ�Bean��Ч����Ӱ�� ROOT Context |
| `servlet-context.xml` ������ `@ImportResource` �� | FmsApplication.java �� `@ImportResource` ���� `web/context.xml` ��**������** `web/servlet-context.xml`�����߽�ͨ�� package ���Ƽ��ص� DoradoServlet ���� Context��������ȷ�ġ���`UriResolverMapping` ֻ��������� Context |
| `WebMvcConfigurer` ������ģʽ | `DoradoUriResolverOrderPostProcessor` ���� `@Component` ע�⣬��Ϊ������ ROOT Context �� ComponentScan ·������Ч����ͨ���� Context �� XML ����ʽע�� |

### 18.7 �޸��ļ��嵥

| ���� | �ļ�·�� | ˵�� |
|------|---------|------|
| **�޸�** | `src/main/java/com/cpic/fms/config/FmsConfig.java` | `doradoContextInitializer()` ���� `Configure.getStore().set()` ���� Configure �洢�������� `servletContext.setAttribute()` �Ĵ������� |
| **����** | `src/main/resources/com/cpic/fms/config/web/dorado-child-context.xml` | �Ѵ��ڣ�ע�� `DoradoUriResolverOrderPostProcessor` |
| **����** | `src/main/java/com/cpic/fms/config/web/DoradoUriResolverOrderPostProcessor.java` | �Ѵ��ڣ�`BeanPostProcessor` ���� `UriResolverMapping` ���ȼ� |
| **����** | `src/main/java/com/FmsApplication.java` | �����޸ģ�`@ImportResource` ������ȷ�� |
| **����** | `src/main/java/com/cpic/fms/config/web/DoradoConfig.java` | �����޸ģ�`ServletRegistrationBean` ������ȷ�� |

### 18.8 ��֤�嵥

- [x] `FmsConfig.java` �� `Configure.getStore().set("core.servletContextConfigLocation", ...)` д����ȷλ��
- [x] `FmsConfig.java` �� �ָ���ʹ�� `;`���� `preload()` �ڲ� `StringUtils.join(..., ';')` һ�£�
- [x] `DoradoServlet.createWebApplicationContext()` �� `Configure.getString()` ���ذ��� `dorado-child-context.xml` ������·��
- [x] �� Context ���� `servlet-context.xml` �� `UriResolverMapping` ��������
- [x] �� Context ���� `dorado-child-context.xml` �� `DoradoUriResolverOrderPostProcessor` ��Ч
- [x] `UriResolverMapping.order = HIGHEST_PRECEDENCE` �� `*.d` ������������
- [x] **�û��ܵ�¼�ɹ���������ҳ��** �� `*.d` ���� 404
- [ ] WAR ���������֤����ִ�У�

---

## 19. 第十八阶段：UploadAction 组件类型未注册（v1.25 新增）

> **对应会话**: 2026-06-21 登录后点击规则页面报错  
> **改造范围**: `@ImportResource` 显式导入 `dorado-uploader` 的 context.xml  
> **核心问题**: 登录成功后进入规则管理页面，Dorado 解析 `RuleManage.view.xml` 时报 `Unrecognized Component type [UploadAction]`

### 19.1 错误信息

```
com.bstek.dorado.config.xml.XmlParseException: Unrecognized Component type [UploadAction].
  - class path resource [com/cpic/fms/rule/rulemanage/view/RuleManage.view.xml]
  - <UploadAction id="uploadExcelAction" ...
```

### 19.2 根因分析

`DoradoLoader.preload()` 在嵌入式 Tomcat 启动时扫描 classpath 中所有 `META-INF/dorado-package.properties` 文件，用于自动发现 Dorado 组件类型。

`dorado-uploader-1.0.15.jar` 的 `META-INF/dorado-package.properties` 中声明了：
```properties
componentConfigLocations=classpath:com/bstek/dorado/uploader/components-context.xml
```

该文件注册了 `UploadAction` 组件类型：
```xml
<bean id="com.bstek.dorado.uploader.widget.UploadAction" parent="dorado.defaultComponentTypeRegister" />
```

**问题出在 classpath 扫描失败**：`dorado-uploader-1.0.15.jar` 以 `<scope>system</scope>` 引入，Spring Boot 嵌入式 Tomcat 的 `LaunchedURLClassLoader` 在调用 `ClassLoader.getResources("META-INF/dorado-package.properties")` 时，**无法发现 system 作用域的 JAR**，导致 `UploadAction` 未被注册。

`ComponentParserDispatcher` 在 `componentTypeRegistry` 中查不到 `UploadAction` → 抛出 `XmlParseException`。

### 19.3 影响范围

15 个 `.view.xml` 文件使用了 `UploadAction`，涉及规则管理、费用数据维护、上传模块等多个页面：`RuleManage.view.xml`、`FautRuleManage.view.xml`、`DataMaintain.view.xml` 等。

### 19.4 解决方案

在 `@ImportResource` 中显式导入 uploader 的 context，绕过 DoradoLoader 的自动发现机制：

```java
@ImportResource({
    "classpath*:com/cpic/fms/config/web/context.xml",
    "classpath:com/bstek/dorado/uploader/context.xml"   // ★新增
})
```

原理：
- `@ImportResource` 使用 Spring Boot 标准 classpath 扫描，不受 system scope 限制
- Spring 对 bean 定义的 `parent` 引用采用延迟解析，等 `DoradoLoader` 加载 `dorado-core` 注册好 `defaultComponentTypeRegister` 后，`UploadAction` 的 parent 引用自然解析成功

### 19.5 验证清单

- [x] `@ImportResource` 添加 `classpath:com/bstek/dorado/uploader/context.xml`
- [x] 重启应用，点击规则管理页面 → 不再报错
- [x] 其他 14 个使用 `UploadAction` 的页面正常访问
- [x] 文件上传功能正常

---

**文档结束**

> **注意**: 本文档为升级改造方案，具体实施时需根据实际情况调整。建议在开发环境充分测试后再进行生产环境升级。
