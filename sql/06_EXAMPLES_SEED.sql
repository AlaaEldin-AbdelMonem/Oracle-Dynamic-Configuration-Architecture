INSERT INTO cfg_parameters (tenant_id, app_id, param_name, param_value, category_code, value_type, description)
VALUES ('MY_SAAS', 100, 'DEFAULT_THEME', 'LIGHT', 'SYS', 'STR', 'Default UI theme');

INSERT INTO cfg_parameters (tenant_id, app_id, param_name, param_value, category_code, value_type, description)
VALUES ('MY_SAAS', 100, 'MAX_RECORDS', '500', 'SYS', 'NUM', 'Pagination limit');

COMMIT;
