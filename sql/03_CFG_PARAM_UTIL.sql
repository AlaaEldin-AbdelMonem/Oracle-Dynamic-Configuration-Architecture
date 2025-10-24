CREATE OR REPLACE PACKAGE cfg_param_util AS
  FUNCTION get_value(
      p_param_name IN VARCHAR2,
      p_tenant_id  IN VARCHAR2,
      p_app_id     IN NUMBER,
      p_user_name  IN VARCHAR2 DEFAULT USER,
      p_roles      IN SYS.ODCIVARCHAR2LIST DEFAULT NULL,
      p_session_id IN VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','SESSIONID')
  ) RETURN VARCHAR2;

  FUNCTION get_number(p_param_name IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER) RETURN NUMBER;
  FUNCTION get_boolean(p_param_name IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER) RETURN BOOLEAN;
END cfg_param_util;
/

CREATE OR REPLACE PACKAGE BODY cfg_param_util AS
  FUNCTION get_value(
      p_param_name IN VARCHAR2,
      p_tenant_id  IN VARCHAR2,
      p_app_id     IN NUMBER,
      p_user_name  IN VARCHAR2 DEFAULT USER,
      p_roles      IN SYS.ODCIVARCHAR2LIST DEFAULT NULL,
      p_session_id IN VARCHAR2 DEFAULT SYS_CONTEXT('USERENV','SESSIONID')
  ) RETURN VARCHAR2
  RESULT_CACHE RELIES_ON (cfg_parameters, cfg_param_overrides)
  IS
      v_value VARCHAR2(4000);
      v_param_id NUMBER;
  BEGIN
      SELECT param_id INTO v_param_id
        FROM cfg_parameters
       WHERE param_name = p_param_name
         AND tenant_id = p_tenant_id
         AND app_id = p_app_id
         AND is_active = 'Y'
       FETCH FIRST 1 ROWS ONLY;

      BEGIN
        SELECT override_value INTO v_value FROM cfg_param_overrides
         WHERE param_id = v_param_id AND scope_type='SESSION' AND scope_value=p_session_id
           AND is_active='Y' AND (expiry_date IS NULL OR expiry_date>SYSDATE)
         FETCH FIRST 1 ROWS ONLY;
        RETURN v_value;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

      BEGIN
        SELECT override_value INTO v_value FROM cfg_param_overrides
         WHERE param_id=v_param_id AND scope_type='USER' AND scope_value=p_user_name
           AND is_active='Y' AND (expiry_date IS NULL OR expiry_date>SYSDATE)
         FETCH FIRST 1 ROWS ONLY;
        RETURN v_value;
      EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;

      IF p_roles IS NOT NULL THEN
        FOR i IN 1..p_roles.COUNT LOOP
          BEGIN
            SELECT override_value INTO v_value FROM cfg_param_overrides
             WHERE param_id=v_param_id AND scope_type='ROLE' AND scope_value=p_roles(i)
               AND is_active='Y' AND (expiry_date IS NULL OR expiry_date>SYSDATE)
             FETCH FIRST 1 ROWS ONLY;
            RETURN v_value;
          EXCEPTION WHEN NO_DATA_FOUND THEN NULL; END;
        END LOOP;
      END IF;

      SELECT param_value INTO v_value FROM cfg_parameters WHERE param_id=v_param_id;
      RETURN v_value;
  END get_value;

  FUNCTION get_number(p_param_name IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER) RETURN NUMBER IS
  BEGIN
    RETURN TO_NUMBER(get_value(p_param_name, p_tenant_id, p_app_id));
  END;

  FUNCTION get_boolean(p_param_name IN VARCHAR2, p_tenant_id IN VARCHAR2, p_app_id IN NUMBER) RETURN BOOLEAN IS
    v VARCHAR2(10);
  BEGIN
    v := UPPER(get_value(p_param_name, p_tenant_id, p_app_id));
    RETURN (v IN ('1','Y','TRUE','T','ON'));
  END;
END cfg_param_util;
/
