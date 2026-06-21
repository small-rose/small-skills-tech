# Dorado Resources目录说明

> **文档版本**: v1.0  
> **生成时间**: 2026年6月19日  
> **适用场景**: Spring Boot升级过程中Dorado资源文件处理

---

## 目录

1. [Resources目录文件分析](#1-resources目录文件分析)
2. [Dorado国际化机制说明](#2-dorado国际化机制说明)
3. [升级处理方案](#3-升级处理方案)
4. [验证方法](#4-验证方法)

---

## 1. Resources目录文件分析

### 1.1 文件清单

```
src/main/webapp/WEB-INF/dorado-home/resources/
├── Address.zh_CN.properties
├── Agent.zh_CN.properties
├── BankAccount.zh_CN.properties
├── Certificate.zh_CN.properties
├── Contact.zh_CN.properties
├── Customer.zh_CN.properties
├── Department.zh_CN.properties
├── Employee.zh_CN.properties
├── Hobby.zh_CN.properties
├── Hospital.zh_CN.properties
├── Operator.zh_CN.properties
├── Organization.zh_CN.properties
├── OrganizationParam.zh_CN.properties
├── Other.zh_CN.properties
├── Party.zh_CN.properties
├── Person.zh_CN.properties
├── PersonParams.zh_CN.properties
├── PersonSolr.zh_CN.properties
├── Rescuer.zh_CN.properties
└── ThirdOrganization.zh_CN.properties
```

### 1.2 文件内容示例

以`Customer.zh_CN.properties`为例：
```properties
orgCode=\u673A\u6783\u4EE3\u7801        # 机构代码
orgName=\u673A\u6783\u540D\u79F0        # 机构名称
customerCode=\u5BA2\u6237\u7F16\u7801    # 客户编码
customerName=\u5BA2\u6237\u540D\u79F0    # 客户名称
```

### 1.3 文件性质判定

| 特征 | 分析结果 |
|------|----------|
| 文件命名 | `{Entity}.zh_CN.properties` 格式 |
| 文件内容 | 实体字段的中文描述 |
| 所在目录 | `dorado-home/resources/` |
| **结论** | **Dorado框架数据模型国际化文件** |

---

## 2. Dorado国际化机制说明

### 2.1 Dorado国际化 vs Spring国际化

| 对比项 | Dorado国际化 | Spring国际化 |
|--------|-------------|-------------|
| 用途 | 数据模型字段描述 | 页面/消息国际化 |
| 加载方式 | Dorado框架自动加载 | MessageSource加载 |
| 文件位置 | `dorado-home/resources/` | `classpath:` 下 |
| 命名规则 | `{Entity}.zh_CN.properties` | `{bundle}.zh_CN.properties` |
| 使用场景 | Grid列头、表单标签 | 错误消息、页面文本 |

### 2.2 Dorado如何加载这些文件

Dorado框架通过`DoradoServlet`初始化时自动加载`dorado-home/resources/`目录下的国际化文件：

1. **初始化阶段**：`DoradoServlet.init()` → 加载`configure.properties`
2. **资源发现**：扫描`dorado-home/resources/`目录
3. **文件加载**：按命名规则加载`{Entity}.zh_CN.properties`
4. **缓存使用**：在View渲染时使用这些资源描述字段

### 2.3 这些文件的作用

这些文件用于Dorado数据模型的**字段描述**，例如：

```java
// 在Dorado View中定义DataPath时
<DataPath name="customerName" label="#{Customer.customerName}"/>
// #{Customer.customerName} 会从 Customer.zh_CN.properties 中获取 "客户名称"
```

---

## 3. 升级处理方案

### 3.1 处理策略：**保持原位，无需迁移**

**原因**：
1. 这些文件由Dorado框架自动加载，不依赖Spring的ResourceBundleMessageSource
2. Dorado框架会根据`configure.properties`中的配置自动扫描`dorado-home/`目录
3. 迁移位置可能导致Dorado框架无法正确加载

### 3.2 不需要迁移的原因

| 考虑因素 | 分析 |
|----------|------|
| Dorado框架加载机制 | 基于`dorado-home`相对路径扫描 |
| Spring Boot兼容性 | WAR部署时webapp目录结构保持不变 |
| 内嵌Tomcat启动 | 通过`file:`路径仍可访问 |
| 代码改动量 | 零改动，风险最低 |

### 3.3 目录结构保持

```
src/main/webapp/WEB-INF/dorado-home/
├── application-context.xml      # Spring配置
├── configure.properties         # Dorado配置
├── resources/                   # Dorado国际化文件（保持原位）
│   ├── Customer.zh_CN.properties
│   ├── Person.zh_CN.properties
│   └── ...
└── ...
```

### 3.4 Maven资源复制配置（可选）

如果希望将这些文件也放入classpath（**非必须**），可以在`pom.xml`中添加：

```xml
<resources>
    <!-- 原有配置 -->
    <resource>
        <directory>src/main/resources</directory>
    </resource>
    <!-- 复制dorado-home下的XML配置 -->
    <resource>
        <directory>src/main/webapp/WEB-INF/dorado-home</directory>
        <targetPath>dorado-home</targetPath>
        <includes>
            <include>**/*.xml</include>
            <include>**/*.properties</include>
        </includes>
    </resource>
</resources>
```

**注意**：此配置会将`resources/`子目录下的properties文件也复制到classpath，但Dorado框架默认仍从webapp目录加载。

---

## 4. 验证方法

### 4.1 启动验证

应用启动后，在日志中搜索以下信息：

```
DoradoServlet initialized
Loading data type resources from: dorado-home/resources/
```

### 4.2 功能验证

1. **访问Dorado View页面**
2. **查看Grid列头**：是否显示中文字段名
3. **查看表单标签**：是否显示中文标签

### 4.3 问题排查

如果国际化失效，检查以下配置：

1. **configure.properties**中是否有Dorado资源路径配置
2. **DoradoServlet**是否正确初始化
3. **resources目录**是否在`dorado-home`下

---

## 5. 相关配置文件说明

### 5.1 configure.properties（Dorado配置）

```properties
core.runMode=debug
model.root=classpath*:models
view.root=classpath:
view.javaScript.charset=UTF-8
view.skin=lan
```

**说明**：
- `model.root`：数据模型定义位置
- `view.root`：View文件位置
- 这些配置决定了Dorado框架的资源扫描路径

### 5.2 与Spring国际化文件的区别

| 文件类型 | 位置 | 用途 | 加载方式 |
|----------|------|------|----------|
| Dorado国际化 | `dorado-home/resources/*.zh_CN.properties` | 数据模型字段描述 | DoradoServlet |
| Spring国际化 | `classpath:messages*.properties` | 页面消息/错误提示 | MessageSource |

---

## 6. 总结

### 6.1 处理建议

| 文件类型 | 处理方式 | 是否迁移 |
|----------|---------|----------|
| `dorado-home/resources/*.zh_CN.properties` | 保持原位 | **否** |

### 6.2 关键结论

1. **这些文件是Dorado框架的国际化文件**，不是Spring的MessageSource文件
2. **由DoradoServlet自动加载**，不依赖Spring配置
3. **保持原位不动**，无需迁移到classpath
4. **零代码改动**，升级风险最低

### 6.3 完整的webapp目录处理清单

| 目录/文件 | 处理方式 | 说明 |
|-----------|---------|------|
| `webapp/*.html` | 保留 | HTML页面 |
| `webapp/*.jsp` | 保留 | JSP页面 |
| `webapp/WEB-INF/web.xml` | 保留 | Web描述符 |
| `webapp/WEB-INF/dorado-home/*.xml` | 保留+复制到classpath | Spring XML配置 |
| `webapp/WEB-INF/dorado-home/*.properties` | 保留+复制到classpath | Dorado配置 |
| `webapp/WEB-INF/dorado-home/resources/*.properties` | **保留原位** | Dorado国际化 |

---

**文档结束**
