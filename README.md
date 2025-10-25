# Oracle Dynamic Configuration Architecture

A governed, hierarchical configuration architecture for Oracle Database 23ai and APEX 24.2+, enabling dynamic runtime configuration across tenants, apps, roles, users, and sessions — without redeployment.

**Repository:** Oracle-Dynamic-Configuration-Architecture

 
### 🧭Architecture High-Level Overview

![High Level Architecture](/docs/Architecture-Overview–High-Level.png)

---

## 🧠 Overview

A **generic, multi-tenant, and flexible configuration framework** built natively for **Oracle Database **.

It enables any SaaS solution (ERP, CRM, HR, Learning, Analytics, etc.) to manage configuration parameters — feature flags, integration endpoints, UI behaviors, or limits — centrally and securely, without code changes or redeployments.

---



## 📚 Documentation

- 📘 [Business Case](docs/BUSINESS_CASE.md)
- 🧱 [Architecture Overview](docs/CONFIG_FRAMEWORK_OVERVIEW.md)
- 🧾 [Changelog](docs/CHANGELOG.md)
  
  

## ⚙️ Hierarchy

```
TENANT → APP → ROLE → [USER] → [SESSION]
```

- `USER` and `SESSION` are optional personalization/debug layers.

---

## 💡 Designed For

- Oracle-based SaaS platforms
- Multi-tenant enterprise products
- Configurable micro-SaaS modules
- Organizations seeking runtime flexibility + governance

---

## 🧱 Core Features

| Category               | Capability                                         |
| ---------------------  | ------------------------------------------------- |
| 🏢 Multi-Tenant        | Per-tenant and per-app configuration isolation    |
| ⚙️ Flexible Hierarchy  | Tenant → App → Role → User → Session              |
| ⚡ High Performance    | Composite indexes + PL/SQL result cache           |
| 🔐 Secure              | Secret masking + auditing of changes              |
| 🧩 Modular             | 5 SQL scripts + 1 API package for easy deployment |
| 🧾 APEX Integration    | Interactive admin console ready                   |
| 🧮 SaaS-Ready          | Governance, isolation, and extensibility          |

---

## 🧰 Components

| File                              | Description                       |
| --------------------------------- | --------------------------------- |
| `/sql/01_TENANTS_LOOKUPS.sql`     | Tenant registry and lookup tables |
| `/sql/02_CFG_PARAMETERS.sql`      | Core parameter & override tables  |
| `/sql/03_CFG_PARAM_UTIL_PKG.sql`  | Unified retrieval API (package)   |
| `/sql/04_CFG_PARAM_AUDIT.sql`     | Auditing + masking triggers       |
| `/sql/05_CFG_PARAM_APEX_VIEW.sql` | APEX view + Interactive Report    |
| `/examples/usage_demo.md`         | Practical usage examples          |

---

## 🚀 Quick Install

```bash
sqlplus <dbuser>@<yourdb>
@sql/01_TENANTS_LOOKUPS.sql
@sql/02_CFG_PARAMETERS.sql
@sql/03_CFG_PARAM_UTIL_PKG.sql
@sql/04_CFG_PARAM_AUDIT.sql
@sql/05_CFG_PARAM_APEX_VIEW.sql
@examples/seed_data.sql
```

---

## 🔍 Example Usage

```sql
SELECT cfg_param_util.get_value(
         p_param_name => 'DEFAULT_THEME',
         p_tenant_id  => 'MY_SAAS',
         p_app_id     => 100
       ) AS theme_name
FROM dual;
```

---

## 🧩 APEX Integration

Use the view `CFG_PARAM_EFFECTIVE_V` as the data source for an Interactive Report in your admin console.  
Secrets are displayed as `****` through `CFG_PARAM_V_MASKED`.

---

## 🧑‍💼 Author

**Alaaeldin Abdelmonem**  
AI Technical Product Manager / Oracle Solutions Architect  
[GitHub @AlaaEldin-AbdelMonem](https://github.com/AlaaEldin-AbdelMonem)

[ALAAELDIN ABDELMONEIM | LinkedIn](https://www.linkedin.com/in/alaa-eldin/)

---

## 🪪 License

Licensed under the [MIT License](LICENSE)

---

## 🧾 Changelog Summary

- v1.0.0 – Initial release: multi-tenant hierarchy
