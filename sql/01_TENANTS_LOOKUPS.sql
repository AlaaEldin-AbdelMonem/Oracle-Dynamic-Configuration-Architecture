CREATE TABLE TENANTS (
    TENANT_ID        VARCHAR2(50) PRIMARY KEY,
    TENANT_NAME      VARCHAR2(200) NOT NULL,
    TENANT_DESC      VARCHAR2(500),
    IS_ACTIVE        CHAR(1) DEFAULT 'Y' CHECK (IS_ACTIVE IN ('Y','N')),
    CREATED_ON       DATE DEFAULT SYSDATE,
    CREATED_BY       VARCHAR2(100)
);

INSERT INTO TENANTS (TENANT_ID, TENANT_NAME, TENANT_DESC) VALUES
('MY_SAAS', 'My SaaS Platform', 'Primary tenant for testing');

CREATE TABLE LKP_PARAM_SCOPE_TYPE (
    SCOPE_TYPE VARCHAR2(10) PRIMARY KEY,
    DESCRIPTION VARCHAR2(200)
);

INSERT INTO LKP_PARAM_SCOPE_TYPE VALUES ('TENANT', 'Tenant-level configuration');
INSERT INTO LKP_PARAM_SCOPE_TYPE VALUES ('APP', 'Application-level configuration');
INSERT INTO LKP_PARAM_SCOPE_TYPE VALUES ('ROLE', 'Role-based configuration');
INSERT INTO LKP_PARAM_SCOPE_TYPE VALUES ('USER', 'User-level configuration');
INSERT INTO LKP_PARAM_SCOPE_TYPE VALUES ('SESSION', 'Session-level configuration');

CREATE TABLE LKP_PARAM_VALUE_TYPE (
    VALUE_TYPE VARCHAR2(15) PRIMARY KEY,
    DESCRIPTION VARCHAR2(100)
);

INSERT INTO LKP_PARAM_VALUE_TYPE VALUES ('STR', 'String');
INSERT INTO LKP_PARAM_VALUE_TYPE VALUES ('NUM', 'Numeric');
INSERT INTO LKP_PARAM_VALUE_TYPE VALUES ('BOOL', 'Boolean');
INSERT INTO LKP_PARAM_VALUE_TYPE VALUES ('JSON', 'JSON object');

   CREATE TABLE "LKP_PARAM_CATEGORY" 
   (	"CATEGORY_CODE" VARCHAR2(50), 
	"DESCRIPTION" VARCHAR2(200), 
	"CATEGORY_NAME" VARCHAR2(50), 
	"DISPLAY_ORDER" NUMBER DEFAULT 100 NOT NULL ENABLE, 
	"IS_ACTIVE" CHAR(1) DEFAULT 'Y' NOT NULL ENABLE, 
	 PRIMARY KEY ("CATEGORY_CODE")
  USING INDEX  ENABLE
   ) ;
/
INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('SYS',        'System Parameters',         'Core engine and system-wide behavior flags.', 1);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('APP',   'Application Defaults',      'App-level default values such as UI themes, pagination, or session timeout.', 2);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('SEC',      'Security & Access',         'Parameters controlling authentication, password policy, data redaction, etc.', 3);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('INT',   'Integration Settings',      'Endpoints, API keys, connectors, and third-party integration toggles.', 4);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('PERF',   'Performance & Tuning',      'Cache sizes, query limits, and runtime optimization flags.', 5);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('UI',            'User Interface',            'User-facing settings like color themes, layouts, or language settings.', 6);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('BUZ',      'Business Logic',            'Tenant or domain-specific functional parameters and rules.', 7);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('NTFT',  'Notification & Alerts',     'Email, SMS, and in-app notification preferences and templates.', 8);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('AI',            'AI / ML Features',          'AI-driven automation, model thresholds, or embedding settings.', 9);

INSERT INTO lkp_param_category (category_code, category_name, description, display_order) VALUES
('AUDIT',         'Audit & Logging',           'Logging levels, retention policies, and auditing configurations.', 10);
 
