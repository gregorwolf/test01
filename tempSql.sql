
CREATE TABLE Environments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  description NVARCHAR(5000),
  parent_ID NVARCHAR(36),
  type_code NVARCHAR(5000) DEFAULT 'ENV_VER',
  PRIMARY KEY(ID),
  CONSTRAINT c__Environments_type
  FOREIGN KEY(type_code)
  REFERENCES EnvironmentTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Environments_environment UNIQUE (environment, version),
  CONSTRAINT Environments_environmentDescription UNIQUE (description, version)
);

CREATE TABLE EnvironmentTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ENV_VER',
  PRIMARY KEY(code)
);

CREATE TABLE CuProcesses (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  type_code NVARCHAR(5000) DEFAULT 'SIMULATION',
  state_code NVARCHAR(5000) DEFAULT '',
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcesses_type
  FOREIGN KEY(type_code)
  REFERENCES CuProcessTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcesses_state
  FOREIGN KEY(state_code)
  REFERENCES CuProcessStates(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivities (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity NVARCHAR(5000),
  parent_ID NVARCHAR(36),
  sequence INTEGER,
  activityType_code NVARCHAR(5000) DEFAULT 'IO',
  activityState_code NVARCHAR(5000) DEFAULT 'OPEN',
  function_ID NVARCHAR(36),
  startDate NVARCHAR(5000),
  endDate NVARCHAR(5000),
  url NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivities_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivities_parent
  FOREIGN KEY(parent_ID)
  REFERENCES CuProcessActivities(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivities_activityType
  FOREIGN KEY(activityType_code)
  REFERENCES CuProcessActivityTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivities_activityState
  FOREIGN KEY(activityState_code)
  REFERENCES CuProcessActivityStates(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivityPerformerTeams (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  team_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivityPerformerTeams_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityPerformerTeams_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CuProcessActivities(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityPerformerTeams_team
  FOREIGN KEY(team_ID)
  REFERENCES Teams(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivityReviewerTeams (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  team_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivityReviewerTeams_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityReviewerTeams_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CuProcessActivities(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityReviewerTeams_team
  FOREIGN KEY(team_ID)
  REFERENCES Teams(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivityComments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  comment NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivityComments_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityComments_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CuProcessActivities(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivityCommentAttachments (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  comment_ID NVARCHAR(36),
  name NVARCHAR(5000),
  file BLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivityCommentAttachments_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityCommentAttachments_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CuProcessActivities(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityCommentAttachments_comment
  FOREIGN KEY(comment_ID)
  REFERENCES CuProcessActivityComments(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessActivityLinks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  previousActivity_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessActivityLinks_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityLinks_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CuProcessActivities(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessActivityLinks_previousActivity
  FOREIGN KEY(previousActivity_ID)
  REFERENCES CuProcessActivities(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessReports (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  report NVARCHAR(5000),
  sequence INTEGER,
  description NVARCHAR(5000),
  content NCLOB,
  calculationCode NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessReports_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessReportElements (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  report_ID NVARCHAR(36),
  element NVARCHAR(5000),
  description NVARCHAR(5000),
  content NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CuProcessReportElements_process
  FOREIGN KEY(process_ID)
  REFERENCES CuProcesses(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CuProcessReportElements_report
  FOREIGN KEY(report_ID)
  REFERENCES CuProcessReports(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CuProcessTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'SIMULATION',
  PRIMARY KEY(code)
);

CREATE TABLE CuProcessStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE CuProcessActivityTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'IO',
  PRIMARY KEY(code)
);

CREATE TABLE CuProcessActivityStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(code)
);

CREATE TABLE SXP0012__CURRENCIES (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  symbol NVARCHAR(5),
  decimalPlaces INTEGER,
  PRIMARY KEY(code)
);

CREATE TABLE SXP0012__UNITS (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL DEFAULT 'PC',
  symbol NVARCHAR(5),
  decimalPlaces INTEGER,
  PRIMARY KEY(code)
);

CREATE TABLE SXP0012_MTAC (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  AC NVARCHAR(10) NOT NULL DEFAULT '1234',
  _DESCR NVARCHAR(255) DEFAULT 'Test',
  _LOCALE NVARCHAR(14) DEFAULT 'en',
  _IS_NODE BOOLEAN DEFAULT FALSE,
  _HIER_NAME NVARCHAR(5000) DEFAULT '',
  PARENT NVARCHAR(10),
  _SEQUENCE NVARCHAR(5000) DEFAULT 0,
  PRIMARY KEY(AC)
);

CREATE TABLE SXP0012_MTCC (
  CC NVARCHAR(10) NOT NULL,
  NAME NVARCHAR(255),
  PRIMARY KEY(CC)
);

CREATE TABLE SXP0012_MT01 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  FACTOR DECIMAL,
  CURRENCY_code NVARCHAR(3),
  AMOUNT DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_MT01_CURRENCY
  FOREIGN KEY(CURRENCY_code)
  REFERENCES SXP0012__CURRENCIES(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SXP0012_MT02 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  AC_AC NVARCHAR(10) DEFAULT '1234',
  UNIT_code NVARCHAR(3) DEFAULT 'PC',
  QUANTITY DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_MT02_UNIT
  FOREIGN KEY(UNIT_code)
  REFERENCES SXP0012__UNITS(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SXP0012_JO01 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  AC_AC NVARCHAR(10) DEFAULT '1234',
  CURRENCY_code NVARCHAR(3),
  AMOUNT DECIMAL,
  UNIT_code NVARCHAR(3) DEFAULT 'PC',
  QUANTITY DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_JO01_CURRENCY
  FOREIGN KEY(CURRENCY_code)
  REFERENCES SXP0012__CURRENCIES(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__SXP0012_JO01_UNIT
  FOREIGN KEY(UNIT_code)
  REFERENCES SXP0012__UNITS(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SXP0012_CA01 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  AC_AC NVARCHAR(10) DEFAULT '1234',
  CURRENCY_code NVARCHAR(3),
  AMOUNT DECIMAL,
  UNIT_code NVARCHAR(3) DEFAULT 'PC',
  QUANTITY DECIMAL,
  SUM DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_CA01_CURRENCY
  FOREIGN KEY(CURRENCY_code)
  REFERENCES SXP0012__CURRENCIES(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__SXP0012_CA01_UNIT
  FOREIGN KEY(UNIT_code)
  REFERENCES SXP0012__UNITS(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SXP0012_DE01 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  AC_AC NVARCHAR(10) DEFAULT '1234',
  CURRENCY_code NVARCHAR(3),
  AMOUNT DECIMAL,
  UNIT_code NVARCHAR(3) DEFAULT 'PC',
  QUANTITY DECIMAL,
  SUM DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_DE01_CURRENCY
  FOREIGN KEY(CURRENCY_code)
  REFERENCES SXP0012__CURRENCIES(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__SXP0012_DE01_UNIT
  FOREIGN KEY(UNIT_code)
  REFERENCES SXP0012__UNITS(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE SXP0012_AL01 (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36),
  _STATE NVARCHAR(5000) DEFAULT 'S=OK',
  CC_CC NVARCHAR(10),
  PC NVARCHAR(10),
  AC_AC NVARCHAR(10) DEFAULT '1234',
  CURRENCY_code NVARCHAR(3),
  AMOUNT DECIMAL,
  UNIT_code NVARCHAR(3) DEFAULT 'PC',
  QUANTITY DECIMAL,
  SUM DECIMAL,
  PRIMARY KEY(_ID),
  CONSTRAINT c__SXP0012_AL01_CURRENCY
  FOREIGN KEY(CURRENCY_code)
  REFERENCES SXP0012__CURRENCIES(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__SXP0012_AL01_UNIT
  FOREIGN KEY(UNIT_code)
  REFERENCES SXP0012__UNITS(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE MessageTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE Orders (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Signs (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE Options (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(2) NOT NULL DEFAULT 'EQ',
  PRIMARY KEY(code)
);

CREATE TABLE ResultHandlings (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENRICHED',
  PRIMARY KEY(code)
);

CREATE TABLE Fields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000),
  class_code NVARCHAR(5000) DEFAULT '',
  type_code NVARCHAR(5000) DEFAULT 'CHA',
  hanaDataType_code NVARCHAR(5000) DEFAULT 'NVARCHAR',
  dataLength INTEGER DEFAULT 16,
  dataDecimals INTEGER DEFAULT 0,
  unitField_ID NVARCHAR(36),
  isLowercase BOOLEAN DEFAULT TRUE,
  hasMasterData BOOLEAN DEFAULT FALSE,
  hasHierarchies BOOLEAN DEFAULT FALSE,
  calculationHierarchy_ID NVARCHAR(36),
  masterDataQuery_ID NVARCHAR(36),
  description NVARCHAR(5000),
  documentation NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__Fields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_class
  FOREIGN KEY(class_code)
  REFERENCES FieldClasses(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_type
  FOREIGN KEY(type_code)
  REFERENCES FieldTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_hanaDataType
  FOREIGN KEY(hanaDataType_code)
  REFERENCES HanaDataTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Fields_calculationHierarchy
  FOREIGN KEY(calculationHierarchy_ID)
  REFERENCES FieldHierarchies(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Fields_fieldname UNIQUE (environment_ID, field),
  CONSTRAINT Fields_fieldDescription UNIQUE (environment_ID, description)
);

CREATE TABLE FieldValues (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  value NVARCHAR(5000),
  isNode BOOLEAN,
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldValues_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValues_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldValueAuthorizations (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  value_ID NVARCHAR(36),
  userGrp NVARCHAR(5000),
  readAccess BOOLEAN,
  writeAccess BOOLEAN,
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldValueAuthorizations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValueAuthorizations_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldValueAuthorizations_value
  FOREIGN KEY(value_ID)
  REFERENCES FieldValues(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldHierarchies (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  hierarchy NVARCHAR(5000),
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldHierarchies_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchies_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldHierarchyStructures (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  sequence INTEGER,
  hierarchy_ID NVARCHAR(36),
  value_ID NVARCHAR(36),
  parentValue_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__FieldHierarchyStructures_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_hierarchy
  FOREIGN KEY(hierarchy_ID)
  REFERENCES FieldHierarchies(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_value
  FOREIGN KEY(value_ID)
  REFERENCES FieldValues(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__FieldHierarchyStructures_parentValue
  FOREIGN KEY(parentValue_ID)
  REFERENCES FieldValues(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE FieldClasses (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE FieldTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(code)
);

CREATE TABLE HanaDataTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'NVARCHAR',
  PRIMARY KEY(code)
);

CREATE TABLE Checks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000),
  messageType_code NVARCHAR(1) DEFAULT 'I',
  category_code NVARCHAR(10) DEFAULT '',
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__Checks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Checks_messageType
  FOREIGN KEY(messageType_code)
  REFERENCES MessageTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Checks_category
  FOREIGN KEY(category_code)
  REFERENCES CheckCategories(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Checks_checkDescription UNIQUE (environment_ID, description)
);

CREATE TABLE CheckFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  check_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CheckFields_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CheckSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  sequence INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  option_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CheckSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckSelections_option
  FOREIGN KEY(option_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES CheckFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CheckCategories (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE CurrencyConversions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  currencyConversion NVARCHAR(5000),
  description NVARCHAR(5000),
  category_code NVARCHAR(5000) DEFAULT 'CURRENCY',
  method_code NVARCHAR(5000) DEFAULT 'ERP',
  bidAskType_code NVARCHAR(5000) DEFAULT 'MID',
  marketDataArea NVARCHAR(5000),
  type NVARCHAR(5000),
  lookup_code NVARCHAR(5000) DEFAULT 'Regular',
  errorHandling_code NVARCHAR(5000) DEFAULT 'fail on error',
  accuracy_code NVARCHAR(5000) DEFAULT '',
  dateFormat_code NVARCHAR(5000) DEFAULT 'auto detect',
  steps_code NVARCHAR(5000) DEFAULT 'shift,convert',
  configurationConnection_ID NVARCHAR(36),
  rateConnection_ID NVARCHAR(36),
  prefactorConnection_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CurrencyConversions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_category
  FOREIGN KEY(category_code)
  REFERENCES ConversionCategories(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_method
  FOREIGN KEY(method_code)
  REFERENCES ConversionMethods(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_bidAskType
  FOREIGN KEY(bidAskType_code)
  REFERENCES ConversionBidAskTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_lookup
  FOREIGN KEY(lookup_code)
  REFERENCES ConversionLookups(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_errorHandling
  FOREIGN KEY(errorHandling_code)
  REFERENCES ConversionErrorHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_accuracy
  FOREIGN KEY(accuracy_code)
  REFERENCES ConversionAccuracies(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_dateFormat
  FOREIGN KEY(dateFormat_code)
  REFERENCES ConversionDateFormats(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_steps
  FOREIGN KEY(steps_code)
  REFERENCES ConversionSteps(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_configurationConnection
  FOREIGN KEY(configurationConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_rateConnection
  FOREIGN KEY(rateConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CurrencyConversions_prefactorConnection
  FOREIGN KEY(prefactorConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE UnitConversions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  unitConversion NVARCHAR(5000),
  description NVARCHAR(5000),
  errorHandling_code NVARCHAR(5000) DEFAULT 'fail on error',
  rateConnection_ID NVARCHAR(36),
  dimensionConnection_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__UnitConversions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_errorHandling
  FOREIGN KEY(errorHandling_code)
  REFERENCES ConversionErrorHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_rateConnection
  FOREIGN KEY(rateConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__UnitConversions_dimensionConnection
  FOREIGN KEY(dimensionConnection_ID)
  REFERENCES Connections(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ConversionCategories (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CURRENCY',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionMethods (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ERP',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionBidAskTypes (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'MID',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionLookups (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'Regular',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionErrorHandlings (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'fail on error',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionAccuracies (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionDateFormats (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'auto detect',
  PRIMARY KEY(code)
);

CREATE TABLE ConversionSteps (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  code NVARCHAR(5000) NOT NULL DEFAULT 'shift,convert',
  PRIMARY KEY(code)
);

CREATE TABLE Partitions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  "partition" NVARCHAR(5000),
  description NVARCHAR(5000),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Partitions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Partitions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Partitions_partition UNIQUE (environment_ID, "partition"),
  CONSTRAINT Partitions_partitionDescription UNIQUE (environment_ID, description)
);

CREATE TABLE PartitionRanges (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  partition_ID NVARCHAR(36),
  "range" NVARCHAR(5000),
  sequence INTEGER,
  level INTEGER DEFAULT 0,
  value NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__PartitionRanges_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__PartitionRanges_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Functions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000),
  sequence INTEGER DEFAULT 10,
  parent_ID NVARCHAR(36),
  type_code NVARCHAR(10) DEFAULT 'MT',
  description NVARCHAR(5000),
  documentation NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__Functions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Functions_type
  FOREIGN KEY(type_code)
  REFERENCES FunctionTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Functions_function UNIQUE (environment_ID, function),
  CONSTRAINT Functions_functionDescription UNIQUE (environment_ID, description)
);

CREATE TABLE FunctionTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'MT',
  PRIMARY KEY(code)
);

CREATE TABLE FunctionProcessingTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE FunctionBusinessEventTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE Teams (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  name NVARCHAR(5000),
  description NVARCHAR(5000),
  obsolete BOOLEAN,
  PRIMARY KEY(ID),
  CONSTRAINT Teams_teamsName UNIQUE (name),
  CONSTRAINT Teams_teamsDescription UNIQUE (description)
);

CREATE TABLE TeamUsers (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  team_ID NVARCHAR(36),
  user_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__TeamUsers_team
  FOREIGN KEY(team_ID)
  REFERENCES Teams(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__TeamUsers_user
  FOREIGN KEY(user_ID)
  REFERENCES Users(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE Users (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  anonymized BOOLEAN,
  PRIMARY KEY(ID)
);

CREATE TABLE UserIdentities (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  user_ID NVARCHAR(36),
  provider NVARCHAR(5000),
  identity NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__UserIdentities_user
  FOREIGN KEY(user_ID)
  REFERENCES Users(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE UserProfiles (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  user_ID NVARCHAR(36),
  eMail NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__UserProfiles_user
  FOREIGN KEY(user_ID)
  REFERENCES Users(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE TABLE_COLUMNS (
  SCHEMA_NAME NVARCHAR(256),
  TABLE_NAME NVARCHAR(256),
  TABLE_OID BIGINT,
  COLUMN_NAME NVARCHAR(256),
  POSITION INTEGER,
  DATA_TYPE_ID SMALLINT,
  DATA_TYPE_NAME NVARCHAR(16),
  "OFFSET" SMALLINT,
  LENGTH INTEGER,
  SCALE INTEGER,
  IS_NULLABLE NVARCHAR(5),
  DEFAULT_VALUE NVARCHAR(5000),
  COMMENTS NVARCHAR(5000)
);

CREATE TABLE VIEW_COLUMNS (
  SCHEMA_NAME NVARCHAR(256),
  VIEW_NAME NVARCHAR(256),
  VIEW_OID BIGINT,
  COLUMN_NAME NVARCHAR(256),
  POSITION INTEGER,
  DATA_TYPE_ID SMALLINT,
  DATA_TYPE_NAME NVARCHAR(16),
  "OFFSET" SMALLINT,
  LENGTH INTEGER,
  SCALE INTEGER,
  IS_NULLABLE NVARCHAR(5),
  DEFAULT_VALUE NVARCHAR(5000),
  COMMENTS NVARCHAR(5000)
);

CREATE TABLE Connections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  connection NVARCHAR(5000),
  description NVARCHAR(5000),
  source_code NVARCHAR(10) DEFAULT 'HANA_VIEW',
  hanaTable NVARCHAR(5000),
  hanaView NVARCHAR(5000),
  odataUrl NVARCHAR(5000),
  odataUrlOptions NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__Connections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Connections_source
  FOREIGN KEY(source_code)
  REFERENCES ConnectionSources(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT Connections_connectionDescription UNIQUE (environment_ID, description)
);

CREATE TABLE ConnectionSources (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'HANA_VIEW',
  PRIMARY KEY(code)
);

CREATE TABLE RuntimeFunctions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  function NVARCHAR(5000),
  description NVARCHAR(5000),
  type_code NVARCHAR(10) DEFAULT 'MT',
  state_code NVARCHAR(10) DEFAULT 'CHECKED',
  processingType_code NVARCHAR(10) DEFAULT '',
  businessEventType_code NVARCHAR(10) DEFAULT '',
  partition_ID NVARCHAR(36),
  storedProcedure NVARCHAR(5000),
  appServerStatement NCLOB,
  preStatement NCLOB,
  statement NCLOB,
  postStatement NCLOB,
  hanaTable NVARCHAR(5000),
  hanaView NVARCHAR(5000),
  synonym NVARCHAR(5000),
  masterDataHierarchyView NVARCHAR(5000),
  calculationView NVARCHAR(5000),
  workBook NCLOB,
  resultModelTable_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeFunctions_type
  FOREIGN KEY(type_code)
  REFERENCES FunctionTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFunctions_state
  FOREIGN KEY(state_code)
  REFERENCES RuntimeFunctionStates(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFunctions_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFunctions_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFunctions_partition
  FOREIGN KEY(partition_ID)
  REFERENCES RuntimePartitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFunctions_resultModelTable
  FOREIGN KEY(resultModelTable_ID)
  REFERENCES RuntimeFunctions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeShareLocks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  function_ID NVARCHAR(36),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  partitionField_ID NVARCHAR(36),
  partitionFieldRangeValue NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeShareLocks_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeShareLocks_partitionField
  FOREIGN KEY(partitionField_ID)
  REFERENCES RuntimeFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeOutputFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  function_ID NVARCHAR(36),
  field NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeOutputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeProcessChains (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  function_ID NVARCHAR(36),
  level INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeProcessChains_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeProcessChainFunctions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  processChain_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeProcessChainFunctions_processChain
  FOREIGN KEY(processChain_ID)
  REFERENCES RuntimeProcessChains(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeProcessChainFunctions_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeInputFunctions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  function_ID NVARCHAR(36),
  inputFunction_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeInputFunctions_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeInputFunctions_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES RuntimeFunctions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimePartitions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  "partition" NVARCHAR(5000),
  description NVARCHAR(5000),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimePartitions_field
  FOREIGN KEY(field_ID)
  REFERENCES RuntimeFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimePartitionRanges (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  partition_ID NVARCHAR(36),
  "range" NVARCHAR(5000),
  sequence INTEGER,
  level INTEGER DEFAULT 0,
  value NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimePartitionRanges_partition
  FOREIGN KEY(partition_ID)
  REFERENCES RuntimePartitions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE RuntimeFunctionStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'CHECKED',
  PRIMARY KEY(code)
);

CREATE TABLE ApplicationLogs (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  run NVARCHAR(36),
  type NVARCHAR(5000),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  mainFunction NVARCHAR(5000),
  parameters NCLOB,
  selections NCLOB,
  businessEvent NVARCHAR(5000),
  field NVARCHAR(5000),
  "check" NVARCHAR(5000),
  conversion NVARCHAR(5000),
  "partition" NVARCHAR(5000),
  package NVARCHAR(5000),
  state_code NVARCHAR(10) DEFAULT 'OK',
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogs_state
  FOREIGN KEY(state_code)
  REFERENCES ApplicationLogStates(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogStatistics (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  applicationLog_ID NVARCHAR(36),
  function NVARCHAR(5000),
  startTimestamp TIMESTAMP_TEXT,
  endTimestamp TIMESTAMP_TEXT,
  inputRecords BIGINT,
  resultRecords BIGINT,
  successRecords BIGINT,
  warningRecords BIGINT,
  errorRecords BIGINT,
  abortRecords BIGINT,
  inputDuration DECIMAL,
  processingDuration DECIMAL,
  outputDuration DECIMAL,
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogStatistics_applicationLog
  FOREIGN KEY(applicationLog_ID)
  REFERENCES ApplicationLogs(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogMessages (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  applicationLog_ID NVARCHAR(36),
  type_code NVARCHAR(10) DEFAULT 'I',
  function NVARCHAR(5000),
  code NVARCHAR(5000),
  entity NVARCHAR(5000),
  primaryKey NVARCHAR(5000),
  target NVARCHAR(5000),
  argument1 NVARCHAR(5000),
  argument2 NVARCHAR(5000),
  argument3 NVARCHAR(5000),
  argument4 NVARCHAR(5000),
  argument5 NVARCHAR(5000),
  argument6 NVARCHAR(5000),
  messageDetails NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogMessages_applicationLog
  FOREIGN KEY(applicationLog_ID)
  REFERENCES ApplicationLogs(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ApplicationLogMessages_type
  FOREIGN KEY(type_code)
  REFERENCES ApplicationLogMessageTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  applicationLog_ID NVARCHAR(36),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  function NVARCHAR(5000),
  "check" NVARCHAR(5000),
  type_code NVARCHAR(10) DEFAULT 'I',
  message NVARCHAR(5000),
  statement NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogChecks_applicationLog
  FOREIGN KEY(applicationLog_ID)
  REFERENCES ApplicationLogs(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ApplicationLogChecks_type
  FOREIGN KEY(type_code)
  REFERENCES ApplicationLogMessageTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  formula NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  applicationLog_ID NVARCHAR(36),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  field NVARCHAR(5000),
  step INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogFields_applicationLog
  FOREIGN KEY(applicationLog_ID)
  REFERENCES ApplicationLogs(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  sequence INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  option_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  applicationLog_ID NVARCHAR(36),
  logField_ID NVARCHAR(36),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  process NVARCHAR(5000),
  activity NVARCHAR(5000),
  field NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationLogFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ApplicationLogFieldSelections_option
  FOREIGN KEY(option_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ApplicationLogFieldSelections_applicationLog
  FOREIGN KEY(applicationLog_ID)
  REFERENCES ApplicationLogs(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ApplicationLogFieldSelections_logField
  FOREIGN KEY(logField_ID)
  REFERENCES ApplicationLogFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ApplicationLogStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'OK',
  PRIMARY KEY(code)
);

CREATE TABLE ApplicationLogMessageTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE Calculations (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  includeInputData BOOLEAN DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN DEFAULT FALSE,
  resultFunction_ID NVARCHAR(36),
  processingType_code NVARCHAR(10) DEFAULT '',
  businessEventType_code NVARCHAR(10) DEFAULT '',
  partition_ID NVARCHAR(36),
  inputFunction_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) DEFAULT 'RELATIVE',
  workbook NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__Calculations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_resultHandling
  FOREIGN KEY(resultHandling_code)
  REFERENCES ResultHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Calculations_type
  FOREIGN KEY(type_code)
  REFERENCES CalculationTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationInputFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  calculation_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationInputFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFields_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFields_calculation
  FOREIGN KEY(calculation_ID)
  REFERENCES Calculations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationInputFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  sequence INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  option_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationInputFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFieldSelections_option
  FOREIGN KEY(option_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationInputFieldSelections_inputField
  FOREIGN KEY(inputField_ID)
  REFERENCES CalculationInputFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationLookupFunctions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  lookupFunction_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationLookupFunctions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationLookupFunctions_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationLookupFunctions_calculation
  FOREIGN KEY(calculation_ID)
  REFERENCES Calculations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationSignatureFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  selection BOOLEAN,
  "action" BOOLEAN,
  granularity BOOLEAN,
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationSignatureFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationSignatureFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationSignatureFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationSignatureFields_calculation
  FOREIGN KEY(calculation_ID)
  REFERENCES Calculations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36),
  sequence INTEGER,
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRules_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRules_calculation
  FOREIGN KEY(calculation_ID)
  REFERENCES Calculations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationRuleConditions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationRuleConditions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditions_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditions_rule
  FOREIGN KEY(rule_ID)
  REFERENCES CalculationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationRuleConditionSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  sequence INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  option_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  condition_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationRuleConditionSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditionSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditionSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditionSelections_option
  FOREIGN KEY(option_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleConditionSelections_condition
  FOREIGN KEY(condition_ID)
  REFERENCES CalculationRuleConditions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationRuleActions (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationRuleActions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleActions_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleActions_rule
  FOREIGN KEY(rule_ID)
  REFERENCES CalculationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationRuleActions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationChecks_calculation
  FOREIGN KEY(calculation_ID)
  REFERENCES Calculations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'RELATIVE',
  PRIMARY KEY(code)
);

CREATE TABLE RuntimeFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000),
  environment NVARCHAR(5000),
  version NVARCHAR(5000),
  class_code NVARCHAR(5000) DEFAULT '',
  type_code NVARCHAR(5000) DEFAULT 'CHA',
  hanaDataType_code NVARCHAR(5000) DEFAULT 'NVARCHAR',
  dataLength INTEGER DEFAULT 16,
  dataDecimals INTEGER DEFAULT 0,
  unitField_ID NVARCHAR(36),
  isLowercase BOOLEAN DEFAULT TRUE,
  hasMasterData BOOLEAN DEFAULT FALSE,
  hasHierarchies BOOLEAN DEFAULT FALSE,
  calculationHierarchy NVARCHAR(5000),
  masterDataHanaView NVARCHAR(5000),
  description NVARCHAR(5000),
  documentation NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeFields_class
  FOREIGN KEY(class_code)
  REFERENCES FieldClasses(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFields_type
  FOREIGN KEY(type_code)
  REFERENCES FieldTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeFields_hanaDataType
  FOREIGN KEY(hanaDataType_code)
  REFERENCES HanaDataTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE EnvironmentTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'ENV_VER',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CuProcessTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'SIMULATION',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CuProcessStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CuProcessActivityTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'IO',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CuProcessActivityStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(locale, code)
);

CREATE TABLE SXP0012__CURRENCIES_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL,
  PRIMARY KEY(locale, code)
);

CREATE TABLE SXP0012__UNITS_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(3) NOT NULL DEFAULT 'PC',
  PRIMARY KEY(locale, code)
);

CREATE TABLE MessageTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Orders_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Signs_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Options_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(2) NOT NULL DEFAULT 'EQ',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ResultHandlings_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENRICHED',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FieldClasses_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FieldTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(locale, code)
);

CREATE TABLE HanaDataTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'NVARCHAR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CheckCategories_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'MT',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionProcessingTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE FunctionBusinessEventTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ConnectionSources_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'HANA_VIEW',
  PRIMARY KEY(locale, code)
);

CREATE TABLE RuntimeFunctionStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'CHECKED',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ApplicationLogStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'OK',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ApplicationLogMessageTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'RELATIVE',
  PRIMARY KEY(locale, code)
);

CREATE TABLE DRAFT_DraftAdministrativeData (
  DraftUUID NVARCHAR(36) NOT NULL,
  CreationDateTime TIMESTAMP_TEXT,
  CreatedByUser NVARCHAR(256),
  DraftIsCreatedByMe BOOLEAN,
  LastChangeDateTime TIMESTAMP_TEXT,
  LastChangedByUser NVARCHAR(256),
  InProcessByUser NVARCHAR(256),
  DraftIsProcessedByMe BOOLEAN,
  PRIMARY KEY(DraftUUID)
);

CREATE TABLE EnvironmentService_Environments_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  ID NVARCHAR(36) NOT NULL,
  environment NVARCHAR(5000) NULL,
  version NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(5000) NULL DEFAULT 'ENV_VER',
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE EnvironmentService_AL01_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  AC_AC NVARCHAR(10) NULL DEFAULT '1234',
  CURRENCY_code NVARCHAR(3) NULL,
  AMOUNT DECIMAL NULL,
  UNIT_code NVARCHAR(3) NULL DEFAULT 'PC',
  QUANTITY DECIMAL NULL,
  SUM DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE TABLE EnvironmentService_CA01_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  AC_AC NVARCHAR(10) NULL DEFAULT '1234',
  CURRENCY_code NVARCHAR(3) NULL,
  AMOUNT DECIMAL NULL,
  UNIT_code NVARCHAR(3) NULL DEFAULT 'PC',
  QUANTITY DECIMAL NULL,
  SUM DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE TABLE EnvironmentService_DE01_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  AC_AC NVARCHAR(10) NULL DEFAULT '1234',
  CURRENCY_code NVARCHAR(3) NULL,
  AMOUNT DECIMAL NULL,
  UNIT_code NVARCHAR(3) NULL DEFAULT 'PC',
  QUANTITY DECIMAL NULL,
  SUM DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE TABLE EnvironmentService_JO01_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  AC_AC NVARCHAR(10) NULL DEFAULT '1234',
  CURRENCY_code NVARCHAR(3) NULL,
  AMOUNT DECIMAL NULL,
  UNIT_code NVARCHAR(3) NULL DEFAULT 'PC',
  QUANTITY DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE TABLE EnvironmentService_MT01_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  FACTOR DECIMAL NULL,
  CURRENCY_code NVARCHAR(3) NULL,
  AMOUNT DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE TABLE EnvironmentService_MT02_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  _ID NVARCHAR(36) NOT NULL,
  _APPLICATIONLOG_ID NVARCHAR(36) NULL,
  _STATE NVARCHAR(5000) NULL DEFAULT 'S=OK',
  CC_CC NVARCHAR(10) NULL,
  PC NVARCHAR(10) NULL,
  AC_AC NVARCHAR(10) NULL DEFAULT '1234',
  UNIT_code NVARCHAR(3) NULL DEFAULT 'PC',
  QUANTITY DECIMAL NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(_ID)
);

CREATE VIEW EnvironmentService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM Environments AS environments_0
ORDER BY environment, version;

CREATE VIEW EnvironmentService_CuProcesses AS SELECT
  cuProcesses_0.createdAt,
  cuProcesses_0.createdBy,
  cuProcesses_0.modifiedAt,
  cuProcesses_0.modifiedBy,
  cuProcesses_0.ID,
  cuProcesses_0.environment,
  cuProcesses_0.version,
  cuProcesses_0.process,
  cuProcesses_0.type_code,
  cuProcesses_0.state_code,
  cuProcesses_0.description
FROM CuProcesses AS cuProcesses_0
ORDER BY ID;

CREATE VIEW EnvironmentService_AL01 AS SELECT
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.AC_AC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.QUANTITY,
  AL01_0.SUM
FROM SXP0012_AL01 AS AL01_0
ORDER BY _ID;

CREATE VIEW EnvironmentService_CA01 AS SELECT
  CA01_0.createdAt,
  CA01_0.createdBy,
  CA01_0.modifiedAt,
  CA01_0.modifiedBy,
  CA01_0._ID,
  CA01_0._APPLICATIONLOG_ID,
  CA01_0._STATE,
  CA01_0.CC_CC,
  CA01_0.PC,
  CA01_0.AC_AC,
  CA01_0.CURRENCY_code,
  CA01_0.AMOUNT,
  CA01_0.UNIT_code,
  CA01_0.QUANTITY,
  CA01_0.SUM
FROM SXP0012_CA01 AS CA01_0
ORDER BY _ID;

CREATE VIEW EnvironmentService_DE01 AS SELECT
  DE01_0.createdAt,
  DE01_0.createdBy,
  DE01_0.modifiedAt,
  DE01_0.modifiedBy,
  DE01_0._ID,
  DE01_0._APPLICATIONLOG_ID,
  DE01_0._STATE,
  DE01_0.CC_CC,
  DE01_0.PC,
  DE01_0.AC_AC,
  DE01_0.CURRENCY_code,
  DE01_0.AMOUNT,
  DE01_0.UNIT_code,
  DE01_0.QUANTITY,
  DE01_0.SUM
FROM SXP0012_DE01 AS DE01_0
ORDER BY _ID;

CREATE VIEW EnvironmentService_JO01 AS SELECT
  JO01_0.createdAt,
  JO01_0.createdBy,
  JO01_0.modifiedAt,
  JO01_0.modifiedBy,
  JO01_0._ID,
  JO01_0._APPLICATIONLOG_ID,
  JO01_0._STATE,
  JO01_0.CC_CC,
  JO01_0.PC,
  JO01_0.AC_AC,
  JO01_0.CURRENCY_code,
  JO01_0.AMOUNT,
  JO01_0.UNIT_code,
  JO01_0.QUANTITY
FROM SXP0012_JO01 AS JO01_0
ORDER BY _ID;

CREATE VIEW EnvironmentService_MT01 AS SELECT
  MT01_0.createdAt,
  MT01_0.createdBy,
  MT01_0.modifiedAt,
  MT01_0.modifiedBy,
  MT01_0._ID,
  MT01_0._APPLICATIONLOG_ID,
  MT01_0._STATE,
  MT01_0.CC_CC,
  MT01_0.PC,
  MT01_0.FACTOR,
  MT01_0.CURRENCY_code,
  MT01_0.AMOUNT
FROM SXP0012_MT01 AS MT01_0
ORDER BY _ID;

CREATE VIEW EnvironmentService_MT02 AS SELECT
  MT02_0.createdAt,
  MT02_0.createdBy,
  MT02_0.modifiedAt,
  MT02_0.modifiedBy,
  MT02_0._ID,
  MT02_0._APPLICATIONLOG_ID,
  MT02_0._STATE,
  MT02_0.CC_CC,
  MT02_0.PC,
  MT02_0.AC_AC,
  MT02_0.UNIT_code,
  MT02_0.QUANTITY
FROM SXP0012_MT02 AS MT02_0
ORDER BY _ID;

CREATE VIEW EnvironmentService__CURRENCIES AS SELECT
  _CURRENCIES_0.name,
  _CURRENCIES_0.descr,
  _CURRENCIES_0.code,
  _CURRENCIES_0.symbol,
  _CURRENCIES_0.decimalPlaces
FROM SXP0012__CURRENCIES AS _CURRENCIES_0
ORDER BY code;

CREATE VIEW EnvironmentService__UNITS AS SELECT
  _UNITS_0.name,
  _UNITS_0.descr,
  _UNITS_0.code,
  _UNITS_0.symbol,
  _UNITS_0.decimalPlaces
FROM SXP0012__UNITS AS _UNITS_0
ORDER BY code;

CREATE VIEW EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW SXP0012_QEAC AS SELECT
  MTAC_0.AC,
  MTAC_0.createdAt,
  MTAC_0.createdBy,
  MTAC_0.modifiedAt,
  MTAC_0.modifiedBy,
  MTAC_0._APPLICATIONLOG_ID,
  MTAC_0._STATE,
  MTAC_0._DESCR,
  MTAC_0._LOCALE,
  MTAC_0._IS_NODE,
  MTAC_0._HIER_NAME,
  MTAC_0.PARENT,
  MTAC_0._SEQUENCE
FROM SXP0012_MTAC AS MTAC_0;

CREATE VIEW SXP0012_QECC AS SELECT
  MTCC_0.CC,
  MTCC_0.NAME
FROM SXP0012_MTCC AS MTCC_0;

CREATE VIEW SXP0012_QERES AS SELECT
  AL01_0.AC_AC,
  AL01_0.QUANTITY,
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.SUM
FROM SXP0012_AL01 AS AL01_0;

CREATE VIEW UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('AL', 'DE', 'JO', 'MJ', 'MT', 'MV', 'QE', 'RF', 'VW', 'WR');

CREATE VIEW RuntimeFunctionResultFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('MT', 'MV');

CREATE VIEW FunctionResultFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW FunctionInputFunctionsVH AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.function,
  F_0.sequence,
  F_0.parent_ID,
  F_0.type_code,
  F_0.description,
  F_0.documentation
FROM Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW FunctionParentFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW EnvironmentService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW EnvironmentService_CuProcessTypes AS SELECT
  CuProcessTypes_0.name,
  CuProcessTypes_0.descr,
  CuProcessTypes_0.code
FROM CuProcessTypes AS CuProcessTypes_0;

CREATE VIEW EnvironmentService_CuProcessStates AS SELECT
  CuProcessStates_0.name,
  CuProcessStates_0.descr,
  CuProcessStates_0.code
FROM CuProcessStates AS CuProcessStates_0;

CREATE VIEW EnvironmentService_CuProcessActivities AS SELECT
  CuProcessActivities_0.createdAt,
  CuProcessActivities_0.createdBy,
  CuProcessActivities_0.modifiedAt,
  CuProcessActivities_0.modifiedBy,
  CuProcessActivities_0.ID,
  CuProcessActivities_0.process_ID,
  CuProcessActivities_0.activity,
  CuProcessActivities_0.parent_ID,
  CuProcessActivities_0.sequence,
  CuProcessActivities_0.activityType_code,
  CuProcessActivities_0.activityState_code,
  CuProcessActivities_0.function_ID,
  CuProcessActivities_0.startDate,
  CuProcessActivities_0.endDate,
  CuProcessActivities_0.url
FROM CuProcessActivities AS CuProcessActivities_0;

CREATE VIEW EnvironmentService__CURRENCIES_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM SXP0012__CURRENCIES_texts AS texts_0;

CREATE VIEW EnvironmentService__UNITS_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM SXP0012__UNITS_texts AS texts_0;

CREATE VIEW EnvironmentService_EnvironmentTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM EnvironmentTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_CuProcessTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CuProcessTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_CuProcessStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CuProcessStates_texts AS texts_0;

CREATE VIEW EnvironmentService_CuProcessActivityTypes AS SELECT
  CuProcessActivityTypes_0.name,
  CuProcessActivityTypes_0.descr,
  CuProcessActivityTypes_0.code
FROM CuProcessActivityTypes AS CuProcessActivityTypes_0;

CREATE VIEW EnvironmentService_CuProcessActivityStates AS SELECT
  CuProcessActivityStates_0.name,
  CuProcessActivityStates_0.descr,
  CuProcessActivityStates_0.code
FROM CuProcessActivityStates AS CuProcessActivityStates_0;

CREATE VIEW EnvironmentService_CuProcessActivityPerformerTeams AS SELECT
  CuProcessActivityPerformerTeams_0.createdAt,
  CuProcessActivityPerformerTeams_0.createdBy,
  CuProcessActivityPerformerTeams_0.modifiedAt,
  CuProcessActivityPerformerTeams_0.modifiedBy,
  CuProcessActivityPerformerTeams_0.ID,
  CuProcessActivityPerformerTeams_0.process_ID,
  CuProcessActivityPerformerTeams_0.activity_ID,
  CuProcessActivityPerformerTeams_0.team_ID
FROM CuProcessActivityPerformerTeams AS CuProcessActivityPerformerTeams_0;

CREATE VIEW EnvironmentService_CuProcessActivityReviewerTeams AS SELECT
  CuProcessActivityReviewerTeams_0.createdAt,
  CuProcessActivityReviewerTeams_0.createdBy,
  CuProcessActivityReviewerTeams_0.modifiedAt,
  CuProcessActivityReviewerTeams_0.modifiedBy,
  CuProcessActivityReviewerTeams_0.ID,
  CuProcessActivityReviewerTeams_0.process_ID,
  CuProcessActivityReviewerTeams_0.activity_ID,
  CuProcessActivityReviewerTeams_0.team_ID
FROM CuProcessActivityReviewerTeams AS CuProcessActivityReviewerTeams_0;

CREATE VIEW EnvironmentService_CuProcessActivityComments AS SELECT
  CuProcessActivityComments_0.createdAt,
  CuProcessActivityComments_0.createdBy,
  CuProcessActivityComments_0.modifiedAt,
  CuProcessActivityComments_0.modifiedBy,
  CuProcessActivityComments_0.ID,
  CuProcessActivityComments_0.process_ID,
  CuProcessActivityComments_0.activity_ID,
  CuProcessActivityComments_0.comment
FROM CuProcessActivityComments AS CuProcessActivityComments_0;

CREATE VIEW EnvironmentService_CuProcessActivityTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CuProcessActivityTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_CuProcessActivityStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CuProcessActivityStates_texts AS texts_0;

CREATE VIEW EnvironmentService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM FunctionTypes AS FunctionTypes_0;

CREATE VIEW EnvironmentService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW EnvironmentService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW EnvironmentService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW EnvironmentService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW EnvironmentService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW EnvironmentService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW EnvironmentService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.environment,
  RuntimeOutputFields_0.version,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field
FROM RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW EnvironmentService_RuntimeShareLocks AS SELECT
  RuntimeShareLocks_0.createdAt,
  RuntimeShareLocks_0.createdBy,
  RuntimeShareLocks_0.modifiedAt,
  RuntimeShareLocks_0.modifiedBy,
  RuntimeShareLocks_0.ID,
  RuntimeShareLocks_0.function_ID,
  RuntimeShareLocks_0.environment,
  RuntimeShareLocks_0.version,
  RuntimeShareLocks_0.process,
  RuntimeShareLocks_0.activity,
  RuntimeShareLocks_0.partitionField_ID,
  RuntimeShareLocks_0.partitionFieldRangeValue
FROM RuntimeShareLocks AS RuntimeShareLocks_0;

CREATE VIEW EnvironmentService_CuProcessActivityCommentAttachments AS SELECT
  CuProcessActivityCommentAttachments_0.createdAt,
  CuProcessActivityCommentAttachments_0.createdBy,
  CuProcessActivityCommentAttachments_0.modifiedAt,
  CuProcessActivityCommentAttachments_0.modifiedBy,
  CuProcessActivityCommentAttachments_0.ID,
  CuProcessActivityCommentAttachments_0.process_ID,
  CuProcessActivityCommentAttachments_0.activity_ID,
  CuProcessActivityCommentAttachments_0.comment_ID,
  CuProcessActivityCommentAttachments_0.name,
  CuProcessActivityCommentAttachments_0.file
FROM CuProcessActivityCommentAttachments AS CuProcessActivityCommentAttachments_0;

CREATE VIEW EnvironmentService_FunctionTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_RuntimeFunctionStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM RuntimeFunctionStates_texts AS texts_0;

CREATE VIEW EnvironmentService_FunctionProcessingTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionProcessingTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_FunctionBusinessEventTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionBusinessEventTypes_texts AS texts_0;

CREATE VIEW EnvironmentService_RuntimePartitionRanges AS SELECT
  RuntimePartitionRanges_0.createdAt,
  RuntimePartitionRanges_0.createdBy,
  RuntimePartitionRanges_0.modifiedAt,
  RuntimePartitionRanges_0.modifiedBy,
  RuntimePartitionRanges_0.ID,
  RuntimePartitionRanges_0.partition_ID,
  RuntimePartitionRanges_0."range",
  RuntimePartitionRanges_0.sequence,
  RuntimePartitionRanges_0.level,
  RuntimePartitionRanges_0.value
FROM RuntimePartitionRanges AS RuntimePartitionRanges_0;

CREATE VIEW EnvironmentService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_EnvironmentTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CuProcessTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessTypes AS L_0 LEFT JOIN CuProcessTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CuProcessStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessStates AS L_0 LEFT JOIN CuProcessStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CuProcessActivityTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityTypes AS L_0 LEFT JOIN CuProcessActivityTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CuProcessActivityStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityStates AS L_0 LEFT JOIN CuProcessActivityStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_SXP0012__CURRENCIES AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__CURRENCIES AS L_0 LEFT JOIN SXP0012__CURRENCIES_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_SXP0012__UNITS AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__UNITS AS L_0 LEFT JOIN SXP0012__UNITS_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_MessageTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Orders AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Signs AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Options AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ResultHandlings AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FieldClasses AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FieldTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_HanaDataTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CheckCategories AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionProcessingTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ConnectionSources AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ConnectionSources AS L_0 LEFT JOIN ConnectionSources_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_RuntimeFunctionStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (RuntimeFunctionStates AS L_0 LEFT JOIN RuntimeFunctionStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ApplicationLogStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogStates AS L_0 LEFT JOIN ApplicationLogStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ApplicationLogMessageTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogMessageTypes AS L_0 LEFT JOIN ApplicationLogMessageTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationTypes AS L_0 LEFT JOIN CalculationTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_CuProcesses AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.type_code,
  L.state_code,
  L.description
FROM CuProcesses AS L;

CREATE VIEW localized_CuProcessActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.startDate,
  L.endDate,
  L.url
FROM CuProcessActivities AS L;

CREATE VIEW localized_SXP0012_MT01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.FACTOR,
  L.CURRENCY_code,
  L.AMOUNT
FROM SXP0012_MT01 AS L;

CREATE VIEW localized_SXP0012_MT02 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_MT02 AS L;

CREATE VIEW localized_SXP0012_JO01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_JO01 AS L;

CREATE VIEW localized_SXP0012_CA01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_CA01 AS L;

CREATE VIEW localized_SXP0012_DE01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_DE01 AS L;

CREATE VIEW localized_SXP0012_AL01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_AL01 AS L;

CREATE VIEW localized_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."check",
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

CREATE VIEW localized_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parent_ID,
  L.type_code,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description,
  L.source_code,
  L.hanaTable,
  L.hanaView,
  L.odataUrl,
  L.odataUrlOptions
FROM Connections AS L;

CREATE VIEW localized_RuntimeFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L.description,
  L.type_code,
  L.state_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.storedProcedure,
  L.appServerStatement,
  L.preStatement,
  L.statement,
  L.postStatement,
  L.hanaTable,
  L.hanaView,
  L.synonym,
  L.masterDataHierarchyView,
  L.calculationView,
  L.workBook,
  L.resultModelTable_ID
FROM RuntimeFunctions AS L;

CREATE VIEW localized_ApplicationLogs AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.run,
  L.type,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.mainFunction,
  L.parameters,
  L.selections,
  L.businessEvent,
  L.field,
  L."check",
  L.conversion,
  L."partition",
  L.package,
  L.state_code
FROM ApplicationLogs AS L;

CREATE VIEW localized_ApplicationLogMessages AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.type_code,
  L.function,
  L.code,
  L.entity,
  L.primaryKey,
  L.target,
  L.argument1,
  L.argument2,
  L.argument3,
  L.argument4,
  L.argument5,
  L.argument6,
  L.messageDetails
FROM ApplicationLogMessages AS L;

CREATE VIEW localized_ApplicationLogChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationLogChecks AS L;

CREATE VIEW localized_ApplicationLogFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.applicationLog_ID,
  L.logField_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field
FROM ApplicationLogFieldSelections AS L;

CREATE VIEW localized_Calculations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.resultFunction_ID,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.inputFunction_ID,
  L.ID,
  L.type_code,
  L.workbook
FROM Calculations AS L;

CREATE VIEW localized_CalculationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.field_ID,
  L.calculation_ID
FROM CalculationInputFields AS L;

CREATE VIEW localized_CalculationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM CalculationInputFieldSelections AS L;

CREATE VIEW localized_CalculationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM CalculationRuleConditionSelections AS L;

CREATE VIEW localized_RuntimeFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.field,
  L.environment,
  L.version,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy,
  L.masterDataHanaView,
  L.description,
  L.documentation
FROM RuntimeFields AS L;

CREATE VIEW localized_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

CREATE VIEW localized_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM PartitionRanges AS L;

CREATE VIEW localized_CalculationLookupFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.lookupFunction_ID,
  L.ID,
  L.calculation_ID
FROM CalculationLookupFunctions AS L;

CREATE VIEW localized_CalculationSignatureFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.field_ID,
  L.selection,
  L."action",
  L.granularity,
  L.ID,
  L.calculation_ID
FROM CalculationSignatureFields AS L;

CREATE VIEW localized_CalculationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.sequence,
  L.description
FROM CalculationRules AS L;

CREATE VIEW localized_CalculationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleConditions AS L;

CREATE VIEW localized_CalculationRuleActions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleActions AS L;

CREATE VIEW localized_CalculationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.check_ID
FROM CalculationChecks AS L;

CREATE VIEW localized_CuProcessActivityPerformerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityPerformerTeams AS L;

CREATE VIEW localized_CuProcessActivityReviewerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityReviewerTeams AS L;

CREATE VIEW localized_CuProcessActivityComments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment
FROM CuProcessActivityComments AS L;

CREATE VIEW localized_CuProcessActivityCommentAttachments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment_ID,
  L.name,
  L.file
FROM CuProcessActivityCommentAttachments AS L;

CREATE VIEW localized_CuProcessActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CuProcessActivityLinks AS L;

CREATE VIEW localized_CuProcessReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CuProcessReports AS L;

CREATE VIEW localized_CuProcessReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CuProcessReportElements AS L;

CREATE VIEW localized_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

CREATE VIEW localized_RuntimeShareLocks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.partitionField_ID,
  L.partitionFieldRangeValue
FROM RuntimeShareLocks AS L;

CREATE VIEW localized_RuntimeOutputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.function_ID,
  L.field
FROM RuntimeOutputFields AS L;

CREATE VIEW localized_RuntimeProcessChains AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.level
FROM RuntimeProcessChains AS L;

CREATE VIEW localized_RuntimeProcessChainFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.processChain_ID,
  L.function_ID
FROM RuntimeProcessChainFunctions AS L;

CREATE VIEW localized_RuntimeInputFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.inputFunction_ID
FROM RuntimeInputFunctions AS L;

CREATE VIEW localized_SXP0012_MTAC AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.AC,
  L._DESCR,
  L._LOCALE,
  L._IS_NODE,
  L._HIER_NAME,
  L.PARENT,
  L._SEQUENCE
FROM SXP0012_MTAC AS L;

CREATE VIEW localized_ApplicationLogStatistics AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.function,
  L.startTimestamp,
  L.endTimestamp,
  L.inputRecords,
  L.resultRecords,
  L.successRecords,
  L.warningRecords,
  L.errorRecords,
  L.abortRecords,
  L.inputDuration,
  L.processingDuration,
  L.outputDuration
FROM ApplicationLogStatistics AS L;

CREATE VIEW localized_ApplicationLogFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.formula,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field,
  L.step
FROM ApplicationLogFields AS L;

CREATE VIEW localized_RuntimePartitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM RuntimePartitions AS L;

CREATE VIEW localized_RuntimePartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM RuntimePartitionRanges AS L;

CREATE VIEW EnvironmentService_DraftAdministrativeData AS SELECT
  DraftAdministrativeData.DraftUUID,
  DraftAdministrativeData.CreationDateTime,
  DraftAdministrativeData.CreatedByUser,
  DraftAdministrativeData.DraftIsCreatedByMe,
  DraftAdministrativeData.LastChangeDateTime,
  DraftAdministrativeData.LastChangedByUser,
  DraftAdministrativeData.InProcessByUser,
  DraftAdministrativeData.DraftIsProcessedByMe
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;

CREATE VIEW EnvironmentService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW EnvironmentService_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctionInputFunctions_0.createdAt,
  RuntimeFunctionInputFunctions_0.createdBy,
  RuntimeFunctionInputFunctions_0.modifiedAt,
  RuntimeFunctionInputFunctions_0.modifiedBy,
  RuntimeFunctionInputFunctions_0.ID,
  RuntimeFunctionInputFunctions_0.environment,
  RuntimeFunctionInputFunctions_0.version,
  RuntimeFunctionInputFunctions_0.process,
  RuntimeFunctionInputFunctions_0.activity,
  RuntimeFunctionInputFunctions_0.function,
  RuntimeFunctionInputFunctions_0.description,
  RuntimeFunctionInputFunctions_0.type_code,
  RuntimeFunctionInputFunctions_0.state_code,
  RuntimeFunctionInputFunctions_0.processingType_code,
  RuntimeFunctionInputFunctions_0.businessEventType_code,
  RuntimeFunctionInputFunctions_0.partition_ID,
  RuntimeFunctionInputFunctions_0.storedProcedure,
  RuntimeFunctionInputFunctions_0.appServerStatement,
  RuntimeFunctionInputFunctions_0.preStatement,
  RuntimeFunctionInputFunctions_0.statement,
  RuntimeFunctionInputFunctions_0.postStatement,
  RuntimeFunctionInputFunctions_0.hanaTable,
  RuntimeFunctionInputFunctions_0.hanaView,
  RuntimeFunctionInputFunctions_0.synonym,
  RuntimeFunctionInputFunctions_0.masterDataHierarchyView,
  RuntimeFunctionInputFunctions_0.calculationView,
  RuntimeFunctionInputFunctions_0.workBook,
  RuntimeFunctionInputFunctions_0.resultModelTable_ID
FROM RuntimeFunctionInputFunctions AS RuntimeFunctionInputFunctions_0;

CREATE VIEW localized_EnvironmentService__CURRENCIES AS SELECT
  _CURRENCIES_0.name,
  _CURRENCIES_0.descr,
  _CURRENCIES_0.code,
  _CURRENCIES_0.symbol,
  _CURRENCIES_0.decimalPlaces
FROM localized_SXP0012__CURRENCIES AS _CURRENCIES_0
ORDER BY code;

CREATE VIEW localized_EnvironmentService__UNITS AS SELECT
  _UNITS_0.name,
  _UNITS_0.descr,
  _UNITS_0.code,
  _UNITS_0.symbol,
  _UNITS_0.decimalPlaces
FROM localized_SXP0012__UNITS AS _UNITS_0
ORDER BY code;

CREATE VIEW localized_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_SXP0012_QERES AS SELECT
  AL01_0.AC_AC,
  AL01_0.QUANTITY,
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.SUM
FROM localized_SXP0012_AL01 AS AL01_0;

CREATE VIEW localized_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('AL', 'DE', 'JO', 'MJ', 'MT', 'MV', 'QE', 'RF', 'VW', 'WR');

CREATE VIEW localized_RuntimeFunctionResultFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('MT', 'MV');

CREATE VIEW localized_FunctionResultFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_FunctionInputFunctionsVH AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.function,
  F_0.sequence,
  F_0.parent_ID,
  F_0.type_code,
  F_0.description,
  F_0.documentation
FROM localized_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_FunctionParentFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_EnvironmentService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_EnvironmentService_CuProcessTypes AS SELECT
  CuProcessTypes_0.name,
  CuProcessTypes_0.descr,
  CuProcessTypes_0.code
FROM localized_CuProcessTypes AS CuProcessTypes_0;

CREATE VIEW localized_EnvironmentService_CuProcessStates AS SELECT
  CuProcessStates_0.name,
  CuProcessStates_0.descr,
  CuProcessStates_0.code
FROM localized_CuProcessStates AS CuProcessStates_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityTypes AS SELECT
  CuProcessActivityTypes_0.name,
  CuProcessActivityTypes_0.descr,
  CuProcessActivityTypes_0.code
FROM localized_CuProcessActivityTypes AS CuProcessActivityTypes_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityStates AS SELECT
  CuProcessActivityStates_0.name,
  CuProcessActivityStates_0.descr,
  CuProcessActivityStates_0.code
FROM localized_CuProcessActivityStates AS CuProcessActivityStates_0;

CREATE VIEW localized_EnvironmentService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_EnvironmentService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_EnvironmentService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_EnvironmentService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_EnvironmentService_AL01 AS SELECT
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.AC_AC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.QUANTITY,
  AL01_0.SUM
FROM localized_SXP0012_AL01 AS AL01_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_CA01 AS SELECT
  CA01_0.createdAt,
  CA01_0.createdBy,
  CA01_0.modifiedAt,
  CA01_0.modifiedBy,
  CA01_0._ID,
  CA01_0._APPLICATIONLOG_ID,
  CA01_0._STATE,
  CA01_0.CC_CC,
  CA01_0.PC,
  CA01_0.AC_AC,
  CA01_0.CURRENCY_code,
  CA01_0.AMOUNT,
  CA01_0.UNIT_code,
  CA01_0.QUANTITY,
  CA01_0.SUM
FROM localized_SXP0012_CA01 AS CA01_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_DE01 AS SELECT
  DE01_0.createdAt,
  DE01_0.createdBy,
  DE01_0.modifiedAt,
  DE01_0.modifiedBy,
  DE01_0._ID,
  DE01_0._APPLICATIONLOG_ID,
  DE01_0._STATE,
  DE01_0.CC_CC,
  DE01_0.PC,
  DE01_0.AC_AC,
  DE01_0.CURRENCY_code,
  DE01_0.AMOUNT,
  DE01_0.UNIT_code,
  DE01_0.QUANTITY,
  DE01_0.SUM
FROM localized_SXP0012_DE01 AS DE01_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_JO01 AS SELECT
  JO01_0.createdAt,
  JO01_0.createdBy,
  JO01_0.modifiedAt,
  JO01_0.modifiedBy,
  JO01_0._ID,
  JO01_0._APPLICATIONLOG_ID,
  JO01_0._STATE,
  JO01_0.CC_CC,
  JO01_0.PC,
  JO01_0.AC_AC,
  JO01_0.CURRENCY_code,
  JO01_0.AMOUNT,
  JO01_0.UNIT_code,
  JO01_0.QUANTITY
FROM localized_SXP0012_JO01 AS JO01_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_MT01 AS SELECT
  MT01_0.createdAt,
  MT01_0.createdBy,
  MT01_0.modifiedAt,
  MT01_0.modifiedBy,
  MT01_0._ID,
  MT01_0._APPLICATIONLOG_ID,
  MT01_0._STATE,
  MT01_0.CC_CC,
  MT01_0.PC,
  MT01_0.FACTOR,
  MT01_0.CURRENCY_code,
  MT01_0.AMOUNT
FROM localized_SXP0012_MT01 AS MT01_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_MT02 AS SELECT
  MT02_0.createdAt,
  MT02_0.createdBy,
  MT02_0.modifiedAt,
  MT02_0.modifiedBy,
  MT02_0._ID,
  MT02_0._APPLICATIONLOG_ID,
  MT02_0._STATE,
  MT02_0.CC_CC,
  MT02_0.PC,
  MT02_0.AC_AC,
  MT02_0.UNIT_code,
  MT02_0.QUANTITY
FROM localized_SXP0012_MT02 AS MT02_0
ORDER BY _ID;

CREATE VIEW localized_EnvironmentService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_Environments AS environments_0
ORDER BY environment, version;

CREATE VIEW localized_EnvironmentService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_EnvironmentService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_EnvironmentService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.environment,
  RuntimeOutputFields_0.version,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field
FROM localized_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_EnvironmentService_RuntimeShareLocks AS SELECT
  RuntimeShareLocks_0.createdAt,
  RuntimeShareLocks_0.createdBy,
  RuntimeShareLocks_0.modifiedAt,
  RuntimeShareLocks_0.modifiedBy,
  RuntimeShareLocks_0.ID,
  RuntimeShareLocks_0.function_ID,
  RuntimeShareLocks_0.environment,
  RuntimeShareLocks_0.version,
  RuntimeShareLocks_0.process,
  RuntimeShareLocks_0.activity,
  RuntimeShareLocks_0.partitionField_ID,
  RuntimeShareLocks_0.partitionFieldRangeValue
FROM localized_RuntimeShareLocks AS RuntimeShareLocks_0;

CREATE VIEW localized_EnvironmentService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_SXP0012_QEAC AS SELECT
  MTAC_0.AC,
  MTAC_0.createdAt,
  MTAC_0.createdBy,
  MTAC_0.modifiedAt,
  MTAC_0.modifiedBy,
  MTAC_0._APPLICATIONLOG_ID,
  MTAC_0._STATE,
  MTAC_0._DESCR,
  MTAC_0._LOCALE,
  MTAC_0._IS_NODE,
  MTAC_0._HIER_NAME,
  MTAC_0.PARENT,
  MTAC_0._SEQUENCE
FROM localized_SXP0012_MTAC AS MTAC_0;

CREATE VIEW localized_EnvironmentService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_EnvironmentService_CuProcesses AS SELECT
  cuProcesses_0.createdAt,
  cuProcesses_0.createdBy,
  cuProcesses_0.modifiedAt,
  cuProcesses_0.modifiedBy,
  cuProcesses_0.ID,
  cuProcesses_0.environment,
  cuProcesses_0.version,
  cuProcesses_0.process,
  cuProcesses_0.type_code,
  cuProcesses_0.state_code,
  cuProcesses_0.description
FROM localized_CuProcesses AS cuProcesses_0
ORDER BY ID;

CREATE VIEW localized_EnvironmentService_CuProcessActivities AS SELECT
  CuProcessActivities_0.createdAt,
  CuProcessActivities_0.createdBy,
  CuProcessActivities_0.modifiedAt,
  CuProcessActivities_0.modifiedBy,
  CuProcessActivities_0.ID,
  CuProcessActivities_0.process_ID,
  CuProcessActivities_0.activity,
  CuProcessActivities_0.parent_ID,
  CuProcessActivities_0.sequence,
  CuProcessActivities_0.activityType_code,
  CuProcessActivities_0.activityState_code,
  CuProcessActivities_0.function_ID,
  CuProcessActivities_0.startDate,
  CuProcessActivities_0.endDate,
  CuProcessActivities_0.url
FROM localized_CuProcessActivities AS CuProcessActivities_0;

CREATE VIEW localized_EnvironmentService_RuntimePartitionRanges AS SELECT
  RuntimePartitionRanges_0.createdAt,
  RuntimePartitionRanges_0.createdBy,
  RuntimePartitionRanges_0.modifiedAt,
  RuntimePartitionRanges_0.modifiedBy,
  RuntimePartitionRanges_0.ID,
  RuntimePartitionRanges_0.partition_ID,
  RuntimePartitionRanges_0."range",
  RuntimePartitionRanges_0.sequence,
  RuntimePartitionRanges_0.level,
  RuntimePartitionRanges_0.value
FROM localized_RuntimePartitionRanges AS RuntimePartitionRanges_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityPerformerTeams AS SELECT
  CuProcessActivityPerformerTeams_0.createdAt,
  CuProcessActivityPerformerTeams_0.createdBy,
  CuProcessActivityPerformerTeams_0.modifiedAt,
  CuProcessActivityPerformerTeams_0.modifiedBy,
  CuProcessActivityPerformerTeams_0.ID,
  CuProcessActivityPerformerTeams_0.process_ID,
  CuProcessActivityPerformerTeams_0.activity_ID,
  CuProcessActivityPerformerTeams_0.team_ID
FROM localized_CuProcessActivityPerformerTeams AS CuProcessActivityPerformerTeams_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityReviewerTeams AS SELECT
  CuProcessActivityReviewerTeams_0.createdAt,
  CuProcessActivityReviewerTeams_0.createdBy,
  CuProcessActivityReviewerTeams_0.modifiedAt,
  CuProcessActivityReviewerTeams_0.modifiedBy,
  CuProcessActivityReviewerTeams_0.ID,
  CuProcessActivityReviewerTeams_0.process_ID,
  CuProcessActivityReviewerTeams_0.activity_ID,
  CuProcessActivityReviewerTeams_0.team_ID
FROM localized_CuProcessActivityReviewerTeams AS CuProcessActivityReviewerTeams_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityComments AS SELECT
  CuProcessActivityComments_0.createdAt,
  CuProcessActivityComments_0.createdBy,
  CuProcessActivityComments_0.modifiedAt,
  CuProcessActivityComments_0.modifiedBy,
  CuProcessActivityComments_0.ID,
  CuProcessActivityComments_0.process_ID,
  CuProcessActivityComments_0.activity_ID,
  CuProcessActivityComments_0.comment
FROM localized_CuProcessActivityComments AS CuProcessActivityComments_0;

CREATE VIEW localized_EnvironmentService_CuProcessActivityCommentAttachments AS SELECT
  CuProcessActivityCommentAttachments_0.createdAt,
  CuProcessActivityCommentAttachments_0.createdBy,
  CuProcessActivityCommentAttachments_0.modifiedAt,
  CuProcessActivityCommentAttachments_0.modifiedBy,
  CuProcessActivityCommentAttachments_0.ID,
  CuProcessActivityCommentAttachments_0.process_ID,
  CuProcessActivityCommentAttachments_0.activity_ID,
  CuProcessActivityCommentAttachments_0.comment_ID,
  CuProcessActivityCommentAttachments_0.name,
  CuProcessActivityCommentAttachments_0.file
FROM localized_CuProcessActivityCommentAttachments AS CuProcessActivityCommentAttachments_0;

CREATE VIEW localized_EnvironmentService_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctionInputFunctions_0.createdAt,
  RuntimeFunctionInputFunctions_0.createdBy,
  RuntimeFunctionInputFunctions_0.modifiedAt,
  RuntimeFunctionInputFunctions_0.modifiedBy,
  RuntimeFunctionInputFunctions_0.ID,
  RuntimeFunctionInputFunctions_0.environment,
  RuntimeFunctionInputFunctions_0.version,
  RuntimeFunctionInputFunctions_0.process,
  RuntimeFunctionInputFunctions_0.activity,
  RuntimeFunctionInputFunctions_0.function,
  RuntimeFunctionInputFunctions_0.description,
  RuntimeFunctionInputFunctions_0.type_code,
  RuntimeFunctionInputFunctions_0.state_code,
  RuntimeFunctionInputFunctions_0.processingType_code,
  RuntimeFunctionInputFunctions_0.businessEventType_code,
  RuntimeFunctionInputFunctions_0.partition_ID,
  RuntimeFunctionInputFunctions_0.storedProcedure,
  RuntimeFunctionInputFunctions_0.appServerStatement,
  RuntimeFunctionInputFunctions_0.preStatement,
  RuntimeFunctionInputFunctions_0.statement,
  RuntimeFunctionInputFunctions_0.postStatement,
  RuntimeFunctionInputFunctions_0.hanaTable,
  RuntimeFunctionInputFunctions_0.hanaView,
  RuntimeFunctionInputFunctions_0.synonym,
  RuntimeFunctionInputFunctions_0.masterDataHierarchyView,
  RuntimeFunctionInputFunctions_0.calculationView,
  RuntimeFunctionInputFunctions_0.workBook,
  RuntimeFunctionInputFunctions_0.resultModelTable_ID
FROM localized_RuntimeFunctionInputFunctions AS RuntimeFunctionInputFunctions_0;

CREATE VIEW localized_EnvironmentService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW localized_de_EnvironmentTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_EnvironmentTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CuProcessTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessTypes AS L_0 LEFT JOIN CuProcessTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CuProcessTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessTypes AS L_0 LEFT JOIN CuProcessTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CuProcessStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessStates AS L_0 LEFT JOIN CuProcessStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CuProcessStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessStates AS L_0 LEFT JOIN CuProcessStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CuProcessActivityTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityTypes AS L_0 LEFT JOIN CuProcessActivityTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CuProcessActivityTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityTypes AS L_0 LEFT JOIN CuProcessActivityTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CuProcessActivityStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityStates AS L_0 LEFT JOIN CuProcessActivityStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CuProcessActivityStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CuProcessActivityStates AS L_0 LEFT JOIN CuProcessActivityStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_SXP0012__CURRENCIES AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__CURRENCIES AS L_0 LEFT JOIN SXP0012__CURRENCIES_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_SXP0012__CURRENCIES AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__CURRENCIES AS L_0 LEFT JOIN SXP0012__CURRENCIES_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_SXP0012__UNITS AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__UNITS AS L_0 LEFT JOIN SXP0012__UNITS_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_SXP0012__UNITS AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code,
  L_0.symbol,
  L_0.decimalPlaces
FROM (SXP0012__UNITS AS L_0 LEFT JOIN SXP0012__UNITS_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_MessageTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_MessageTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Orders AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Orders AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Orders AS L_0 LEFT JOIN Orders_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Signs AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Signs AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Signs AS L_0 LEFT JOIN Signs_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Options AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Options AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (Options AS L_0 LEFT JOIN Options_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ResultHandlings AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ResultHandlings AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ResultHandlings AS L_0 LEFT JOIN ResultHandlings_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FieldClasses AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FieldClasses AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldClasses AS L_0 LEFT JOIN FieldClasses_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FieldTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FieldTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FieldTypes AS L_0 LEFT JOIN FieldTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_HanaDataTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_HanaDataTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (HanaDataTypes AS L_0 LEFT JOIN HanaDataTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CheckCategories AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CheckCategories AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CheckCategories AS L_0 LEFT JOIN CheckCategories_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionTypes AS L_0 LEFT JOIN FunctionTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionProcessingTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionProcessingTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionProcessingTypes AS L_0 LEFT JOIN FunctionProcessingTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_FunctionBusinessEventTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (FunctionBusinessEventTypes AS L_0 LEFT JOIN FunctionBusinessEventTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ConnectionSources AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ConnectionSources AS L_0 LEFT JOIN ConnectionSources_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ConnectionSources AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ConnectionSources AS L_0 LEFT JOIN ConnectionSources_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_RuntimeFunctionStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (RuntimeFunctionStates AS L_0 LEFT JOIN RuntimeFunctionStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_RuntimeFunctionStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (RuntimeFunctionStates AS L_0 LEFT JOIN RuntimeFunctionStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ApplicationLogStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogStates AS L_0 LEFT JOIN ApplicationLogStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ApplicationLogStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogStates AS L_0 LEFT JOIN ApplicationLogStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ApplicationLogMessageTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogMessageTypes AS L_0 LEFT JOIN ApplicationLogMessageTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ApplicationLogMessageTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ApplicationLogMessageTypes AS L_0 LEFT JOIN ApplicationLogMessageTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CalculationTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationTypes AS L_0 LEFT JOIN CalculationTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CalculationTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationTypes AS L_0 LEFT JOIN CalculationTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_fr_Environments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.description,
  L.parent_ID,
  L.type_code
FROM Environments AS L;

CREATE VIEW localized_de_CuProcesses AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.type_code,
  L.state_code,
  L.description
FROM CuProcesses AS L;

CREATE VIEW localized_fr_CuProcesses AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.type_code,
  L.state_code,
  L.description
FROM CuProcesses AS L;

CREATE VIEW localized_de_CuProcessActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.startDate,
  L.endDate,
  L.url
FROM CuProcessActivities AS L;

CREATE VIEW localized_fr_CuProcessActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.startDate,
  L.endDate,
  L.url
FROM CuProcessActivities AS L;

CREATE VIEW localized_de_SXP0012_MT01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.FACTOR,
  L.CURRENCY_code,
  L.AMOUNT
FROM SXP0012_MT01 AS L;

CREATE VIEW localized_fr_SXP0012_MT01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.FACTOR,
  L.CURRENCY_code,
  L.AMOUNT
FROM SXP0012_MT01 AS L;

CREATE VIEW localized_de_SXP0012_MT02 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_MT02 AS L;

CREATE VIEW localized_fr_SXP0012_MT02 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_MT02 AS L;

CREATE VIEW localized_de_SXP0012_JO01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_JO01 AS L;

CREATE VIEW localized_fr_SXP0012_JO01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY
FROM SXP0012_JO01 AS L;

CREATE VIEW localized_de_SXP0012_CA01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_CA01 AS L;

CREATE VIEW localized_fr_SXP0012_CA01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_CA01 AS L;

CREATE VIEW localized_de_SXP0012_DE01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_DE01 AS L;

CREATE VIEW localized_fr_SXP0012_DE01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_DE01 AS L;

CREATE VIEW localized_de_SXP0012_AL01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_AL01 AS L;

CREATE VIEW localized_fr_SXP0012_AL01 AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._ID,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.CC_CC,
  L.PC,
  L.AC_AC,
  L.CURRENCY_code,
  L.AMOUNT,
  L.UNIT_code,
  L.QUANTITY,
  L.SUM
FROM SXP0012_AL01 AS L;

CREATE VIEW localized_de_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_fr_Fields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.field,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy_ID,
  L.masterDataQuery_ID,
  L.description,
  L.documentation
FROM Fields AS L;

CREATE VIEW localized_de_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."check",
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_fr_Checks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."check",
  L.messageType_code,
  L.category_code,
  L.description
FROM Checks AS L;

CREATE VIEW localized_de_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

CREATE VIEW localized_fr_CheckSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM CheckSelections AS L;

CREATE VIEW localized_de_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parent_ID,
  L.type_code,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_fr_Functions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.function,
  L.sequence,
  L.parent_ID,
  L.type_code,
  L.description,
  L.documentation
FROM Functions AS L;

CREATE VIEW localized_de_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description,
  L.source_code,
  L.hanaTable,
  L.hanaView,
  L.odataUrl,
  L.odataUrlOptions
FROM Connections AS L;

CREATE VIEW localized_fr_Connections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.connection,
  L.description,
  L.source_code,
  L.hanaTable,
  L.hanaView,
  L.odataUrl,
  L.odataUrlOptions
FROM Connections AS L;

CREATE VIEW localized_de_RuntimeFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L.description,
  L.type_code,
  L.state_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.storedProcedure,
  L.appServerStatement,
  L.preStatement,
  L.statement,
  L.postStatement,
  L.hanaTable,
  L.hanaView,
  L.synonym,
  L.masterDataHierarchyView,
  L.calculationView,
  L.workBook,
  L.resultModelTable_ID
FROM RuntimeFunctions AS L;

CREATE VIEW localized_fr_RuntimeFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L.description,
  L.type_code,
  L.state_code,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.storedProcedure,
  L.appServerStatement,
  L.preStatement,
  L.statement,
  L.postStatement,
  L.hanaTable,
  L.hanaView,
  L.synonym,
  L.masterDataHierarchyView,
  L.calculationView,
  L.workBook,
  L.resultModelTable_ID
FROM RuntimeFunctions AS L;

CREATE VIEW localized_de_ApplicationLogs AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.run,
  L.type,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.mainFunction,
  L.parameters,
  L.selections,
  L.businessEvent,
  L.field,
  L."check",
  L.conversion,
  L."partition",
  L.package,
  L.state_code
FROM ApplicationLogs AS L;

CREATE VIEW localized_fr_ApplicationLogs AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.run,
  L.type,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.mainFunction,
  L.parameters,
  L.selections,
  L.businessEvent,
  L.field,
  L."check",
  L.conversion,
  L."partition",
  L.package,
  L.state_code
FROM ApplicationLogs AS L;

CREATE VIEW localized_de_ApplicationLogMessages AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.type_code,
  L.function,
  L.code,
  L.entity,
  L.primaryKey,
  L.target,
  L.argument1,
  L.argument2,
  L.argument3,
  L.argument4,
  L.argument5,
  L.argument6,
  L.messageDetails
FROM ApplicationLogMessages AS L;

CREATE VIEW localized_fr_ApplicationLogMessages AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.type_code,
  L.function,
  L.code,
  L.entity,
  L.primaryKey,
  L.target,
  L.argument1,
  L.argument2,
  L.argument3,
  L.argument4,
  L.argument5,
  L.argument6,
  L.messageDetails
FROM ApplicationLogMessages AS L;

CREATE VIEW localized_de_ApplicationLogChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationLogChecks AS L;

CREATE VIEW localized_fr_ApplicationLogChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.function,
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationLogChecks AS L;

CREATE VIEW localized_de_ApplicationLogFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.applicationLog_ID,
  L.logField_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field
FROM ApplicationLogFieldSelections AS L;

CREATE VIEW localized_fr_ApplicationLogFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.applicationLog_ID,
  L.logField_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field
FROM ApplicationLogFieldSelections AS L;

CREATE VIEW localized_de_Calculations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.resultFunction_ID,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.inputFunction_ID,
  L.ID,
  L.type_code,
  L.workbook
FROM Calculations AS L;

CREATE VIEW localized_fr_Calculations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.includeInputData,
  L.resultHandling_code,
  L.includeInitialResult,
  L.resultFunction_ID,
  L.processingType_code,
  L.businessEventType_code,
  L.partition_ID,
  L.inputFunction_ID,
  L.ID,
  L.type_code,
  L.workbook
FROM Calculations AS L;

CREATE VIEW localized_de_CalculationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.field_ID,
  L.calculation_ID
FROM CalculationInputFields AS L;

CREATE VIEW localized_fr_CalculationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.field_ID,
  L.calculation_ID
FROM CalculationInputFields AS L;

CREATE VIEW localized_de_CalculationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM CalculationInputFieldSelections AS L;

CREATE VIEW localized_fr_CalculationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM CalculationInputFieldSelections AS L;

CREATE VIEW localized_de_CalculationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM CalculationRuleConditionSelections AS L;

CREATE VIEW localized_fr_CalculationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.sequence,
  L.sign_code,
  L.option_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM CalculationRuleConditionSelections AS L;

CREATE VIEW localized_de_RuntimeFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.field,
  L.environment,
  L.version,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy,
  L.masterDataHanaView,
  L.description,
  L.documentation
FROM RuntimeFields AS L;

CREATE VIEW localized_fr_RuntimeFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.field,
  L.environment,
  L.version,
  L.class_code,
  L.type_code,
  L.hanaDataType_code,
  L.dataLength,
  L.dataDecimals,
  L.unitField_ID,
  L.isLowercase,
  L.hasMasterData,
  L.hasHierarchies,
  L.calculationHierarchy,
  L.masterDataHanaView,
  L.description,
  L.documentation
FROM RuntimeFields AS L;

CREATE VIEW localized_de_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_fr_FieldValues AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value,
  L.isNode,
  L.description
FROM FieldValues AS L;

CREATE VIEW localized_de_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_fr_FieldValueAuthorizations AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.value_ID,
  L.userGrp,
  L.readAccess,
  L.writeAccess
FROM FieldValueAuthorizations AS L;

CREATE VIEW localized_de_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_fr_FieldHierarchies AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.hierarchy,
  L.description
FROM FieldHierarchies AS L;

CREATE VIEW localized_de_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_fr_FieldHierarchyStructures AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.sequence,
  L.hierarchy_ID,
  L.value_ID,
  L.parentValue_ID
FROM FieldHierarchyStructures AS L;

CREATE VIEW localized_de_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_fr_CurrencyConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.currencyConversion,
  L.description,
  L.category_code,
  L.method_code,
  L.bidAskType_code,
  L.marketDataArea,
  L.type,
  L.lookup_code,
  L.errorHandling_code,
  L.accuracy_code,
  L.dateFormat_code,
  L.steps_code,
  L.configurationConnection_ID,
  L.rateConnection_ID,
  L.prefactorConnection_ID
FROM CurrencyConversions AS L;

CREATE VIEW localized_de_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

CREATE VIEW localized_fr_UnitConversions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.unitConversion,
  L.description,
  L.errorHandling_code,
  L.rateConnection_ID,
  L.dimensionConnection_ID
FROM UnitConversions AS L;

CREATE VIEW localized_de_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_fr_Partitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM Partitions AS L;

CREATE VIEW localized_de_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM PartitionRanges AS L;

CREATE VIEW localized_fr_PartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM PartitionRanges AS L;

CREATE VIEW localized_de_CalculationLookupFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.lookupFunction_ID,
  L.ID,
  L.calculation_ID
FROM CalculationLookupFunctions AS L;

CREATE VIEW localized_fr_CalculationLookupFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.lookupFunction_ID,
  L.ID,
  L.calculation_ID
FROM CalculationLookupFunctions AS L;

CREATE VIEW localized_de_CalculationSignatureFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.field_ID,
  L.selection,
  L."action",
  L.granularity,
  L.ID,
  L.calculation_ID
FROM CalculationSignatureFields AS L;

CREATE VIEW localized_fr_CalculationSignatureFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.field_ID,
  L.selection,
  L."action",
  L.granularity,
  L.ID,
  L.calculation_ID
FROM CalculationSignatureFields AS L;

CREATE VIEW localized_de_CalculationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.sequence,
  L.description
FROM CalculationRules AS L;

CREATE VIEW localized_fr_CalculationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.sequence,
  L.description
FROM CalculationRules AS L;

CREATE VIEW localized_de_CalculationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleConditions AS L;

CREATE VIEW localized_fr_CalculationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleConditions AS L;

CREATE VIEW localized_de_CalculationRuleActions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleActions AS L;

CREATE VIEW localized_fr_CalculationRuleActions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM CalculationRuleActions AS L;

CREATE VIEW localized_de_CalculationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.check_ID
FROM CalculationChecks AS L;

CREATE VIEW localized_fr_CalculationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.calculation_ID,
  L.check_ID
FROM CalculationChecks AS L;

CREATE VIEW localized_de_CuProcessActivityPerformerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityPerformerTeams AS L;

CREATE VIEW localized_fr_CuProcessActivityPerformerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityPerformerTeams AS L;

CREATE VIEW localized_de_CuProcessActivityReviewerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityReviewerTeams AS L;

CREATE VIEW localized_fr_CuProcessActivityReviewerTeams AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.team_ID
FROM CuProcessActivityReviewerTeams AS L;

CREATE VIEW localized_de_CuProcessActivityComments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment
FROM CuProcessActivityComments AS L;

CREATE VIEW localized_fr_CuProcessActivityComments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment
FROM CuProcessActivityComments AS L;

CREATE VIEW localized_de_CuProcessActivityCommentAttachments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment_ID,
  L.name,
  L.file
FROM CuProcessActivityCommentAttachments AS L;

CREATE VIEW localized_fr_CuProcessActivityCommentAttachments AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.comment_ID,
  L.name,
  L.file
FROM CuProcessActivityCommentAttachments AS L;

CREATE VIEW localized_de_CuProcessActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CuProcessActivityLinks AS L;

CREATE VIEW localized_fr_CuProcessActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CuProcessActivityLinks AS L;

CREATE VIEW localized_de_CuProcessReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CuProcessReports AS L;

CREATE VIEW localized_fr_CuProcessReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CuProcessReports AS L;

CREATE VIEW localized_de_CuProcessReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CuProcessReportElements AS L;

CREATE VIEW localized_fr_CuProcessReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.process_ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CuProcessReportElements AS L;

CREATE VIEW localized_de_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

CREATE VIEW localized_fr_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

CREATE VIEW localized_de_RuntimeShareLocks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.partitionField_ID,
  L.partitionFieldRangeValue
FROM RuntimeShareLocks AS L;

CREATE VIEW localized_fr_RuntimeShareLocks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.partitionField_ID,
  L.partitionFieldRangeValue
FROM RuntimeShareLocks AS L;

CREATE VIEW localized_de_RuntimeOutputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.function_ID,
  L.field
FROM RuntimeOutputFields AS L;

CREATE VIEW localized_fr_RuntimeOutputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.environment,
  L.version,
  L.function_ID,
  L.field
FROM RuntimeOutputFields AS L;

CREATE VIEW localized_de_RuntimeProcessChains AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.level
FROM RuntimeProcessChains AS L;

CREATE VIEW localized_fr_RuntimeProcessChains AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.level
FROM RuntimeProcessChains AS L;

CREATE VIEW localized_de_RuntimeProcessChainFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.processChain_ID,
  L.function_ID
FROM RuntimeProcessChainFunctions AS L;

CREATE VIEW localized_fr_RuntimeProcessChainFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.processChain_ID,
  L.function_ID
FROM RuntimeProcessChainFunctions AS L;

CREATE VIEW localized_de_RuntimeInputFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.inputFunction_ID
FROM RuntimeInputFunctions AS L;

CREATE VIEW localized_fr_RuntimeInputFunctions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.inputFunction_ID
FROM RuntimeInputFunctions AS L;

CREATE VIEW localized_de_SXP0012_MTAC AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.AC,
  L._DESCR,
  L._LOCALE,
  L._IS_NODE,
  L._HIER_NAME,
  L.PARENT,
  L._SEQUENCE
FROM SXP0012_MTAC AS L;

CREATE VIEW localized_fr_SXP0012_MTAC AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L._APPLICATIONLOG_ID,
  L._STATE,
  L.AC,
  L._DESCR,
  L._LOCALE,
  L._IS_NODE,
  L._HIER_NAME,
  L.PARENT,
  L._SEQUENCE
FROM SXP0012_MTAC AS L;

CREATE VIEW localized_de_ApplicationLogStatistics AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.function,
  L.startTimestamp,
  L.endTimestamp,
  L.inputRecords,
  L.resultRecords,
  L.successRecords,
  L.warningRecords,
  L.errorRecords,
  L.abortRecords,
  L.inputDuration,
  L.processingDuration,
  L.outputDuration
FROM ApplicationLogStatistics AS L;

CREATE VIEW localized_fr_ApplicationLogStatistics AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.applicationLog_ID,
  L.function,
  L.startTimestamp,
  L.endTimestamp,
  L.inputRecords,
  L.resultRecords,
  L.successRecords,
  L.warningRecords,
  L.errorRecords,
  L.abortRecords,
  L.inputDuration,
  L.processingDuration,
  L.outputDuration
FROM ApplicationLogStatistics AS L;

CREATE VIEW localized_de_ApplicationLogFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.formula,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field,
  L.step
FROM ApplicationLogFields AS L;

CREATE VIEW localized_fr_ApplicationLogFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.formula,
  L.ID,
  L.applicationLog_ID,
  L.environment,
  L.version,
  L.process,
  L.activity,
  L.field,
  L.step
FROM ApplicationLogFields AS L;

CREATE VIEW localized_de_RuntimePartitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM RuntimePartitions AS L;

CREATE VIEW localized_fr_RuntimePartitions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L."partition",
  L.description,
  L.field_ID
FROM RuntimePartitions AS L;

CREATE VIEW localized_de_RuntimePartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM RuntimePartitionRanges AS L;

CREATE VIEW localized_fr_RuntimePartitionRanges AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.partition_ID,
  L."range",
  L.sequence,
  L.level,
  L.value
FROM RuntimePartitionRanges AS L;

CREATE VIEW localized_de_EnvironmentService__CURRENCIES AS SELECT
  _CURRENCIES_0.name,
  _CURRENCIES_0.descr,
  _CURRENCIES_0.code,
  _CURRENCIES_0.symbol,
  _CURRENCIES_0.decimalPlaces
FROM localized_de_SXP0012__CURRENCIES AS _CURRENCIES_0
ORDER BY code;

CREATE VIEW localized_fr_EnvironmentService__CURRENCIES AS SELECT
  _CURRENCIES_0.name,
  _CURRENCIES_0.descr,
  _CURRENCIES_0.code,
  _CURRENCIES_0.symbol,
  _CURRENCIES_0.decimalPlaces
FROM localized_fr_SXP0012__CURRENCIES AS _CURRENCIES_0
ORDER BY code;

CREATE VIEW localized_de_EnvironmentService__UNITS AS SELECT
  _UNITS_0.name,
  _UNITS_0.descr,
  _UNITS_0.code,
  _UNITS_0.symbol,
  _UNITS_0.decimalPlaces
FROM localized_de_SXP0012__UNITS AS _UNITS_0
ORDER BY code;

CREATE VIEW localized_fr_EnvironmentService__UNITS AS SELECT
  _UNITS_0.name,
  _UNITS_0.descr,
  _UNITS_0.code,
  _UNITS_0.symbol,
  _UNITS_0.decimalPlaces
FROM localized_fr_SXP0012__UNITS AS _UNITS_0
ORDER BY code;

CREATE VIEW localized_de_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_de_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_fr_EnvironmentFolders AS SELECT
  Environments_0.createdAt,
  Environments_0.createdBy,
  Environments_0.modifiedAt,
  Environments_0.modifiedBy,
  Environments_0.ID,
  Environments_0.environment,
  Environments_0.version,
  Environments_0.description,
  Environments_0.parent_ID,
  Environments_0.type_code
FROM localized_fr_Environments AS Environments_0
WHERE Environments_0.type_code = 'NODE';

CREATE VIEW localized_de_SXP0012_QERES AS SELECT
  AL01_0.AC_AC,
  AL01_0.QUANTITY,
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.SUM
FROM localized_de_SXP0012_AL01 AS AL01_0;

CREATE VIEW localized_fr_SXP0012_QERES AS SELECT
  AL01_0.AC_AC,
  AL01_0.QUANTITY,
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.SUM
FROM localized_fr_SXP0012_AL01 AS AL01_0;

CREATE VIEW localized_de_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_de_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_fr_UnitFields AS SELECT
  Fields_0.createdAt,
  Fields_0.createdBy,
  Fields_0.modifiedAt,
  Fields_0.modifiedBy,
  Fields_0.environment_ID,
  Fields_0.ID,
  Fields_0.field,
  Fields_0.class_code,
  Fields_0.type_code,
  Fields_0.hanaDataType_code,
  Fields_0.dataLength,
  Fields_0.dataDecimals,
  Fields_0.unitField_ID,
  Fields_0.isLowercase,
  Fields_0.hasMasterData,
  Fields_0.hasHierarchies,
  Fields_0.calculationHierarchy_ID,
  Fields_0.masterDataQuery_ID,
  Fields_0.description,
  Fields_0.documentation
FROM localized_fr_Fields AS Fields_0
WHERE Fields_0.type_code = 'UNI';

CREATE VIEW localized_de_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_fr_MasterDataQueries AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_fr_FunctionParentCalculationUnits AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU';

CREATE VIEW localized_de_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_de_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('AL', 'DE', 'JO', 'MJ', 'MT', 'MV', 'QE', 'RF', 'VW', 'WR');

CREATE VIEW localized_fr_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_fr_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('AL', 'DE', 'JO', 'MJ', 'MT', 'MV', 'QE', 'RF', 'VW', 'WR');

CREATE VIEW localized_de_RuntimeFunctionResultFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_de_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('MT', 'MV');

CREATE VIEW localized_fr_RuntimeFunctionResultFunctions AS SELECT
  RuntimeFunctions_0.createdAt,
  RuntimeFunctions_0.createdBy,
  RuntimeFunctions_0.modifiedAt,
  RuntimeFunctions_0.modifiedBy,
  RuntimeFunctions_0.ID,
  RuntimeFunctions_0.environment,
  RuntimeFunctions_0.version,
  RuntimeFunctions_0.process,
  RuntimeFunctions_0.activity,
  RuntimeFunctions_0.function,
  RuntimeFunctions_0.description,
  RuntimeFunctions_0.type_code,
  RuntimeFunctions_0.state_code,
  RuntimeFunctions_0.processingType_code,
  RuntimeFunctions_0.businessEventType_code,
  RuntimeFunctions_0.partition_ID,
  RuntimeFunctions_0.storedProcedure,
  RuntimeFunctions_0.appServerStatement,
  RuntimeFunctions_0.preStatement,
  RuntimeFunctions_0.statement,
  RuntimeFunctions_0.postStatement,
  RuntimeFunctions_0.hanaTable,
  RuntimeFunctions_0.hanaView,
  RuntimeFunctions_0.synonym,
  RuntimeFunctions_0.masterDataHierarchyView,
  RuntimeFunctions_0.calculationView,
  RuntimeFunctions_0.workBook,
  RuntimeFunctions_0.resultModelTable_ID
FROM localized_fr_RuntimeFunctions AS RuntimeFunctions_0
WHERE RuntimeFunctions_0.type_code IN ('MT', 'MV');

CREATE VIEW localized_de_FunctionResultFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_fr_FunctionResultFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'MT';

CREATE VIEW localized_de_FunctionInputFunctionsVH AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.function,
  F_0.sequence,
  F_0.parent_ID,
  F_0.type_code,
  F_0.description,
  F_0.documentation
FROM localized_de_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_fr_FunctionInputFunctionsVH AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.function,
  F_0.sequence,
  F_0.parent_ID,
  F_0.type_code,
  F_0.description,
  F_0.documentation
FROM localized_fr_Functions AS F_0
WHERE F_0.type_code IN ('MT', 'AL');

CREATE VIEW localized_de_FunctionParentFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_de_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_fr_FunctionParentFunctionsVH AS SELECT
  Functions_0.createdAt,
  Functions_0.createdBy,
  Functions_0.modifiedAt,
  Functions_0.modifiedBy,
  Functions_0.environment_ID,
  Functions_0.ID,
  Functions_0.function,
  Functions_0.sequence,
  Functions_0.parent_ID,
  Functions_0.type_code,
  Functions_0.description,
  Functions_0.documentation
FROM localized_fr_Functions AS Functions_0
WHERE Functions_0.type_code = 'CU' OR Functions_0.type_code = 'DS';

CREATE VIEW localized_de_EnvironmentService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_de_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_fr_EnvironmentService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_fr_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessTypes AS SELECT
  CuProcessTypes_0.name,
  CuProcessTypes_0.descr,
  CuProcessTypes_0.code
FROM localized_de_CuProcessTypes AS CuProcessTypes_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessTypes AS SELECT
  CuProcessTypes_0.name,
  CuProcessTypes_0.descr,
  CuProcessTypes_0.code
FROM localized_fr_CuProcessTypes AS CuProcessTypes_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessStates AS SELECT
  CuProcessStates_0.name,
  CuProcessStates_0.descr,
  CuProcessStates_0.code
FROM localized_de_CuProcessStates AS CuProcessStates_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessStates AS SELECT
  CuProcessStates_0.name,
  CuProcessStates_0.descr,
  CuProcessStates_0.code
FROM localized_fr_CuProcessStates AS CuProcessStates_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityTypes AS SELECT
  CuProcessActivityTypes_0.name,
  CuProcessActivityTypes_0.descr,
  CuProcessActivityTypes_0.code
FROM localized_de_CuProcessActivityTypes AS CuProcessActivityTypes_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityTypes AS SELECT
  CuProcessActivityTypes_0.name,
  CuProcessActivityTypes_0.descr,
  CuProcessActivityTypes_0.code
FROM localized_fr_CuProcessActivityTypes AS CuProcessActivityTypes_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityStates AS SELECT
  CuProcessActivityStates_0.name,
  CuProcessActivityStates_0.descr,
  CuProcessActivityStates_0.code
FROM localized_de_CuProcessActivityStates AS CuProcessActivityStates_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityStates AS SELECT
  CuProcessActivityStates_0.name,
  CuProcessActivityStates_0.descr,
  CuProcessActivityStates_0.code
FROM localized_fr_CuProcessActivityStates AS CuProcessActivityStates_0;

CREATE VIEW localized_de_EnvironmentService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_de_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_fr_EnvironmentService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_fr_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_de_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_fr_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_de_EnvironmentService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_de_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_fr_EnvironmentService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_fr_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_de_EnvironmentService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_de_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_fr_EnvironmentService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_fr_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_de_EnvironmentService_AL01 AS SELECT
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.AC_AC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.QUANTITY,
  AL01_0.SUM
FROM localized_de_SXP0012_AL01 AS AL01_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_AL01 AS SELECT
  AL01_0.createdAt,
  AL01_0.createdBy,
  AL01_0.modifiedAt,
  AL01_0.modifiedBy,
  AL01_0._ID,
  AL01_0._APPLICATIONLOG_ID,
  AL01_0._STATE,
  AL01_0.CC_CC,
  AL01_0.PC,
  AL01_0.AC_AC,
  AL01_0.CURRENCY_code,
  AL01_0.AMOUNT,
  AL01_0.UNIT_code,
  AL01_0.QUANTITY,
  AL01_0.SUM
FROM localized_fr_SXP0012_AL01 AS AL01_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_CA01 AS SELECT
  CA01_0.createdAt,
  CA01_0.createdBy,
  CA01_0.modifiedAt,
  CA01_0.modifiedBy,
  CA01_0._ID,
  CA01_0._APPLICATIONLOG_ID,
  CA01_0._STATE,
  CA01_0.CC_CC,
  CA01_0.PC,
  CA01_0.AC_AC,
  CA01_0.CURRENCY_code,
  CA01_0.AMOUNT,
  CA01_0.UNIT_code,
  CA01_0.QUANTITY,
  CA01_0.SUM
FROM localized_de_SXP0012_CA01 AS CA01_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_CA01 AS SELECT
  CA01_0.createdAt,
  CA01_0.createdBy,
  CA01_0.modifiedAt,
  CA01_0.modifiedBy,
  CA01_0._ID,
  CA01_0._APPLICATIONLOG_ID,
  CA01_0._STATE,
  CA01_0.CC_CC,
  CA01_0.PC,
  CA01_0.AC_AC,
  CA01_0.CURRENCY_code,
  CA01_0.AMOUNT,
  CA01_0.UNIT_code,
  CA01_0.QUANTITY,
  CA01_0.SUM
FROM localized_fr_SXP0012_CA01 AS CA01_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_DE01 AS SELECT
  DE01_0.createdAt,
  DE01_0.createdBy,
  DE01_0.modifiedAt,
  DE01_0.modifiedBy,
  DE01_0._ID,
  DE01_0._APPLICATIONLOG_ID,
  DE01_0._STATE,
  DE01_0.CC_CC,
  DE01_0.PC,
  DE01_0.AC_AC,
  DE01_0.CURRENCY_code,
  DE01_0.AMOUNT,
  DE01_0.UNIT_code,
  DE01_0.QUANTITY,
  DE01_0.SUM
FROM localized_de_SXP0012_DE01 AS DE01_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_DE01 AS SELECT
  DE01_0.createdAt,
  DE01_0.createdBy,
  DE01_0.modifiedAt,
  DE01_0.modifiedBy,
  DE01_0._ID,
  DE01_0._APPLICATIONLOG_ID,
  DE01_0._STATE,
  DE01_0.CC_CC,
  DE01_0.PC,
  DE01_0.AC_AC,
  DE01_0.CURRENCY_code,
  DE01_0.AMOUNT,
  DE01_0.UNIT_code,
  DE01_0.QUANTITY,
  DE01_0.SUM
FROM localized_fr_SXP0012_DE01 AS DE01_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_JO01 AS SELECT
  JO01_0.createdAt,
  JO01_0.createdBy,
  JO01_0.modifiedAt,
  JO01_0.modifiedBy,
  JO01_0._ID,
  JO01_0._APPLICATIONLOG_ID,
  JO01_0._STATE,
  JO01_0.CC_CC,
  JO01_0.PC,
  JO01_0.AC_AC,
  JO01_0.CURRENCY_code,
  JO01_0.AMOUNT,
  JO01_0.UNIT_code,
  JO01_0.QUANTITY
FROM localized_de_SXP0012_JO01 AS JO01_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_JO01 AS SELECT
  JO01_0.createdAt,
  JO01_0.createdBy,
  JO01_0.modifiedAt,
  JO01_0.modifiedBy,
  JO01_0._ID,
  JO01_0._APPLICATIONLOG_ID,
  JO01_0._STATE,
  JO01_0.CC_CC,
  JO01_0.PC,
  JO01_0.AC_AC,
  JO01_0.CURRENCY_code,
  JO01_0.AMOUNT,
  JO01_0.UNIT_code,
  JO01_0.QUANTITY
FROM localized_fr_SXP0012_JO01 AS JO01_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_MT01 AS SELECT
  MT01_0.createdAt,
  MT01_0.createdBy,
  MT01_0.modifiedAt,
  MT01_0.modifiedBy,
  MT01_0._ID,
  MT01_0._APPLICATIONLOG_ID,
  MT01_0._STATE,
  MT01_0.CC_CC,
  MT01_0.PC,
  MT01_0.FACTOR,
  MT01_0.CURRENCY_code,
  MT01_0.AMOUNT
FROM localized_de_SXP0012_MT01 AS MT01_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_MT01 AS SELECT
  MT01_0.createdAt,
  MT01_0.createdBy,
  MT01_0.modifiedAt,
  MT01_0.modifiedBy,
  MT01_0._ID,
  MT01_0._APPLICATIONLOG_ID,
  MT01_0._STATE,
  MT01_0.CC_CC,
  MT01_0.PC,
  MT01_0.FACTOR,
  MT01_0.CURRENCY_code,
  MT01_0.AMOUNT
FROM localized_fr_SXP0012_MT01 AS MT01_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_MT02 AS SELECT
  MT02_0.createdAt,
  MT02_0.createdBy,
  MT02_0.modifiedAt,
  MT02_0.modifiedBy,
  MT02_0._ID,
  MT02_0._APPLICATIONLOG_ID,
  MT02_0._STATE,
  MT02_0.CC_CC,
  MT02_0.PC,
  MT02_0.AC_AC,
  MT02_0.UNIT_code,
  MT02_0.QUANTITY
FROM localized_de_SXP0012_MT02 AS MT02_0
ORDER BY _ID;

CREATE VIEW localized_fr_EnvironmentService_MT02 AS SELECT
  MT02_0.createdAt,
  MT02_0.createdBy,
  MT02_0.modifiedAt,
  MT02_0.modifiedBy,
  MT02_0._ID,
  MT02_0._APPLICATIONLOG_ID,
  MT02_0._STATE,
  MT02_0.CC_CC,
  MT02_0.PC,
  MT02_0.AC_AC,
  MT02_0.UNIT_code,
  MT02_0.QUANTITY
FROM localized_fr_SXP0012_MT02 AS MT02_0
ORDER BY _ID;

CREATE VIEW localized_de_EnvironmentService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_de_Environments AS environments_0
ORDER BY environment, version;

CREATE VIEW localized_fr_EnvironmentService_Environments AS SELECT
  environments_0.createdAt,
  environments_0.createdBy,
  environments_0.modifiedAt,
  environments_0.modifiedBy,
  environments_0.ID,
  environments_0.environment,
  environments_0.version,
  environments_0.description,
  environments_0.parent_ID,
  environments_0.type_code
FROM localized_fr_Environments AS environments_0
ORDER BY environment, version;

CREATE VIEW localized_de_EnvironmentService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_de_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_fr_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_de_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_fr_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.environment,
  RuntimeOutputFields_0.version,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field
FROM localized_de_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.environment,
  RuntimeOutputFields_0.version,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field
FROM localized_fr_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeShareLocks AS SELECT
  RuntimeShareLocks_0.createdAt,
  RuntimeShareLocks_0.createdBy,
  RuntimeShareLocks_0.modifiedAt,
  RuntimeShareLocks_0.modifiedBy,
  RuntimeShareLocks_0.ID,
  RuntimeShareLocks_0.function_ID,
  RuntimeShareLocks_0.environment,
  RuntimeShareLocks_0.version,
  RuntimeShareLocks_0.process,
  RuntimeShareLocks_0.activity,
  RuntimeShareLocks_0.partitionField_ID,
  RuntimeShareLocks_0.partitionFieldRangeValue
FROM localized_de_RuntimeShareLocks AS RuntimeShareLocks_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeShareLocks AS SELECT
  RuntimeShareLocks_0.createdAt,
  RuntimeShareLocks_0.createdBy,
  RuntimeShareLocks_0.modifiedAt,
  RuntimeShareLocks_0.modifiedBy,
  RuntimeShareLocks_0.ID,
  RuntimeShareLocks_0.function_ID,
  RuntimeShareLocks_0.environment,
  RuntimeShareLocks_0.version,
  RuntimeShareLocks_0.process,
  RuntimeShareLocks_0.activity,
  RuntimeShareLocks_0.partitionField_ID,
  RuntimeShareLocks_0.partitionFieldRangeValue
FROM localized_fr_RuntimeShareLocks AS RuntimeShareLocks_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_de_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_fr_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_de_SXP0012_QEAC AS SELECT
  MTAC_0.AC,
  MTAC_0.createdAt,
  MTAC_0.createdBy,
  MTAC_0.modifiedAt,
  MTAC_0.modifiedBy,
  MTAC_0._APPLICATIONLOG_ID,
  MTAC_0._STATE,
  MTAC_0._DESCR,
  MTAC_0._LOCALE,
  MTAC_0._IS_NODE,
  MTAC_0._HIER_NAME,
  MTAC_0.PARENT,
  MTAC_0._SEQUENCE
FROM localized_de_SXP0012_MTAC AS MTAC_0;

CREATE VIEW localized_fr_SXP0012_QEAC AS SELECT
  MTAC_0.AC,
  MTAC_0.createdAt,
  MTAC_0.createdBy,
  MTAC_0.modifiedAt,
  MTAC_0.modifiedBy,
  MTAC_0._APPLICATIONLOG_ID,
  MTAC_0._STATE,
  MTAC_0._DESCR,
  MTAC_0._LOCALE,
  MTAC_0._IS_NODE,
  MTAC_0._HIER_NAME,
  MTAC_0.PARENT,
  MTAC_0._SEQUENCE
FROM localized_fr_SXP0012_MTAC AS MTAC_0;

CREATE VIEW localized_de_EnvironmentService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_de_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_fr_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_de_EnvironmentService_CuProcesses AS SELECT
  cuProcesses_0.createdAt,
  cuProcesses_0.createdBy,
  cuProcesses_0.modifiedAt,
  cuProcesses_0.modifiedBy,
  cuProcesses_0.ID,
  cuProcesses_0.environment,
  cuProcesses_0.version,
  cuProcesses_0.process,
  cuProcesses_0.type_code,
  cuProcesses_0.state_code,
  cuProcesses_0.description
FROM localized_de_CuProcesses AS cuProcesses_0
ORDER BY ID;

CREATE VIEW localized_fr_EnvironmentService_CuProcesses AS SELECT
  cuProcesses_0.createdAt,
  cuProcesses_0.createdBy,
  cuProcesses_0.modifiedAt,
  cuProcesses_0.modifiedBy,
  cuProcesses_0.ID,
  cuProcesses_0.environment,
  cuProcesses_0.version,
  cuProcesses_0.process,
  cuProcesses_0.type_code,
  cuProcesses_0.state_code,
  cuProcesses_0.description
FROM localized_fr_CuProcesses AS cuProcesses_0
ORDER BY ID;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivities AS SELECT
  CuProcessActivities_0.createdAt,
  CuProcessActivities_0.createdBy,
  CuProcessActivities_0.modifiedAt,
  CuProcessActivities_0.modifiedBy,
  CuProcessActivities_0.ID,
  CuProcessActivities_0.process_ID,
  CuProcessActivities_0.activity,
  CuProcessActivities_0.parent_ID,
  CuProcessActivities_0.sequence,
  CuProcessActivities_0.activityType_code,
  CuProcessActivities_0.activityState_code,
  CuProcessActivities_0.function_ID,
  CuProcessActivities_0.startDate,
  CuProcessActivities_0.endDate,
  CuProcessActivities_0.url
FROM localized_de_CuProcessActivities AS CuProcessActivities_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivities AS SELECT
  CuProcessActivities_0.createdAt,
  CuProcessActivities_0.createdBy,
  CuProcessActivities_0.modifiedAt,
  CuProcessActivities_0.modifiedBy,
  CuProcessActivities_0.ID,
  CuProcessActivities_0.process_ID,
  CuProcessActivities_0.activity,
  CuProcessActivities_0.parent_ID,
  CuProcessActivities_0.sequence,
  CuProcessActivities_0.activityType_code,
  CuProcessActivities_0.activityState_code,
  CuProcessActivities_0.function_ID,
  CuProcessActivities_0.startDate,
  CuProcessActivities_0.endDate,
  CuProcessActivities_0.url
FROM localized_fr_CuProcessActivities AS CuProcessActivities_0;

CREATE VIEW localized_de_EnvironmentService_RuntimePartitionRanges AS SELECT
  RuntimePartitionRanges_0.createdAt,
  RuntimePartitionRanges_0.createdBy,
  RuntimePartitionRanges_0.modifiedAt,
  RuntimePartitionRanges_0.modifiedBy,
  RuntimePartitionRanges_0.ID,
  RuntimePartitionRanges_0.partition_ID,
  RuntimePartitionRanges_0."range",
  RuntimePartitionRanges_0.sequence,
  RuntimePartitionRanges_0.level,
  RuntimePartitionRanges_0.value
FROM localized_de_RuntimePartitionRanges AS RuntimePartitionRanges_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimePartitionRanges AS SELECT
  RuntimePartitionRanges_0.createdAt,
  RuntimePartitionRanges_0.createdBy,
  RuntimePartitionRanges_0.modifiedAt,
  RuntimePartitionRanges_0.modifiedBy,
  RuntimePartitionRanges_0.ID,
  RuntimePartitionRanges_0.partition_ID,
  RuntimePartitionRanges_0."range",
  RuntimePartitionRanges_0.sequence,
  RuntimePartitionRanges_0.level,
  RuntimePartitionRanges_0.value
FROM localized_fr_RuntimePartitionRanges AS RuntimePartitionRanges_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityPerformerTeams AS SELECT
  CuProcessActivityPerformerTeams_0.createdAt,
  CuProcessActivityPerformerTeams_0.createdBy,
  CuProcessActivityPerformerTeams_0.modifiedAt,
  CuProcessActivityPerformerTeams_0.modifiedBy,
  CuProcessActivityPerformerTeams_0.ID,
  CuProcessActivityPerformerTeams_0.process_ID,
  CuProcessActivityPerformerTeams_0.activity_ID,
  CuProcessActivityPerformerTeams_0.team_ID
FROM localized_de_CuProcessActivityPerformerTeams AS CuProcessActivityPerformerTeams_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityPerformerTeams AS SELECT
  CuProcessActivityPerformerTeams_0.createdAt,
  CuProcessActivityPerformerTeams_0.createdBy,
  CuProcessActivityPerformerTeams_0.modifiedAt,
  CuProcessActivityPerformerTeams_0.modifiedBy,
  CuProcessActivityPerformerTeams_0.ID,
  CuProcessActivityPerformerTeams_0.process_ID,
  CuProcessActivityPerformerTeams_0.activity_ID,
  CuProcessActivityPerformerTeams_0.team_ID
FROM localized_fr_CuProcessActivityPerformerTeams AS CuProcessActivityPerformerTeams_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityReviewerTeams AS SELECT
  CuProcessActivityReviewerTeams_0.createdAt,
  CuProcessActivityReviewerTeams_0.createdBy,
  CuProcessActivityReviewerTeams_0.modifiedAt,
  CuProcessActivityReviewerTeams_0.modifiedBy,
  CuProcessActivityReviewerTeams_0.ID,
  CuProcessActivityReviewerTeams_0.process_ID,
  CuProcessActivityReviewerTeams_0.activity_ID,
  CuProcessActivityReviewerTeams_0.team_ID
FROM localized_de_CuProcessActivityReviewerTeams AS CuProcessActivityReviewerTeams_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityReviewerTeams AS SELECT
  CuProcessActivityReviewerTeams_0.createdAt,
  CuProcessActivityReviewerTeams_0.createdBy,
  CuProcessActivityReviewerTeams_0.modifiedAt,
  CuProcessActivityReviewerTeams_0.modifiedBy,
  CuProcessActivityReviewerTeams_0.ID,
  CuProcessActivityReviewerTeams_0.process_ID,
  CuProcessActivityReviewerTeams_0.activity_ID,
  CuProcessActivityReviewerTeams_0.team_ID
FROM localized_fr_CuProcessActivityReviewerTeams AS CuProcessActivityReviewerTeams_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityComments AS SELECT
  CuProcessActivityComments_0.createdAt,
  CuProcessActivityComments_0.createdBy,
  CuProcessActivityComments_0.modifiedAt,
  CuProcessActivityComments_0.modifiedBy,
  CuProcessActivityComments_0.ID,
  CuProcessActivityComments_0.process_ID,
  CuProcessActivityComments_0.activity_ID,
  CuProcessActivityComments_0.comment
FROM localized_de_CuProcessActivityComments AS CuProcessActivityComments_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityComments AS SELECT
  CuProcessActivityComments_0.createdAt,
  CuProcessActivityComments_0.createdBy,
  CuProcessActivityComments_0.modifiedAt,
  CuProcessActivityComments_0.modifiedBy,
  CuProcessActivityComments_0.ID,
  CuProcessActivityComments_0.process_ID,
  CuProcessActivityComments_0.activity_ID,
  CuProcessActivityComments_0.comment
FROM localized_fr_CuProcessActivityComments AS CuProcessActivityComments_0;

CREATE VIEW localized_de_EnvironmentService_CuProcessActivityCommentAttachments AS SELECT
  CuProcessActivityCommentAttachments_0.createdAt,
  CuProcessActivityCommentAttachments_0.createdBy,
  CuProcessActivityCommentAttachments_0.modifiedAt,
  CuProcessActivityCommentAttachments_0.modifiedBy,
  CuProcessActivityCommentAttachments_0.ID,
  CuProcessActivityCommentAttachments_0.process_ID,
  CuProcessActivityCommentAttachments_0.activity_ID,
  CuProcessActivityCommentAttachments_0.comment_ID,
  CuProcessActivityCommentAttachments_0.name,
  CuProcessActivityCommentAttachments_0.file
FROM localized_de_CuProcessActivityCommentAttachments AS CuProcessActivityCommentAttachments_0;

CREATE VIEW localized_fr_EnvironmentService_CuProcessActivityCommentAttachments AS SELECT
  CuProcessActivityCommentAttachments_0.createdAt,
  CuProcessActivityCommentAttachments_0.createdBy,
  CuProcessActivityCommentAttachments_0.modifiedAt,
  CuProcessActivityCommentAttachments_0.modifiedBy,
  CuProcessActivityCommentAttachments_0.ID,
  CuProcessActivityCommentAttachments_0.process_ID,
  CuProcessActivityCommentAttachments_0.activity_ID,
  CuProcessActivityCommentAttachments_0.comment_ID,
  CuProcessActivityCommentAttachments_0.name,
  CuProcessActivityCommentAttachments_0.file
FROM localized_fr_CuProcessActivityCommentAttachments AS CuProcessActivityCommentAttachments_0;

CREATE VIEW localized_de_EnvironmentService_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctionInputFunctions_0.createdAt,
  RuntimeFunctionInputFunctions_0.createdBy,
  RuntimeFunctionInputFunctions_0.modifiedAt,
  RuntimeFunctionInputFunctions_0.modifiedBy,
  RuntimeFunctionInputFunctions_0.ID,
  RuntimeFunctionInputFunctions_0.environment,
  RuntimeFunctionInputFunctions_0.version,
  RuntimeFunctionInputFunctions_0.process,
  RuntimeFunctionInputFunctions_0.activity,
  RuntimeFunctionInputFunctions_0.function,
  RuntimeFunctionInputFunctions_0.description,
  RuntimeFunctionInputFunctions_0.type_code,
  RuntimeFunctionInputFunctions_0.state_code,
  RuntimeFunctionInputFunctions_0.processingType_code,
  RuntimeFunctionInputFunctions_0.businessEventType_code,
  RuntimeFunctionInputFunctions_0.partition_ID,
  RuntimeFunctionInputFunctions_0.storedProcedure,
  RuntimeFunctionInputFunctions_0.appServerStatement,
  RuntimeFunctionInputFunctions_0.preStatement,
  RuntimeFunctionInputFunctions_0.statement,
  RuntimeFunctionInputFunctions_0.postStatement,
  RuntimeFunctionInputFunctions_0.hanaTable,
  RuntimeFunctionInputFunctions_0.hanaView,
  RuntimeFunctionInputFunctions_0.synonym,
  RuntimeFunctionInputFunctions_0.masterDataHierarchyView,
  RuntimeFunctionInputFunctions_0.calculationView,
  RuntimeFunctionInputFunctions_0.workBook,
  RuntimeFunctionInputFunctions_0.resultModelTable_ID
FROM localized_de_RuntimeFunctionInputFunctions AS RuntimeFunctionInputFunctions_0;

CREATE VIEW localized_fr_EnvironmentService_RuntimeFunctionInputFunctions AS SELECT
  RuntimeFunctionInputFunctions_0.createdAt,
  RuntimeFunctionInputFunctions_0.createdBy,
  RuntimeFunctionInputFunctions_0.modifiedAt,
  RuntimeFunctionInputFunctions_0.modifiedBy,
  RuntimeFunctionInputFunctions_0.ID,
  RuntimeFunctionInputFunctions_0.environment,
  RuntimeFunctionInputFunctions_0.version,
  RuntimeFunctionInputFunctions_0.process,
  RuntimeFunctionInputFunctions_0.activity,
  RuntimeFunctionInputFunctions_0.function,
  RuntimeFunctionInputFunctions_0.description,
  RuntimeFunctionInputFunctions_0.type_code,
  RuntimeFunctionInputFunctions_0.state_code,
  RuntimeFunctionInputFunctions_0.processingType_code,
  RuntimeFunctionInputFunctions_0.businessEventType_code,
  RuntimeFunctionInputFunctions_0.partition_ID,
  RuntimeFunctionInputFunctions_0.storedProcedure,
  RuntimeFunctionInputFunctions_0.appServerStatement,
  RuntimeFunctionInputFunctions_0.preStatement,
  RuntimeFunctionInputFunctions_0.statement,
  RuntimeFunctionInputFunctions_0.postStatement,
  RuntimeFunctionInputFunctions_0.hanaTable,
  RuntimeFunctionInputFunctions_0.hanaView,
  RuntimeFunctionInputFunctions_0.synonym,
  RuntimeFunctionInputFunctions_0.masterDataHierarchyView,
  RuntimeFunctionInputFunctions_0.calculationView,
  RuntimeFunctionInputFunctions_0.workBook,
  RuntimeFunctionInputFunctions_0.resultModelTable_ID
FROM localized_fr_RuntimeFunctionInputFunctions AS RuntimeFunctionInputFunctions_0;

CREATE VIEW localized_de_EnvironmentService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_de_EnvironmentFolders AS EnvironmentFolders_0;

CREATE VIEW localized_fr_EnvironmentService_EnvironmentFolders AS SELECT
  EnvironmentFolders_0.createdAt,
  EnvironmentFolders_0.createdBy,
  EnvironmentFolders_0.modifiedAt,
  EnvironmentFolders_0.modifiedBy,
  EnvironmentFolders_0.ID,
  EnvironmentFolders_0.environment,
  EnvironmentFolders_0.version,
  EnvironmentFolders_0.description,
  EnvironmentFolders_0.parent_ID,
  EnvironmentFolders_0.type_code
FROM localized_fr_EnvironmentFolders AS EnvironmentFolders_0;
