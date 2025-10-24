# Usage Demo – Oracle Flexible Configuration Framework

### Example 1: Retrieve a parameter value
```sql
SELECT cfg_param_util.get_value(
         p_param_name => 'DEFAULT_THEME',
         p_tenant_id  => 'MY_SAAS',
         p_app_id     => 100
       ) AS theme_name
FROM dual;
```

### Example 2: Boolean parameter
```sql
SELECT cfg_param_util.get_boolean(
         p_param_name => 'ENABLE_LOGGING',
         p_tenant_id  => 'MY_SAAS',
         p_app_id     => 100
       ) AS is_logging_enabled
FROM dual;
```

### Example 3: Override value by user or role
```sql
INSERT INTO cfg_param_overrides (param_id, tenant_id, app_id, scope_type, scope_value, override_value)
SELECT param_id, 'MY_SAAS', 100, 'ROLE', 'ADMIN', 'DARK'
  FROM cfg_parameters
 WHERE param_name = 'DEFAULT_THEME';
COMMIT;
```
