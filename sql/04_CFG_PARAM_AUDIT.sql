CREATE TABLE CFG_PARAM_AUDIT (
    AUDIT_ID        NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    PARAM_ID        NUMBER,
    TENANT_ID       VARCHAR2(50),
    APP_ID          NUMBER,
    ACTION_TYPE     VARCHAR2(10) CHECK (ACTION_TYPE IN ('INSERT','UPDATE','DELETE')),
    OLD_VALUE       VARCHAR2(4000),
    NEW_VALUE       VARCHAR2(4000),
    IS_SECRET       CHAR(1),
    CHANGED_BY      VARCHAR2(100),
    CHANGED_ON      DATE DEFAULT SYSDATE
);

CREATE OR REPLACE TRIGGER trg_cfg_parameters_audit
AFTER INSERT OR UPDATE OR DELETE ON cfg_parameters
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO cfg_param_audit (param_id, tenant_id, app_id, action_type, new_value, is_secret, changed_by)
        VALUES (:NEW.param_id, :NEW.tenant_id, :NEW.app_id, 'INSERT',
                CASE WHEN :NEW.is_secret='Y' THEN '****' ELSE :NEW.param_value END,
                :NEW.is_secret, NVL(V('APP_USER'), USER));
    ELSIF UPDATING THEN
        INSERT INTO cfg_param_audit (param_id, tenant_id, app_id, action_type, old_value, new_value, is_secret, changed_by)
        VALUES (:NEW.param_id, :NEW.tenant_id, :NEW.app_id, 'UPDATE',
                CASE WHEN :OLD.is_secret='Y' THEN '****' ELSE :OLD.param_value END,
                CASE WHEN :NEW.is_secret='Y' THEN '****' ELSE :NEW.param_value END,
                :NEW.is_secret, NVL(V('APP_USER'), USER));
    ELSIF DELETING THEN
        INSERT INTO cfg_param_audit (param_id, tenant_id, app_id, action_type, old_value, is_secret, changed_by)
        VALUES (:OLD.param_id, :OLD.tenant_id, :OLD.app_id, 'DELETE',
                CASE WHEN :OLD.is_secret='Y' THEN '****' ELSE :OLD.param_value END,
                :OLD.is_secret, NVL(V('APP_USER'), USER));
    END IF;
END;
/

CREATE OR REPLACE VIEW CFG_PARAM_V_MASKED AS
SELECT p.param_id,
       p.param_name,
       CASE WHEN p.is_secret='Y' THEN '****' ELSE p.param_value END AS display_value,
       p.tenant_id, p.app_id, p.category_code, p.is_active, p.is_secret,
       p.last_updated_by, p.last_updated_on
  FROM cfg_parameters p;
