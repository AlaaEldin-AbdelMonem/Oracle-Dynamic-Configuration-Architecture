  CREATE TABLE "CFG_PARAM_AUDIT" 
   (	"AUDIT_ID" NUMBER GENERATED GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	"PARAM_ID" NUMBER NOT NULL ENABLE, 
	"TENANT_ID" VARCHAR2(100), 
	"APP_ID" NUMBER, 
	"ACTION_TYPE" VARCHAR2(30) NOT NULL ENABLE, 
	"OLD_VALUE" VARCHAR2(4000), 
	"NEW_VALUE" VARCHAR2(4000), 
	"IS_SECRET" CHAR(1) DEFAULT 'N', 
	"CHANGED_BY" VARCHAR2(200) DEFAULT USER, 
	"CHANGED_ON" DATE DEFAULT SYSDATE, 
	"REMARKS" VARCHAR2(1000), 
	 CHECK (is_secret IN ('Y','N')) ENABLE, 
	 PRIMARY KEY ("AUDIT_ID")
  USING INDEX  ENABLE
   ) ;
/
  ALTER TABLE "CFG_PARAM_AUDIT" ADD CONSTRAINT "FK_AUDIT_PARAM" FOREIGN KEY ("PARAM_ID") REFERENCES "CFG_PARAMETERS" ("PARAM_ID") ON DELETE CASCADE ENABLE;

  CREATE INDEX "IDX_CFG_AUDIT_DATE" ON "CFG_PARAM_AUDIT" ("CHANGED_ON");
  CREATE INDEX "IDX_CFG_AUDIT_PARAM" ON "CFG_PARAM_AUDIT" ("PARAM_ID");
  CREATE INDEX "IDX_CFG_AUDIT_TENANT" ON "CFG_PARAM_AUDIT" ("TENANT_ID", "APP_ID");
/
    
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
