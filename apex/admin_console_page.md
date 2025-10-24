# APEX Admin Console Page (Template)

### Page 10 – Configuration Console

**Type:** Interactive Report

**Region Source:**
```sql
SELECT * FROM CFG_PARAM_EFFECTIVE_V
```

**Filters:**
- Tenant → :P0_TENANT_ID
- App → :APP_ID
- Category → :P0_CATEGORY

**Actions:**
- Edit Parameter → Modal form on CFG_PARAMETERS
- Add Override → Form on CFG_PARAM_OVERRIDES
- View Audit Trail → Report on CFG_PARAM_AUDIT

**Security:**
- Authorization Scheme: AIADMIN_ROLE

**Notes:**
Use `CFG_PARAM_V_MASKED.display_value` to mask secrets in reports.
