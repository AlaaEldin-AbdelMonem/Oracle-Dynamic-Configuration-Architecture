 CREATE OR REPLACE VIEW CFG_PARAM_EFFECTIVE_V AS
SELECT p.param_id,
       p.tenant_id,
       p.app_id,
       p.param_name,
       cfg_param_util.get_value(p.param_name, p.tenant_id, p.app_id) AS effective_value,
       p.value_type,
       p.category_code,
       p.is_secret,
       p.is_active,
       p.description,
       p.last_updated_by,
       p.last_updated_on
FROM cfg_parameters p
WHERE p.is_active = 'Y';
