
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
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CheckSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CheckSelections_opt
  FOREIGN KEY(opt_code)
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

CREATE TABLE Allocations (
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
  type_code NVARCHAR(10) DEFAULT 'ALLOC',
  valueAdjustment_code NVARCHAR(10) DEFAULT '',
  cycleFlag BOOLEAN DEFAULT FALSE,
  cycleMaximum NVARCHAR(5000) DEFAULT '',
  cycleIterationField_ID NVARCHAR(36),
  cycleAggregation_code NVARCHAR(10) DEFAULT '',
  termFlag BOOLEAN DEFAULT FALSE,
  termIterationField_ID NVARCHAR(36),
  termYearField_ID NVARCHAR(36),
  termField_ID NVARCHAR(36),
  termProcessing_code NVARCHAR(10) DEFAULT '',
  termYear NVARCHAR(5000),
  termMinimum NVARCHAR(5000),
  termMaximum NVARCHAR(5000),
  receiverFunction_ID NVARCHAR(36),
  earlyExitCheck_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Allocations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_resultHandling
  FOREIGN KEY(resultHandling_code)
  REFERENCES ResultHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_type
  FOREIGN KEY(type_code)
  REFERENCES AllocationTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_valueAdjustment
  FOREIGN KEY(valueAdjustment_code)
  REFERENCES AllocationValueAdjustments(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_cycleAggregation
  FOREIGN KEY(cycleAggregation_code)
  REFERENCES AllocationCycleAggregations(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_termProcessing
  FOREIGN KEY(termProcessing_code)
  REFERENCES AllocationTermProcessings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Allocations_receiverFunction
  FOREIGN KEY(receiverFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationInputFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationInputFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFields_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationInputFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationInputFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationInputFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationInputFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverViewSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverViewSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverViewSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationReceiverViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationOffsets (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  offsetField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationOffsets_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationOffsets_offsetField
  FOREIGN KEY(offsetField_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationDebitCredits (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  debitSign NVARCHAR(5000),
  creditSign NVARCHAR(5000),
  sequence INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationDebitCredits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationDebitCredits_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ALLOC',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationValueAdjustments (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationTermProcessings (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationCycleAggregations (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationSelectionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationSelectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationSelectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationActionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationActionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationActionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverSelectionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverSelectionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverSelectionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationReceiverActionFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationReceiverActionFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationReceiverActionFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36),
  sequence INTEGER,
  rule NVARCHAR(5000),
  description NVARCHAR(5000),
  isActive BOOLEAN DEFAULT TRUE,
  type_code NVARCHAR(10) DEFAULT 'DIRECT',
  senderRule_code NVARCHAR(10) DEFAULT 'POST_AM',
  senderShare DECIMAL DEFAULT 100,
  method_code NVARCHAR(10) DEFAULT 'PR',
  distributionBase NVARCHAR(5000),
  parentRule_ID NVARCHAR(36),
  receiverRule_code NVARCHAR(10) DEFAULT 'VAR_POR',
  scale_code NVARCHAR(10) DEFAULT '',
  driverResultField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_allocation
  FOREIGN KEY(allocation_ID)
  REFERENCES Allocations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_type
  FOREIGN KEY(type_code)
  REFERENCES AllocationRuleTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_senderRule
  FOREIGN KEY(senderRule_code)
  REFERENCES AllocationSenderRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_method
  FOREIGN KEY(method_code)
  REFERENCES AllocationRuleMethods(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_parentRule
  FOREIGN KEY(parentRule_ID)
  REFERENCES AllocationRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_receiverRule
  FOREIGN KEY(receiverRule_code)
  REFERENCES AllocationReceiverRules(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRules_scale
  FOREIGN KEY(scale_code)
  REFERENCES AllocationRuleScales(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderValueFields (
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
  CONSTRAINT c__AllocationRuleSenderValueFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderValueFields_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationActionFields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  group_code NVARCHAR(10) DEFAULT '',
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleSenderViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_group
  FOREIGN KEY(group_code)
  REFERENCES "Groups"(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleSenderFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleSenderFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleSenderFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationRuleSenderViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleReceiverViews (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  group_code NVARCHAR(10) DEFAULT '',
  order_code NVARCHAR(10) DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleReceiverViews_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_group
  FOREIGN KEY(group_code)
  REFERENCES "Groups"(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_rule
  FOREIGN KEY(rule_ID)
  REFERENCES AllocationRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverViews_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleReceiverFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__AllocationRuleReceiverFieldSelections_field
  FOREIGN KEY(field_ID)
  REFERENCES AllocationRuleReceiverViews(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE AllocationRuleTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DIRECT',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationRuleMethods (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'PR',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationSenderRules (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'POST_AM',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationReceiverRules (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'VAR_POR',
  PRIMARY KEY(code)
);

CREATE TABLE AllocationRuleScales (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
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
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
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
  CONSTRAINT c__CalculationInputFieldSelections_opt
  FOREIGN KEY(opt_code)
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
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
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
  CONSTRAINT c__CalculationRuleConditionSelections_opt
  FOREIGN KEY(opt_code)
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

CREATE TABLE Derivations (
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
  type_code NVARCHAR(10) DEFAULT 'DERIVATION',
  suppressInitialResults BOOLEAN,
  ensureDistinctResults BOOLEAN,
  PRIMARY KEY(ID),
  CONSTRAINT c__Derivations_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_resultHandling
  FOREIGN KEY(resultHandling_code)
  REFERENCES ResultHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Derivations_type
  FOREIGN KEY(type_code)
  REFERENCES DerivationTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationInputFields (
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
  derivation_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationInputFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFields_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFields_derivation
  FOREIGN KEY(derivation_ID)
  REFERENCES Derivations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationInputFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationInputFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationInputFieldSelections_inputField
  FOREIGN KEY(inputField_ID)
  REFERENCES DerivationInputFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationSignatureFields (
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
  derivation_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationSignatureFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationSignatureFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationSignatureFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationSignatureFields_derivation
  FOREIGN KEY(derivation_ID)
  REFERENCES Derivations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  derivation_ID NVARCHAR(36),
  sequence INTEGER,
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRules_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRules_derivation
  FOREIGN KEY(derivation_ID)
  REFERENCES Derivations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationRuleConditions (
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
  CONSTRAINT c__DerivationRuleConditions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditions_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditions_rule
  FOREIGN KEY(rule_ID)
  REFERENCES DerivationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationRuleConditionSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  condition_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationRuleConditionSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditionSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditionSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditionSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleConditionSelections_condition
  FOREIGN KEY(condition_ID)
  REFERENCES DerivationRuleConditions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationRuleActions (
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
  CONSTRAINT c__DerivationRuleActions_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleActions_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleActions_rule
  FOREIGN KEY(rule_ID)
  REFERENCES DerivationRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationRuleActions_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  derivation_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__DerivationChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationChecks_derivation
  FOREIGN KEY(derivation_ID)
  REFERENCES Derivations(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__DerivationChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE DerivationTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DERIVATION',
  PRIMARY KEY(code)
);

CREATE TABLE ModelTables (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) DEFAULT 'ENV',
  transportData BOOLEAN DEFAULT FALSE,
  connection NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTables_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTables_type
  FOREIGN KEY(type_code)
  REFERENCES ModelTableTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTableFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  modelTable_ID NVARCHAR(36),
  sourceField NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__ModelTableFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTableFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__ModelTableFields_modelTable
  FOREIGN KEY(modelTable_ID)
  REFERENCES ModelTables(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE ModelTableTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENV',
  PRIMARY KEY(code)
);

CREATE TABLE CalculationUnits (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnits_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnits_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplates (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  CalculationUnit_ID NVARCHAR(36),
  process NVARCHAR(5000),
  sequence INTEGER DEFAULT 10,
  type_code NVARCHAR(5000) DEFAULT 'SIMULATION',
  state_code NVARCHAR(5000) DEFAULT '',
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplates_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplates_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplates_CalculationUnit
  FOREIGN KEY(CalculationUnit_ID)
  REFERENCES CalculationUnits(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplates_type
  FOREIGN KEY(type_code)
  REFERENCES CalculationUnitProcessTemplateTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplates_state
  FOREIGN KEY(state_code)
  REFERENCES CalculationUnitProcessTemplateStates(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateActivities (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity NVARCHAR(5000),
  parent_ID NVARCHAR(36),
  sequence INTEGER,
  activityType_code NVARCHAR(5000) DEFAULT 'OPEN',
  activityState_code NVARCHAR(5000) DEFAULT 'OPEN',
  function_ID NVARCHAR(36),
  performerGroup NVARCHAR(5000),
  reviewerGroup NVARCHAR(5000),
  startDate NVARCHAR(5000),
  endDate NVARCHAR(5000),
  url NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_process
  FOREIGN KEY(process_ID)
  REFERENCES CalculationUnitProcessTemplates(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_parent
  FOREIGN KEY(parent_ID)
  REFERENCES CalculationUnitProcessTemplateActivities(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_activityType
  FOREIGN KEY(activityType_code)
  REFERENCES CalculationUnitProcessTemplateActivityTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_activityState
  FOREIGN KEY(activityState_code)
  REFERENCES CalculationUnitProcessTemplateActivityStates(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivities_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateActivityLinks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  activity_ID NVARCHAR(36),
  previousActivity_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplateActivityLinks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityLinks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityLinks_process
  FOREIGN KEY(process_ID)
  REFERENCES CalculationUnitProcessTemplates(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityLinks_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CalculationUnitProcessTemplateActivities(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityLinks_previousActivity
  FOREIGN KEY(previousActivity_ID)
  REFERENCES CalculationUnitProcessTemplateActivities(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateActivityChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  activity_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplateActivityChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityChecks_activity
  FOREIGN KEY(activity_ID)
  REFERENCES CalculationUnitProcessTemplateActivities(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateActivityChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateReports (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36),
  report NVARCHAR(5000),
  sequence INTEGER,
  description NVARCHAR(5000),
  content NCLOB,
  calculationCode NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplateReports_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateReports_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateReports_process
  FOREIGN KEY(process_ID)
  REFERENCES CalculationUnitProcessTemplates(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateReportElements (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  report_ID NVARCHAR(36),
  element NVARCHAR(5000),
  description NVARCHAR(5000),
  content NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__CalculationUnitProcessTemplateReportElements_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateReportElements_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__CalculationUnitProcessTemplateReportElements_report
  FOREIGN KEY(report_ID)
  REFERENCES CalculationUnitProcessTemplateReports(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE CalculationUnitProcessTemplateTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'SIMULATION',
  PRIMARY KEY(code)
);

CREATE TABLE CalculationUnitProcessTemplateStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE CalculationUnitProcessTemplateActivityTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(code)
);

CREATE TABLE CalculationUnitProcessTemplateActivityStates (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(code)
);

CREATE TABLE Joins (
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
  type_code NVARCHAR(10) DEFAULT 'IMPLICIT',
  PRIMARY KEY(ID),
  CONSTRAINT c__Joins_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_resultHandling
  FOREIGN KEY(resultHandling_code)
  REFERENCES ResultHandlings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_processingType
  FOREIGN KEY(processingType_code)
  REFERENCES FunctionProcessingTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_businessEventType
  FOREIGN KEY(businessEventType_code)
  REFERENCES FunctionBusinessEventTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_partition
  FOREIGN KEY(partition_ID)
  REFERENCES Partitions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Joins_type
  FOREIGN KEY(type_code)
  REFERENCES JoinTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinInputFields (
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
  Join_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinInputFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFields_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFields_Join
  FOREIGN KEY(Join_ID)
  REFERENCES Joins(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinInputFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinInputFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinInputFieldSelections_inputField
  FOREIGN KEY(inputField_ID)
  REFERENCES JoinInputFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinSignatureFields (
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
  Join_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinSignatureFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinSignatureFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinSignatureFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinSignatureFields_Join
  FOREIGN KEY(Join_ID)
  REFERENCES Joins(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinRules (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  Join_ID NVARCHAR(36),
  parent_ID NVARCHAR(36),
  type_code NVARCHAR(12) DEFAULT 'PROJECTION',
  inputFunction_ID NVARCHAR(36),
  joinType_code NVARCHAR(10) DEFAULT 'FROM',
  complexPredicates NCLOB,
  sequence INTEGER,
  description NVARCHAR(5000),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinRules_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_Join
  FOREIGN KEY(Join_ID)
  REFERENCES Joins(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_parent
  FOREIGN KEY(parent_ID)
  REFERENCES JoinRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_type
  FOREIGN KEY(type_code)
  REFERENCES JoinRuleTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRules_joinType
  FOREIGN KEY(joinType_code)
  REFERENCES JoinRuleJoinTypes(code)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinRuleInputFields (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  formula NVARCHAR(5000),
  order_code NVARCHAR(10) DEFAULT '',
  field_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinRuleInputFields_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFields_order
  FOREIGN KEY(order_code)
  REFERENCES Orders(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFields_rule
  FOREIGN KEY(rule_ID)
  REFERENCES JoinRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinRuleInputFieldSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinRuleInputFieldSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFieldSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFieldSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFieldSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRuleInputFieldSelections_inputField
  FOREIGN KEY(inputField_ID)
  REFERENCES JoinRuleInputFields(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinRulePredicates (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  comparison_code NVARCHAR(10) DEFAULT '=',
  joinRule_ID NVARCHAR(36),
  joinField_ID NVARCHAR(36),
  sequence INTEGER,
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinRulePredicates_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_rule
  FOREIGN KEY(rule_ID)
  REFERENCES JoinRules(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_comparison
  FOREIGN KEY(comparison_code)
  REFERENCES JoinRulePredicateComparisons(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_joinRule
  FOREIGN KEY(joinRule_ID)
  REFERENCES JoinRules(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinRulePredicates_joinField
  FOREIGN KEY(joinField_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinChecks (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  Join_ID NVARCHAR(36),
  check_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__JoinChecks_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinChecks_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinChecks_Join
  FOREIGN KEY(Join_ID)
  REFERENCES Joins(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__JoinChecks_check
  FOREIGN KEY(check_ID)
  REFERENCES Checks(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE JoinTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'IMPLICIT',
  PRIMARY KEY(code)
);

CREATE TABLE JoinRuleTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(12) NOT NULL DEFAULT 'PROJECTION',
  PRIMARY KEY(code)
);

CREATE TABLE JoinRuleJoinTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'FROM',
  PRIMARY KEY(code)
);

CREATE TABLE JoinRulePredicateComparisons (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '=',
  PRIMARY KEY(code)
);

CREATE TABLE Queries (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  Editable BOOLEAN DEFAULT FALSE,
  inputFunction_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__Queries_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Queries_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__Queries_inputFunction
  FOREIGN KEY(inputFunction_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE QueryComponents (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  ID NVARCHAR(36) NOT NULL,
  query_ID NVARCHAR(36),
  component NVARCHAR(5000),
  type_code NVARCHAR(10) DEFAULT 'CHA',
  layout_code NVARCHAR(10) DEFAULT 'ROW',
  tag_code NVARCHAR(10) DEFAULT '',
  editable BOOLEAN,
  field_ID NVARCHAR(36),
  hierarchy_ID NVARCHAR(36),
  display_code NVARCHAR(10) DEFAULT '',
  resultRow_code NVARCHAR(10) DEFAULT '',
  variableRepresentation_code NVARCHAR(10) DEFAULT '',
  variableMandatory BOOLEAN,
  variableDefaultValue NVARCHAR(5000),
  aggregation_code NVARCHAR(10) DEFAULT 'SUM',
  hiding_code NVARCHAR(10) DEFAULT '',
  decimalPlaces_code NVARCHAR(10) DEFAULT '',
  scalingFactor_code NVARCHAR(10) DEFAULT '',
  changeSign BOOLEAN,
  formula NVARCHAR(5000),
  keyfigure_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__QueryComponents_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_query
  FOREIGN KEY(query_ID)
  REFERENCES Queries(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_type
  FOREIGN KEY(type_code)
  REFERENCES QueryFieldTypes(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_layout
  FOREIGN KEY(layout_code)
  REFERENCES QueryFieldLayouts(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_tag
  FOREIGN KEY(tag_code)
  REFERENCES QueryFieldTags(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_field
  FOREIGN KEY(field_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_hierarchy
  FOREIGN KEY(hierarchy_ID)
  REFERENCES FieldHierarchies(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_display
  FOREIGN KEY(display_code)
  REFERENCES QueryFieldDisplays(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_resultRow
  FOREIGN KEY(resultRow_code)
  REFERENCES QueryFieldResultRows(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_variableRepresentation
  FOREIGN KEY(variableRepresentation_code)
  REFERENCES QueryFieldVariableRepresentations(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_aggregation
  FOREIGN KEY(aggregation_code)
  REFERENCES QueryFieldAggregations(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_hiding
  FOREIGN KEY(hiding_code)
  REFERENCES QueryFieldHidings(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_decimalPlaces
  FOREIGN KEY(decimalPlaces_code)
  REFERENCES QueryFieldDecimalPlaces(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_scalingFactor
  FOREIGN KEY(scalingFactor_code)
  REFERENCES QueryFieldScalingFactors(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponents_keyfigure
  FOREIGN KEY(keyfigure_ID)
  REFERENCES Fields(ID)
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE QueryComponentFixSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  component_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__QueryComponentFixSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentFixSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentFixSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentFixSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentFixSelections_component
  FOREIGN KEY(component_ID)
  REFERENCES QueryComponents(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE QueryComponentSelections (
  createdAt TIMESTAMP_TEXT,
  createdBy NVARCHAR(255),
  modifiedAt TIMESTAMP_TEXT,
  modifiedBy NVARCHAR(255),
  environment_ID NVARCHAR(36),
  function_ID NVARCHAR(36),
  seq INTEGER DEFAULT 0,
  sign_code NVARCHAR(1) DEFAULT 'I',
  opt_code NVARCHAR(2) DEFAULT 'EQ',
  low NVARCHAR(5000),
  high NVARCHAR(5000),
  ID NVARCHAR(36) NOT NULL,
  component_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__QueryComponentSelections_environment
  FOREIGN KEY(environment_ID)
  REFERENCES Environments(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentSelections_function
  FOREIGN KEY(function_ID)
  REFERENCES Functions(ID)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentSelections_sign
  FOREIGN KEY(sign_code)
  REFERENCES Signs(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentSelections_opt
  FOREIGN KEY(opt_code)
  REFERENCES Options(code)
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__QueryComponentSelections_component
  FOREIGN KEY(component_ID)
  REFERENCES QueryComponents(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED
);

CREATE TABLE QueryFieldTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldLayouts (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ROW',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldVariableRepresentations (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldHidings (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldDisplays (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldScalingFactors (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldDecimalPlaces (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldResultRows (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldTags (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(code)
);

CREATE TABLE QueryFieldAggregations (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'SUM',
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

CREATE TABLE ApplicationChecks (
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
  "check" NVARCHAR(5000),
  type_code NVARCHAR(10) DEFAULT 'I',
  message NVARCHAR(5000),
  statement NCLOB,
  PRIMARY KEY(ID),
  CONSTRAINT c__ApplicationChecks_type
  FOREIGN KEY(type_code)
  REFERENCES ApplicationLogMessageTypes(code)
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
  function_ID NVARCHAR(36),
  field_ID NVARCHAR(36),
  PRIMARY KEY(ID),
  CONSTRAINT c__RuntimeOutputFields_function
  FOREIGN KEY(function_ID)
  REFERENCES RuntimeFunctions(ID)
  ON DELETE CASCADE
  DEFERRABLE INITIALLY DEFERRED,
  CONSTRAINT c__RuntimeOutputFields_field
  FOREIGN KEY(field_ID)
  REFERENCES RuntimeFields(ID)
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

CREATE TABLE MessageTypes (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(code)
);

CREATE TABLE "Groups" (
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
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

CREATE TABLE AllocationTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ALLOC',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationValueAdjustments_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationTermProcessings_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationCycleAggregations_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DIRECT',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleMethods_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'PR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationSenderRules_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'POST_AM',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationReceiverRules_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'VAR_POR',
  PRIMARY KEY(locale, code)
);

CREATE TABLE AllocationRuleScales_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'RELATIVE',
  PRIMARY KEY(locale, code)
);

CREATE TABLE DerivationTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'DERIVATION',
  PRIMARY KEY(locale, code)
);

CREATE TABLE ModelTableTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ENV',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationUnitProcessTemplateTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'SIMULATION',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationUnitProcessTemplateStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationUnitProcessTemplateActivityTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(locale, code)
);

CREATE TABLE CalculationUnitProcessTemplateActivityStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(5000) NOT NULL DEFAULT 'OPEN',
  PRIMARY KEY(locale, code)
);

CREATE TABLE JoinTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'IMPLICIT',
  PRIMARY KEY(locale, code)
);

CREATE TABLE JoinRuleTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(12) NOT NULL DEFAULT 'PROJECTION',
  PRIMARY KEY(locale, code)
);

CREATE TABLE JoinRuleJoinTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'FROM',
  PRIMARY KEY(locale, code)
);

CREATE TABLE JoinRulePredicateComparisons_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '=',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'CHA',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldLayouts_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'ROW',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldVariableRepresentations_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldHidings_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldDisplays_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldScalingFactors_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldDecimalPlaces_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldResultRows_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldTags_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
  PRIMARY KEY(locale, code)
);

CREATE TABLE QueryFieldAggregations_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'SUM',
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

CREATE TABLE RuntimeFunctionStates_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'CHECKED',
  PRIMARY KEY(locale, code)
);

CREATE TABLE MessageTypes_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(1) NOT NULL DEFAULT 'I',
  PRIMARY KEY(locale, code)
);

CREATE TABLE Groups_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT '',
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

CREATE TABLE ConnectionSources_texts (
  locale NVARCHAR(14) NOT NULL,
  name NVARCHAR(255),
  descr NVARCHAR(1000),
  code NVARCHAR(10) NOT NULL DEFAULT 'HANA_VIEW',
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

CREATE TABLE ModelingService_Environments_drafts (
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

CREATE TABLE ModelingService_Fields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  field NVARCHAR(5000) NULL,
  class_code NVARCHAR(5000) NULL DEFAULT '',
  type_code NVARCHAR(5000) NULL DEFAULT 'CHA',
  hanaDataType_code NVARCHAR(5000) NULL DEFAULT 'NVARCHAR',
  dataLength INTEGER NULL DEFAULT 16,
  dataDecimals INTEGER NULL DEFAULT 0,
  unitField_ID NVARCHAR(36) NULL,
  isLowercase BOOLEAN NULL DEFAULT TRUE,
  hasMasterData BOOLEAN NULL DEFAULT FALSE,
  hasHierarchies BOOLEAN NULL DEFAULT FALSE,
  calculationHierarchy_ID NVARCHAR(36) NULL,
  masterDataQuery_ID NVARCHAR(36) NULL,
  description NVARCHAR(5000) NULL,
  documentation NCLOB NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldValues_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  value NVARCHAR(5000) NULL,
  isNode BOOLEAN NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldValueAuthorizations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  value_ID NVARCHAR(36) NULL,
  userGrp NVARCHAR(5000) NULL,
  readAccess BOOLEAN NULL,
  writeAccess BOOLEAN NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldHierarchies_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  hierarchy NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_FieldHierarchyStructures_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  sequence INTEGER NULL,
  hierarchy_ID NVARCHAR(36) NULL,
  value_ID NVARCHAR(36) NULL,
  parentValue_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Checks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  "check" NVARCHAR(5000) NULL,
  messageType_code NVARCHAR(1) NULL DEFAULT 'I',
  category_code NVARCHAR(10) NULL DEFAULT '',
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CheckFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  ID NVARCHAR(36) NOT NULL,
  check_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CheckSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CurrencyConversions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  currencyConversion NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  category_code NVARCHAR(5000) NULL DEFAULT 'CURRENCY',
  method_code NVARCHAR(5000) NULL DEFAULT 'ERP',
  bidAskType_code NVARCHAR(5000) NULL DEFAULT 'MID',
  marketDataArea NVARCHAR(5000) NULL,
  type NVARCHAR(5000) NULL,
  lookup_code NVARCHAR(5000) NULL DEFAULT 'Regular',
  errorHandling_code NVARCHAR(5000) NULL DEFAULT 'fail on error',
  accuracy_code NVARCHAR(5000) NULL DEFAULT '',
  dateFormat_code NVARCHAR(5000) NULL DEFAULT 'auto detect',
  steps_code NVARCHAR(5000) NULL DEFAULT 'shift,convert',
  configurationConnection_ID NVARCHAR(36) NULL,
  rateConnection_ID NVARCHAR(36) NULL,
  prefactorConnection_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_UnitConversions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  unitConversion NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  errorHandling_code NVARCHAR(5000) NULL DEFAULT 'fail on error',
  rateConnection_ID NVARCHAR(36) NULL,
  dimensionConnection_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Partitions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  "partition" NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_PartitionRanges_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  partition_ID NVARCHAR(36) NULL,
  "range" NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  level INTEGER NULL DEFAULT 0,
  value NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Functions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  function NVARCHAR(5000) NULL,
  sequence INTEGER NULL DEFAULT 10,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'MT',
  description NVARCHAR(5000) NULL,
  documentation NCLOB NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Allocations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  includeInputData BOOLEAN NULL DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) NULL DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN NULL DEFAULT FALSE,
  resultFunction_ID NVARCHAR(36) NULL,
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'ALLOC',
  valueAdjustment_code NVARCHAR(10) NULL DEFAULT '',
  cycleFlag BOOLEAN NULL DEFAULT FALSE,
  cycleMaximum NVARCHAR(5000) NULL DEFAULT '',
  cycleIterationField_ID NVARCHAR(36) NULL,
  cycleAggregation_code NVARCHAR(10) NULL DEFAULT '',
  termFlag BOOLEAN NULL DEFAULT FALSE,
  termIterationField_ID NVARCHAR(36) NULL,
  termYearField_ID NVARCHAR(36) NULL,
  termField_ID NVARCHAR(36) NULL,
  termProcessing_code NVARCHAR(10) NULL DEFAULT '',
  termYear NVARCHAR(5000) NULL,
  termMinimum NVARCHAR(5000) NULL,
  termMaximum NVARCHAR(5000) NULL,
  receiverFunction_ID NVARCHAR(36) NULL,
  earlyExitCheck_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationInputFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationInputFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverViews_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverViewSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationSelectionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationActionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverSelectionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationReceiverActionFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  rule NVARCHAR(5000) NULL,
  description NVARCHAR(5000) NULL,
  isActive BOOLEAN NULL DEFAULT TRUE,
  type_code NVARCHAR(10) NULL DEFAULT 'DIRECT',
  senderRule_code NVARCHAR(10) NULL DEFAULT 'POST_AM',
  senderShare DECIMAL NULL DEFAULT 100,
  method_code NVARCHAR(10) NULL DEFAULT 'PR',
  distributionBase NVARCHAR(5000) NULL,
  parentRule_ID NVARCHAR(36) NULL,
  receiverRule_code NVARCHAR(10) NULL DEFAULT 'VAR_POR',
  scale_code NVARCHAR(10) NULL DEFAULT '',
  driverResultField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderValueFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderViews_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  group_code NVARCHAR(10) NULL DEFAULT '',
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationRuleSenderFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationOffsets_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  offsetField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationDebitCredits_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  debitSign NVARCHAR(5000) NULL,
  creditSign NVARCHAR(5000) NULL,
  sequence INTEGER NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_AllocationChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  allocation_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationUnits_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationUnitProcessTemplates_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  CalculationUnit_ID NVARCHAR(36) NULL,
  process NVARCHAR(5000) NULL,
  sequence INTEGER NULL DEFAULT 10,
  type_code NVARCHAR(5000) NULL DEFAULT 'SIMULATION',
  state_code NVARCHAR(5000) NULL DEFAULT '',
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationUnitProcessTemplateActivities_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  process_ID NVARCHAR(36) NULL,
  activity NVARCHAR(5000) NULL,
  parent_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  activityType_code NVARCHAR(5000) NULL DEFAULT 'OPEN',
  activityState_code NVARCHAR(5000) NULL DEFAULT 'OPEN',
  function_ID NVARCHAR(36) NULL,
  performerGroup NVARCHAR(5000) NULL,
  reviewerGroup NVARCHAR(5000) NULL,
  startDate NVARCHAR(5000) NULL,
  endDate NVARCHAR(5000) NULL,
  url NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationUnitProcessTemplateActivityChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  activity_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_ModelTables_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'ENV',
  transportData BOOLEAN NULL DEFAULT FALSE,
  connection NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_ModelTableFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  modelTable_ID NVARCHAR(36) NULL,
  sourceField NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Calculations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  includeInputData BOOLEAN NULL DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) NULL DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN NULL DEFAULT FALSE,
  resultFunction_ID NVARCHAR(36) NULL,
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'RELATIVE',
  workbook NCLOB NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationLookupFunctions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  lookupFunction_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationInputFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  calculation_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationInputFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationSignatureFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  selection BOOLEAN NULL,
  "action" BOOLEAN NULL,
  granularity BOOLEAN NULL,
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationRuleConditions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationRuleConditionSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  condition_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationRuleActions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_CalculationChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  calculation_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Derivations_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  includeInputData BOOLEAN NULL DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) NULL DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN NULL DEFAULT FALSE,
  resultFunction_ID NVARCHAR(36) NULL,
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'DERIVATION',
  suppressInitialResults BOOLEAN NULL,
  ensureDistinctResults BOOLEAN NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationInputFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  derivation_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationInputFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationSignatureFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  selection BOOLEAN NULL,
  "action" BOOLEAN NULL,
  granularity BOOLEAN NULL,
  ID NVARCHAR(36) NOT NULL,
  derivation_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  derivation_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationRuleConditions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationRuleConditionSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  condition_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationRuleActions_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_DerivationChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  derivation_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Joins_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  includeInputData BOOLEAN NULL DEFAULT FALSE,
  resultHandling_code NVARCHAR(10) NULL DEFAULT 'ENRICHED',
  includeInitialResult BOOLEAN NULL DEFAULT FALSE,
  resultFunction_ID NVARCHAR(36) NULL,
  processingType_code NVARCHAR(10) NULL DEFAULT '',
  businessEventType_code NVARCHAR(10) NULL DEFAULT '',
  partition_ID NVARCHAR(36) NULL,
  inputFunction_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'IMPLICIT',
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinInputFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  ID NVARCHAR(36) NOT NULL,
  field_ID NVARCHAR(36) NULL,
  Join_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinInputFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinSignatureFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  selection BOOLEAN NULL,
  "action" BOOLEAN NULL,
  granularity BOOLEAN NULL,
  ID NVARCHAR(36) NOT NULL,
  Join_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinRules_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  Join_ID NVARCHAR(36) NULL,
  parent_ID NVARCHAR(36) NULL,
  type_code NVARCHAR(12) NULL DEFAULT 'PROJECTION',
  inputFunction_ID NVARCHAR(36) NULL,
  joinType_code NVARCHAR(10) NULL DEFAULT 'FROM',
  complexPredicates NCLOB NULL,
  sequence INTEGER NULL,
  description NVARCHAR(5000) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinRuleInputFields_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  formula NVARCHAR(5000) NULL,
  order_code NVARCHAR(10) NULL DEFAULT '',
  field_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinRuleInputFieldSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  inputField_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinRulePredicates_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  rule_ID NVARCHAR(36) NULL,
  field_ID NVARCHAR(36) NULL,
  comparison_code NVARCHAR(10) NULL DEFAULT '=',
  joinRule_ID NVARCHAR(36) NULL,
  joinField_ID NVARCHAR(36) NULL,
  sequence INTEGER NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_JoinChecks_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  Join_ID NVARCHAR(36) NULL,
  check_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_Queries_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  Editable BOOLEAN NULL DEFAULT FALSE,
  inputFunction_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_QueryComponents_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  ID NVARCHAR(36) NOT NULL,
  query_ID NVARCHAR(36) NULL,
  component NVARCHAR(5000) NULL,
  type_code NVARCHAR(10) NULL DEFAULT 'CHA',
  layout_code NVARCHAR(10) NULL DEFAULT 'ROW',
  tag_code NVARCHAR(10) NULL DEFAULT '',
  editable BOOLEAN NULL,
  field_ID NVARCHAR(36) NULL,
  hierarchy_ID NVARCHAR(36) NULL,
  display_code NVARCHAR(10) NULL DEFAULT '',
  resultRow_code NVARCHAR(10) NULL DEFAULT '',
  variableRepresentation_code NVARCHAR(10) NULL DEFAULT '',
  variableMandatory BOOLEAN NULL,
  variableDefaultValue NVARCHAR(5000) NULL,
  aggregation_code NVARCHAR(10) NULL DEFAULT 'SUM',
  hiding_code NVARCHAR(10) NULL DEFAULT '',
  decimalPlaces_code NVARCHAR(10) NULL DEFAULT '',
  scalingFactor_code NVARCHAR(10) NULL DEFAULT '',
  changeSign BOOLEAN NULL,
  formula NVARCHAR(5000) NULL,
  keyfigure_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_QueryComponentFixSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  component_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE TABLE ModelingService_QueryComponentSelections_drafts (
  createdAt TIMESTAMP_TEXT NULL,
  createdBy NVARCHAR(255) NULL,
  modifiedAt TIMESTAMP_TEXT NULL,
  modifiedBy NVARCHAR(255) NULL,
  environment_ID NVARCHAR(36) NULL,
  function_ID NVARCHAR(36) NULL,
  seq INTEGER NULL DEFAULT 0,
  sign_code NVARCHAR(1) NULL DEFAULT 'I',
  opt_code NVARCHAR(2) NULL DEFAULT 'EQ',
  low NVARCHAR(5000) NULL,
  high NVARCHAR(5000) NULL,
  ID NVARCHAR(36) NOT NULL,
  component_ID NVARCHAR(36) NULL,
  IsActiveEntity BOOLEAN,
  HasActiveEntity BOOLEAN,
  HasDraftEntity BOOLEAN,
  DraftAdministrativeData_DraftUUID NVARCHAR(36) NOT NULL,
  PRIMARY KEY(ID)
);

CREATE VIEW ModelingService_Environments AS SELECT
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
FROM Environments AS environments_0;

CREATE VIEW ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM Fields AS fields_0;

CREATE VIEW ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM Checks AS checks_0;

CREATE VIEW ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM CurrencyConversions AS currencyConversions_0;

CREATE VIEW ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM UnitConversions AS unitConversions_0;

CREATE VIEW ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM Partitions AS partitions_0;

CREATE VIEW ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.description,
  functions_0.documentation
FROM Functions AS functions_0;

CREATE VIEW ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.resultFunction_ID,
  allocations_0.processingType_code,
  allocations_0.businessEventType_code,
  allocations_0.partition_ID,
  allocations_0.inputFunction_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.receiverFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM Allocations AS allocations_0;

CREATE VIEW ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM CalculationUnits AS calculationUnits_0;

CREATE VIEW ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connection
FROM ModelTables AS modelTables_0;

CREATE VIEW ModelingService_Calculations AS SELECT
  calculations_0.createdAt,
  calculations_0.createdBy,
  calculations_0.modifiedAt,
  calculations_0.modifiedBy,
  calculations_0.environment_ID,
  calculations_0.function_ID,
  calculations_0.includeInputData,
  calculations_0.resultHandling_code,
  calculations_0.includeInitialResult,
  calculations_0.resultFunction_ID,
  calculations_0.processingType_code,
  calculations_0.businessEventType_code,
  calculations_0.partition_ID,
  calculations_0.inputFunction_ID,
  calculations_0.ID,
  calculations_0.type_code,
  calculations_0.workbook
FROM Calculations AS calculations_0;

CREATE VIEW ModelingService_Derivations AS SELECT
  derivations_0.createdAt,
  derivations_0.createdBy,
  derivations_0.modifiedAt,
  derivations_0.modifiedBy,
  derivations_0.environment_ID,
  derivations_0.function_ID,
  derivations_0.includeInputData,
  derivations_0.resultHandling_code,
  derivations_0.includeInitialResult,
  derivations_0.resultFunction_ID,
  derivations_0.processingType_code,
  derivations_0.businessEventType_code,
  derivations_0.partition_ID,
  derivations_0.inputFunction_ID,
  derivations_0.ID,
  derivations_0.type_code,
  derivations_0.suppressInitialResults,
  derivations_0.ensureDistinctResults
FROM Derivations AS derivations_0;

CREATE VIEW ModelingService_Joins AS SELECT
  joins_0.createdAt,
  joins_0.createdBy,
  joins_0.modifiedAt,
  joins_0.modifiedBy,
  joins_0.environment_ID,
  joins_0.function_ID,
  joins_0.includeInputData,
  joins_0.resultHandling_code,
  joins_0.includeInitialResult,
  joins_0.resultFunction_ID,
  joins_0.processingType_code,
  joins_0.businessEventType_code,
  joins_0.partition_ID,
  joins_0.inputFunction_ID,
  joins_0.ID,
  joins_0.type_code
FROM Joins AS joins_0;

CREATE VIEW ModelingService_Queries AS SELECT
  queries_0.createdAt,
  queries_0.createdBy,
  queries_0.modifiedAt,
  queries_0.modifiedBy,
  queries_0.environment_ID,
  queries_0.function_ID,
  queries_0.ID,
  queries_0.Editable,
  queries_0.inputFunction_ID
FROM Queries AS queries_0;

CREATE VIEW ModelingService_ApplicationLogs AS SELECT
  applicationLogs_0.createdAt,
  applicationLogs_0.createdBy,
  applicationLogs_0.modifiedAt,
  applicationLogs_0.modifiedBy,
  applicationLogs_0.ID,
  applicationLogs_0.run,
  applicationLogs_0.type,
  applicationLogs_0.environment,
  applicationLogs_0.version,
  applicationLogs_0.process,
  applicationLogs_0.activity,
  applicationLogs_0.mainFunction,
  applicationLogs_0.parameters,
  applicationLogs_0.selections,
  applicationLogs_0.businessEvent,
  applicationLogs_0.field,
  applicationLogs_0."check",
  applicationLogs_0.conversion,
  applicationLogs_0."partition",
  applicationLogs_0.package,
  applicationLogs_0.state_code
FROM ApplicationLogs AS applicationLogs_0;

CREATE VIEW ModelingService_RuntimeFunctions AS SELECT
  runtimeFunctions_0.createdAt,
  runtimeFunctions_0.createdBy,
  runtimeFunctions_0.modifiedAt,
  runtimeFunctions_0.modifiedBy,
  runtimeFunctions_0.ID,
  runtimeFunctions_0.environment,
  runtimeFunctions_0.version,
  runtimeFunctions_0.process,
  runtimeFunctions_0.activity,
  runtimeFunctions_0.function,
  runtimeFunctions_0.description,
  runtimeFunctions_0.type_code,
  runtimeFunctions_0.state_code,
  runtimeFunctions_0.processingType_code,
  runtimeFunctions_0.businessEventType_code,
  runtimeFunctions_0.partition_ID,
  runtimeFunctions_0.storedProcedure,
  runtimeFunctions_0.appServerStatement,
  runtimeFunctions_0.preStatement,
  runtimeFunctions_0.statement,
  runtimeFunctions_0.postStatement,
  runtimeFunctions_0.hanaTable,
  runtimeFunctions_0.hanaView,
  runtimeFunctions_0.synonym,
  runtimeFunctions_0.masterDataHierarchyView,
  runtimeFunctions_0.calculationView,
  runtimeFunctions_0.workBook,
  runtimeFunctions_0.resultModelTable_ID
FROM RuntimeFunctions AS runtimeFunctions_0;

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

CREATE VIEW OffsetAllocation AS SELECT
  Allocations_0.environment_ID,
  Allocations_0.function_ID,
  Allocations_0.ID,
  Allocations_0.type_code,
  Allocations_0.valueAdjustment_code,
  Allocations_0.includeInputData,
  Allocations_0.resultHandling_code,
  Allocations_0.includeInitialResult,
  Allocations_0.inputFunction_ID,
  Allocations_0.receiverFunction_ID,
  Allocations_0.resultFunction_ID
FROM Allocations AS Allocations_0;

CREATE VIEW AllocationTermIterationFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW AllocationTermYearFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW AllocationTermFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM Checks AS Checks_0;

CREATE VIEW AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((AllocationActionFields AS L_1 LEFT JOIN Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((AllocationActionFields AS L_1 LEFT JOIN Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW modelJoins AS SELECT
  Joins_0.createdAt,
  Joins_0.createdBy,
  Joins_0.modifiedAt,
  Joins_0.modifiedBy,
  Joins_0.environment_ID,
  Joins_0.function_ID,
  Joins_0.ID,
  Joins_0.type_code
FROM Joins AS Joins_0;

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

CREATE VIEW ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM FieldClasses AS FieldClasses_0;

CREATE VIEW ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM FieldTypes AS FieldTypes_0;

CREATE VIEW ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM FieldValues AS FieldValues_0;

CREATE VIEW ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM MessageTypes AS MessageTypes_0;

CREATE VIEW ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM CheckCategories AS CheckCategories_0;

CREATE VIEW ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM CheckFields AS CheckFields_0;

CREATE VIEW ModelingService_Connections AS SELECT
  Connections_0.createdAt,
  Connections_0.createdBy,
  Connections_0.modifiedAt,
  Connections_0.modifiedBy,
  Connections_0.environment_ID,
  Connections_0.ID,
  Connections_0.connection,
  Connections_0.description,
  Connections_0.source_code,
  Connections_0.hanaTable,
  Connections_0.hanaView,
  Connections_0.odataUrl,
  Connections_0.odataUrlOptions
FROM Connections AS Connections_0;

CREATE VIEW ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value
FROM PartitionRanges AS PartitionRanges_0;

CREATE VIEW ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM FunctionTypes AS FunctionTypes_0;

CREATE VIEW ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM ResultHandlings AS ResultHandlings_0;

CREATE VIEW ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM AllocationTypes AS AllocationTypes_0;

CREATE VIEW ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW ModelingService_AllocationInputFields AS SELECT
  AllocationInputFields_0.createdAt,
  AllocationInputFields_0.createdBy,
  AllocationInputFields_0.modifiedAt,
  AllocationInputFields_0.modifiedBy,
  AllocationInputFields_0.environment_ID,
  AllocationInputFields_0.function_ID,
  AllocationInputFields_0.formula,
  AllocationInputFields_0.order_code,
  AllocationInputFields_0.ID,
  AllocationInputFields_0.allocation_ID,
  AllocationInputFields_0.field_ID
FROM AllocationInputFields AS AllocationInputFields_0;

CREATE VIEW ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM AllocationRules AS AllocationRules_0;

CREATE VIEW ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM AllocationChecks AS AllocationChecks_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplates AS SELECT
  CalculationUnitProcessTemplates_0.createdAt,
  CalculationUnitProcessTemplates_0.createdBy,
  CalculationUnitProcessTemplates_0.modifiedAt,
  CalculationUnitProcessTemplates_0.modifiedBy,
  CalculationUnitProcessTemplates_0.environment_ID,
  CalculationUnitProcessTemplates_0.function_ID,
  CalculationUnitProcessTemplates_0.ID,
  CalculationUnitProcessTemplates_0.CalculationUnit_ID,
  CalculationUnitProcessTemplates_0.process,
  CalculationUnitProcessTemplates_0.sequence,
  CalculationUnitProcessTemplates_0.type_code,
  CalculationUnitProcessTemplates_0.state_code,
  CalculationUnitProcessTemplates_0.description
FROM CalculationUnitProcessTemplates AS CalculationUnitProcessTemplates_0;

CREATE VIEW ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID,
  ModelTableFields_0.sourceField
FROM ModelTableFields AS ModelTableFields_0;

CREATE VIEW ModelingService_CalculationTypes AS SELECT
  CalculationTypes_0.name,
  CalculationTypes_0.descr,
  CalculationTypes_0.code
FROM CalculationTypes AS CalculationTypes_0;

CREATE VIEW ModelingService_CalculationLookupFunctions AS SELECT
  CalculationLookupFunctions_0.createdAt,
  CalculationLookupFunctions_0.createdBy,
  CalculationLookupFunctions_0.modifiedAt,
  CalculationLookupFunctions_0.modifiedBy,
  CalculationLookupFunctions_0.environment_ID,
  CalculationLookupFunctions_0.function_ID,
  CalculationLookupFunctions_0.lookupFunction_ID,
  CalculationLookupFunctions_0.ID,
  CalculationLookupFunctions_0.calculation_ID
FROM CalculationLookupFunctions AS CalculationLookupFunctions_0;

CREATE VIEW ModelingService_CalculationInputFields AS SELECT
  CalculationInputFields_0.createdAt,
  CalculationInputFields_0.createdBy,
  CalculationInputFields_0.modifiedAt,
  CalculationInputFields_0.modifiedBy,
  CalculationInputFields_0.environment_ID,
  CalculationInputFields_0.function_ID,
  CalculationInputFields_0.formula,
  CalculationInputFields_0.order_code,
  CalculationInputFields_0.ID,
  CalculationInputFields_0.field_ID,
  CalculationInputFields_0.calculation_ID
FROM CalculationInputFields AS CalculationInputFields_0;

CREATE VIEW ModelingService_CalculationSignatureFields AS SELECT
  CalculationSignatureFields_0.createdAt,
  CalculationSignatureFields_0.createdBy,
  CalculationSignatureFields_0.modifiedAt,
  CalculationSignatureFields_0.modifiedBy,
  CalculationSignatureFields_0.environment_ID,
  CalculationSignatureFields_0.function_ID,
  CalculationSignatureFields_0.field_ID,
  CalculationSignatureFields_0.selection,
  CalculationSignatureFields_0."action",
  CalculationSignatureFields_0.granularity,
  CalculationSignatureFields_0.ID,
  CalculationSignatureFields_0.calculation_ID
FROM CalculationSignatureFields AS CalculationSignatureFields_0;

CREATE VIEW ModelingService_CalculationRules AS SELECT
  CalculationRules_0.createdAt,
  CalculationRules_0.createdBy,
  CalculationRules_0.modifiedAt,
  CalculationRules_0.modifiedBy,
  CalculationRules_0.environment_ID,
  CalculationRules_0.function_ID,
  CalculationRules_0.ID,
  CalculationRules_0.calculation_ID,
  CalculationRules_0.sequence,
  CalculationRules_0.description
FROM CalculationRules AS CalculationRules_0;

CREATE VIEW ModelingService_CalculationChecks AS SELECT
  CalculationChecks_0.createdAt,
  CalculationChecks_0.createdBy,
  CalculationChecks_0.modifiedAt,
  CalculationChecks_0.modifiedBy,
  CalculationChecks_0.environment_ID,
  CalculationChecks_0.function_ID,
  CalculationChecks_0.ID,
  CalculationChecks_0.calculation_ID,
  CalculationChecks_0.check_ID
FROM CalculationChecks AS CalculationChecks_0;

CREATE VIEW ModelingService_DerivationTypes AS SELECT
  DerivationTypes_0.name,
  DerivationTypes_0.descr,
  DerivationTypes_0.code
FROM DerivationTypes AS DerivationTypes_0;

CREATE VIEW ModelingService_DerivationInputFields AS SELECT
  DerivationInputFields_0.createdAt,
  DerivationInputFields_0.createdBy,
  DerivationInputFields_0.modifiedAt,
  DerivationInputFields_0.modifiedBy,
  DerivationInputFields_0.environment_ID,
  DerivationInputFields_0.function_ID,
  DerivationInputFields_0.formula,
  DerivationInputFields_0.order_code,
  DerivationInputFields_0.ID,
  DerivationInputFields_0.field_ID,
  DerivationInputFields_0.derivation_ID
FROM DerivationInputFields AS DerivationInputFields_0;

CREATE VIEW ModelingService_DerivationSignatureFields AS SELECT
  DerivationSignatureFields_0.createdAt,
  DerivationSignatureFields_0.createdBy,
  DerivationSignatureFields_0.modifiedAt,
  DerivationSignatureFields_0.modifiedBy,
  DerivationSignatureFields_0.environment_ID,
  DerivationSignatureFields_0.function_ID,
  DerivationSignatureFields_0.field_ID,
  DerivationSignatureFields_0.selection,
  DerivationSignatureFields_0."action",
  DerivationSignatureFields_0.granularity,
  DerivationSignatureFields_0.ID,
  DerivationSignatureFields_0.derivation_ID
FROM DerivationSignatureFields AS DerivationSignatureFields_0;

CREATE VIEW ModelingService_DerivationRules AS SELECT
  DerivationRules_0.createdAt,
  DerivationRules_0.createdBy,
  DerivationRules_0.modifiedAt,
  DerivationRules_0.modifiedBy,
  DerivationRules_0.environment_ID,
  DerivationRules_0.function_ID,
  DerivationRules_0.ID,
  DerivationRules_0.derivation_ID,
  DerivationRules_0.sequence,
  DerivationRules_0.description
FROM DerivationRules AS DerivationRules_0;

CREATE VIEW ModelingService_DerivationChecks AS SELECT
  DerivationChecks_0.createdAt,
  DerivationChecks_0.createdBy,
  DerivationChecks_0.modifiedAt,
  DerivationChecks_0.modifiedBy,
  DerivationChecks_0.environment_ID,
  DerivationChecks_0.function_ID,
  DerivationChecks_0.ID,
  DerivationChecks_0.derivation_ID,
  DerivationChecks_0.check_ID
FROM DerivationChecks AS DerivationChecks_0;

CREATE VIEW ModelingService_JoinTypes AS SELECT
  JoinTypes_0.name,
  JoinTypes_0.descr,
  JoinTypes_0.code
FROM JoinTypes AS JoinTypes_0;

CREATE VIEW ModelingService_JoinInputFields AS SELECT
  JoinInputFields_0.createdAt,
  JoinInputFields_0.createdBy,
  JoinInputFields_0.modifiedAt,
  JoinInputFields_0.modifiedBy,
  JoinInputFields_0.environment_ID,
  JoinInputFields_0.function_ID,
  JoinInputFields_0.formula,
  JoinInputFields_0.order_code,
  JoinInputFields_0.ID,
  JoinInputFields_0.field_ID,
  JoinInputFields_0.Join_ID
FROM JoinInputFields AS JoinInputFields_0;

CREATE VIEW ModelingService_JoinSignatureFields AS SELECT
  JoinSignatureFields_0.createdAt,
  JoinSignatureFields_0.createdBy,
  JoinSignatureFields_0.modifiedAt,
  JoinSignatureFields_0.modifiedBy,
  JoinSignatureFields_0.environment_ID,
  JoinSignatureFields_0.function_ID,
  JoinSignatureFields_0.field_ID,
  JoinSignatureFields_0.selection,
  JoinSignatureFields_0."action",
  JoinSignatureFields_0.granularity,
  JoinSignatureFields_0.ID,
  JoinSignatureFields_0.Join_ID
FROM JoinSignatureFields AS JoinSignatureFields_0;

CREATE VIEW ModelingService_JoinRules AS SELECT
  JoinRules_0.createdAt,
  JoinRules_0.createdBy,
  JoinRules_0.modifiedAt,
  JoinRules_0.modifiedBy,
  JoinRules_0.environment_ID,
  JoinRules_0.function_ID,
  JoinRules_0.ID,
  JoinRules_0.Join_ID,
  JoinRules_0.parent_ID,
  JoinRules_0.type_code,
  JoinRules_0.inputFunction_ID,
  JoinRules_0.joinType_code,
  JoinRules_0.complexPredicates,
  JoinRules_0.sequence,
  JoinRules_0.description
FROM JoinRules AS JoinRules_0;

CREATE VIEW ModelingService_JoinChecks AS SELECT
  JoinChecks_0.createdAt,
  JoinChecks_0.createdBy,
  JoinChecks_0.modifiedAt,
  JoinChecks_0.modifiedBy,
  JoinChecks_0.environment_ID,
  JoinChecks_0.function_ID,
  JoinChecks_0.ID,
  JoinChecks_0.Join_ID,
  JoinChecks_0.check_ID
FROM JoinChecks AS JoinChecks_0;

CREATE VIEW ModelingService_QueryComponents AS SELECT
  QueryComponents_0.createdAt,
  QueryComponents_0.createdBy,
  QueryComponents_0.modifiedAt,
  QueryComponents_0.modifiedBy,
  QueryComponents_0.environment_ID,
  QueryComponents_0.function_ID,
  QueryComponents_0.ID,
  QueryComponents_0.query_ID,
  QueryComponents_0.component,
  QueryComponents_0.type_code,
  QueryComponents_0.layout_code,
  QueryComponents_0.tag_code,
  QueryComponents_0.editable,
  QueryComponents_0.field_ID,
  QueryComponents_0.hierarchy_ID,
  QueryComponents_0.display_code,
  QueryComponents_0.resultRow_code,
  QueryComponents_0.variableRepresentation_code,
  QueryComponents_0.variableMandatory,
  QueryComponents_0.variableDefaultValue,
  QueryComponents_0.aggregation_code,
  QueryComponents_0.hiding_code,
  QueryComponents_0.decimalPlaces_code,
  QueryComponents_0.scalingFactor_code,
  QueryComponents_0.changeSign,
  QueryComponents_0.formula,
  QueryComponents_0.keyfigure_ID
FROM QueryComponents AS QueryComponents_0;

CREATE VIEW ModelingService_ApplicationLogStates AS SELECT
  ApplicationLogStates_0.name,
  ApplicationLogStates_0.descr,
  ApplicationLogStates_0.code
FROM ApplicationLogStates AS ApplicationLogStates_0;

CREATE VIEW ModelingService_ApplicationLogMessages AS SELECT
  ApplicationLogMessages_0.createdAt,
  ApplicationLogMessages_0.createdBy,
  ApplicationLogMessages_0.modifiedAt,
  ApplicationLogMessages_0.modifiedBy,
  ApplicationLogMessages_0.ID,
  ApplicationLogMessages_0.applicationLog_ID,
  ApplicationLogMessages_0.type_code,
  ApplicationLogMessages_0.function,
  ApplicationLogMessages_0.code,
  ApplicationLogMessages_0.entity,
  ApplicationLogMessages_0.primaryKey,
  ApplicationLogMessages_0.target,
  ApplicationLogMessages_0.argument1,
  ApplicationLogMessages_0.argument2,
  ApplicationLogMessages_0.argument3,
  ApplicationLogMessages_0.argument4,
  ApplicationLogMessages_0.argument5,
  ApplicationLogMessages_0.argument6,
  ApplicationLogMessages_0.messageDetails
FROM ApplicationLogMessages AS ApplicationLogMessages_0;

CREATE VIEW ModelingService_ApplicationLogStatistics AS SELECT
  ApplicationLogStatistics_0.createdAt,
  ApplicationLogStatistics_0.createdBy,
  ApplicationLogStatistics_0.modifiedAt,
  ApplicationLogStatistics_0.modifiedBy,
  ApplicationLogStatistics_0.ID,
  ApplicationLogStatistics_0.applicationLog_ID,
  ApplicationLogStatistics_0.function,
  ApplicationLogStatistics_0.startTimestamp,
  ApplicationLogStatistics_0.endTimestamp,
  ApplicationLogStatistics_0.inputRecords,
  ApplicationLogStatistics_0.resultRecords,
  ApplicationLogStatistics_0.successRecords,
  ApplicationLogStatistics_0.warningRecords,
  ApplicationLogStatistics_0.errorRecords,
  ApplicationLogStatistics_0.abortRecords,
  ApplicationLogStatistics_0.inputDuration,
  ApplicationLogStatistics_0.processingDuration,
  ApplicationLogStatistics_0.outputDuration
FROM ApplicationLogStatistics AS ApplicationLogStatistics_0;

CREATE VIEW ModelingService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW ModelingService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW ModelingService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW ModelingService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW ModelingService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field_ID
FROM RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW ModelingService_RuntimeShareLocks AS SELECT
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

CREATE VIEW ModelingService_EnvironmentTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM EnvironmentTypes_texts AS texts_0;

CREATE VIEW ModelingService_FieldClasses_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FieldClasses_texts AS texts_0;

CREATE VIEW ModelingService_FieldTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FieldTypes_texts AS texts_0;

CREATE VIEW ModelingService_HanaDataTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM HanaDataTypes_texts AS texts_0;

CREATE VIEW ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW ModelingService_MessageTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM MessageTypes_texts AS texts_0;

CREATE VIEW ModelingService_CheckCategories_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CheckCategories_texts AS texts_0;

CREATE VIEW ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM CheckSelections AS CheckSelections_0;

CREATE VIEW ModelingService_ConnectionSources AS SELECT
  ConnectionSources_0.name,
  ConnectionSources_0.descr,
  ConnectionSources_0.code
FROM ConnectionSources AS ConnectionSources_0;

CREATE VIEW ModelingService_FunctionTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionTypes_texts AS texts_0;

CREATE VIEW ModelingService_ResultHandlings_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ResultHandlings_texts AS texts_0;

CREATE VIEW ModelingService_FunctionProcessingTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionProcessingTypes_texts AS texts_0;

CREATE VIEW ModelingService_FunctionBusinessEventTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM FunctionBusinessEventTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationValueAdjustments_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationValueAdjustments_texts AS texts_0;

CREATE VIEW ModelingService_AllocationCycleAggregations_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationCycleAggregations_texts AS texts_0;

CREATE VIEW ModelingService_AllocationTermProcessings_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationTermProcessings_texts AS texts_0;

CREATE VIEW ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM Orders AS Orders_0;

CREATE VIEW ModelingService_AllocationInputFieldSelections AS SELECT
  AllocationInputFieldSelections_0.createdAt,
  AllocationInputFieldSelections_0.createdBy,
  AllocationInputFieldSelections_0.modifiedAt,
  AllocationInputFieldSelections_0.modifiedBy,
  AllocationInputFieldSelections_0.environment_ID,
  AllocationInputFieldSelections_0.function_ID,
  AllocationInputFieldSelections_0.seq,
  AllocationInputFieldSelections_0.sign_code,
  AllocationInputFieldSelections_0.opt_code,
  AllocationInputFieldSelections_0.low,
  AllocationInputFieldSelections_0.high,
  AllocationInputFieldSelections_0.ID,
  AllocationInputFieldSelections_0.field_ID
FROM AllocationInputFieldSelections AS AllocationInputFieldSelections_0;

CREATE VIEW ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateTypes AS SELECT
  CalculationUnitProcessTemplateTypes_0.name,
  CalculationUnitProcessTemplateTypes_0.descr,
  CalculationUnitProcessTemplateTypes_0.code
FROM CalculationUnitProcessTemplateTypes AS CalculationUnitProcessTemplateTypes_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateStates AS SELECT
  CalculationUnitProcessTemplateStates_0.name,
  CalculationUnitProcessTemplateStates_0.descr,
  CalculationUnitProcessTemplateStates_0.code
FROM CalculationUnitProcessTemplateStates AS CalculationUnitProcessTemplateStates_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivities AS SELECT
  CalculationUnitProcessTemplateActivities_0.createdAt,
  CalculationUnitProcessTemplateActivities_0.createdBy,
  CalculationUnitProcessTemplateActivities_0.modifiedAt,
  CalculationUnitProcessTemplateActivities_0.modifiedBy,
  CalculationUnitProcessTemplateActivities_0.environment_ID,
  CalculationUnitProcessTemplateActivities_0.ID,
  CalculationUnitProcessTemplateActivities_0.process_ID,
  CalculationUnitProcessTemplateActivities_0.activity,
  CalculationUnitProcessTemplateActivities_0.parent_ID,
  CalculationUnitProcessTemplateActivities_0.sequence,
  CalculationUnitProcessTemplateActivities_0.activityType_code,
  CalculationUnitProcessTemplateActivities_0.activityState_code,
  CalculationUnitProcessTemplateActivities_0.function_ID,
  CalculationUnitProcessTemplateActivities_0.performerGroup,
  CalculationUnitProcessTemplateActivities_0.reviewerGroup,
  CalculationUnitProcessTemplateActivities_0.startDate,
  CalculationUnitProcessTemplateActivities_0.endDate,
  CalculationUnitProcessTemplateActivities_0.url
FROM CalculationUnitProcessTemplateActivities AS CalculationUnitProcessTemplateActivities_0;

CREATE VIEW ModelingService_ModelTableTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ModelTableTypes_texts AS texts_0;

CREATE VIEW ModelingService_CalculationTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CalculationTypes_texts AS texts_0;

CREATE VIEW ModelingService_CalculationInputFieldSelections AS SELECT
  CalculationInputFieldSelections_0.createdAt,
  CalculationInputFieldSelections_0.createdBy,
  CalculationInputFieldSelections_0.modifiedAt,
  CalculationInputFieldSelections_0.modifiedBy,
  CalculationInputFieldSelections_0.environment_ID,
  CalculationInputFieldSelections_0.function_ID,
  CalculationInputFieldSelections_0.seq,
  CalculationInputFieldSelections_0.sign_code,
  CalculationInputFieldSelections_0.opt_code,
  CalculationInputFieldSelections_0.low,
  CalculationInputFieldSelections_0.high,
  CalculationInputFieldSelections_0.ID,
  CalculationInputFieldSelections_0.inputField_ID
FROM CalculationInputFieldSelections AS CalculationInputFieldSelections_0;

CREATE VIEW ModelingService_CalculationRuleConditions AS SELECT
  CalculationRuleConditions_0.createdAt,
  CalculationRuleConditions_0.createdBy,
  CalculationRuleConditions_0.modifiedAt,
  CalculationRuleConditions_0.modifiedBy,
  CalculationRuleConditions_0.environment_ID,
  CalculationRuleConditions_0.function_ID,
  CalculationRuleConditions_0.ID,
  CalculationRuleConditions_0.rule_ID,
  CalculationRuleConditions_0.field_ID
FROM CalculationRuleConditions AS CalculationRuleConditions_0;

CREATE VIEW ModelingService_CalculationRuleActions AS SELECT
  CalculationRuleActions_0.createdAt,
  CalculationRuleActions_0.createdBy,
  CalculationRuleActions_0.modifiedAt,
  CalculationRuleActions_0.modifiedBy,
  CalculationRuleActions_0.environment_ID,
  CalculationRuleActions_0.function_ID,
  CalculationRuleActions_0.formula,
  CalculationRuleActions_0.ID,
  CalculationRuleActions_0.rule_ID,
  CalculationRuleActions_0.field_ID
FROM CalculationRuleActions AS CalculationRuleActions_0;

CREATE VIEW ModelingService_DerivationTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM DerivationTypes_texts AS texts_0;

CREATE VIEW ModelingService_DerivationInputFieldSelections AS SELECT
  DerivationInputFieldSelections_0.createdAt,
  DerivationInputFieldSelections_0.createdBy,
  DerivationInputFieldSelections_0.modifiedAt,
  DerivationInputFieldSelections_0.modifiedBy,
  DerivationInputFieldSelections_0.environment_ID,
  DerivationInputFieldSelections_0.function_ID,
  DerivationInputFieldSelections_0.seq,
  DerivationInputFieldSelections_0.sign_code,
  DerivationInputFieldSelections_0.opt_code,
  DerivationInputFieldSelections_0.low,
  DerivationInputFieldSelections_0.high,
  DerivationInputFieldSelections_0.ID,
  DerivationInputFieldSelections_0.inputField_ID
FROM DerivationInputFieldSelections AS DerivationInputFieldSelections_0;

CREATE VIEW ModelingService_DerivationRuleConditions AS SELECT
  DerivationRuleConditions_0.createdAt,
  DerivationRuleConditions_0.createdBy,
  DerivationRuleConditions_0.modifiedAt,
  DerivationRuleConditions_0.modifiedBy,
  DerivationRuleConditions_0.environment_ID,
  DerivationRuleConditions_0.function_ID,
  DerivationRuleConditions_0.ID,
  DerivationRuleConditions_0.rule_ID,
  DerivationRuleConditions_0.field_ID
FROM DerivationRuleConditions AS DerivationRuleConditions_0;

CREATE VIEW ModelingService_DerivationRuleActions AS SELECT
  DerivationRuleActions_0.createdAt,
  DerivationRuleActions_0.createdBy,
  DerivationRuleActions_0.modifiedAt,
  DerivationRuleActions_0.modifiedBy,
  DerivationRuleActions_0.environment_ID,
  DerivationRuleActions_0.function_ID,
  DerivationRuleActions_0.formula,
  DerivationRuleActions_0.ID,
  DerivationRuleActions_0.rule_ID,
  DerivationRuleActions_0.field_ID
FROM DerivationRuleActions AS DerivationRuleActions_0;

CREATE VIEW ModelingService_JoinTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM JoinTypes_texts AS texts_0;

CREATE VIEW ModelingService_JoinInputFieldSelections AS SELECT
  JoinInputFieldSelections_0.createdAt,
  JoinInputFieldSelections_0.createdBy,
  JoinInputFieldSelections_0.modifiedAt,
  JoinInputFieldSelections_0.modifiedBy,
  JoinInputFieldSelections_0.environment_ID,
  JoinInputFieldSelections_0.function_ID,
  JoinInputFieldSelections_0.seq,
  JoinInputFieldSelections_0.sign_code,
  JoinInputFieldSelections_0.opt_code,
  JoinInputFieldSelections_0.low,
  JoinInputFieldSelections_0.high,
  JoinInputFieldSelections_0.ID,
  JoinInputFieldSelections_0.inputField_ID
FROM JoinInputFieldSelections AS JoinInputFieldSelections_0;

CREATE VIEW ModelingService_JoinRuleTypes AS SELECT
  JoinRuleTypes_0.name,
  JoinRuleTypes_0.descr,
  JoinRuleTypes_0.code
FROM JoinRuleTypes AS JoinRuleTypes_0;

CREATE VIEW ModelingService_JoinRuleInputFields AS SELECT
  JoinRuleInputFields_0.createdAt,
  JoinRuleInputFields_0.createdBy,
  JoinRuleInputFields_0.modifiedAt,
  JoinRuleInputFields_0.modifiedBy,
  JoinRuleInputFields_0.environment_ID,
  JoinRuleInputFields_0.function_ID,
  JoinRuleInputFields_0.formula,
  JoinRuleInputFields_0.order_code,
  JoinRuleInputFields_0.field_ID,
  JoinRuleInputFields_0.ID,
  JoinRuleInputFields_0.rule_ID
FROM JoinRuleInputFields AS JoinRuleInputFields_0;

CREATE VIEW ModelingService_JoinRuleJoinTypes AS SELECT
  JoinRuleJoinTypes_0.name,
  JoinRuleJoinTypes_0.descr,
  JoinRuleJoinTypes_0.code
FROM JoinRuleJoinTypes AS JoinRuleJoinTypes_0;

CREATE VIEW ModelingService_JoinRulePredicates AS SELECT
  JoinRulePredicates_0.createdAt,
  JoinRulePredicates_0.createdBy,
  JoinRulePredicates_0.modifiedAt,
  JoinRulePredicates_0.modifiedBy,
  JoinRulePredicates_0.environment_ID,
  JoinRulePredicates_0.function_ID,
  JoinRulePredicates_0.ID,
  JoinRulePredicates_0.rule_ID,
  JoinRulePredicates_0.field_ID,
  JoinRulePredicates_0.comparison_code,
  JoinRulePredicates_0.joinRule_ID,
  JoinRulePredicates_0.joinField_ID,
  JoinRulePredicates_0.sequence
FROM JoinRulePredicates AS JoinRulePredicates_0;

CREATE VIEW ModelingService_QueryFieldTypes AS SELECT
  QueryFieldTypes_0.name,
  QueryFieldTypes_0.descr,
  QueryFieldTypes_0.code
FROM QueryFieldTypes AS QueryFieldTypes_0;

CREATE VIEW ModelingService_QueryFieldLayouts AS SELECT
  QueryFieldLayouts_0.name,
  QueryFieldLayouts_0.descr,
  QueryFieldLayouts_0.code
FROM QueryFieldLayouts AS QueryFieldLayouts_0;

CREATE VIEW ModelingService_QueryFieldTags AS SELECT
  QueryFieldTags_0.name,
  QueryFieldTags_0.descr,
  QueryFieldTags_0.code
FROM QueryFieldTags AS QueryFieldTags_0;

CREATE VIEW ModelingService_QueryFieldDisplays AS SELECT
  QueryFieldDisplays_0.name,
  QueryFieldDisplays_0.descr,
  QueryFieldDisplays_0.code
FROM QueryFieldDisplays AS QueryFieldDisplays_0;

CREATE VIEW ModelingService_QueryFieldResultRows AS SELECT
  QueryFieldResultRows_0.name,
  QueryFieldResultRows_0.descr,
  QueryFieldResultRows_0.code
FROM QueryFieldResultRows AS QueryFieldResultRows_0;

CREATE VIEW ModelingService_QueryFieldVariableRepresentations AS SELECT
  QueryFieldVariableRepresentations_0.name,
  QueryFieldVariableRepresentations_0.descr,
  QueryFieldVariableRepresentations_0.code
FROM QueryFieldVariableRepresentations AS QueryFieldVariableRepresentations_0;

CREATE VIEW ModelingService_QueryComponentFixSelections AS SELECT
  QueryComponentFixSelections_0.createdAt,
  QueryComponentFixSelections_0.createdBy,
  QueryComponentFixSelections_0.modifiedAt,
  QueryComponentFixSelections_0.modifiedBy,
  QueryComponentFixSelections_0.environment_ID,
  QueryComponentFixSelections_0.function_ID,
  QueryComponentFixSelections_0.seq,
  QueryComponentFixSelections_0.sign_code,
  QueryComponentFixSelections_0.opt_code,
  QueryComponentFixSelections_0.low,
  QueryComponentFixSelections_0.high,
  QueryComponentFixSelections_0.ID,
  QueryComponentFixSelections_0.component_ID
FROM QueryComponentFixSelections AS QueryComponentFixSelections_0;

CREATE VIEW ModelingService_QueryFieldAggregations AS SELECT
  QueryFieldAggregations_0.name,
  QueryFieldAggregations_0.descr,
  QueryFieldAggregations_0.code
FROM QueryFieldAggregations AS QueryFieldAggregations_0;

CREATE VIEW ModelingService_QueryFieldHidings AS SELECT
  QueryFieldHidings_0.name,
  QueryFieldHidings_0.descr,
  QueryFieldHidings_0.code
FROM QueryFieldHidings AS QueryFieldHidings_0;

CREATE VIEW ModelingService_QueryFieldDecimalPlaces AS SELECT
  QueryFieldDecimalPlaces_0.name,
  QueryFieldDecimalPlaces_0.descr,
  QueryFieldDecimalPlaces_0.code
FROM QueryFieldDecimalPlaces AS QueryFieldDecimalPlaces_0;

CREATE VIEW ModelingService_QueryFieldScalingFactors AS SELECT
  QueryFieldScalingFactors_0.name,
  QueryFieldScalingFactors_0.descr,
  QueryFieldScalingFactors_0.code
FROM QueryFieldScalingFactors AS QueryFieldScalingFactors_0;

CREATE VIEW ModelingService_QueryComponentSelections AS SELECT
  QueryComponentSelections_0.createdAt,
  QueryComponentSelections_0.createdBy,
  QueryComponentSelections_0.modifiedAt,
  QueryComponentSelections_0.modifiedBy,
  QueryComponentSelections_0.environment_ID,
  QueryComponentSelections_0.function_ID,
  QueryComponentSelections_0.seq,
  QueryComponentSelections_0.sign_code,
  QueryComponentSelections_0.opt_code,
  QueryComponentSelections_0.low,
  QueryComponentSelections_0.high,
  QueryComponentSelections_0.ID,
  QueryComponentSelections_0.component_ID
FROM QueryComponentSelections AS QueryComponentSelections_0;

CREATE VIEW ModelingService_ApplicationLogStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ApplicationLogStates_texts AS texts_0;

CREATE VIEW ModelingService_ApplicationLogMessageTypes AS SELECT
  ApplicationLogMessageTypes_0.name,
  ApplicationLogMessageTypes_0.descr,
  ApplicationLogMessageTypes_0.code
FROM ApplicationLogMessageTypes AS ApplicationLogMessageTypes_0;

CREATE VIEW ModelingService_RuntimeFunctionStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM RuntimeFunctionStates_texts AS texts_0;

CREATE VIEW ModelingService_RuntimePartitionRanges AS SELECT
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

CREATE VIEW ModelingService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM Signs AS Signs_0;

CREATE VIEW ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM Options AS Options_0;

CREATE VIEW ModelingService_ConnectionSources_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ConnectionSources_texts AS texts_0;

CREATE VIEW ModelingService_Orders_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Orders_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleTypes_texts AS texts_0;

CREATE VIEW ModelingService_AllocationSenderRules_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationSenderRules_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleMethods_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleMethods_texts AS texts_0;

CREATE VIEW ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM "Groups" AS Groups_0;

CREATE VIEW ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW ModelingService_AllocationReceiverRules_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationReceiverRules_texts AS texts_0;

CREATE VIEW ModelingService_AllocationRuleScales_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM AllocationRuleScales_texts AS texts_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CalculationUnitProcessTemplateTypes_texts AS texts_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CalculationUnitProcessTemplateStates_texts AS texts_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivityTypes AS SELECT
  CalculationUnitProcessTemplateActivityTypes_0.name,
  CalculationUnitProcessTemplateActivityTypes_0.descr,
  CalculationUnitProcessTemplateActivityTypes_0.code
FROM CalculationUnitProcessTemplateActivityTypes AS CalculationUnitProcessTemplateActivityTypes_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivityStates AS SELECT
  CalculationUnitProcessTemplateActivityStates_0.name,
  CalculationUnitProcessTemplateActivityStates_0.descr,
  CalculationUnitProcessTemplateActivityStates_0.code
FROM CalculationUnitProcessTemplateActivityStates AS CalculationUnitProcessTemplateActivityStates_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivityChecks AS SELECT
  CalculationUnitProcessTemplateActivityChecks_0.createdAt,
  CalculationUnitProcessTemplateActivityChecks_0.createdBy,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedAt,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedBy,
  CalculationUnitProcessTemplateActivityChecks_0.environment_ID,
  CalculationUnitProcessTemplateActivityChecks_0.function_ID,
  CalculationUnitProcessTemplateActivityChecks_0.ID,
  CalculationUnitProcessTemplateActivityChecks_0.activity_ID,
  CalculationUnitProcessTemplateActivityChecks_0.check_ID
FROM CalculationUnitProcessTemplateActivityChecks AS CalculationUnitProcessTemplateActivityChecks_0;

CREATE VIEW ModelingService_CalculationRuleConditionSelections AS SELECT
  CalculationRuleConditionSelections_0.createdAt,
  CalculationRuleConditionSelections_0.createdBy,
  CalculationRuleConditionSelections_0.modifiedAt,
  CalculationRuleConditionSelections_0.modifiedBy,
  CalculationRuleConditionSelections_0.environment_ID,
  CalculationRuleConditionSelections_0.function_ID,
  CalculationRuleConditionSelections_0.seq,
  CalculationRuleConditionSelections_0.sign_code,
  CalculationRuleConditionSelections_0.opt_code,
  CalculationRuleConditionSelections_0.low,
  CalculationRuleConditionSelections_0.high,
  CalculationRuleConditionSelections_0.ID,
  CalculationRuleConditionSelections_0.condition_ID
FROM CalculationRuleConditionSelections AS CalculationRuleConditionSelections_0;

CREATE VIEW ModelingService_DerivationRuleConditionSelections AS SELECT
  DerivationRuleConditionSelections_0.createdAt,
  DerivationRuleConditionSelections_0.createdBy,
  DerivationRuleConditionSelections_0.modifiedAt,
  DerivationRuleConditionSelections_0.modifiedBy,
  DerivationRuleConditionSelections_0.environment_ID,
  DerivationRuleConditionSelections_0.function_ID,
  DerivationRuleConditionSelections_0.seq,
  DerivationRuleConditionSelections_0.sign_code,
  DerivationRuleConditionSelections_0.opt_code,
  DerivationRuleConditionSelections_0.low,
  DerivationRuleConditionSelections_0.high,
  DerivationRuleConditionSelections_0.ID,
  DerivationRuleConditionSelections_0.condition_ID
FROM DerivationRuleConditionSelections AS DerivationRuleConditionSelections_0;

CREATE VIEW ModelingService_JoinRuleTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM JoinRuleTypes_texts AS texts_0;

CREATE VIEW ModelingService_JoinRuleInputFieldSelections AS SELECT
  JoinRuleInputFieldSelections_0.createdAt,
  JoinRuleInputFieldSelections_0.createdBy,
  JoinRuleInputFieldSelections_0.modifiedAt,
  JoinRuleInputFieldSelections_0.modifiedBy,
  JoinRuleInputFieldSelections_0.environment_ID,
  JoinRuleInputFieldSelections_0.function_ID,
  JoinRuleInputFieldSelections_0.seq,
  JoinRuleInputFieldSelections_0.sign_code,
  JoinRuleInputFieldSelections_0.opt_code,
  JoinRuleInputFieldSelections_0.low,
  JoinRuleInputFieldSelections_0.high,
  JoinRuleInputFieldSelections_0.ID,
  JoinRuleInputFieldSelections_0.inputField_ID
FROM JoinRuleInputFieldSelections AS JoinRuleInputFieldSelections_0;

CREATE VIEW ModelingService_JoinRuleJoinTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM JoinRuleJoinTypes_texts AS texts_0;

CREATE VIEW ModelingService_JoinRulePredicateComparisons AS SELECT
  JoinRulePredicateComparisons_0.name,
  JoinRulePredicateComparisons_0.descr,
  JoinRulePredicateComparisons_0.code
FROM JoinRulePredicateComparisons AS JoinRulePredicateComparisons_0;

CREATE VIEW ModelingService_QueryFieldTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldTypes_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldLayouts_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldLayouts_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldTags_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldTags_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldDisplays_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldDisplays_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldResultRows_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldResultRows_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldVariableRepresentations_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldVariableRepresentations_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldAggregations_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldAggregations_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldHidings_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldHidings_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldDecimalPlaces_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldDecimalPlaces_texts AS texts_0;

CREATE VIEW ModelingService_QueryFieldScalingFactors_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM QueryFieldScalingFactors_texts AS texts_0;

CREATE VIEW ModelingService_ApplicationLogMessageTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM ApplicationLogMessageTypes_texts AS texts_0;

CREATE VIEW ModelingService_Signs_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Signs_texts AS texts_0;

CREATE VIEW ModelingService_Options_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Options_texts AS texts_0;

CREATE VIEW ModelingService_Groups_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM Groups_texts AS texts_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivityTypes_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CalculationUnitProcessTemplateActivityTypes_texts AS texts_0;

CREATE VIEW ModelingService_CalculationUnitProcessTemplateActivityStates_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM CalculationUnitProcessTemplateActivityStates_texts AS texts_0;

CREATE VIEW ModelingService_JoinRulePredicateComparisons_texts AS SELECT
  texts_0.locale,
  texts_0.name,
  texts_0.descr,
  texts_0.code
FROM JoinRulePredicateComparisons_texts AS texts_0;

CREATE VIEW localized_EnvironmentTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (EnvironmentTypes AS L_0 LEFT JOIN EnvironmentTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

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

CREATE VIEW localized_AllocationTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationValueAdjustments AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationTermProcessings AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationCycleAggregations AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleMethods AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationSenderRules AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationReceiverRules AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_AllocationRuleScales AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationTypes AS L_0 LEFT JOIN CalculationTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_DerivationTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (DerivationTypes AS L_0 LEFT JOIN DerivationTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_ModelTableTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationUnitProcessTemplateTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationUnitProcessTemplateStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationUnitProcessTemplateActivityTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_CalculationUnitProcessTemplateActivityStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_JoinTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinTypes AS L_0 LEFT JOIN JoinTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_JoinRuleTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleTypes AS L_0 LEFT JOIN JoinRuleTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_JoinRuleJoinTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleJoinTypes AS L_0 LEFT JOIN JoinRuleJoinTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_JoinRulePredicateComparisons AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRulePredicateComparisons AS L_0 LEFT JOIN JoinRulePredicateComparisons_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTypes AS L_0 LEFT JOIN QueryFieldTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldLayouts AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldLayouts AS L_0 LEFT JOIN QueryFieldLayouts_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldVariableRepresentations AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldVariableRepresentations AS L_0 LEFT JOIN QueryFieldVariableRepresentations_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldHidings AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldHidings AS L_0 LEFT JOIN QueryFieldHidings_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldDisplays AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDisplays AS L_0 LEFT JOIN QueryFieldDisplays_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldScalingFactors AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldScalingFactors AS L_0 LEFT JOIN QueryFieldScalingFactors_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldDecimalPlaces AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDecimalPlaces AS L_0 LEFT JOIN QueryFieldDecimalPlaces_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldResultRows AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldResultRows AS L_0 LEFT JOIN QueryFieldResultRows_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldTags AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTags AS L_0 LEFT JOIN QueryFieldTags_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_QueryFieldAggregations AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldAggregations AS L_0 LEFT JOIN QueryFieldAggregations_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

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

CREATE VIEW localized_RuntimeFunctionStates AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (RuntimeFunctionStates AS L_0 LEFT JOIN RuntimeFunctionStates_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_MessageTypes AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (MessageTypes AS L_0 LEFT JOIN MessageTypes_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

CREATE VIEW localized_Groups AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

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

CREATE VIEW localized_ConnectionSources AS SELECT
  coalesce(localized_1.name, L_0.name) AS name,
  coalesce(localized_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ConnectionSources AS L_0 LEFT JOIN ConnectionSources_texts AS localized_1 ON localized_1.code = L_0.code AND localized_1.locale = 'en');

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
  L.seq,
  L.sign_code,
  L.opt_code,
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

CREATE VIEW localized_Allocations AS SELECT
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
  L.valueAdjustment_code,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.receiverFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_AllocationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationInputFields AS L;

CREATE VIEW localized_AllocationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationInputFieldSelections AS L;

CREATE VIEW localized_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

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
  L.seq,
  L.sign_code,
  L.opt_code,
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
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM CalculationRuleConditionSelections AS L;

CREATE VIEW localized_Derivations AS SELECT
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
  L.suppressInitialResults,
  L.ensureDistinctResults
FROM Derivations AS L;

CREATE VIEW localized_DerivationInputFields AS SELECT
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
  L.derivation_ID
FROM DerivationInputFields AS L;

CREATE VIEW localized_DerivationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM DerivationInputFieldSelections AS L;

CREATE VIEW localized_DerivationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM DerivationRuleConditionSelections AS L;

CREATE VIEW localized_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connection
FROM ModelTables AS L;

CREATE VIEW localized_CalculationUnitProcessTemplates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.CalculationUnit_ID,
  L.process,
  L.sequence,
  L.type_code,
  L.state_code,
  L.description
FROM CalculationUnitProcessTemplates AS L;

CREATE VIEW localized_CalculationUnitProcessTemplateActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.performerGroup,
  L.reviewerGroup,
  L.startDate,
  L.endDate,
  L.url
FROM CalculationUnitProcessTemplateActivities AS L;

CREATE VIEW localized_Joins AS SELECT
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
  L.type_code
FROM Joins AS L;

CREATE VIEW localized_JoinInputFields AS SELECT
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
  L.Join_ID
FROM JoinInputFields AS L;

CREATE VIEW localized_JoinInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinInputFieldSelections AS L;

CREATE VIEW localized_JoinRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.parent_ID,
  L.type_code,
  L.inputFunction_ID,
  L.joinType_code,
  L.complexPredicates,
  L.sequence,
  L.description
FROM JoinRules AS L;

CREATE VIEW localized_JoinRuleInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.field_ID,
  L.ID,
  L.rule_ID
FROM JoinRuleInputFields AS L;

CREATE VIEW localized_JoinRuleInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinRuleInputFieldSelections AS L;

CREATE VIEW localized_JoinRulePredicates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID,
  L.comparison_code,
  L.joinRule_ID,
  L.joinField_ID,
  L.sequence
FROM JoinRulePredicates AS L;

CREATE VIEW localized_QueryComponents AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.query_ID,
  L.component,
  L.type_code,
  L.layout_code,
  L.tag_code,
  L.editable,
  L.field_ID,
  L.hierarchy_ID,
  L.display_code,
  L.resultRow_code,
  L.variableRepresentation_code,
  L.variableMandatory,
  L.variableDefaultValue,
  L.aggregation_code,
  L.hiding_code,
  L.decimalPlaces_code,
  L.scalingFactor_code,
  L.changeSign,
  L.formula,
  L.keyfigure_ID
FROM QueryComponents AS L;

CREATE VIEW localized_QueryComponentFixSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentFixSelections AS L;

CREATE VIEW localized_QueryComponentSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentSelections AS L;

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

CREATE VIEW localized_ApplicationChecks AS SELECT
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
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationChecks AS L;

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

CREATE VIEW localized_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

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

CREATE VIEW localized_DerivationSignatureFields AS SELECT
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
  L.derivation_ID
FROM DerivationSignatureFields AS L;

CREATE VIEW localized_DerivationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.sequence,
  L.description
FROM DerivationRules AS L;

CREATE VIEW localized_DerivationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM DerivationRuleConditions AS L;

CREATE VIEW localized_DerivationRuleActions AS SELECT
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
FROM DerivationRuleActions AS L;

CREATE VIEW localized_DerivationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.check_ID
FROM DerivationChecks AS L;

CREATE VIEW localized_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID,
  L.sourceField
FROM ModelTableFields AS L;

CREATE VIEW localized_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_CalculationUnitProcessTemplateActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CalculationUnitProcessTemplateActivityLinks AS L;

CREATE VIEW localized_CalculationUnitProcessTemplateActivityChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.activity_ID,
  L.check_ID
FROM CalculationUnitProcessTemplateActivityChecks AS L;

CREATE VIEW localized_CalculationUnitProcessTemplateReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CalculationUnitProcessTemplateReports AS L;

CREATE VIEW localized_CalculationUnitProcessTemplateReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CalculationUnitProcessTemplateReportElements AS L;

CREATE VIEW localized_JoinSignatureFields AS SELECT
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
  L.Join_ID
FROM JoinSignatureFields AS L;

CREATE VIEW localized_JoinChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.check_ID
FROM JoinChecks AS L;

CREATE VIEW localized_Queries AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Editable,
  L.inputFunction_ID
FROM Queries AS L;

CREATE VIEW localized_CheckFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.check_ID,
  L.field_ID
FROM CheckFields AS L;

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
  L.function_ID,
  L.field_ID
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

CREATE VIEW ModelingService_DraftAdministrativeData AS SELECT
  DraftAdministrativeData.DraftUUID,
  DraftAdministrativeData.CreationDateTime,
  DraftAdministrativeData.CreatedByUser,
  DraftAdministrativeData.DraftIsCreatedByMe,
  DraftAdministrativeData.LastChangeDateTime,
  DraftAdministrativeData.LastChangedByUser,
  DraftAdministrativeData.InProcessByUser,
  DraftAdministrativeData.DraftIsProcessedByMe
FROM DRAFT_DraftAdministrativeData AS DraftAdministrativeData;

CREATE VIEW ModelingService_EnvironmentFolders AS SELECT
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

CREATE VIEW ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM UnitFields AS UnitFields_0;

CREATE VIEW ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW ModelingService_FunctionParentFunctionsVH AS SELECT
  FunctionParentFunctionsVH_0.createdAt,
  FunctionParentFunctionsVH_0.createdBy,
  FunctionParentFunctionsVH_0.modifiedAt,
  FunctionParentFunctionsVH_0.modifiedBy,
  FunctionParentFunctionsVH_0.environment_ID,
  FunctionParentFunctionsVH_0.ID,
  FunctionParentFunctionsVH_0.function,
  FunctionParentFunctionsVH_0.sequence,
  FunctionParentFunctionsVH_0.parent_ID,
  FunctionParentFunctionsVH_0.type_code,
  FunctionParentFunctionsVH_0.description,
  FunctionParentFunctionsVH_0.documentation
FROM FunctionParentFunctionsVH AS FunctionParentFunctionsVH_0;

CREATE VIEW ModelingService_FunctionResultFunctionsVH AS SELECT
  FunctionResultFunctionsVH_0.createdAt,
  FunctionResultFunctionsVH_0.createdBy,
  FunctionResultFunctionsVH_0.modifiedAt,
  FunctionResultFunctionsVH_0.modifiedBy,
  FunctionResultFunctionsVH_0.environment_ID,
  FunctionResultFunctionsVH_0.ID,
  FunctionResultFunctionsVH_0.function,
  FunctionResultFunctionsVH_0.sequence,
  FunctionResultFunctionsVH_0.parent_ID,
  FunctionResultFunctionsVH_0.type_code,
  FunctionResultFunctionsVH_0.description,
  FunctionResultFunctionsVH_0.documentation
FROM FunctionResultFunctionsVH AS FunctionResultFunctionsVH_0;

CREATE VIEW ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

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

CREATE VIEW localized_OffsetAllocation AS SELECT
  Allocations_0.environment_ID,
  Allocations_0.function_ID,
  Allocations_0.ID,
  Allocations_0.type_code,
  Allocations_0.valueAdjustment_code,
  Allocations_0.includeInputData,
  Allocations_0.resultHandling_code,
  Allocations_0.includeInitialResult,
  Allocations_0.inputFunction_ID,
  Allocations_0.receiverFunction_ID,
  Allocations_0.resultFunction_ID
FROM localized_Allocations AS Allocations_0;

CREATE VIEW localized_AllocationTermIterationFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_AllocationTermYearFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_AllocationTermFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_Checks AS Checks_0;

CREATE VIEW localized_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_AllocationActionFields AS L_1 LEFT JOIN localized_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_AllocationActionFields AS L_1 LEFT JOIN localized_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_modelJoins AS SELECT
  Joins_0.createdAt,
  Joins_0.createdBy,
  Joins_0.modifiedAt,
  Joins_0.modifiedBy,
  Joins_0.environment_ID,
  Joins_0.function_ID,
  Joins_0.ID,
  Joins_0.type_code
FROM localized_Joins AS Joins_0;

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

CREATE VIEW localized_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_ModelingService_CalculationTypes AS SELECT
  CalculationTypes_0.name,
  CalculationTypes_0.descr,
  CalculationTypes_0.code
FROM localized_CalculationTypes AS CalculationTypes_0;

CREATE VIEW localized_ModelingService_DerivationTypes AS SELECT
  DerivationTypes_0.name,
  DerivationTypes_0.descr,
  DerivationTypes_0.code
FROM localized_DerivationTypes AS DerivationTypes_0;

CREATE VIEW localized_ModelingService_JoinTypes AS SELECT
  JoinTypes_0.name,
  JoinTypes_0.descr,
  JoinTypes_0.code
FROM localized_JoinTypes AS JoinTypes_0;

CREATE VIEW localized_ModelingService_ApplicationLogStates AS SELECT
  ApplicationLogStates_0.name,
  ApplicationLogStates_0.descr,
  ApplicationLogStates_0.code
FROM localized_ApplicationLogStates AS ApplicationLogStates_0;

CREATE VIEW localized_ModelingService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_ModelingService_ConnectionSources AS SELECT
  ConnectionSources_0.name,
  ConnectionSources_0.descr,
  ConnectionSources_0.code
FROM localized_ConnectionSources AS ConnectionSources_0;

CREATE VIEW localized_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_Orders AS Orders_0;

CREATE VIEW localized_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateTypes AS SELECT
  CalculationUnitProcessTemplateTypes_0.name,
  CalculationUnitProcessTemplateTypes_0.descr,
  CalculationUnitProcessTemplateTypes_0.code
FROM localized_CalculationUnitProcessTemplateTypes AS CalculationUnitProcessTemplateTypes_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateStates AS SELECT
  CalculationUnitProcessTemplateStates_0.name,
  CalculationUnitProcessTemplateStates_0.descr,
  CalculationUnitProcessTemplateStates_0.code
FROM localized_CalculationUnitProcessTemplateStates AS CalculationUnitProcessTemplateStates_0;

CREATE VIEW localized_ModelingService_JoinRuleTypes AS SELECT
  JoinRuleTypes_0.name,
  JoinRuleTypes_0.descr,
  JoinRuleTypes_0.code
FROM localized_JoinRuleTypes AS JoinRuleTypes_0;

CREATE VIEW localized_ModelingService_JoinRuleJoinTypes AS SELECT
  JoinRuleJoinTypes_0.name,
  JoinRuleJoinTypes_0.descr,
  JoinRuleJoinTypes_0.code
FROM localized_JoinRuleJoinTypes AS JoinRuleJoinTypes_0;

CREATE VIEW localized_ModelingService_QueryFieldTypes AS SELECT
  QueryFieldTypes_0.name,
  QueryFieldTypes_0.descr,
  QueryFieldTypes_0.code
FROM localized_QueryFieldTypes AS QueryFieldTypes_0;

CREATE VIEW localized_ModelingService_QueryFieldLayouts AS SELECT
  QueryFieldLayouts_0.name,
  QueryFieldLayouts_0.descr,
  QueryFieldLayouts_0.code
FROM localized_QueryFieldLayouts AS QueryFieldLayouts_0;

CREATE VIEW localized_ModelingService_QueryFieldTags AS SELECT
  QueryFieldTags_0.name,
  QueryFieldTags_0.descr,
  QueryFieldTags_0.code
FROM localized_QueryFieldTags AS QueryFieldTags_0;

CREATE VIEW localized_ModelingService_QueryFieldDisplays AS SELECT
  QueryFieldDisplays_0.name,
  QueryFieldDisplays_0.descr,
  QueryFieldDisplays_0.code
FROM localized_QueryFieldDisplays AS QueryFieldDisplays_0;

CREATE VIEW localized_ModelingService_QueryFieldResultRows AS SELECT
  QueryFieldResultRows_0.name,
  QueryFieldResultRows_0.descr,
  QueryFieldResultRows_0.code
FROM localized_QueryFieldResultRows AS QueryFieldResultRows_0;

CREATE VIEW localized_ModelingService_QueryFieldVariableRepresentations AS SELECT
  QueryFieldVariableRepresentations_0.name,
  QueryFieldVariableRepresentations_0.descr,
  QueryFieldVariableRepresentations_0.code
FROM localized_QueryFieldVariableRepresentations AS QueryFieldVariableRepresentations_0;

CREATE VIEW localized_ModelingService_QueryFieldAggregations AS SELECT
  QueryFieldAggregations_0.name,
  QueryFieldAggregations_0.descr,
  QueryFieldAggregations_0.code
FROM localized_QueryFieldAggregations AS QueryFieldAggregations_0;

CREATE VIEW localized_ModelingService_QueryFieldHidings AS SELECT
  QueryFieldHidings_0.name,
  QueryFieldHidings_0.descr,
  QueryFieldHidings_0.code
FROM localized_QueryFieldHidings AS QueryFieldHidings_0;

CREATE VIEW localized_ModelingService_QueryFieldDecimalPlaces AS SELECT
  QueryFieldDecimalPlaces_0.name,
  QueryFieldDecimalPlaces_0.descr,
  QueryFieldDecimalPlaces_0.code
FROM localized_QueryFieldDecimalPlaces AS QueryFieldDecimalPlaces_0;

CREATE VIEW localized_ModelingService_QueryFieldScalingFactors AS SELECT
  QueryFieldScalingFactors_0.name,
  QueryFieldScalingFactors_0.descr,
  QueryFieldScalingFactors_0.code
FROM localized_QueryFieldScalingFactors AS QueryFieldScalingFactors_0;

CREATE VIEW localized_ModelingService_ApplicationLogMessageTypes AS SELECT
  ApplicationLogMessageTypes_0.name,
  ApplicationLogMessageTypes_0.descr,
  ApplicationLogMessageTypes_0.code
FROM localized_ApplicationLogMessageTypes AS ApplicationLogMessageTypes_0;

CREATE VIEW localized_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_Signs AS Signs_0;

CREATE VIEW localized_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_Options AS Options_0;

CREATE VIEW localized_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_Groups AS Groups_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateActivityTypes AS SELECT
  CalculationUnitProcessTemplateActivityTypes_0.name,
  CalculationUnitProcessTemplateActivityTypes_0.descr,
  CalculationUnitProcessTemplateActivityTypes_0.code
FROM localized_CalculationUnitProcessTemplateActivityTypes AS CalculationUnitProcessTemplateActivityTypes_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateActivityStates AS SELECT
  CalculationUnitProcessTemplateActivityStates_0.name,
  CalculationUnitProcessTemplateActivityStates_0.descr,
  CalculationUnitProcessTemplateActivityStates_0.code
FROM localized_CalculationUnitProcessTemplateActivityStates AS CalculationUnitProcessTemplateActivityStates_0;

CREATE VIEW localized_ModelingService_JoinRulePredicateComparisons AS SELECT
  JoinRulePredicateComparisons_0.name,
  JoinRulePredicateComparisons_0.descr,
  JoinRulePredicateComparisons_0.code
FROM localized_JoinRulePredicateComparisons AS JoinRulePredicateComparisons_0;

CREATE VIEW localized_ModelingService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_ModelingService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field_ID
FROM localized_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_ModelingService_RuntimeShareLocks AS SELECT
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

CREATE VIEW localized_ModelingService_Environments AS SELECT
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
FROM localized_Environments AS environments_0;

CREATE VIEW localized_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_Fields AS fields_0;

CREATE VIEW localized_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_Checks AS checks_0;

CREATE VIEW localized_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.description,
  functions_0.documentation
FROM localized_Functions AS functions_0;

CREATE VIEW localized_ModelingService_RuntimeFunctions AS SELECT
  runtimeFunctions_0.createdAt,
  runtimeFunctions_0.createdBy,
  runtimeFunctions_0.modifiedAt,
  runtimeFunctions_0.modifiedBy,
  runtimeFunctions_0.ID,
  runtimeFunctions_0.environment,
  runtimeFunctions_0.version,
  runtimeFunctions_0.process,
  runtimeFunctions_0.activity,
  runtimeFunctions_0.function,
  runtimeFunctions_0.description,
  runtimeFunctions_0.type_code,
  runtimeFunctions_0.state_code,
  runtimeFunctions_0.processingType_code,
  runtimeFunctions_0.businessEventType_code,
  runtimeFunctions_0.partition_ID,
  runtimeFunctions_0.storedProcedure,
  runtimeFunctions_0.appServerStatement,
  runtimeFunctions_0.preStatement,
  runtimeFunctions_0.statement,
  runtimeFunctions_0.postStatement,
  runtimeFunctions_0.hanaTable,
  runtimeFunctions_0.hanaView,
  runtimeFunctions_0.synonym,
  runtimeFunctions_0.masterDataHierarchyView,
  runtimeFunctions_0.calculationView,
  runtimeFunctions_0.workBook,
  runtimeFunctions_0.resultModelTable_ID
FROM localized_RuntimeFunctions AS runtimeFunctions_0;

CREATE VIEW localized_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.resultFunction_ID,
  allocations_0.processingType_code,
  allocations_0.businessEventType_code,
  allocations_0.partition_ID,
  allocations_0.inputFunction_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.receiverFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_Allocations AS allocations_0;

CREATE VIEW localized_ModelingService_Calculations AS SELECT
  calculations_0.createdAt,
  calculations_0.createdBy,
  calculations_0.modifiedAt,
  calculations_0.modifiedBy,
  calculations_0.environment_ID,
  calculations_0.function_ID,
  calculations_0.includeInputData,
  calculations_0.resultHandling_code,
  calculations_0.includeInitialResult,
  calculations_0.resultFunction_ID,
  calculations_0.processingType_code,
  calculations_0.businessEventType_code,
  calculations_0.partition_ID,
  calculations_0.inputFunction_ID,
  calculations_0.ID,
  calculations_0.type_code,
  calculations_0.workbook
FROM localized_Calculations AS calculations_0;

CREATE VIEW localized_ModelingService_Derivations AS SELECT
  derivations_0.createdAt,
  derivations_0.createdBy,
  derivations_0.modifiedAt,
  derivations_0.modifiedBy,
  derivations_0.environment_ID,
  derivations_0.function_ID,
  derivations_0.includeInputData,
  derivations_0.resultHandling_code,
  derivations_0.includeInitialResult,
  derivations_0.resultFunction_ID,
  derivations_0.processingType_code,
  derivations_0.businessEventType_code,
  derivations_0.partition_ID,
  derivations_0.inputFunction_ID,
  derivations_0.ID,
  derivations_0.type_code,
  derivations_0.suppressInitialResults,
  derivations_0.ensureDistinctResults
FROM localized_Derivations AS derivations_0;

CREATE VIEW localized_ModelingService_Joins AS SELECT
  joins_0.createdAt,
  joins_0.createdBy,
  joins_0.modifiedAt,
  joins_0.modifiedBy,
  joins_0.environment_ID,
  joins_0.function_ID,
  joins_0.includeInputData,
  joins_0.resultHandling_code,
  joins_0.includeInitialResult,
  joins_0.resultFunction_ID,
  joins_0.processingType_code,
  joins_0.businessEventType_code,
  joins_0.partition_ID,
  joins_0.inputFunction_ID,
  joins_0.ID,
  joins_0.type_code
FROM localized_Joins AS joins_0;

CREATE VIEW localized_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connection
FROM localized_ModelTables AS modelTables_0;

CREATE VIEW localized_ModelingService_ApplicationLogs AS SELECT
  applicationLogs_0.createdAt,
  applicationLogs_0.createdBy,
  applicationLogs_0.modifiedAt,
  applicationLogs_0.modifiedBy,
  applicationLogs_0.ID,
  applicationLogs_0.run,
  applicationLogs_0.type,
  applicationLogs_0.environment,
  applicationLogs_0.version,
  applicationLogs_0.process,
  applicationLogs_0.activity,
  applicationLogs_0.mainFunction,
  applicationLogs_0.parameters,
  applicationLogs_0.selections,
  applicationLogs_0.businessEvent,
  applicationLogs_0.field,
  applicationLogs_0."check",
  applicationLogs_0.conversion,
  applicationLogs_0."partition",
  applicationLogs_0.package,
  applicationLogs_0.state_code
FROM localized_ApplicationLogs AS applicationLogs_0;

CREATE VIEW localized_ModelingService_Connections AS SELECT
  Connections_0.createdAt,
  Connections_0.createdBy,
  Connections_0.modifiedAt,
  Connections_0.modifiedBy,
  Connections_0.environment_ID,
  Connections_0.ID,
  Connections_0.connection,
  Connections_0.description,
  Connections_0.source_code,
  Connections_0.hanaTable,
  Connections_0.hanaView,
  Connections_0.odataUrl,
  Connections_0.odataUrlOptions
FROM localized_Connections AS Connections_0;

CREATE VIEW localized_ModelingService_AllocationInputFields AS SELECT
  AllocationInputFields_0.createdAt,
  AllocationInputFields_0.createdBy,
  AllocationInputFields_0.modifiedAt,
  AllocationInputFields_0.modifiedBy,
  AllocationInputFields_0.environment_ID,
  AllocationInputFields_0.function_ID,
  AllocationInputFields_0.formula,
  AllocationInputFields_0.order_code,
  AllocationInputFields_0.ID,
  AllocationInputFields_0.allocation_ID,
  AllocationInputFields_0.field_ID
FROM localized_AllocationInputFields AS AllocationInputFields_0;

CREATE VIEW localized_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_ModelingService_CalculationInputFields AS SELECT
  CalculationInputFields_0.createdAt,
  CalculationInputFields_0.createdBy,
  CalculationInputFields_0.modifiedAt,
  CalculationInputFields_0.modifiedBy,
  CalculationInputFields_0.environment_ID,
  CalculationInputFields_0.function_ID,
  CalculationInputFields_0.formula,
  CalculationInputFields_0.order_code,
  CalculationInputFields_0.ID,
  CalculationInputFields_0.field_ID,
  CalculationInputFields_0.calculation_ID
FROM localized_CalculationInputFields AS CalculationInputFields_0;

CREATE VIEW localized_ModelingService_DerivationInputFields AS SELECT
  DerivationInputFields_0.createdAt,
  DerivationInputFields_0.createdBy,
  DerivationInputFields_0.modifiedAt,
  DerivationInputFields_0.modifiedBy,
  DerivationInputFields_0.environment_ID,
  DerivationInputFields_0.function_ID,
  DerivationInputFields_0.formula,
  DerivationInputFields_0.order_code,
  DerivationInputFields_0.ID,
  DerivationInputFields_0.field_ID,
  DerivationInputFields_0.derivation_ID
FROM localized_DerivationInputFields AS DerivationInputFields_0;

CREATE VIEW localized_ModelingService_JoinInputFields AS SELECT
  JoinInputFields_0.createdAt,
  JoinInputFields_0.createdBy,
  JoinInputFields_0.modifiedAt,
  JoinInputFields_0.modifiedBy,
  JoinInputFields_0.environment_ID,
  JoinInputFields_0.function_ID,
  JoinInputFields_0.formula,
  JoinInputFields_0.order_code,
  JoinInputFields_0.ID,
  JoinInputFields_0.field_ID,
  JoinInputFields_0.Join_ID
FROM localized_JoinInputFields AS JoinInputFields_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_ModelingService_JoinRuleInputFields AS SELECT
  JoinRuleInputFields_0.createdAt,
  JoinRuleInputFields_0.createdBy,
  JoinRuleInputFields_0.modifiedAt,
  JoinRuleInputFields_0.modifiedBy,
  JoinRuleInputFields_0.environment_ID,
  JoinRuleInputFields_0.function_ID,
  JoinRuleInputFields_0.formula,
  JoinRuleInputFields_0.order_code,
  JoinRuleInputFields_0.field_ID,
  JoinRuleInputFields_0.ID,
  JoinRuleInputFields_0.rule_ID
FROM localized_JoinRuleInputFields AS JoinRuleInputFields_0;

CREATE VIEW localized_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplates AS SELECT
  CalculationUnitProcessTemplates_0.createdAt,
  CalculationUnitProcessTemplates_0.createdBy,
  CalculationUnitProcessTemplates_0.modifiedAt,
  CalculationUnitProcessTemplates_0.modifiedBy,
  CalculationUnitProcessTemplates_0.environment_ID,
  CalculationUnitProcessTemplates_0.function_ID,
  CalculationUnitProcessTemplates_0.ID,
  CalculationUnitProcessTemplates_0.CalculationUnit_ID,
  CalculationUnitProcessTemplates_0.process,
  CalculationUnitProcessTemplates_0.sequence,
  CalculationUnitProcessTemplates_0.type_code,
  CalculationUnitProcessTemplates_0.state_code,
  CalculationUnitProcessTemplates_0.description
FROM localized_CalculationUnitProcessTemplates AS CalculationUnitProcessTemplates_0;

CREATE VIEW localized_ModelingService_JoinRules AS SELECT
  JoinRules_0.createdAt,
  JoinRules_0.createdBy,
  JoinRules_0.modifiedAt,
  JoinRules_0.modifiedBy,
  JoinRules_0.environment_ID,
  JoinRules_0.function_ID,
  JoinRules_0.ID,
  JoinRules_0.Join_ID,
  JoinRules_0.parent_ID,
  JoinRules_0.type_code,
  JoinRules_0.inputFunction_ID,
  JoinRules_0.joinType_code,
  JoinRules_0.complexPredicates,
  JoinRules_0.sequence,
  JoinRules_0.description
FROM localized_JoinRules AS JoinRules_0;

CREATE VIEW localized_ModelingService_QueryComponents AS SELECT
  QueryComponents_0.createdAt,
  QueryComponents_0.createdBy,
  QueryComponents_0.modifiedAt,
  QueryComponents_0.modifiedBy,
  QueryComponents_0.environment_ID,
  QueryComponents_0.function_ID,
  QueryComponents_0.ID,
  QueryComponents_0.query_ID,
  QueryComponents_0.component,
  QueryComponents_0.type_code,
  QueryComponents_0.layout_code,
  QueryComponents_0.tag_code,
  QueryComponents_0.editable,
  QueryComponents_0.field_ID,
  QueryComponents_0.hierarchy_ID,
  QueryComponents_0.display_code,
  QueryComponents_0.resultRow_code,
  QueryComponents_0.variableRepresentation_code,
  QueryComponents_0.variableMandatory,
  QueryComponents_0.variableDefaultValue,
  QueryComponents_0.aggregation_code,
  QueryComponents_0.hiding_code,
  QueryComponents_0.decimalPlaces_code,
  QueryComponents_0.scalingFactor_code,
  QueryComponents_0.changeSign,
  QueryComponents_0.formula,
  QueryComponents_0.keyfigure_ID
FROM localized_QueryComponents AS QueryComponents_0;

CREATE VIEW localized_ModelingService_ApplicationLogMessages AS SELECT
  ApplicationLogMessages_0.createdAt,
  ApplicationLogMessages_0.createdBy,
  ApplicationLogMessages_0.modifiedAt,
  ApplicationLogMessages_0.modifiedBy,
  ApplicationLogMessages_0.ID,
  ApplicationLogMessages_0.applicationLog_ID,
  ApplicationLogMessages_0.type_code,
  ApplicationLogMessages_0.function,
  ApplicationLogMessages_0.code,
  ApplicationLogMessages_0.entity,
  ApplicationLogMessages_0.primaryKey,
  ApplicationLogMessages_0.target,
  ApplicationLogMessages_0.argument1,
  ApplicationLogMessages_0.argument2,
  ApplicationLogMessages_0.argument3,
  ApplicationLogMessages_0.argument4,
  ApplicationLogMessages_0.argument5,
  ApplicationLogMessages_0.argument6,
  ApplicationLogMessages_0.messageDetails
FROM localized_ApplicationLogMessages AS ApplicationLogMessages_0;

CREATE VIEW localized_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_ModelingService_AllocationInputFieldSelections AS SELECT
  AllocationInputFieldSelections_0.createdAt,
  AllocationInputFieldSelections_0.createdBy,
  AllocationInputFieldSelections_0.modifiedAt,
  AllocationInputFieldSelections_0.modifiedBy,
  AllocationInputFieldSelections_0.environment_ID,
  AllocationInputFieldSelections_0.function_ID,
  AllocationInputFieldSelections_0.seq,
  AllocationInputFieldSelections_0.sign_code,
  AllocationInputFieldSelections_0.opt_code,
  AllocationInputFieldSelections_0.low,
  AllocationInputFieldSelections_0.high,
  AllocationInputFieldSelections_0.ID,
  AllocationInputFieldSelections_0.field_ID
FROM localized_AllocationInputFieldSelections AS AllocationInputFieldSelections_0;

CREATE VIEW localized_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_ModelingService_CalculationInputFieldSelections AS SELECT
  CalculationInputFieldSelections_0.createdAt,
  CalculationInputFieldSelections_0.createdBy,
  CalculationInputFieldSelections_0.modifiedAt,
  CalculationInputFieldSelections_0.modifiedBy,
  CalculationInputFieldSelections_0.environment_ID,
  CalculationInputFieldSelections_0.function_ID,
  CalculationInputFieldSelections_0.seq,
  CalculationInputFieldSelections_0.sign_code,
  CalculationInputFieldSelections_0.opt_code,
  CalculationInputFieldSelections_0.low,
  CalculationInputFieldSelections_0.high,
  CalculationInputFieldSelections_0.ID,
  CalculationInputFieldSelections_0.inputField_ID
FROM localized_CalculationInputFieldSelections AS CalculationInputFieldSelections_0;

CREATE VIEW localized_ModelingService_DerivationInputFieldSelections AS SELECT
  DerivationInputFieldSelections_0.createdAt,
  DerivationInputFieldSelections_0.createdBy,
  DerivationInputFieldSelections_0.modifiedAt,
  DerivationInputFieldSelections_0.modifiedBy,
  DerivationInputFieldSelections_0.environment_ID,
  DerivationInputFieldSelections_0.function_ID,
  DerivationInputFieldSelections_0.seq,
  DerivationInputFieldSelections_0.sign_code,
  DerivationInputFieldSelections_0.opt_code,
  DerivationInputFieldSelections_0.low,
  DerivationInputFieldSelections_0.high,
  DerivationInputFieldSelections_0.ID,
  DerivationInputFieldSelections_0.inputField_ID
FROM localized_DerivationInputFieldSelections AS DerivationInputFieldSelections_0;

CREATE VIEW localized_ModelingService_JoinInputFieldSelections AS SELECT
  JoinInputFieldSelections_0.createdAt,
  JoinInputFieldSelections_0.createdBy,
  JoinInputFieldSelections_0.modifiedAt,
  JoinInputFieldSelections_0.modifiedBy,
  JoinInputFieldSelections_0.environment_ID,
  JoinInputFieldSelections_0.function_ID,
  JoinInputFieldSelections_0.seq,
  JoinInputFieldSelections_0.sign_code,
  JoinInputFieldSelections_0.opt_code,
  JoinInputFieldSelections_0.low,
  JoinInputFieldSelections_0.high,
  JoinInputFieldSelections_0.ID,
  JoinInputFieldSelections_0.inputField_ID
FROM localized_JoinInputFieldSelections AS JoinInputFieldSelections_0;

CREATE VIEW localized_ModelingService_QueryComponentFixSelections AS SELECT
  QueryComponentFixSelections_0.createdAt,
  QueryComponentFixSelections_0.createdBy,
  QueryComponentFixSelections_0.modifiedAt,
  QueryComponentFixSelections_0.modifiedBy,
  QueryComponentFixSelections_0.environment_ID,
  QueryComponentFixSelections_0.function_ID,
  QueryComponentFixSelections_0.seq,
  QueryComponentFixSelections_0.sign_code,
  QueryComponentFixSelections_0.opt_code,
  QueryComponentFixSelections_0.low,
  QueryComponentFixSelections_0.high,
  QueryComponentFixSelections_0.ID,
  QueryComponentFixSelections_0.component_ID
FROM localized_QueryComponentFixSelections AS QueryComponentFixSelections_0;

CREATE VIEW localized_ModelingService_QueryComponentSelections AS SELECT
  QueryComponentSelections_0.createdAt,
  QueryComponentSelections_0.createdBy,
  QueryComponentSelections_0.modifiedAt,
  QueryComponentSelections_0.modifiedBy,
  QueryComponentSelections_0.environment_ID,
  QueryComponentSelections_0.function_ID,
  QueryComponentSelections_0.seq,
  QueryComponentSelections_0.sign_code,
  QueryComponentSelections_0.opt_code,
  QueryComponentSelections_0.low,
  QueryComponentSelections_0.high,
  QueryComponentSelections_0.ID,
  QueryComponentSelections_0.component_ID
FROM localized_QueryComponentSelections AS QueryComponentSelections_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_ModelingService_CalculationRuleConditionSelections AS SELECT
  CalculationRuleConditionSelections_0.createdAt,
  CalculationRuleConditionSelections_0.createdBy,
  CalculationRuleConditionSelections_0.modifiedAt,
  CalculationRuleConditionSelections_0.modifiedBy,
  CalculationRuleConditionSelections_0.environment_ID,
  CalculationRuleConditionSelections_0.function_ID,
  CalculationRuleConditionSelections_0.seq,
  CalculationRuleConditionSelections_0.sign_code,
  CalculationRuleConditionSelections_0.opt_code,
  CalculationRuleConditionSelections_0.low,
  CalculationRuleConditionSelections_0.high,
  CalculationRuleConditionSelections_0.ID,
  CalculationRuleConditionSelections_0.condition_ID
FROM localized_CalculationRuleConditionSelections AS CalculationRuleConditionSelections_0;

CREATE VIEW localized_ModelingService_DerivationRuleConditionSelections AS SELECT
  DerivationRuleConditionSelections_0.createdAt,
  DerivationRuleConditionSelections_0.createdBy,
  DerivationRuleConditionSelections_0.modifiedAt,
  DerivationRuleConditionSelections_0.modifiedBy,
  DerivationRuleConditionSelections_0.environment_ID,
  DerivationRuleConditionSelections_0.function_ID,
  DerivationRuleConditionSelections_0.seq,
  DerivationRuleConditionSelections_0.sign_code,
  DerivationRuleConditionSelections_0.opt_code,
  DerivationRuleConditionSelections_0.low,
  DerivationRuleConditionSelections_0.high,
  DerivationRuleConditionSelections_0.ID,
  DerivationRuleConditionSelections_0.condition_ID
FROM localized_DerivationRuleConditionSelections AS DerivationRuleConditionSelections_0;

CREATE VIEW localized_ModelingService_JoinRuleInputFieldSelections AS SELECT
  JoinRuleInputFieldSelections_0.createdAt,
  JoinRuleInputFieldSelections_0.createdBy,
  JoinRuleInputFieldSelections_0.modifiedAt,
  JoinRuleInputFieldSelections_0.modifiedBy,
  JoinRuleInputFieldSelections_0.environment_ID,
  JoinRuleInputFieldSelections_0.function_ID,
  JoinRuleInputFieldSelections_0.seq,
  JoinRuleInputFieldSelections_0.sign_code,
  JoinRuleInputFieldSelections_0.opt_code,
  JoinRuleInputFieldSelections_0.low,
  JoinRuleInputFieldSelections_0.high,
  JoinRuleInputFieldSelections_0.ID,
  JoinRuleInputFieldSelections_0.inputField_ID
FROM localized_JoinRuleInputFieldSelections AS JoinRuleInputFieldSelections_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateActivities AS SELECT
  CalculationUnitProcessTemplateActivities_0.createdAt,
  CalculationUnitProcessTemplateActivities_0.createdBy,
  CalculationUnitProcessTemplateActivities_0.modifiedAt,
  CalculationUnitProcessTemplateActivities_0.modifiedBy,
  CalculationUnitProcessTemplateActivities_0.environment_ID,
  CalculationUnitProcessTemplateActivities_0.ID,
  CalculationUnitProcessTemplateActivities_0.process_ID,
  CalculationUnitProcessTemplateActivities_0.activity,
  CalculationUnitProcessTemplateActivities_0.parent_ID,
  CalculationUnitProcessTemplateActivities_0.sequence,
  CalculationUnitProcessTemplateActivities_0.activityType_code,
  CalculationUnitProcessTemplateActivities_0.activityState_code,
  CalculationUnitProcessTemplateActivities_0.function_ID,
  CalculationUnitProcessTemplateActivities_0.performerGroup,
  CalculationUnitProcessTemplateActivities_0.reviewerGroup,
  CalculationUnitProcessTemplateActivities_0.startDate,
  CalculationUnitProcessTemplateActivities_0.endDate,
  CalculationUnitProcessTemplateActivities_0.url
FROM localized_CalculationUnitProcessTemplateActivities AS CalculationUnitProcessTemplateActivities_0;

CREATE VIEW localized_ModelingService_JoinRulePredicates AS SELECT
  JoinRulePredicates_0.createdAt,
  JoinRulePredicates_0.createdBy,
  JoinRulePredicates_0.modifiedAt,
  JoinRulePredicates_0.modifiedBy,
  JoinRulePredicates_0.environment_ID,
  JoinRulePredicates_0.function_ID,
  JoinRulePredicates_0.ID,
  JoinRulePredicates_0.rule_ID,
  JoinRulePredicates_0.field_ID,
  JoinRulePredicates_0.comparison_code,
  JoinRulePredicates_0.joinRule_ID,
  JoinRulePredicates_0.joinField_ID,
  JoinRulePredicates_0.sequence
FROM localized_JoinRulePredicates AS JoinRulePredicates_0;

CREATE VIEW localized_ModelingService_RuntimePartitionRanges AS SELECT
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

CREATE VIEW localized_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_UnitConversions AS unitConversions_0;

CREATE VIEW localized_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_Partitions AS partitions_0;

CREATE VIEW localized_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_ModelingService_Queries AS SELECT
  queries_0.createdAt,
  queries_0.createdBy,
  queries_0.modifiedAt,
  queries_0.modifiedBy,
  queries_0.environment_ID,
  queries_0.function_ID,
  queries_0.ID,
  queries_0.Editable,
  queries_0.inputFunction_ID
FROM localized_Queries AS queries_0;

CREATE VIEW localized_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_FieldValues AS FieldValues_0;

CREATE VIEW localized_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value
FROM localized_PartitionRanges AS PartitionRanges_0;

CREATE VIEW localized_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID,
  ModelTableFields_0.sourceField
FROM localized_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_ModelingService_CalculationLookupFunctions AS SELECT
  CalculationLookupFunctions_0.createdAt,
  CalculationLookupFunctions_0.createdBy,
  CalculationLookupFunctions_0.modifiedAt,
  CalculationLookupFunctions_0.modifiedBy,
  CalculationLookupFunctions_0.environment_ID,
  CalculationLookupFunctions_0.function_ID,
  CalculationLookupFunctions_0.lookupFunction_ID,
  CalculationLookupFunctions_0.ID,
  CalculationLookupFunctions_0.calculation_ID
FROM localized_CalculationLookupFunctions AS CalculationLookupFunctions_0;

CREATE VIEW localized_ModelingService_CalculationSignatureFields AS SELECT
  CalculationSignatureFields_0.createdAt,
  CalculationSignatureFields_0.createdBy,
  CalculationSignatureFields_0.modifiedAt,
  CalculationSignatureFields_0.modifiedBy,
  CalculationSignatureFields_0.environment_ID,
  CalculationSignatureFields_0.function_ID,
  CalculationSignatureFields_0.field_ID,
  CalculationSignatureFields_0.selection,
  CalculationSignatureFields_0."action",
  CalculationSignatureFields_0.granularity,
  CalculationSignatureFields_0.ID,
  CalculationSignatureFields_0.calculation_ID
FROM localized_CalculationSignatureFields AS CalculationSignatureFields_0;

CREATE VIEW localized_ModelingService_CalculationRules AS SELECT
  CalculationRules_0.createdAt,
  CalculationRules_0.createdBy,
  CalculationRules_0.modifiedAt,
  CalculationRules_0.modifiedBy,
  CalculationRules_0.environment_ID,
  CalculationRules_0.function_ID,
  CalculationRules_0.ID,
  CalculationRules_0.calculation_ID,
  CalculationRules_0.sequence,
  CalculationRules_0.description
FROM localized_CalculationRules AS CalculationRules_0;

CREATE VIEW localized_ModelingService_CalculationChecks AS SELECT
  CalculationChecks_0.createdAt,
  CalculationChecks_0.createdBy,
  CalculationChecks_0.modifiedAt,
  CalculationChecks_0.modifiedBy,
  CalculationChecks_0.environment_ID,
  CalculationChecks_0.function_ID,
  CalculationChecks_0.ID,
  CalculationChecks_0.calculation_ID,
  CalculationChecks_0.check_ID
FROM localized_CalculationChecks AS CalculationChecks_0;

CREATE VIEW localized_ModelingService_DerivationSignatureFields AS SELECT
  DerivationSignatureFields_0.createdAt,
  DerivationSignatureFields_0.createdBy,
  DerivationSignatureFields_0.modifiedAt,
  DerivationSignatureFields_0.modifiedBy,
  DerivationSignatureFields_0.environment_ID,
  DerivationSignatureFields_0.function_ID,
  DerivationSignatureFields_0.field_ID,
  DerivationSignatureFields_0.selection,
  DerivationSignatureFields_0."action",
  DerivationSignatureFields_0.granularity,
  DerivationSignatureFields_0.ID,
  DerivationSignatureFields_0.derivation_ID
FROM localized_DerivationSignatureFields AS DerivationSignatureFields_0;

CREATE VIEW localized_ModelingService_DerivationRules AS SELECT
  DerivationRules_0.createdAt,
  DerivationRules_0.createdBy,
  DerivationRules_0.modifiedAt,
  DerivationRules_0.modifiedBy,
  DerivationRules_0.environment_ID,
  DerivationRules_0.function_ID,
  DerivationRules_0.ID,
  DerivationRules_0.derivation_ID,
  DerivationRules_0.sequence,
  DerivationRules_0.description
FROM localized_DerivationRules AS DerivationRules_0;

CREATE VIEW localized_ModelingService_DerivationChecks AS SELECT
  DerivationChecks_0.createdAt,
  DerivationChecks_0.createdBy,
  DerivationChecks_0.modifiedAt,
  DerivationChecks_0.modifiedBy,
  DerivationChecks_0.environment_ID,
  DerivationChecks_0.function_ID,
  DerivationChecks_0.ID,
  DerivationChecks_0.derivation_ID,
  DerivationChecks_0.check_ID
FROM localized_DerivationChecks AS DerivationChecks_0;

CREATE VIEW localized_ModelingService_JoinSignatureFields AS SELECT
  JoinSignatureFields_0.createdAt,
  JoinSignatureFields_0.createdBy,
  JoinSignatureFields_0.modifiedAt,
  JoinSignatureFields_0.modifiedBy,
  JoinSignatureFields_0.environment_ID,
  JoinSignatureFields_0.function_ID,
  JoinSignatureFields_0.field_ID,
  JoinSignatureFields_0.selection,
  JoinSignatureFields_0."action",
  JoinSignatureFields_0.granularity,
  JoinSignatureFields_0.ID,
  JoinSignatureFields_0.Join_ID
FROM localized_JoinSignatureFields AS JoinSignatureFields_0;

CREATE VIEW localized_ModelingService_JoinChecks AS SELECT
  JoinChecks_0.createdAt,
  JoinChecks_0.createdBy,
  JoinChecks_0.modifiedAt,
  JoinChecks_0.modifiedBy,
  JoinChecks_0.environment_ID,
  JoinChecks_0.function_ID,
  JoinChecks_0.ID,
  JoinChecks_0.Join_ID,
  JoinChecks_0.check_ID
FROM localized_JoinChecks AS JoinChecks_0;

CREATE VIEW localized_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_ModelingService_CalculationRuleConditions AS SELECT
  CalculationRuleConditions_0.createdAt,
  CalculationRuleConditions_0.createdBy,
  CalculationRuleConditions_0.modifiedAt,
  CalculationRuleConditions_0.modifiedBy,
  CalculationRuleConditions_0.environment_ID,
  CalculationRuleConditions_0.function_ID,
  CalculationRuleConditions_0.ID,
  CalculationRuleConditions_0.rule_ID,
  CalculationRuleConditions_0.field_ID
FROM localized_CalculationRuleConditions AS CalculationRuleConditions_0;

CREATE VIEW localized_ModelingService_CalculationRuleActions AS SELECT
  CalculationRuleActions_0.createdAt,
  CalculationRuleActions_0.createdBy,
  CalculationRuleActions_0.modifiedAt,
  CalculationRuleActions_0.modifiedBy,
  CalculationRuleActions_0.environment_ID,
  CalculationRuleActions_0.function_ID,
  CalculationRuleActions_0.formula,
  CalculationRuleActions_0.ID,
  CalculationRuleActions_0.rule_ID,
  CalculationRuleActions_0.field_ID
FROM localized_CalculationRuleActions AS CalculationRuleActions_0;

CREATE VIEW localized_ModelingService_DerivationRuleConditions AS SELECT
  DerivationRuleConditions_0.createdAt,
  DerivationRuleConditions_0.createdBy,
  DerivationRuleConditions_0.modifiedAt,
  DerivationRuleConditions_0.modifiedBy,
  DerivationRuleConditions_0.environment_ID,
  DerivationRuleConditions_0.function_ID,
  DerivationRuleConditions_0.ID,
  DerivationRuleConditions_0.rule_ID,
  DerivationRuleConditions_0.field_ID
FROM localized_DerivationRuleConditions AS DerivationRuleConditions_0;

CREATE VIEW localized_ModelingService_DerivationRuleActions AS SELECT
  DerivationRuleActions_0.createdAt,
  DerivationRuleActions_0.createdBy,
  DerivationRuleActions_0.modifiedAt,
  DerivationRuleActions_0.modifiedBy,
  DerivationRuleActions_0.environment_ID,
  DerivationRuleActions_0.function_ID,
  DerivationRuleActions_0.formula,
  DerivationRuleActions_0.ID,
  DerivationRuleActions_0.rule_ID,
  DerivationRuleActions_0.field_ID
FROM localized_DerivationRuleActions AS DerivationRuleActions_0;

CREATE VIEW localized_ModelingService_CalculationUnitProcessTemplateActivityChecks AS SELECT
  CalculationUnitProcessTemplateActivityChecks_0.createdAt,
  CalculationUnitProcessTemplateActivityChecks_0.createdBy,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedAt,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedBy,
  CalculationUnitProcessTemplateActivityChecks_0.environment_ID,
  CalculationUnitProcessTemplateActivityChecks_0.function_ID,
  CalculationUnitProcessTemplateActivityChecks_0.ID,
  CalculationUnitProcessTemplateActivityChecks_0.activity_ID,
  CalculationUnitProcessTemplateActivityChecks_0.check_ID
FROM localized_CalculationUnitProcessTemplateActivityChecks AS CalculationUnitProcessTemplateActivityChecks_0;

CREATE VIEW localized_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_CheckFields AS CheckFields_0;

CREATE VIEW localized_ModelingService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_ModelingService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_ModelingService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_ModelingService_ApplicationLogStatistics AS SELECT
  ApplicationLogStatistics_0.createdAt,
  ApplicationLogStatistics_0.createdBy,
  ApplicationLogStatistics_0.modifiedAt,
  ApplicationLogStatistics_0.modifiedBy,
  ApplicationLogStatistics_0.ID,
  ApplicationLogStatistics_0.applicationLog_ID,
  ApplicationLogStatistics_0.function,
  ApplicationLogStatistics_0.startTimestamp,
  ApplicationLogStatistics_0.endTimestamp,
  ApplicationLogStatistics_0.inputRecords,
  ApplicationLogStatistics_0.resultRecords,
  ApplicationLogStatistics_0.successRecords,
  ApplicationLogStatistics_0.warningRecords,
  ApplicationLogStatistics_0.errorRecords,
  ApplicationLogStatistics_0.abortRecords,
  ApplicationLogStatistics_0.inputDuration,
  ApplicationLogStatistics_0.processingDuration,
  ApplicationLogStatistics_0.outputDuration
FROM localized_ApplicationLogStatistics AS ApplicationLogStatistics_0;

CREATE VIEW localized_ModelingService_EnvironmentFolders AS SELECT
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

CREATE VIEW localized_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_UnitFields AS UnitFields_0;

CREATE VIEW localized_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_ModelingService_FunctionParentFunctionsVH AS SELECT
  FunctionParentFunctionsVH_0.createdAt,
  FunctionParentFunctionsVH_0.createdBy,
  FunctionParentFunctionsVH_0.modifiedAt,
  FunctionParentFunctionsVH_0.modifiedBy,
  FunctionParentFunctionsVH_0.environment_ID,
  FunctionParentFunctionsVH_0.ID,
  FunctionParentFunctionsVH_0.function,
  FunctionParentFunctionsVH_0.sequence,
  FunctionParentFunctionsVH_0.parent_ID,
  FunctionParentFunctionsVH_0.type_code,
  FunctionParentFunctionsVH_0.description,
  FunctionParentFunctionsVH_0.documentation
FROM localized_FunctionParentFunctionsVH AS FunctionParentFunctionsVH_0;

CREATE VIEW localized_ModelingService_FunctionResultFunctionsVH AS SELECT
  FunctionResultFunctionsVH_0.createdAt,
  FunctionResultFunctionsVH_0.createdBy,
  FunctionResultFunctionsVH_0.modifiedAt,
  FunctionResultFunctionsVH_0.modifiedBy,
  FunctionResultFunctionsVH_0.environment_ID,
  FunctionResultFunctionsVH_0.ID,
  FunctionResultFunctionsVH_0.function,
  FunctionResultFunctionsVH_0.sequence,
  FunctionResultFunctionsVH_0.parent_ID,
  FunctionResultFunctionsVH_0.type_code,
  FunctionResultFunctionsVH_0.description,
  FunctionResultFunctionsVH_0.documentation
FROM localized_FunctionResultFunctionsVH AS FunctionResultFunctionsVH_0;

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

CREATE VIEW localized_de_AllocationTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTypes AS L_0 LEFT JOIN AllocationTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationValueAdjustments AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationValueAdjustments AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationValueAdjustments AS L_0 LEFT JOIN AllocationValueAdjustments_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationTermProcessings AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationTermProcessings AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationTermProcessings AS L_0 LEFT JOIN AllocationTermProcessings_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationCycleAggregations AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationCycleAggregations AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationCycleAggregations AS L_0 LEFT JOIN AllocationCycleAggregations_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleTypes AS L_0 LEFT JOIN AllocationRuleTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleMethods AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleMethods AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleMethods AS L_0 LEFT JOIN AllocationRuleMethods_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationSenderRules AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationSenderRules AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationSenderRules AS L_0 LEFT JOIN AllocationSenderRules_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationReceiverRules AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationReceiverRules AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationReceiverRules AS L_0 LEFT JOIN AllocationReceiverRules_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_AllocationRuleScales AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_AllocationRuleScales AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (AllocationRuleScales AS L_0 LEFT JOIN AllocationRuleScales_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

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

CREATE VIEW localized_de_DerivationTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (DerivationTypes AS L_0 LEFT JOIN DerivationTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_DerivationTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (DerivationTypes AS L_0 LEFT JOIN DerivationTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_ModelTableTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_ModelTableTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (ModelTableTypes AS L_0 LEFT JOIN ModelTableTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CalculationUnitProcessTemplateTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CalculationUnitProcessTemplateTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CalculationUnitProcessTemplateStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CalculationUnitProcessTemplateStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CalculationUnitProcessTemplateActivityTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CalculationUnitProcessTemplateActivityTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityTypes AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_CalculationUnitProcessTemplateActivityStates AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityStates_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_CalculationUnitProcessTemplateActivityStates AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (CalculationUnitProcessTemplateActivityStates AS L_0 LEFT JOIN CalculationUnitProcessTemplateActivityStates_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_JoinTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinTypes AS L_0 LEFT JOIN JoinTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_JoinTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinTypes AS L_0 LEFT JOIN JoinTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_JoinRuleTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleTypes AS L_0 LEFT JOIN JoinRuleTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_JoinRuleTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleTypes AS L_0 LEFT JOIN JoinRuleTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_JoinRuleJoinTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleJoinTypes AS L_0 LEFT JOIN JoinRuleJoinTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_JoinRuleJoinTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRuleJoinTypes AS L_0 LEFT JOIN JoinRuleJoinTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_JoinRulePredicateComparisons AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRulePredicateComparisons AS L_0 LEFT JOIN JoinRulePredicateComparisons_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_JoinRulePredicateComparisons AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (JoinRulePredicateComparisons AS L_0 LEFT JOIN JoinRulePredicateComparisons_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldTypes AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTypes AS L_0 LEFT JOIN QueryFieldTypes_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldTypes AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTypes AS L_0 LEFT JOIN QueryFieldTypes_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldLayouts AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldLayouts AS L_0 LEFT JOIN QueryFieldLayouts_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldLayouts AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldLayouts AS L_0 LEFT JOIN QueryFieldLayouts_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldVariableRepresentations AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldVariableRepresentations AS L_0 LEFT JOIN QueryFieldVariableRepresentations_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldVariableRepresentations AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldVariableRepresentations AS L_0 LEFT JOIN QueryFieldVariableRepresentations_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldHidings AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldHidings AS L_0 LEFT JOIN QueryFieldHidings_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldHidings AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldHidings AS L_0 LEFT JOIN QueryFieldHidings_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldDisplays AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDisplays AS L_0 LEFT JOIN QueryFieldDisplays_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldDisplays AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDisplays AS L_0 LEFT JOIN QueryFieldDisplays_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldScalingFactors AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldScalingFactors AS L_0 LEFT JOIN QueryFieldScalingFactors_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldScalingFactors AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldScalingFactors AS L_0 LEFT JOIN QueryFieldScalingFactors_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldDecimalPlaces AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDecimalPlaces AS L_0 LEFT JOIN QueryFieldDecimalPlaces_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldDecimalPlaces AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldDecimalPlaces AS L_0 LEFT JOIN QueryFieldDecimalPlaces_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldResultRows AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldResultRows AS L_0 LEFT JOIN QueryFieldResultRows_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldResultRows AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldResultRows AS L_0 LEFT JOIN QueryFieldResultRows_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldTags AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTags AS L_0 LEFT JOIN QueryFieldTags_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldTags AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldTags AS L_0 LEFT JOIN QueryFieldTags_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

CREATE VIEW localized_de_QueryFieldAggregations AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldAggregations AS L_0 LEFT JOIN QueryFieldAggregations_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_QueryFieldAggregations AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM (QueryFieldAggregations AS L_0 LEFT JOIN QueryFieldAggregations_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

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

CREATE VIEW localized_de_Groups AS SELECT
  coalesce(localized_de_1.name, L_0.name) AS name,
  coalesce(localized_de_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_de_1 ON localized_de_1.code = L_0.code AND localized_de_1.locale = 'de');

CREATE VIEW localized_fr_Groups AS SELECT
  coalesce(localized_fr_1.name, L_0.name) AS name,
  coalesce(localized_fr_1.descr, L_0.descr) AS descr,
  L_0.code
FROM ("Groups" AS L_0 LEFT JOIN Groups_texts AS localized_fr_1 ON localized_fr_1.code = L_0.code AND localized_fr_1.locale = 'fr');

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
  L.seq,
  L.sign_code,
  L.opt_code,
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
  L.seq,
  L.sign_code,
  L.opt_code,
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

CREATE VIEW localized_de_Allocations AS SELECT
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
  L.valueAdjustment_code,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.receiverFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_fr_Allocations AS SELECT
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
  L.valueAdjustment_code,
  L.cycleFlag,
  L.cycleMaximum,
  L.cycleIterationField_ID,
  L.cycleAggregation_code,
  L.termFlag,
  L.termIterationField_ID,
  L.termYearField_ID,
  L.termField_ID,
  L.termProcessing_code,
  L.termYear,
  L.termMinimum,
  L.termMaximum,
  L.receiverFunction_ID,
  L.earlyExitCheck_ID
FROM Allocations AS L;

CREATE VIEW localized_de_AllocationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationInputFields AS L;

CREATE VIEW localized_fr_AllocationInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationInputFields AS L;

CREATE VIEW localized_de_AllocationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationInputFieldSelections AS L;

CREATE VIEW localized_fr_AllocationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationInputFieldSelections AS L;

CREATE VIEW localized_de_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_fr_AllocationReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverViews AS L;

CREATE VIEW localized_de_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_fr_AllocationReceiverViewSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationReceiverViewSelections AS L;

CREATE VIEW localized_de_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_fr_AllocationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.sequence,
  L.rule,
  L.description,
  L.isActive,
  L.type_code,
  L.senderRule_code,
  L.senderShare,
  L.method_code,
  L.distributionBase,
  L.parentRule_ID,
  L.receiverRule_code,
  L.scale_code,
  L.driverResultField_ID
FROM AllocationRules AS L;

CREATE VIEW localized_de_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_fr_AllocationRuleSenderViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderViews AS L;

CREATE VIEW localized_de_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_fr_AllocationRuleSenderFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleSenderFieldSelections AS L;

CREATE VIEW localized_de_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_fr_AllocationRuleReceiverViews AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.group_code,
  L.order_code,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleReceiverViews AS L;

CREATE VIEW localized_de_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

CREATE VIEW localized_fr_AllocationRuleReceiverFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.field_ID
FROM AllocationRuleReceiverFieldSelections AS L;

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
  L.seq,
  L.sign_code,
  L.opt_code,
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
  L.seq,
  L.sign_code,
  L.opt_code,
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
  L.seq,
  L.sign_code,
  L.opt_code,
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
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM CalculationRuleConditionSelections AS L;

CREATE VIEW localized_de_Derivations AS SELECT
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
  L.suppressInitialResults,
  L.ensureDistinctResults
FROM Derivations AS L;

CREATE VIEW localized_fr_Derivations AS SELECT
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
  L.suppressInitialResults,
  L.ensureDistinctResults
FROM Derivations AS L;

CREATE VIEW localized_de_DerivationInputFields AS SELECT
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
  L.derivation_ID
FROM DerivationInputFields AS L;

CREATE VIEW localized_fr_DerivationInputFields AS SELECT
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
  L.derivation_ID
FROM DerivationInputFields AS L;

CREATE VIEW localized_de_DerivationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM DerivationInputFieldSelections AS L;

CREATE VIEW localized_fr_DerivationInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM DerivationInputFieldSelections AS L;

CREATE VIEW localized_de_DerivationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM DerivationRuleConditionSelections AS L;

CREATE VIEW localized_fr_DerivationRuleConditionSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.condition_ID
FROM DerivationRuleConditionSelections AS L;

CREATE VIEW localized_de_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connection
FROM ModelTables AS L;

CREATE VIEW localized_fr_ModelTables AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.type_code,
  L.transportData,
  L.connection
FROM ModelTables AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.CalculationUnit_ID,
  L.process,
  L.sequence,
  L.type_code,
  L.state_code,
  L.description
FROM CalculationUnitProcessTemplates AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.CalculationUnit_ID,
  L.process,
  L.sequence,
  L.type_code,
  L.state_code,
  L.description
FROM CalculationUnitProcessTemplates AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplateActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.performerGroup,
  L.reviewerGroup,
  L.startDate,
  L.endDate,
  L.url
FROM CalculationUnitProcessTemplateActivities AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplateActivities AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.ID,
  L.process_ID,
  L.activity,
  L.parent_ID,
  L.sequence,
  L.activityType_code,
  L.activityState_code,
  L.function_ID,
  L.performerGroup,
  L.reviewerGroup,
  L.startDate,
  L.endDate,
  L.url
FROM CalculationUnitProcessTemplateActivities AS L;

CREATE VIEW localized_de_Joins AS SELECT
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
  L.type_code
FROM Joins AS L;

CREATE VIEW localized_fr_Joins AS SELECT
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
  L.type_code
FROM Joins AS L;

CREATE VIEW localized_de_JoinInputFields AS SELECT
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
  L.Join_ID
FROM JoinInputFields AS L;

CREATE VIEW localized_fr_JoinInputFields AS SELECT
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
  L.Join_ID
FROM JoinInputFields AS L;

CREATE VIEW localized_de_JoinInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinInputFieldSelections AS L;

CREATE VIEW localized_fr_JoinInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinInputFieldSelections AS L;

CREATE VIEW localized_de_JoinRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.parent_ID,
  L.type_code,
  L.inputFunction_ID,
  L.joinType_code,
  L.complexPredicates,
  L.sequence,
  L.description
FROM JoinRules AS L;

CREATE VIEW localized_fr_JoinRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.parent_ID,
  L.type_code,
  L.inputFunction_ID,
  L.joinType_code,
  L.complexPredicates,
  L.sequence,
  L.description
FROM JoinRules AS L;

CREATE VIEW localized_de_JoinRuleInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.field_ID,
  L.ID,
  L.rule_ID
FROM JoinRuleInputFields AS L;

CREATE VIEW localized_fr_JoinRuleInputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.formula,
  L.order_code,
  L.field_ID,
  L.ID,
  L.rule_ID
FROM JoinRuleInputFields AS L;

CREATE VIEW localized_de_JoinRuleInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinRuleInputFieldSelections AS L;

CREATE VIEW localized_fr_JoinRuleInputFieldSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.inputField_ID
FROM JoinRuleInputFieldSelections AS L;

CREATE VIEW localized_de_JoinRulePredicates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID,
  L.comparison_code,
  L.joinRule_ID,
  L.joinField_ID,
  L.sequence
FROM JoinRulePredicates AS L;

CREATE VIEW localized_fr_JoinRulePredicates AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID,
  L.comparison_code,
  L.joinRule_ID,
  L.joinField_ID,
  L.sequence
FROM JoinRulePredicates AS L;

CREATE VIEW localized_de_QueryComponents AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.query_ID,
  L.component,
  L.type_code,
  L.layout_code,
  L.tag_code,
  L.editable,
  L.field_ID,
  L.hierarchy_ID,
  L.display_code,
  L.resultRow_code,
  L.variableRepresentation_code,
  L.variableMandatory,
  L.variableDefaultValue,
  L.aggregation_code,
  L.hiding_code,
  L.decimalPlaces_code,
  L.scalingFactor_code,
  L.changeSign,
  L.formula,
  L.keyfigure_ID
FROM QueryComponents AS L;

CREATE VIEW localized_fr_QueryComponents AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.query_ID,
  L.component,
  L.type_code,
  L.layout_code,
  L.tag_code,
  L.editable,
  L.field_ID,
  L.hierarchy_ID,
  L.display_code,
  L.resultRow_code,
  L.variableRepresentation_code,
  L.variableMandatory,
  L.variableDefaultValue,
  L.aggregation_code,
  L.hiding_code,
  L.decimalPlaces_code,
  L.scalingFactor_code,
  L.changeSign,
  L.formula,
  L.keyfigure_ID
FROM QueryComponents AS L;

CREATE VIEW localized_de_QueryComponentFixSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentFixSelections AS L;

CREATE VIEW localized_fr_QueryComponentFixSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentFixSelections AS L;

CREATE VIEW localized_de_QueryComponentSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentSelections AS L;

CREATE VIEW localized_fr_QueryComponentSelections AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.seq,
  L.sign_code,
  L.opt_code,
  L.low,
  L.high,
  L.ID,
  L.component_ID
FROM QueryComponentSelections AS L;

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

CREATE VIEW localized_de_ApplicationChecks AS SELECT
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
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationChecks AS L;

CREATE VIEW localized_fr_ApplicationChecks AS SELECT
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
  L."check",
  L.type_code,
  L.message,
  L.statement
FROM ApplicationChecks AS L;

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

CREATE VIEW localized_de_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_fr_AllocationOffsets AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.offsetField_ID
FROM AllocationOffsets AS L;

CREATE VIEW localized_de_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_fr_AllocationDebitCredits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID,
  L.debitSign,
  L.creditSign,
  L.sequence
FROM AllocationDebitCredits AS L;

CREATE VIEW localized_de_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_fr_AllocationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.check_ID
FROM AllocationChecks AS L;

CREATE VIEW localized_de_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_fr_AllocationSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationSelectionFields AS L;

CREATE VIEW localized_de_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_fr_AllocationActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationActionFields AS L;

CREATE VIEW localized_de_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_fr_AllocationReceiverSelectionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverSelectionFields AS L;

CREATE VIEW localized_de_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_fr_AllocationReceiverActionFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.allocation_ID,
  L.field_ID
FROM AllocationReceiverActionFields AS L;

CREATE VIEW localized_de_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

CREATE VIEW localized_fr_AllocationRuleSenderValueFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM AllocationRuleSenderValueFields AS L;

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

CREATE VIEW localized_de_DerivationSignatureFields AS SELECT
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
  L.derivation_ID
FROM DerivationSignatureFields AS L;

CREATE VIEW localized_fr_DerivationSignatureFields AS SELECT
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
  L.derivation_ID
FROM DerivationSignatureFields AS L;

CREATE VIEW localized_de_DerivationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.sequence,
  L.description
FROM DerivationRules AS L;

CREATE VIEW localized_fr_DerivationRules AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.sequence,
  L.description
FROM DerivationRules AS L;

CREATE VIEW localized_de_DerivationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM DerivationRuleConditions AS L;

CREATE VIEW localized_fr_DerivationRuleConditions AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.rule_ID,
  L.field_ID
FROM DerivationRuleConditions AS L;

CREATE VIEW localized_de_DerivationRuleActions AS SELECT
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
FROM DerivationRuleActions AS L;

CREATE VIEW localized_fr_DerivationRuleActions AS SELECT
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
FROM DerivationRuleActions AS L;

CREATE VIEW localized_de_DerivationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.check_ID
FROM DerivationChecks AS L;

CREATE VIEW localized_fr_DerivationChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.derivation_ID,
  L.check_ID
FROM DerivationChecks AS L;

CREATE VIEW localized_de_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID,
  L.sourceField
FROM ModelTableFields AS L;

CREATE VIEW localized_fr_ModelTableFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.field_ID,
  L.ID,
  L.modelTable_ID,
  L.sourceField
FROM ModelTableFields AS L;

CREATE VIEW localized_de_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_fr_CalculationUnits AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID
FROM CalculationUnits AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplateActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CalculationUnitProcessTemplateActivityLinks AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplateActivityLinks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.activity_ID,
  L.previousActivity_ID
FROM CalculationUnitProcessTemplateActivityLinks AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplateActivityChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.activity_ID,
  L.check_ID
FROM CalculationUnitProcessTemplateActivityChecks AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplateActivityChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.activity_ID,
  L.check_ID
FROM CalculationUnitProcessTemplateActivityChecks AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplateReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CalculationUnitProcessTemplateReports AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplateReports AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.process_ID,
  L.report,
  L.sequence,
  L.description,
  L.content,
  L.calculationCode
FROM CalculationUnitProcessTemplateReports AS L;

CREATE VIEW localized_de_CalculationUnitProcessTemplateReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CalculationUnitProcessTemplateReportElements AS L;

CREATE VIEW localized_fr_CalculationUnitProcessTemplateReportElements AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.report_ID,
  L.element,
  L.description,
  L.content
FROM CalculationUnitProcessTemplateReportElements AS L;

CREATE VIEW localized_de_JoinSignatureFields AS SELECT
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
  L.Join_ID
FROM JoinSignatureFields AS L;

CREATE VIEW localized_fr_JoinSignatureFields AS SELECT
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
  L.Join_ID
FROM JoinSignatureFields AS L;

CREATE VIEW localized_de_JoinChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.check_ID
FROM JoinChecks AS L;

CREATE VIEW localized_fr_JoinChecks AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Join_ID,
  L.check_ID
FROM JoinChecks AS L;

CREATE VIEW localized_de_Queries AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Editable,
  L.inputFunction_ID
FROM Queries AS L;

CREATE VIEW localized_fr_Queries AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.environment_ID,
  L.function_ID,
  L.ID,
  L.Editable,
  L.inputFunction_ID
FROM Queries AS L;

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
  L.function_ID,
  L.field_ID
FROM RuntimeOutputFields AS L;

CREATE VIEW localized_fr_RuntimeOutputFields AS SELECT
  L.createdAt,
  L.createdBy,
  L.modifiedAt,
  L.modifiedBy,
  L.ID,
  L.function_ID,
  L.field_ID
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

CREATE VIEW localized_de_OffsetAllocation AS SELECT
  Allocations_0.environment_ID,
  Allocations_0.function_ID,
  Allocations_0.ID,
  Allocations_0.type_code,
  Allocations_0.valueAdjustment_code,
  Allocations_0.includeInputData,
  Allocations_0.resultHandling_code,
  Allocations_0.includeInitialResult,
  Allocations_0.inputFunction_ID,
  Allocations_0.receiverFunction_ID,
  Allocations_0.resultFunction_ID
FROM localized_de_Allocations AS Allocations_0;

CREATE VIEW localized_fr_OffsetAllocation AS SELECT
  Allocations_0.environment_ID,
  Allocations_0.function_ID,
  Allocations_0.ID,
  Allocations_0.type_code,
  Allocations_0.valueAdjustment_code,
  Allocations_0.includeInputData,
  Allocations_0.resultHandling_code,
  Allocations_0.includeInitialResult,
  Allocations_0.inputFunction_ID,
  Allocations_0.receiverFunction_ID,
  Allocations_0.resultFunction_ID
FROM localized_fr_Allocations AS Allocations_0;

CREATE VIEW localized_de_AllocationTermIterationFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_fr_AllocationTermIterationFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'KYF';

CREATE VIEW localized_de_AllocationTermYearFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_fr_AllocationTermYearFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_de_AllocationTermFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_fr_AllocationTermFields AS SELECT
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
WHERE Fields_0.class_code = '' AND Fields_0.type_code = 'CHA' AND Fields_0.dataLength >= 4;

CREATE VIEW localized_de_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_de_Checks AS Checks_0;

CREATE VIEW localized_fr_AllocationEarlyExitChecks AS SELECT
  Checks_0.createdAt,
  Checks_0.createdBy,
  Checks_0.modifiedAt,
  Checks_0.modifiedBy,
  Checks_0.environment_ID,
  Checks_0.ID,
  Checks_0."check",
  Checks_0.messageType_code,
  Checks_0.category_code,
  Checks_0.description
FROM localized_fr_Checks AS Checks_0;

CREATE VIEW localized_de_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_de_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_de_AllocationActionFields AS L_1 LEFT JOIN localized_de_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_de_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_fr_AllocationRuleDriverResultFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_fr_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_fr_AllocationActionFields AS L_1 LEFT JOIN localized_fr_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_fr_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_de_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_de_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_de_AllocationActionFields AS L_1 LEFT JOIN localized_de_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_de_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_fr_AllocationCycleIterationFields AS SELECT
  F_0.createdAt,
  F_0.createdBy,
  F_0.modifiedAt,
  F_0.modifiedBy,
  F_0.environment_ID,
  F_0.ID,
  F_0.field,
  F_0.class_code,
  F_0.type_code,
  F_0.hanaDataType_code,
  F_0.dataLength,
  F_0.dataDecimals,
  F_0.unitField_ID,
  F_0.isLowercase,
  F_0.hasMasterData,
  F_0.hasHierarchies,
  F_0.calculationHierarchy_ID,
  F_0.masterDataQuery_ID,
  F_0.description,
  F_0.documentation
FROM localized_fr_Fields AS F_0
WHERE F_0.class_code = '' AND F_0.type_code = 'KYF' AND F_0.ID IN (SELECT
    L_1.field_ID AS ID
  FROM ((localized_fr_AllocationActionFields AS L_1 LEFT JOIN localized_fr_Allocations AS allocation_2 ON L_1.allocation_ID = allocation_2.ID) LEFT JOIN localized_fr_Functions AS function_3 ON allocation_2.function_ID = function_3.ID)
  WHERE F_0.environment_ID = function_3.environment_ID);

CREATE VIEW localized_de_modelJoins AS SELECT
  Joins_0.createdAt,
  Joins_0.createdBy,
  Joins_0.modifiedAt,
  Joins_0.modifiedBy,
  Joins_0.environment_ID,
  Joins_0.function_ID,
  Joins_0.ID,
  Joins_0.type_code
FROM localized_de_Joins AS Joins_0;

CREATE VIEW localized_fr_modelJoins AS SELECT
  Joins_0.createdAt,
  Joins_0.createdBy,
  Joins_0.modifiedAt,
  Joins_0.modifiedBy,
  Joins_0.environment_ID,
  Joins_0.function_ID,
  Joins_0.ID,
  Joins_0.type_code
FROM localized_fr_Joins AS Joins_0;

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

CREATE VIEW localized_de_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_de_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_fr_ModelingService_EnvironmentTypes AS SELECT
  EnvironmentTypes_0.name,
  EnvironmentTypes_0.descr,
  EnvironmentTypes_0.code
FROM localized_fr_EnvironmentTypes AS EnvironmentTypes_0;

CREATE VIEW localized_de_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_de_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_fr_ModelingService_FieldClasses AS SELECT
  FieldClasses_0.name,
  FieldClasses_0.descr,
  FieldClasses_0.code
FROM localized_fr_FieldClasses AS FieldClasses_0;

CREATE VIEW localized_de_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_de_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_fr_ModelingService_FieldTypes AS SELECT
  FieldTypes_0.name,
  FieldTypes_0.descr,
  FieldTypes_0.code
FROM localized_fr_FieldTypes AS FieldTypes_0;

CREATE VIEW localized_de_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_de_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_fr_ModelingService_HanaDataTypes AS SELECT
  HanaDataTypes_0.name,
  HanaDataTypes_0.descr,
  HanaDataTypes_0.code
FROM localized_fr_HanaDataTypes AS HanaDataTypes_0;

CREATE VIEW localized_de_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_de_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_fr_ModelingService_MessageTypes AS SELECT
  MessageTypes_0.name,
  MessageTypes_0.descr,
  MessageTypes_0.code
FROM localized_fr_MessageTypes AS MessageTypes_0;

CREATE VIEW localized_de_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_de_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_fr_ModelingService_CheckCategories AS SELECT
  CheckCategories_0.name,
  CheckCategories_0.descr,
  CheckCategories_0.code
FROM localized_fr_CheckCategories AS CheckCategories_0;

CREATE VIEW localized_de_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_de_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionTypes AS SELECT
  FunctionTypes_0.name,
  FunctionTypes_0.descr,
  FunctionTypes_0.code
FROM localized_fr_FunctionTypes AS FunctionTypes_0;

CREATE VIEW localized_de_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_de_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_fr_ModelingService_ResultHandlings AS SELECT
  ResultHandlings_0.name,
  ResultHandlings_0.descr,
  ResultHandlings_0.code
FROM localized_fr_ResultHandlings AS ResultHandlings_0;

CREATE VIEW localized_de_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_de_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionProcessingTypes AS SELECT
  FunctionProcessingTypes_0.name,
  FunctionProcessingTypes_0.descr,
  FunctionProcessingTypes_0.code
FROM localized_fr_FunctionProcessingTypes AS FunctionProcessingTypes_0;

CREATE VIEW localized_de_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_de_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_fr_ModelingService_FunctionBusinessEventTypes AS SELECT
  FunctionBusinessEventTypes_0.name,
  FunctionBusinessEventTypes_0.descr,
  FunctionBusinessEventTypes_0.code
FROM localized_fr_FunctionBusinessEventTypes AS FunctionBusinessEventTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_de_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_fr_ModelingService_AllocationTypes AS SELECT
  AllocationTypes_0.name,
  AllocationTypes_0.descr,
  AllocationTypes_0.code
FROM localized_fr_AllocationTypes AS AllocationTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_de_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_fr_ModelingService_AllocationValueAdjustments AS SELECT
  AllocationValueAdjustments_0.name,
  AllocationValueAdjustments_0.descr,
  AllocationValueAdjustments_0.code
FROM localized_fr_AllocationValueAdjustments AS AllocationValueAdjustments_0;

CREATE VIEW localized_de_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_de_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_fr_ModelingService_AllocationCycleAggregations AS SELECT
  AllocationCycleAggregations_0.name,
  AllocationCycleAggregations_0.descr,
  AllocationCycleAggregations_0.code
FROM localized_fr_AllocationCycleAggregations AS AllocationCycleAggregations_0;

CREATE VIEW localized_de_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_de_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermProcessings AS SELECT
  AllocationTermProcessings_0.name,
  AllocationTermProcessings_0.descr,
  AllocationTermProcessings_0.code
FROM localized_fr_AllocationTermProcessings AS AllocationTermProcessings_0;

CREATE VIEW localized_de_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_de_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_fr_ModelingService_ModelTableTypes AS SELECT
  ModelTableTypes_0.name,
  ModelTableTypes_0.descr,
  ModelTableTypes_0.code
FROM localized_fr_ModelTableTypes AS ModelTableTypes_0;

CREATE VIEW localized_de_ModelingService_CalculationTypes AS SELECT
  CalculationTypes_0.name,
  CalculationTypes_0.descr,
  CalculationTypes_0.code
FROM localized_de_CalculationTypes AS CalculationTypes_0;

CREATE VIEW localized_fr_ModelingService_CalculationTypes AS SELECT
  CalculationTypes_0.name,
  CalculationTypes_0.descr,
  CalculationTypes_0.code
FROM localized_fr_CalculationTypes AS CalculationTypes_0;

CREATE VIEW localized_de_ModelingService_DerivationTypes AS SELECT
  DerivationTypes_0.name,
  DerivationTypes_0.descr,
  DerivationTypes_0.code
FROM localized_de_DerivationTypes AS DerivationTypes_0;

CREATE VIEW localized_fr_ModelingService_DerivationTypes AS SELECT
  DerivationTypes_0.name,
  DerivationTypes_0.descr,
  DerivationTypes_0.code
FROM localized_fr_DerivationTypes AS DerivationTypes_0;

CREATE VIEW localized_de_ModelingService_JoinTypes AS SELECT
  JoinTypes_0.name,
  JoinTypes_0.descr,
  JoinTypes_0.code
FROM localized_de_JoinTypes AS JoinTypes_0;

CREATE VIEW localized_fr_ModelingService_JoinTypes AS SELECT
  JoinTypes_0.name,
  JoinTypes_0.descr,
  JoinTypes_0.code
FROM localized_fr_JoinTypes AS JoinTypes_0;

CREATE VIEW localized_de_ModelingService_ApplicationLogStates AS SELECT
  ApplicationLogStates_0.name,
  ApplicationLogStates_0.descr,
  ApplicationLogStates_0.code
FROM localized_de_ApplicationLogStates AS ApplicationLogStates_0;

CREATE VIEW localized_fr_ModelingService_ApplicationLogStates AS SELECT
  ApplicationLogStates_0.name,
  ApplicationLogStates_0.descr,
  ApplicationLogStates_0.code
FROM localized_fr_ApplicationLogStates AS ApplicationLogStates_0;

CREATE VIEW localized_de_ModelingService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_de_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_fr_ModelingService_RuntimeFunctionStates AS SELECT
  RuntimeFunctionStates_0.name,
  RuntimeFunctionStates_0.descr,
  RuntimeFunctionStates_0.code
FROM localized_fr_RuntimeFunctionStates AS RuntimeFunctionStates_0;

CREATE VIEW localized_de_ModelingService_ConnectionSources AS SELECT
  ConnectionSources_0.name,
  ConnectionSources_0.descr,
  ConnectionSources_0.code
FROM localized_de_ConnectionSources AS ConnectionSources_0;

CREATE VIEW localized_fr_ModelingService_ConnectionSources AS SELECT
  ConnectionSources_0.name,
  ConnectionSources_0.descr,
  ConnectionSources_0.code
FROM localized_fr_ConnectionSources AS ConnectionSources_0;

CREATE VIEW localized_de_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_de_Orders AS Orders_0;

CREATE VIEW localized_fr_ModelingService_Orders AS SELECT
  Orders_0.name,
  Orders_0.descr,
  Orders_0.code
FROM localized_fr_Orders AS Orders_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_de_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleTypes AS SELECT
  AllocationRuleTypes_0.name,
  AllocationRuleTypes_0.descr,
  AllocationRuleTypes_0.code
FROM localized_fr_AllocationRuleTypes AS AllocationRuleTypes_0;

CREATE VIEW localized_de_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_de_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationSenderRules AS SELECT
  AllocationSenderRules_0.name,
  AllocationSenderRules_0.descr,
  AllocationSenderRules_0.code
FROM localized_fr_AllocationSenderRules AS AllocationSenderRules_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_de_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleMethods AS SELECT
  AllocationRuleMethods_0.name,
  AllocationRuleMethods_0.descr,
  AllocationRuleMethods_0.code
FROM localized_fr_AllocationRuleMethods AS AllocationRuleMethods_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_de_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverRules AS SELECT
  AllocationReceiverRules_0.name,
  AllocationReceiverRules_0.descr,
  AllocationReceiverRules_0.code
FROM localized_fr_AllocationReceiverRules AS AllocationReceiverRules_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_de_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleScales AS SELECT
  AllocationRuleScales_0.name,
  AllocationRuleScales_0.descr,
  AllocationRuleScales_0.code
FROM localized_fr_AllocationRuleScales AS AllocationRuleScales_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateTypes AS SELECT
  CalculationUnitProcessTemplateTypes_0.name,
  CalculationUnitProcessTemplateTypes_0.descr,
  CalculationUnitProcessTemplateTypes_0.code
FROM localized_de_CalculationUnitProcessTemplateTypes AS CalculationUnitProcessTemplateTypes_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateTypes AS SELECT
  CalculationUnitProcessTemplateTypes_0.name,
  CalculationUnitProcessTemplateTypes_0.descr,
  CalculationUnitProcessTemplateTypes_0.code
FROM localized_fr_CalculationUnitProcessTemplateTypes AS CalculationUnitProcessTemplateTypes_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateStates AS SELECT
  CalculationUnitProcessTemplateStates_0.name,
  CalculationUnitProcessTemplateStates_0.descr,
  CalculationUnitProcessTemplateStates_0.code
FROM localized_de_CalculationUnitProcessTemplateStates AS CalculationUnitProcessTemplateStates_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateStates AS SELECT
  CalculationUnitProcessTemplateStates_0.name,
  CalculationUnitProcessTemplateStates_0.descr,
  CalculationUnitProcessTemplateStates_0.code
FROM localized_fr_CalculationUnitProcessTemplateStates AS CalculationUnitProcessTemplateStates_0;

CREATE VIEW localized_de_ModelingService_JoinRuleTypes AS SELECT
  JoinRuleTypes_0.name,
  JoinRuleTypes_0.descr,
  JoinRuleTypes_0.code
FROM localized_de_JoinRuleTypes AS JoinRuleTypes_0;

CREATE VIEW localized_fr_ModelingService_JoinRuleTypes AS SELECT
  JoinRuleTypes_0.name,
  JoinRuleTypes_0.descr,
  JoinRuleTypes_0.code
FROM localized_fr_JoinRuleTypes AS JoinRuleTypes_0;

CREATE VIEW localized_de_ModelingService_JoinRuleJoinTypes AS SELECT
  JoinRuleJoinTypes_0.name,
  JoinRuleJoinTypes_0.descr,
  JoinRuleJoinTypes_0.code
FROM localized_de_JoinRuleJoinTypes AS JoinRuleJoinTypes_0;

CREATE VIEW localized_fr_ModelingService_JoinRuleJoinTypes AS SELECT
  JoinRuleJoinTypes_0.name,
  JoinRuleJoinTypes_0.descr,
  JoinRuleJoinTypes_0.code
FROM localized_fr_JoinRuleJoinTypes AS JoinRuleJoinTypes_0;

CREATE VIEW localized_de_ModelingService_QueryFieldTypes AS SELECT
  QueryFieldTypes_0.name,
  QueryFieldTypes_0.descr,
  QueryFieldTypes_0.code
FROM localized_de_QueryFieldTypes AS QueryFieldTypes_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldTypes AS SELECT
  QueryFieldTypes_0.name,
  QueryFieldTypes_0.descr,
  QueryFieldTypes_0.code
FROM localized_fr_QueryFieldTypes AS QueryFieldTypes_0;

CREATE VIEW localized_de_ModelingService_QueryFieldLayouts AS SELECT
  QueryFieldLayouts_0.name,
  QueryFieldLayouts_0.descr,
  QueryFieldLayouts_0.code
FROM localized_de_QueryFieldLayouts AS QueryFieldLayouts_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldLayouts AS SELECT
  QueryFieldLayouts_0.name,
  QueryFieldLayouts_0.descr,
  QueryFieldLayouts_0.code
FROM localized_fr_QueryFieldLayouts AS QueryFieldLayouts_0;

CREATE VIEW localized_de_ModelingService_QueryFieldTags AS SELECT
  QueryFieldTags_0.name,
  QueryFieldTags_0.descr,
  QueryFieldTags_0.code
FROM localized_de_QueryFieldTags AS QueryFieldTags_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldTags AS SELECT
  QueryFieldTags_0.name,
  QueryFieldTags_0.descr,
  QueryFieldTags_0.code
FROM localized_fr_QueryFieldTags AS QueryFieldTags_0;

CREATE VIEW localized_de_ModelingService_QueryFieldDisplays AS SELECT
  QueryFieldDisplays_0.name,
  QueryFieldDisplays_0.descr,
  QueryFieldDisplays_0.code
FROM localized_de_QueryFieldDisplays AS QueryFieldDisplays_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldDisplays AS SELECT
  QueryFieldDisplays_0.name,
  QueryFieldDisplays_0.descr,
  QueryFieldDisplays_0.code
FROM localized_fr_QueryFieldDisplays AS QueryFieldDisplays_0;

CREATE VIEW localized_de_ModelingService_QueryFieldResultRows AS SELECT
  QueryFieldResultRows_0.name,
  QueryFieldResultRows_0.descr,
  QueryFieldResultRows_0.code
FROM localized_de_QueryFieldResultRows AS QueryFieldResultRows_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldResultRows AS SELECT
  QueryFieldResultRows_0.name,
  QueryFieldResultRows_0.descr,
  QueryFieldResultRows_0.code
FROM localized_fr_QueryFieldResultRows AS QueryFieldResultRows_0;

CREATE VIEW localized_de_ModelingService_QueryFieldVariableRepresentations AS SELECT
  QueryFieldVariableRepresentations_0.name,
  QueryFieldVariableRepresentations_0.descr,
  QueryFieldVariableRepresentations_0.code
FROM localized_de_QueryFieldVariableRepresentations AS QueryFieldVariableRepresentations_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldVariableRepresentations AS SELECT
  QueryFieldVariableRepresentations_0.name,
  QueryFieldVariableRepresentations_0.descr,
  QueryFieldVariableRepresentations_0.code
FROM localized_fr_QueryFieldVariableRepresentations AS QueryFieldVariableRepresentations_0;

CREATE VIEW localized_de_ModelingService_QueryFieldAggregations AS SELECT
  QueryFieldAggregations_0.name,
  QueryFieldAggregations_0.descr,
  QueryFieldAggregations_0.code
FROM localized_de_QueryFieldAggregations AS QueryFieldAggregations_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldAggregations AS SELECT
  QueryFieldAggregations_0.name,
  QueryFieldAggregations_0.descr,
  QueryFieldAggregations_0.code
FROM localized_fr_QueryFieldAggregations AS QueryFieldAggregations_0;

CREATE VIEW localized_de_ModelingService_QueryFieldHidings AS SELECT
  QueryFieldHidings_0.name,
  QueryFieldHidings_0.descr,
  QueryFieldHidings_0.code
FROM localized_de_QueryFieldHidings AS QueryFieldHidings_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldHidings AS SELECT
  QueryFieldHidings_0.name,
  QueryFieldHidings_0.descr,
  QueryFieldHidings_0.code
FROM localized_fr_QueryFieldHidings AS QueryFieldHidings_0;

CREATE VIEW localized_de_ModelingService_QueryFieldDecimalPlaces AS SELECT
  QueryFieldDecimalPlaces_0.name,
  QueryFieldDecimalPlaces_0.descr,
  QueryFieldDecimalPlaces_0.code
FROM localized_de_QueryFieldDecimalPlaces AS QueryFieldDecimalPlaces_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldDecimalPlaces AS SELECT
  QueryFieldDecimalPlaces_0.name,
  QueryFieldDecimalPlaces_0.descr,
  QueryFieldDecimalPlaces_0.code
FROM localized_fr_QueryFieldDecimalPlaces AS QueryFieldDecimalPlaces_0;

CREATE VIEW localized_de_ModelingService_QueryFieldScalingFactors AS SELECT
  QueryFieldScalingFactors_0.name,
  QueryFieldScalingFactors_0.descr,
  QueryFieldScalingFactors_0.code
FROM localized_de_QueryFieldScalingFactors AS QueryFieldScalingFactors_0;

CREATE VIEW localized_fr_ModelingService_QueryFieldScalingFactors AS SELECT
  QueryFieldScalingFactors_0.name,
  QueryFieldScalingFactors_0.descr,
  QueryFieldScalingFactors_0.code
FROM localized_fr_QueryFieldScalingFactors AS QueryFieldScalingFactors_0;

CREATE VIEW localized_de_ModelingService_ApplicationLogMessageTypes AS SELECT
  ApplicationLogMessageTypes_0.name,
  ApplicationLogMessageTypes_0.descr,
  ApplicationLogMessageTypes_0.code
FROM localized_de_ApplicationLogMessageTypes AS ApplicationLogMessageTypes_0;

CREATE VIEW localized_fr_ModelingService_ApplicationLogMessageTypes AS SELECT
  ApplicationLogMessageTypes_0.name,
  ApplicationLogMessageTypes_0.descr,
  ApplicationLogMessageTypes_0.code
FROM localized_fr_ApplicationLogMessageTypes AS ApplicationLogMessageTypes_0;

CREATE VIEW localized_de_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_de_Signs AS Signs_0;

CREATE VIEW localized_fr_ModelingService_Signs AS SELECT
  Signs_0.name,
  Signs_0.descr,
  Signs_0.code
FROM localized_fr_Signs AS Signs_0;

CREATE VIEW localized_de_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_de_Options AS Options_0;

CREATE VIEW localized_fr_ModelingService_Options AS SELECT
  Options_0.name,
  Options_0.descr,
  Options_0.code
FROM localized_fr_Options AS Options_0;

CREATE VIEW localized_de_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_de_Groups AS Groups_0;

CREATE VIEW localized_fr_ModelingService_Groups AS SELECT
  Groups_0.name,
  Groups_0.descr,
  Groups_0.code
FROM localized_fr_Groups AS Groups_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateActivityTypes AS SELECT
  CalculationUnitProcessTemplateActivityTypes_0.name,
  CalculationUnitProcessTemplateActivityTypes_0.descr,
  CalculationUnitProcessTemplateActivityTypes_0.code
FROM localized_de_CalculationUnitProcessTemplateActivityTypes AS CalculationUnitProcessTemplateActivityTypes_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateActivityTypes AS SELECT
  CalculationUnitProcessTemplateActivityTypes_0.name,
  CalculationUnitProcessTemplateActivityTypes_0.descr,
  CalculationUnitProcessTemplateActivityTypes_0.code
FROM localized_fr_CalculationUnitProcessTemplateActivityTypes AS CalculationUnitProcessTemplateActivityTypes_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateActivityStates AS SELECT
  CalculationUnitProcessTemplateActivityStates_0.name,
  CalculationUnitProcessTemplateActivityStates_0.descr,
  CalculationUnitProcessTemplateActivityStates_0.code
FROM localized_de_CalculationUnitProcessTemplateActivityStates AS CalculationUnitProcessTemplateActivityStates_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateActivityStates AS SELECT
  CalculationUnitProcessTemplateActivityStates_0.name,
  CalculationUnitProcessTemplateActivityStates_0.descr,
  CalculationUnitProcessTemplateActivityStates_0.code
FROM localized_fr_CalculationUnitProcessTemplateActivityStates AS CalculationUnitProcessTemplateActivityStates_0;

CREATE VIEW localized_de_ModelingService_JoinRulePredicateComparisons AS SELECT
  JoinRulePredicateComparisons_0.name,
  JoinRulePredicateComparisons_0.descr,
  JoinRulePredicateComparisons_0.code
FROM localized_de_JoinRulePredicateComparisons AS JoinRulePredicateComparisons_0;

CREATE VIEW localized_fr_ModelingService_JoinRulePredicateComparisons AS SELECT
  JoinRulePredicateComparisons_0.name,
  JoinRulePredicateComparisons_0.descr,
  JoinRulePredicateComparisons_0.code
FROM localized_fr_JoinRulePredicateComparisons AS JoinRulePredicateComparisons_0;

CREATE VIEW localized_de_ModelingService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_de_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_fr_ModelingService_RuntimePartitions AS SELECT
  RuntimePartitions_0.createdAt,
  RuntimePartitions_0.createdBy,
  RuntimePartitions_0.modifiedAt,
  RuntimePartitions_0.modifiedBy,
  RuntimePartitions_0.ID,
  RuntimePartitions_0."partition",
  RuntimePartitions_0.description,
  RuntimePartitions_0.field_ID
FROM localized_fr_RuntimePartitions AS RuntimePartitions_0;

CREATE VIEW localized_de_ModelingService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field_ID
FROM localized_de_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_fr_ModelingService_RuntimeOutputFields AS SELECT
  RuntimeOutputFields_0.createdAt,
  RuntimeOutputFields_0.createdBy,
  RuntimeOutputFields_0.modifiedAt,
  RuntimeOutputFields_0.modifiedBy,
  RuntimeOutputFields_0.ID,
  RuntimeOutputFields_0.function_ID,
  RuntimeOutputFields_0.field_ID
FROM localized_fr_RuntimeOutputFields AS RuntimeOutputFields_0;

CREATE VIEW localized_de_ModelingService_RuntimeShareLocks AS SELECT
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

CREATE VIEW localized_fr_ModelingService_RuntimeShareLocks AS SELECT
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

CREATE VIEW localized_de_ModelingService_Environments AS SELECT
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
FROM localized_de_Environments AS environments_0;

CREATE VIEW localized_fr_ModelingService_Environments AS SELECT
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
FROM localized_fr_Environments AS environments_0;

CREATE VIEW localized_de_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_de_Fields AS fields_0;

CREATE VIEW localized_fr_ModelingService_Fields AS SELECT
  fields_0.createdAt,
  fields_0.createdBy,
  fields_0.modifiedAt,
  fields_0.modifiedBy,
  fields_0.environment_ID,
  fields_0.ID,
  fields_0.field,
  fields_0.class_code,
  fields_0.type_code,
  fields_0.hanaDataType_code,
  fields_0.dataLength,
  fields_0.dataDecimals,
  fields_0.unitField_ID,
  fields_0.isLowercase,
  fields_0.hasMasterData,
  fields_0.hasHierarchies,
  fields_0.calculationHierarchy_ID,
  fields_0.masterDataQuery_ID,
  fields_0.description,
  fields_0.documentation
FROM localized_fr_Fields AS fields_0;

CREATE VIEW localized_de_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_de_Checks AS checks_0;

CREATE VIEW localized_fr_ModelingService_Checks AS SELECT
  checks_0.createdAt,
  checks_0.createdBy,
  checks_0.modifiedAt,
  checks_0.modifiedBy,
  checks_0.environment_ID,
  checks_0.ID,
  checks_0."check",
  checks_0.messageType_code,
  checks_0.category_code,
  checks_0.description
FROM localized_fr_Checks AS checks_0;

CREATE VIEW localized_de_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.description,
  functions_0.documentation
FROM localized_de_Functions AS functions_0;

CREATE VIEW localized_fr_ModelingService_Functions AS SELECT
  functions_0.createdAt,
  functions_0.createdBy,
  functions_0.modifiedAt,
  functions_0.modifiedBy,
  functions_0.environment_ID,
  functions_0.ID,
  functions_0.function,
  functions_0.sequence,
  functions_0.parent_ID,
  functions_0.type_code,
  functions_0.description,
  functions_0.documentation
FROM localized_fr_Functions AS functions_0;

CREATE VIEW localized_de_ModelingService_RuntimeFunctions AS SELECT
  runtimeFunctions_0.createdAt,
  runtimeFunctions_0.createdBy,
  runtimeFunctions_0.modifiedAt,
  runtimeFunctions_0.modifiedBy,
  runtimeFunctions_0.ID,
  runtimeFunctions_0.environment,
  runtimeFunctions_0.version,
  runtimeFunctions_0.process,
  runtimeFunctions_0.activity,
  runtimeFunctions_0.function,
  runtimeFunctions_0.description,
  runtimeFunctions_0.type_code,
  runtimeFunctions_0.state_code,
  runtimeFunctions_0.processingType_code,
  runtimeFunctions_0.businessEventType_code,
  runtimeFunctions_0.partition_ID,
  runtimeFunctions_0.storedProcedure,
  runtimeFunctions_0.appServerStatement,
  runtimeFunctions_0.preStatement,
  runtimeFunctions_0.statement,
  runtimeFunctions_0.postStatement,
  runtimeFunctions_0.hanaTable,
  runtimeFunctions_0.hanaView,
  runtimeFunctions_0.synonym,
  runtimeFunctions_0.masterDataHierarchyView,
  runtimeFunctions_0.calculationView,
  runtimeFunctions_0.workBook,
  runtimeFunctions_0.resultModelTable_ID
FROM localized_de_RuntimeFunctions AS runtimeFunctions_0;

CREATE VIEW localized_fr_ModelingService_RuntimeFunctions AS SELECT
  runtimeFunctions_0.createdAt,
  runtimeFunctions_0.createdBy,
  runtimeFunctions_0.modifiedAt,
  runtimeFunctions_0.modifiedBy,
  runtimeFunctions_0.ID,
  runtimeFunctions_0.environment,
  runtimeFunctions_0.version,
  runtimeFunctions_0.process,
  runtimeFunctions_0.activity,
  runtimeFunctions_0.function,
  runtimeFunctions_0.description,
  runtimeFunctions_0.type_code,
  runtimeFunctions_0.state_code,
  runtimeFunctions_0.processingType_code,
  runtimeFunctions_0.businessEventType_code,
  runtimeFunctions_0.partition_ID,
  runtimeFunctions_0.storedProcedure,
  runtimeFunctions_0.appServerStatement,
  runtimeFunctions_0.preStatement,
  runtimeFunctions_0.statement,
  runtimeFunctions_0.postStatement,
  runtimeFunctions_0.hanaTable,
  runtimeFunctions_0.hanaView,
  runtimeFunctions_0.synonym,
  runtimeFunctions_0.masterDataHierarchyView,
  runtimeFunctions_0.calculationView,
  runtimeFunctions_0.workBook,
  runtimeFunctions_0.resultModelTable_ID
FROM localized_fr_RuntimeFunctions AS runtimeFunctions_0;

CREATE VIEW localized_de_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.resultFunction_ID,
  allocations_0.processingType_code,
  allocations_0.businessEventType_code,
  allocations_0.partition_ID,
  allocations_0.inputFunction_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.receiverFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_de_Allocations AS allocations_0;

CREATE VIEW localized_fr_ModelingService_Allocations AS SELECT
  allocations_0.createdAt,
  allocations_0.createdBy,
  allocations_0.modifiedAt,
  allocations_0.modifiedBy,
  allocations_0.environment_ID,
  allocations_0.function_ID,
  allocations_0.includeInputData,
  allocations_0.resultHandling_code,
  allocations_0.includeInitialResult,
  allocations_0.resultFunction_ID,
  allocations_0.processingType_code,
  allocations_0.businessEventType_code,
  allocations_0.partition_ID,
  allocations_0.inputFunction_ID,
  allocations_0.ID,
  allocations_0.type_code,
  allocations_0.valueAdjustment_code,
  allocations_0.cycleFlag,
  allocations_0.cycleMaximum,
  allocations_0.cycleIterationField_ID,
  allocations_0.cycleAggregation_code,
  allocations_0.termFlag,
  allocations_0.termIterationField_ID,
  allocations_0.termYearField_ID,
  allocations_0.termField_ID,
  allocations_0.termProcessing_code,
  allocations_0.termYear,
  allocations_0.termMinimum,
  allocations_0.termMaximum,
  allocations_0.receiverFunction_ID,
  allocations_0.earlyExitCheck_ID
FROM localized_fr_Allocations AS allocations_0;

CREATE VIEW localized_de_ModelingService_Calculations AS SELECT
  calculations_0.createdAt,
  calculations_0.createdBy,
  calculations_0.modifiedAt,
  calculations_0.modifiedBy,
  calculations_0.environment_ID,
  calculations_0.function_ID,
  calculations_0.includeInputData,
  calculations_0.resultHandling_code,
  calculations_0.includeInitialResult,
  calculations_0.resultFunction_ID,
  calculations_0.processingType_code,
  calculations_0.businessEventType_code,
  calculations_0.partition_ID,
  calculations_0.inputFunction_ID,
  calculations_0.ID,
  calculations_0.type_code,
  calculations_0.workbook
FROM localized_de_Calculations AS calculations_0;

CREATE VIEW localized_fr_ModelingService_Calculations AS SELECT
  calculations_0.createdAt,
  calculations_0.createdBy,
  calculations_0.modifiedAt,
  calculations_0.modifiedBy,
  calculations_0.environment_ID,
  calculations_0.function_ID,
  calculations_0.includeInputData,
  calculations_0.resultHandling_code,
  calculations_0.includeInitialResult,
  calculations_0.resultFunction_ID,
  calculations_0.processingType_code,
  calculations_0.businessEventType_code,
  calculations_0.partition_ID,
  calculations_0.inputFunction_ID,
  calculations_0.ID,
  calculations_0.type_code,
  calculations_0.workbook
FROM localized_fr_Calculations AS calculations_0;

CREATE VIEW localized_de_ModelingService_Derivations AS SELECT
  derivations_0.createdAt,
  derivations_0.createdBy,
  derivations_0.modifiedAt,
  derivations_0.modifiedBy,
  derivations_0.environment_ID,
  derivations_0.function_ID,
  derivations_0.includeInputData,
  derivations_0.resultHandling_code,
  derivations_0.includeInitialResult,
  derivations_0.resultFunction_ID,
  derivations_0.processingType_code,
  derivations_0.businessEventType_code,
  derivations_0.partition_ID,
  derivations_0.inputFunction_ID,
  derivations_0.ID,
  derivations_0.type_code,
  derivations_0.suppressInitialResults,
  derivations_0.ensureDistinctResults
FROM localized_de_Derivations AS derivations_0;

CREATE VIEW localized_fr_ModelingService_Derivations AS SELECT
  derivations_0.createdAt,
  derivations_0.createdBy,
  derivations_0.modifiedAt,
  derivations_0.modifiedBy,
  derivations_0.environment_ID,
  derivations_0.function_ID,
  derivations_0.includeInputData,
  derivations_0.resultHandling_code,
  derivations_0.includeInitialResult,
  derivations_0.resultFunction_ID,
  derivations_0.processingType_code,
  derivations_0.businessEventType_code,
  derivations_0.partition_ID,
  derivations_0.inputFunction_ID,
  derivations_0.ID,
  derivations_0.type_code,
  derivations_0.suppressInitialResults,
  derivations_0.ensureDistinctResults
FROM localized_fr_Derivations AS derivations_0;

CREATE VIEW localized_de_ModelingService_Joins AS SELECT
  joins_0.createdAt,
  joins_0.createdBy,
  joins_0.modifiedAt,
  joins_0.modifiedBy,
  joins_0.environment_ID,
  joins_0.function_ID,
  joins_0.includeInputData,
  joins_0.resultHandling_code,
  joins_0.includeInitialResult,
  joins_0.resultFunction_ID,
  joins_0.processingType_code,
  joins_0.businessEventType_code,
  joins_0.partition_ID,
  joins_0.inputFunction_ID,
  joins_0.ID,
  joins_0.type_code
FROM localized_de_Joins AS joins_0;

CREATE VIEW localized_fr_ModelingService_Joins AS SELECT
  joins_0.createdAt,
  joins_0.createdBy,
  joins_0.modifiedAt,
  joins_0.modifiedBy,
  joins_0.environment_ID,
  joins_0.function_ID,
  joins_0.includeInputData,
  joins_0.resultHandling_code,
  joins_0.includeInitialResult,
  joins_0.resultFunction_ID,
  joins_0.processingType_code,
  joins_0.businessEventType_code,
  joins_0.partition_ID,
  joins_0.inputFunction_ID,
  joins_0.ID,
  joins_0.type_code
FROM localized_fr_Joins AS joins_0;

CREATE VIEW localized_de_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connection
FROM localized_de_ModelTables AS modelTables_0;

CREATE VIEW localized_fr_ModelingService_ModelTables AS SELECT
  modelTables_0.createdAt,
  modelTables_0.createdBy,
  modelTables_0.modifiedAt,
  modelTables_0.modifiedBy,
  modelTables_0.environment_ID,
  modelTables_0.function_ID,
  modelTables_0.ID,
  modelTables_0.type_code,
  modelTables_0.transportData,
  modelTables_0.connection
FROM localized_fr_ModelTables AS modelTables_0;

CREATE VIEW localized_de_ModelingService_ApplicationLogs AS SELECT
  applicationLogs_0.createdAt,
  applicationLogs_0.createdBy,
  applicationLogs_0.modifiedAt,
  applicationLogs_0.modifiedBy,
  applicationLogs_0.ID,
  applicationLogs_0.run,
  applicationLogs_0.type,
  applicationLogs_0.environment,
  applicationLogs_0.version,
  applicationLogs_0.process,
  applicationLogs_0.activity,
  applicationLogs_0.mainFunction,
  applicationLogs_0.parameters,
  applicationLogs_0.selections,
  applicationLogs_0.businessEvent,
  applicationLogs_0.field,
  applicationLogs_0."check",
  applicationLogs_0.conversion,
  applicationLogs_0."partition",
  applicationLogs_0.package,
  applicationLogs_0.state_code
FROM localized_de_ApplicationLogs AS applicationLogs_0;

CREATE VIEW localized_fr_ModelingService_ApplicationLogs AS SELECT
  applicationLogs_0.createdAt,
  applicationLogs_0.createdBy,
  applicationLogs_0.modifiedAt,
  applicationLogs_0.modifiedBy,
  applicationLogs_0.ID,
  applicationLogs_0.run,
  applicationLogs_0.type,
  applicationLogs_0.environment,
  applicationLogs_0.version,
  applicationLogs_0.process,
  applicationLogs_0.activity,
  applicationLogs_0.mainFunction,
  applicationLogs_0.parameters,
  applicationLogs_0.selections,
  applicationLogs_0.businessEvent,
  applicationLogs_0.field,
  applicationLogs_0."check",
  applicationLogs_0.conversion,
  applicationLogs_0."partition",
  applicationLogs_0.package,
  applicationLogs_0.state_code
FROM localized_fr_ApplicationLogs AS applicationLogs_0;

CREATE VIEW localized_de_ModelingService_Connections AS SELECT
  Connections_0.createdAt,
  Connections_0.createdBy,
  Connections_0.modifiedAt,
  Connections_0.modifiedBy,
  Connections_0.environment_ID,
  Connections_0.ID,
  Connections_0.connection,
  Connections_0.description,
  Connections_0.source_code,
  Connections_0.hanaTable,
  Connections_0.hanaView,
  Connections_0.odataUrl,
  Connections_0.odataUrlOptions
FROM localized_de_Connections AS Connections_0;

CREATE VIEW localized_fr_ModelingService_Connections AS SELECT
  Connections_0.createdAt,
  Connections_0.createdBy,
  Connections_0.modifiedAt,
  Connections_0.modifiedBy,
  Connections_0.environment_ID,
  Connections_0.ID,
  Connections_0.connection,
  Connections_0.description,
  Connections_0.source_code,
  Connections_0.hanaTable,
  Connections_0.hanaView,
  Connections_0.odataUrl,
  Connections_0.odataUrlOptions
FROM localized_fr_Connections AS Connections_0;

CREATE VIEW localized_de_ModelingService_AllocationInputFields AS SELECT
  AllocationInputFields_0.createdAt,
  AllocationInputFields_0.createdBy,
  AllocationInputFields_0.modifiedAt,
  AllocationInputFields_0.modifiedBy,
  AllocationInputFields_0.environment_ID,
  AllocationInputFields_0.function_ID,
  AllocationInputFields_0.formula,
  AllocationInputFields_0.order_code,
  AllocationInputFields_0.ID,
  AllocationInputFields_0.allocation_ID,
  AllocationInputFields_0.field_ID
FROM localized_de_AllocationInputFields AS AllocationInputFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationInputFields AS SELECT
  AllocationInputFields_0.createdAt,
  AllocationInputFields_0.createdBy,
  AllocationInputFields_0.modifiedAt,
  AllocationInputFields_0.modifiedBy,
  AllocationInputFields_0.environment_ID,
  AllocationInputFields_0.function_ID,
  AllocationInputFields_0.formula,
  AllocationInputFields_0.order_code,
  AllocationInputFields_0.ID,
  AllocationInputFields_0.allocation_ID,
  AllocationInputFields_0.field_ID
FROM localized_fr_AllocationInputFields AS AllocationInputFields_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_de_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverViews AS SELECT
  AllocationReceiverViews_0.createdAt,
  AllocationReceiverViews_0.createdBy,
  AllocationReceiverViews_0.modifiedAt,
  AllocationReceiverViews_0.modifiedBy,
  AllocationReceiverViews_0.environment_ID,
  AllocationReceiverViews_0.function_ID,
  AllocationReceiverViews_0.formula,
  AllocationReceiverViews_0.order_code,
  AllocationReceiverViews_0.ID,
  AllocationReceiverViews_0.allocation_ID,
  AllocationReceiverViews_0.field_ID
FROM localized_fr_AllocationReceiverViews AS AllocationReceiverViews_0;

CREATE VIEW localized_de_ModelingService_CalculationInputFields AS SELECT
  CalculationInputFields_0.createdAt,
  CalculationInputFields_0.createdBy,
  CalculationInputFields_0.modifiedAt,
  CalculationInputFields_0.modifiedBy,
  CalculationInputFields_0.environment_ID,
  CalculationInputFields_0.function_ID,
  CalculationInputFields_0.formula,
  CalculationInputFields_0.order_code,
  CalculationInputFields_0.ID,
  CalculationInputFields_0.field_ID,
  CalculationInputFields_0.calculation_ID
FROM localized_de_CalculationInputFields AS CalculationInputFields_0;

CREATE VIEW localized_fr_ModelingService_CalculationInputFields AS SELECT
  CalculationInputFields_0.createdAt,
  CalculationInputFields_0.createdBy,
  CalculationInputFields_0.modifiedAt,
  CalculationInputFields_0.modifiedBy,
  CalculationInputFields_0.environment_ID,
  CalculationInputFields_0.function_ID,
  CalculationInputFields_0.formula,
  CalculationInputFields_0.order_code,
  CalculationInputFields_0.ID,
  CalculationInputFields_0.field_ID,
  CalculationInputFields_0.calculation_ID
FROM localized_fr_CalculationInputFields AS CalculationInputFields_0;

CREATE VIEW localized_de_ModelingService_DerivationInputFields AS SELECT
  DerivationInputFields_0.createdAt,
  DerivationInputFields_0.createdBy,
  DerivationInputFields_0.modifiedAt,
  DerivationInputFields_0.modifiedBy,
  DerivationInputFields_0.environment_ID,
  DerivationInputFields_0.function_ID,
  DerivationInputFields_0.formula,
  DerivationInputFields_0.order_code,
  DerivationInputFields_0.ID,
  DerivationInputFields_0.field_ID,
  DerivationInputFields_0.derivation_ID
FROM localized_de_DerivationInputFields AS DerivationInputFields_0;

CREATE VIEW localized_fr_ModelingService_DerivationInputFields AS SELECT
  DerivationInputFields_0.createdAt,
  DerivationInputFields_0.createdBy,
  DerivationInputFields_0.modifiedAt,
  DerivationInputFields_0.modifiedBy,
  DerivationInputFields_0.environment_ID,
  DerivationInputFields_0.function_ID,
  DerivationInputFields_0.formula,
  DerivationInputFields_0.order_code,
  DerivationInputFields_0.ID,
  DerivationInputFields_0.field_ID,
  DerivationInputFields_0.derivation_ID
FROM localized_fr_DerivationInputFields AS DerivationInputFields_0;

CREATE VIEW localized_de_ModelingService_JoinInputFields AS SELECT
  JoinInputFields_0.createdAt,
  JoinInputFields_0.createdBy,
  JoinInputFields_0.modifiedAt,
  JoinInputFields_0.modifiedBy,
  JoinInputFields_0.environment_ID,
  JoinInputFields_0.function_ID,
  JoinInputFields_0.formula,
  JoinInputFields_0.order_code,
  JoinInputFields_0.ID,
  JoinInputFields_0.field_ID,
  JoinInputFields_0.Join_ID
FROM localized_de_JoinInputFields AS JoinInputFields_0;

CREATE VIEW localized_fr_ModelingService_JoinInputFields AS SELECT
  JoinInputFields_0.createdAt,
  JoinInputFields_0.createdBy,
  JoinInputFields_0.modifiedAt,
  JoinInputFields_0.modifiedBy,
  JoinInputFields_0.environment_ID,
  JoinInputFields_0.function_ID,
  JoinInputFields_0.formula,
  JoinInputFields_0.order_code,
  JoinInputFields_0.ID,
  JoinInputFields_0.field_ID,
  JoinInputFields_0.Join_ID
FROM localized_fr_JoinInputFields AS JoinInputFields_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_de_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderViews AS SELECT
  AllocationRuleSenderViews_0.createdAt,
  AllocationRuleSenderViews_0.createdBy,
  AllocationRuleSenderViews_0.modifiedAt,
  AllocationRuleSenderViews_0.modifiedBy,
  AllocationRuleSenderViews_0.environment_ID,
  AllocationRuleSenderViews_0.function_ID,
  AllocationRuleSenderViews_0.formula,
  AllocationRuleSenderViews_0.group_code,
  AllocationRuleSenderViews_0.order_code,
  AllocationRuleSenderViews_0.ID,
  AllocationRuleSenderViews_0.rule_ID,
  AllocationRuleSenderViews_0.field_ID
FROM localized_fr_AllocationRuleSenderViews AS AllocationRuleSenderViews_0;

CREATE VIEW localized_de_ModelingService_JoinRuleInputFields AS SELECT
  JoinRuleInputFields_0.createdAt,
  JoinRuleInputFields_0.createdBy,
  JoinRuleInputFields_0.modifiedAt,
  JoinRuleInputFields_0.modifiedBy,
  JoinRuleInputFields_0.environment_ID,
  JoinRuleInputFields_0.function_ID,
  JoinRuleInputFields_0.formula,
  JoinRuleInputFields_0.order_code,
  JoinRuleInputFields_0.field_ID,
  JoinRuleInputFields_0.ID,
  JoinRuleInputFields_0.rule_ID
FROM localized_de_JoinRuleInputFields AS JoinRuleInputFields_0;

CREATE VIEW localized_fr_ModelingService_JoinRuleInputFields AS SELECT
  JoinRuleInputFields_0.createdAt,
  JoinRuleInputFields_0.createdBy,
  JoinRuleInputFields_0.modifiedAt,
  JoinRuleInputFields_0.modifiedBy,
  JoinRuleInputFields_0.environment_ID,
  JoinRuleInputFields_0.function_ID,
  JoinRuleInputFields_0.formula,
  JoinRuleInputFields_0.order_code,
  JoinRuleInputFields_0.field_ID,
  JoinRuleInputFields_0.ID,
  JoinRuleInputFields_0.rule_ID
FROM localized_fr_JoinRuleInputFields AS JoinRuleInputFields_0;

CREATE VIEW localized_de_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_de_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_fr_ModelingService_AllocationRules AS SELECT
  AllocationRules_0.createdAt,
  AllocationRules_0.createdBy,
  AllocationRules_0.modifiedAt,
  AllocationRules_0.modifiedBy,
  AllocationRules_0.environment_ID,
  AllocationRules_0.function_ID,
  AllocationRules_0.ID,
  AllocationRules_0.allocation_ID,
  AllocationRules_0.sequence,
  AllocationRules_0.rule,
  AllocationRules_0.description,
  AllocationRules_0.isActive,
  AllocationRules_0.type_code,
  AllocationRules_0.senderRule_code,
  AllocationRules_0.senderShare,
  AllocationRules_0.method_code,
  AllocationRules_0.distributionBase,
  AllocationRules_0.parentRule_ID,
  AllocationRules_0.receiverRule_code,
  AllocationRules_0.scale_code,
  AllocationRules_0.driverResultField_ID
FROM localized_fr_AllocationRules AS AllocationRules_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplates AS SELECT
  CalculationUnitProcessTemplates_0.createdAt,
  CalculationUnitProcessTemplates_0.createdBy,
  CalculationUnitProcessTemplates_0.modifiedAt,
  CalculationUnitProcessTemplates_0.modifiedBy,
  CalculationUnitProcessTemplates_0.environment_ID,
  CalculationUnitProcessTemplates_0.function_ID,
  CalculationUnitProcessTemplates_0.ID,
  CalculationUnitProcessTemplates_0.CalculationUnit_ID,
  CalculationUnitProcessTemplates_0.process,
  CalculationUnitProcessTemplates_0.sequence,
  CalculationUnitProcessTemplates_0.type_code,
  CalculationUnitProcessTemplates_0.state_code,
  CalculationUnitProcessTemplates_0.description
FROM localized_de_CalculationUnitProcessTemplates AS CalculationUnitProcessTemplates_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplates AS SELECT
  CalculationUnitProcessTemplates_0.createdAt,
  CalculationUnitProcessTemplates_0.createdBy,
  CalculationUnitProcessTemplates_0.modifiedAt,
  CalculationUnitProcessTemplates_0.modifiedBy,
  CalculationUnitProcessTemplates_0.environment_ID,
  CalculationUnitProcessTemplates_0.function_ID,
  CalculationUnitProcessTemplates_0.ID,
  CalculationUnitProcessTemplates_0.CalculationUnit_ID,
  CalculationUnitProcessTemplates_0.process,
  CalculationUnitProcessTemplates_0.sequence,
  CalculationUnitProcessTemplates_0.type_code,
  CalculationUnitProcessTemplates_0.state_code,
  CalculationUnitProcessTemplates_0.description
FROM localized_fr_CalculationUnitProcessTemplates AS CalculationUnitProcessTemplates_0;

CREATE VIEW localized_de_ModelingService_JoinRules AS SELECT
  JoinRules_0.createdAt,
  JoinRules_0.createdBy,
  JoinRules_0.modifiedAt,
  JoinRules_0.modifiedBy,
  JoinRules_0.environment_ID,
  JoinRules_0.function_ID,
  JoinRules_0.ID,
  JoinRules_0.Join_ID,
  JoinRules_0.parent_ID,
  JoinRules_0.type_code,
  JoinRules_0.inputFunction_ID,
  JoinRules_0.joinType_code,
  JoinRules_0.complexPredicates,
  JoinRules_0.sequence,
  JoinRules_0.description
FROM localized_de_JoinRules AS JoinRules_0;

CREATE VIEW localized_fr_ModelingService_JoinRules AS SELECT
  JoinRules_0.createdAt,
  JoinRules_0.createdBy,
  JoinRules_0.modifiedAt,
  JoinRules_0.modifiedBy,
  JoinRules_0.environment_ID,
  JoinRules_0.function_ID,
  JoinRules_0.ID,
  JoinRules_0.Join_ID,
  JoinRules_0.parent_ID,
  JoinRules_0.type_code,
  JoinRules_0.inputFunction_ID,
  JoinRules_0.joinType_code,
  JoinRules_0.complexPredicates,
  JoinRules_0.sequence,
  JoinRules_0.description
FROM localized_fr_JoinRules AS JoinRules_0;

CREATE VIEW localized_de_ModelingService_QueryComponents AS SELECT
  QueryComponents_0.createdAt,
  QueryComponents_0.createdBy,
  QueryComponents_0.modifiedAt,
  QueryComponents_0.modifiedBy,
  QueryComponents_0.environment_ID,
  QueryComponents_0.function_ID,
  QueryComponents_0.ID,
  QueryComponents_0.query_ID,
  QueryComponents_0.component,
  QueryComponents_0.type_code,
  QueryComponents_0.layout_code,
  QueryComponents_0.tag_code,
  QueryComponents_0.editable,
  QueryComponents_0.field_ID,
  QueryComponents_0.hierarchy_ID,
  QueryComponents_0.display_code,
  QueryComponents_0.resultRow_code,
  QueryComponents_0.variableRepresentation_code,
  QueryComponents_0.variableMandatory,
  QueryComponents_0.variableDefaultValue,
  QueryComponents_0.aggregation_code,
  QueryComponents_0.hiding_code,
  QueryComponents_0.decimalPlaces_code,
  QueryComponents_0.scalingFactor_code,
  QueryComponents_0.changeSign,
  QueryComponents_0.formula,
  QueryComponents_0.keyfigure_ID
FROM localized_de_QueryComponents AS QueryComponents_0;

CREATE VIEW localized_fr_ModelingService_QueryComponents AS SELECT
  QueryComponents_0.createdAt,
  QueryComponents_0.createdBy,
  QueryComponents_0.modifiedAt,
  QueryComponents_0.modifiedBy,
  QueryComponents_0.environment_ID,
  QueryComponents_0.function_ID,
  QueryComponents_0.ID,
  QueryComponents_0.query_ID,
  QueryComponents_0.component,
  QueryComponents_0.type_code,
  QueryComponents_0.layout_code,
  QueryComponents_0.tag_code,
  QueryComponents_0.editable,
  QueryComponents_0.field_ID,
  QueryComponents_0.hierarchy_ID,
  QueryComponents_0.display_code,
  QueryComponents_0.resultRow_code,
  QueryComponents_0.variableRepresentation_code,
  QueryComponents_0.variableMandatory,
  QueryComponents_0.variableDefaultValue,
  QueryComponents_0.aggregation_code,
  QueryComponents_0.hiding_code,
  QueryComponents_0.decimalPlaces_code,
  QueryComponents_0.scalingFactor_code,
  QueryComponents_0.changeSign,
  QueryComponents_0.formula,
  QueryComponents_0.keyfigure_ID
FROM localized_fr_QueryComponents AS QueryComponents_0;

CREATE VIEW localized_de_ModelingService_ApplicationLogMessages AS SELECT
  ApplicationLogMessages_0.createdAt,
  ApplicationLogMessages_0.createdBy,
  ApplicationLogMessages_0.modifiedAt,
  ApplicationLogMessages_0.modifiedBy,
  ApplicationLogMessages_0.ID,
  ApplicationLogMessages_0.applicationLog_ID,
  ApplicationLogMessages_0.type_code,
  ApplicationLogMessages_0.function,
  ApplicationLogMessages_0.code,
  ApplicationLogMessages_0.entity,
  ApplicationLogMessages_0.primaryKey,
  ApplicationLogMessages_0.target,
  ApplicationLogMessages_0.argument1,
  ApplicationLogMessages_0.argument2,
  ApplicationLogMessages_0.argument3,
  ApplicationLogMessages_0.argument4,
  ApplicationLogMessages_0.argument5,
  ApplicationLogMessages_0.argument6,
  ApplicationLogMessages_0.messageDetails
FROM localized_de_ApplicationLogMessages AS ApplicationLogMessages_0;

CREATE VIEW localized_fr_ModelingService_ApplicationLogMessages AS SELECT
  ApplicationLogMessages_0.createdAt,
  ApplicationLogMessages_0.createdBy,
  ApplicationLogMessages_0.modifiedAt,
  ApplicationLogMessages_0.modifiedBy,
  ApplicationLogMessages_0.ID,
  ApplicationLogMessages_0.applicationLog_ID,
  ApplicationLogMessages_0.type_code,
  ApplicationLogMessages_0.function,
  ApplicationLogMessages_0.code,
  ApplicationLogMessages_0.entity,
  ApplicationLogMessages_0.primaryKey,
  ApplicationLogMessages_0.target,
  ApplicationLogMessages_0.argument1,
  ApplicationLogMessages_0.argument2,
  ApplicationLogMessages_0.argument3,
  ApplicationLogMessages_0.argument4,
  ApplicationLogMessages_0.argument5,
  ApplicationLogMessages_0.argument6,
  ApplicationLogMessages_0.messageDetails
FROM localized_fr_ApplicationLogMessages AS ApplicationLogMessages_0;

CREATE VIEW localized_de_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_de_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_fr_ModelingService_CheckSelections AS SELECT
  CheckSelections_0.createdAt,
  CheckSelections_0.createdBy,
  CheckSelections_0.modifiedAt,
  CheckSelections_0.modifiedBy,
  CheckSelections_0.seq,
  CheckSelections_0.sign_code,
  CheckSelections_0.opt_code,
  CheckSelections_0.low,
  CheckSelections_0.high,
  CheckSelections_0.ID,
  CheckSelections_0.field_ID
FROM localized_fr_CheckSelections AS CheckSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationInputFieldSelections AS SELECT
  AllocationInputFieldSelections_0.createdAt,
  AllocationInputFieldSelections_0.createdBy,
  AllocationInputFieldSelections_0.modifiedAt,
  AllocationInputFieldSelections_0.modifiedBy,
  AllocationInputFieldSelections_0.environment_ID,
  AllocationInputFieldSelections_0.function_ID,
  AllocationInputFieldSelections_0.seq,
  AllocationInputFieldSelections_0.sign_code,
  AllocationInputFieldSelections_0.opt_code,
  AllocationInputFieldSelections_0.low,
  AllocationInputFieldSelections_0.high,
  AllocationInputFieldSelections_0.ID,
  AllocationInputFieldSelections_0.field_ID
FROM localized_de_AllocationInputFieldSelections AS AllocationInputFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationInputFieldSelections AS SELECT
  AllocationInputFieldSelections_0.createdAt,
  AllocationInputFieldSelections_0.createdBy,
  AllocationInputFieldSelections_0.modifiedAt,
  AllocationInputFieldSelections_0.modifiedBy,
  AllocationInputFieldSelections_0.environment_ID,
  AllocationInputFieldSelections_0.function_ID,
  AllocationInputFieldSelections_0.seq,
  AllocationInputFieldSelections_0.sign_code,
  AllocationInputFieldSelections_0.opt_code,
  AllocationInputFieldSelections_0.low,
  AllocationInputFieldSelections_0.high,
  AllocationInputFieldSelections_0.ID,
  AllocationInputFieldSelections_0.field_ID
FROM localized_fr_AllocationInputFieldSelections AS AllocationInputFieldSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_de_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverViewSelections AS SELECT
  AllocationReceiverViewSelections_0.createdAt,
  AllocationReceiverViewSelections_0.createdBy,
  AllocationReceiverViewSelections_0.modifiedAt,
  AllocationReceiverViewSelections_0.modifiedBy,
  AllocationReceiverViewSelections_0.environment_ID,
  AllocationReceiverViewSelections_0.function_ID,
  AllocationReceiverViewSelections_0.seq,
  AllocationReceiverViewSelections_0.sign_code,
  AllocationReceiverViewSelections_0.opt_code,
  AllocationReceiverViewSelections_0.low,
  AllocationReceiverViewSelections_0.high,
  AllocationReceiverViewSelections_0.ID,
  AllocationReceiverViewSelections_0.field_ID
FROM localized_fr_AllocationReceiverViewSelections AS AllocationReceiverViewSelections_0;

CREATE VIEW localized_de_ModelingService_CalculationInputFieldSelections AS SELECT
  CalculationInputFieldSelections_0.createdAt,
  CalculationInputFieldSelections_0.createdBy,
  CalculationInputFieldSelections_0.modifiedAt,
  CalculationInputFieldSelections_0.modifiedBy,
  CalculationInputFieldSelections_0.environment_ID,
  CalculationInputFieldSelections_0.function_ID,
  CalculationInputFieldSelections_0.seq,
  CalculationInputFieldSelections_0.sign_code,
  CalculationInputFieldSelections_0.opt_code,
  CalculationInputFieldSelections_0.low,
  CalculationInputFieldSelections_0.high,
  CalculationInputFieldSelections_0.ID,
  CalculationInputFieldSelections_0.inputField_ID
FROM localized_de_CalculationInputFieldSelections AS CalculationInputFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_CalculationInputFieldSelections AS SELECT
  CalculationInputFieldSelections_0.createdAt,
  CalculationInputFieldSelections_0.createdBy,
  CalculationInputFieldSelections_0.modifiedAt,
  CalculationInputFieldSelections_0.modifiedBy,
  CalculationInputFieldSelections_0.environment_ID,
  CalculationInputFieldSelections_0.function_ID,
  CalculationInputFieldSelections_0.seq,
  CalculationInputFieldSelections_0.sign_code,
  CalculationInputFieldSelections_0.opt_code,
  CalculationInputFieldSelections_0.low,
  CalculationInputFieldSelections_0.high,
  CalculationInputFieldSelections_0.ID,
  CalculationInputFieldSelections_0.inputField_ID
FROM localized_fr_CalculationInputFieldSelections AS CalculationInputFieldSelections_0;

CREATE VIEW localized_de_ModelingService_DerivationInputFieldSelections AS SELECT
  DerivationInputFieldSelections_0.createdAt,
  DerivationInputFieldSelections_0.createdBy,
  DerivationInputFieldSelections_0.modifiedAt,
  DerivationInputFieldSelections_0.modifiedBy,
  DerivationInputFieldSelections_0.environment_ID,
  DerivationInputFieldSelections_0.function_ID,
  DerivationInputFieldSelections_0.seq,
  DerivationInputFieldSelections_0.sign_code,
  DerivationInputFieldSelections_0.opt_code,
  DerivationInputFieldSelections_0.low,
  DerivationInputFieldSelections_0.high,
  DerivationInputFieldSelections_0.ID,
  DerivationInputFieldSelections_0.inputField_ID
FROM localized_de_DerivationInputFieldSelections AS DerivationInputFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_DerivationInputFieldSelections AS SELECT
  DerivationInputFieldSelections_0.createdAt,
  DerivationInputFieldSelections_0.createdBy,
  DerivationInputFieldSelections_0.modifiedAt,
  DerivationInputFieldSelections_0.modifiedBy,
  DerivationInputFieldSelections_0.environment_ID,
  DerivationInputFieldSelections_0.function_ID,
  DerivationInputFieldSelections_0.seq,
  DerivationInputFieldSelections_0.sign_code,
  DerivationInputFieldSelections_0.opt_code,
  DerivationInputFieldSelections_0.low,
  DerivationInputFieldSelections_0.high,
  DerivationInputFieldSelections_0.ID,
  DerivationInputFieldSelections_0.inputField_ID
FROM localized_fr_DerivationInputFieldSelections AS DerivationInputFieldSelections_0;

CREATE VIEW localized_de_ModelingService_JoinInputFieldSelections AS SELECT
  JoinInputFieldSelections_0.createdAt,
  JoinInputFieldSelections_0.createdBy,
  JoinInputFieldSelections_0.modifiedAt,
  JoinInputFieldSelections_0.modifiedBy,
  JoinInputFieldSelections_0.environment_ID,
  JoinInputFieldSelections_0.function_ID,
  JoinInputFieldSelections_0.seq,
  JoinInputFieldSelections_0.sign_code,
  JoinInputFieldSelections_0.opt_code,
  JoinInputFieldSelections_0.low,
  JoinInputFieldSelections_0.high,
  JoinInputFieldSelections_0.ID,
  JoinInputFieldSelections_0.inputField_ID
FROM localized_de_JoinInputFieldSelections AS JoinInputFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_JoinInputFieldSelections AS SELECT
  JoinInputFieldSelections_0.createdAt,
  JoinInputFieldSelections_0.createdBy,
  JoinInputFieldSelections_0.modifiedAt,
  JoinInputFieldSelections_0.modifiedBy,
  JoinInputFieldSelections_0.environment_ID,
  JoinInputFieldSelections_0.function_ID,
  JoinInputFieldSelections_0.seq,
  JoinInputFieldSelections_0.sign_code,
  JoinInputFieldSelections_0.opt_code,
  JoinInputFieldSelections_0.low,
  JoinInputFieldSelections_0.high,
  JoinInputFieldSelections_0.ID,
  JoinInputFieldSelections_0.inputField_ID
FROM localized_fr_JoinInputFieldSelections AS JoinInputFieldSelections_0;

CREATE VIEW localized_de_ModelingService_QueryComponentFixSelections AS SELECT
  QueryComponentFixSelections_0.createdAt,
  QueryComponentFixSelections_0.createdBy,
  QueryComponentFixSelections_0.modifiedAt,
  QueryComponentFixSelections_0.modifiedBy,
  QueryComponentFixSelections_0.environment_ID,
  QueryComponentFixSelections_0.function_ID,
  QueryComponentFixSelections_0.seq,
  QueryComponentFixSelections_0.sign_code,
  QueryComponentFixSelections_0.opt_code,
  QueryComponentFixSelections_0.low,
  QueryComponentFixSelections_0.high,
  QueryComponentFixSelections_0.ID,
  QueryComponentFixSelections_0.component_ID
FROM localized_de_QueryComponentFixSelections AS QueryComponentFixSelections_0;

CREATE VIEW localized_fr_ModelingService_QueryComponentFixSelections AS SELECT
  QueryComponentFixSelections_0.createdAt,
  QueryComponentFixSelections_0.createdBy,
  QueryComponentFixSelections_0.modifiedAt,
  QueryComponentFixSelections_0.modifiedBy,
  QueryComponentFixSelections_0.environment_ID,
  QueryComponentFixSelections_0.function_ID,
  QueryComponentFixSelections_0.seq,
  QueryComponentFixSelections_0.sign_code,
  QueryComponentFixSelections_0.opt_code,
  QueryComponentFixSelections_0.low,
  QueryComponentFixSelections_0.high,
  QueryComponentFixSelections_0.ID,
  QueryComponentFixSelections_0.component_ID
FROM localized_fr_QueryComponentFixSelections AS QueryComponentFixSelections_0;

CREATE VIEW localized_de_ModelingService_QueryComponentSelections AS SELECT
  QueryComponentSelections_0.createdAt,
  QueryComponentSelections_0.createdBy,
  QueryComponentSelections_0.modifiedAt,
  QueryComponentSelections_0.modifiedBy,
  QueryComponentSelections_0.environment_ID,
  QueryComponentSelections_0.function_ID,
  QueryComponentSelections_0.seq,
  QueryComponentSelections_0.sign_code,
  QueryComponentSelections_0.opt_code,
  QueryComponentSelections_0.low,
  QueryComponentSelections_0.high,
  QueryComponentSelections_0.ID,
  QueryComponentSelections_0.component_ID
FROM localized_de_QueryComponentSelections AS QueryComponentSelections_0;

CREATE VIEW localized_fr_ModelingService_QueryComponentSelections AS SELECT
  QueryComponentSelections_0.createdAt,
  QueryComponentSelections_0.createdBy,
  QueryComponentSelections_0.modifiedAt,
  QueryComponentSelections_0.modifiedBy,
  QueryComponentSelections_0.environment_ID,
  QueryComponentSelections_0.function_ID,
  QueryComponentSelections_0.seq,
  QueryComponentSelections_0.sign_code,
  QueryComponentSelections_0.opt_code,
  QueryComponentSelections_0.low,
  QueryComponentSelections_0.high,
  QueryComponentSelections_0.ID,
  QueryComponentSelections_0.component_ID
FROM localized_fr_QueryComponentSelections AS QueryComponentSelections_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_de_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderFieldSelections AS SELECT
  AllocationRuleSenderFieldSelections_0.createdAt,
  AllocationRuleSenderFieldSelections_0.createdBy,
  AllocationRuleSenderFieldSelections_0.modifiedAt,
  AllocationRuleSenderFieldSelections_0.modifiedBy,
  AllocationRuleSenderFieldSelections_0.environment_ID,
  AllocationRuleSenderFieldSelections_0.function_ID,
  AllocationRuleSenderFieldSelections_0.seq,
  AllocationRuleSenderFieldSelections_0.sign_code,
  AllocationRuleSenderFieldSelections_0.opt_code,
  AllocationRuleSenderFieldSelections_0.low,
  AllocationRuleSenderFieldSelections_0.high,
  AllocationRuleSenderFieldSelections_0.ID,
  AllocationRuleSenderFieldSelections_0.field_ID
FROM localized_fr_AllocationRuleSenderFieldSelections AS AllocationRuleSenderFieldSelections_0;

CREATE VIEW localized_de_ModelingService_CalculationRuleConditionSelections AS SELECT
  CalculationRuleConditionSelections_0.createdAt,
  CalculationRuleConditionSelections_0.createdBy,
  CalculationRuleConditionSelections_0.modifiedAt,
  CalculationRuleConditionSelections_0.modifiedBy,
  CalculationRuleConditionSelections_0.environment_ID,
  CalculationRuleConditionSelections_0.function_ID,
  CalculationRuleConditionSelections_0.seq,
  CalculationRuleConditionSelections_0.sign_code,
  CalculationRuleConditionSelections_0.opt_code,
  CalculationRuleConditionSelections_0.low,
  CalculationRuleConditionSelections_0.high,
  CalculationRuleConditionSelections_0.ID,
  CalculationRuleConditionSelections_0.condition_ID
FROM localized_de_CalculationRuleConditionSelections AS CalculationRuleConditionSelections_0;

CREATE VIEW localized_fr_ModelingService_CalculationRuleConditionSelections AS SELECT
  CalculationRuleConditionSelections_0.createdAt,
  CalculationRuleConditionSelections_0.createdBy,
  CalculationRuleConditionSelections_0.modifiedAt,
  CalculationRuleConditionSelections_0.modifiedBy,
  CalculationRuleConditionSelections_0.environment_ID,
  CalculationRuleConditionSelections_0.function_ID,
  CalculationRuleConditionSelections_0.seq,
  CalculationRuleConditionSelections_0.sign_code,
  CalculationRuleConditionSelections_0.opt_code,
  CalculationRuleConditionSelections_0.low,
  CalculationRuleConditionSelections_0.high,
  CalculationRuleConditionSelections_0.ID,
  CalculationRuleConditionSelections_0.condition_ID
FROM localized_fr_CalculationRuleConditionSelections AS CalculationRuleConditionSelections_0;

CREATE VIEW localized_de_ModelingService_DerivationRuleConditionSelections AS SELECT
  DerivationRuleConditionSelections_0.createdAt,
  DerivationRuleConditionSelections_0.createdBy,
  DerivationRuleConditionSelections_0.modifiedAt,
  DerivationRuleConditionSelections_0.modifiedBy,
  DerivationRuleConditionSelections_0.environment_ID,
  DerivationRuleConditionSelections_0.function_ID,
  DerivationRuleConditionSelections_0.seq,
  DerivationRuleConditionSelections_0.sign_code,
  DerivationRuleConditionSelections_0.opt_code,
  DerivationRuleConditionSelections_0.low,
  DerivationRuleConditionSelections_0.high,
  DerivationRuleConditionSelections_0.ID,
  DerivationRuleConditionSelections_0.condition_ID
FROM localized_de_DerivationRuleConditionSelections AS DerivationRuleConditionSelections_0;

CREATE VIEW localized_fr_ModelingService_DerivationRuleConditionSelections AS SELECT
  DerivationRuleConditionSelections_0.createdAt,
  DerivationRuleConditionSelections_0.createdBy,
  DerivationRuleConditionSelections_0.modifiedAt,
  DerivationRuleConditionSelections_0.modifiedBy,
  DerivationRuleConditionSelections_0.environment_ID,
  DerivationRuleConditionSelections_0.function_ID,
  DerivationRuleConditionSelections_0.seq,
  DerivationRuleConditionSelections_0.sign_code,
  DerivationRuleConditionSelections_0.opt_code,
  DerivationRuleConditionSelections_0.low,
  DerivationRuleConditionSelections_0.high,
  DerivationRuleConditionSelections_0.ID,
  DerivationRuleConditionSelections_0.condition_ID
FROM localized_fr_DerivationRuleConditionSelections AS DerivationRuleConditionSelections_0;

CREATE VIEW localized_de_ModelingService_JoinRuleInputFieldSelections AS SELECT
  JoinRuleInputFieldSelections_0.createdAt,
  JoinRuleInputFieldSelections_0.createdBy,
  JoinRuleInputFieldSelections_0.modifiedAt,
  JoinRuleInputFieldSelections_0.modifiedBy,
  JoinRuleInputFieldSelections_0.environment_ID,
  JoinRuleInputFieldSelections_0.function_ID,
  JoinRuleInputFieldSelections_0.seq,
  JoinRuleInputFieldSelections_0.sign_code,
  JoinRuleInputFieldSelections_0.opt_code,
  JoinRuleInputFieldSelections_0.low,
  JoinRuleInputFieldSelections_0.high,
  JoinRuleInputFieldSelections_0.ID,
  JoinRuleInputFieldSelections_0.inputField_ID
FROM localized_de_JoinRuleInputFieldSelections AS JoinRuleInputFieldSelections_0;

CREATE VIEW localized_fr_ModelingService_JoinRuleInputFieldSelections AS SELECT
  JoinRuleInputFieldSelections_0.createdAt,
  JoinRuleInputFieldSelections_0.createdBy,
  JoinRuleInputFieldSelections_0.modifiedAt,
  JoinRuleInputFieldSelections_0.modifiedBy,
  JoinRuleInputFieldSelections_0.environment_ID,
  JoinRuleInputFieldSelections_0.function_ID,
  JoinRuleInputFieldSelections_0.seq,
  JoinRuleInputFieldSelections_0.sign_code,
  JoinRuleInputFieldSelections_0.opt_code,
  JoinRuleInputFieldSelections_0.low,
  JoinRuleInputFieldSelections_0.high,
  JoinRuleInputFieldSelections_0.ID,
  JoinRuleInputFieldSelections_0.inputField_ID
FROM localized_fr_JoinRuleInputFieldSelections AS JoinRuleInputFieldSelections_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateActivities AS SELECT
  CalculationUnitProcessTemplateActivities_0.createdAt,
  CalculationUnitProcessTemplateActivities_0.createdBy,
  CalculationUnitProcessTemplateActivities_0.modifiedAt,
  CalculationUnitProcessTemplateActivities_0.modifiedBy,
  CalculationUnitProcessTemplateActivities_0.environment_ID,
  CalculationUnitProcessTemplateActivities_0.ID,
  CalculationUnitProcessTemplateActivities_0.process_ID,
  CalculationUnitProcessTemplateActivities_0.activity,
  CalculationUnitProcessTemplateActivities_0.parent_ID,
  CalculationUnitProcessTemplateActivities_0.sequence,
  CalculationUnitProcessTemplateActivities_0.activityType_code,
  CalculationUnitProcessTemplateActivities_0.activityState_code,
  CalculationUnitProcessTemplateActivities_0.function_ID,
  CalculationUnitProcessTemplateActivities_0.performerGroup,
  CalculationUnitProcessTemplateActivities_0.reviewerGroup,
  CalculationUnitProcessTemplateActivities_0.startDate,
  CalculationUnitProcessTemplateActivities_0.endDate,
  CalculationUnitProcessTemplateActivities_0.url
FROM localized_de_CalculationUnitProcessTemplateActivities AS CalculationUnitProcessTemplateActivities_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateActivities AS SELECT
  CalculationUnitProcessTemplateActivities_0.createdAt,
  CalculationUnitProcessTemplateActivities_0.createdBy,
  CalculationUnitProcessTemplateActivities_0.modifiedAt,
  CalculationUnitProcessTemplateActivities_0.modifiedBy,
  CalculationUnitProcessTemplateActivities_0.environment_ID,
  CalculationUnitProcessTemplateActivities_0.ID,
  CalculationUnitProcessTemplateActivities_0.process_ID,
  CalculationUnitProcessTemplateActivities_0.activity,
  CalculationUnitProcessTemplateActivities_0.parent_ID,
  CalculationUnitProcessTemplateActivities_0.sequence,
  CalculationUnitProcessTemplateActivities_0.activityType_code,
  CalculationUnitProcessTemplateActivities_0.activityState_code,
  CalculationUnitProcessTemplateActivities_0.function_ID,
  CalculationUnitProcessTemplateActivities_0.performerGroup,
  CalculationUnitProcessTemplateActivities_0.reviewerGroup,
  CalculationUnitProcessTemplateActivities_0.startDate,
  CalculationUnitProcessTemplateActivities_0.endDate,
  CalculationUnitProcessTemplateActivities_0.url
FROM localized_fr_CalculationUnitProcessTemplateActivities AS CalculationUnitProcessTemplateActivities_0;

CREATE VIEW localized_de_ModelingService_JoinRulePredicates AS SELECT
  JoinRulePredicates_0.createdAt,
  JoinRulePredicates_0.createdBy,
  JoinRulePredicates_0.modifiedAt,
  JoinRulePredicates_0.modifiedBy,
  JoinRulePredicates_0.environment_ID,
  JoinRulePredicates_0.function_ID,
  JoinRulePredicates_0.ID,
  JoinRulePredicates_0.rule_ID,
  JoinRulePredicates_0.field_ID,
  JoinRulePredicates_0.comparison_code,
  JoinRulePredicates_0.joinRule_ID,
  JoinRulePredicates_0.joinField_ID,
  JoinRulePredicates_0.sequence
FROM localized_de_JoinRulePredicates AS JoinRulePredicates_0;

CREATE VIEW localized_fr_ModelingService_JoinRulePredicates AS SELECT
  JoinRulePredicates_0.createdAt,
  JoinRulePredicates_0.createdBy,
  JoinRulePredicates_0.modifiedAt,
  JoinRulePredicates_0.modifiedBy,
  JoinRulePredicates_0.environment_ID,
  JoinRulePredicates_0.function_ID,
  JoinRulePredicates_0.ID,
  JoinRulePredicates_0.rule_ID,
  JoinRulePredicates_0.field_ID,
  JoinRulePredicates_0.comparison_code,
  JoinRulePredicates_0.joinRule_ID,
  JoinRulePredicates_0.joinField_ID,
  JoinRulePredicates_0.sequence
FROM localized_fr_JoinRulePredicates AS JoinRulePredicates_0;

CREATE VIEW localized_de_ModelingService_RuntimePartitionRanges AS SELECT
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

CREATE VIEW localized_fr_ModelingService_RuntimePartitionRanges AS SELECT
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

CREATE VIEW localized_de_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_de_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_fr_ModelingService_CurrencyConversions AS SELECT
  currencyConversions_0.createdAt,
  currencyConversions_0.createdBy,
  currencyConversions_0.modifiedAt,
  currencyConversions_0.modifiedBy,
  currencyConversions_0.environment_ID,
  currencyConversions_0.ID,
  currencyConversions_0.currencyConversion,
  currencyConversions_0.description,
  currencyConversions_0.category_code,
  currencyConversions_0.method_code,
  currencyConversions_0.bidAskType_code,
  currencyConversions_0.marketDataArea,
  currencyConversions_0.type,
  currencyConversions_0.lookup_code,
  currencyConversions_0.errorHandling_code,
  currencyConversions_0.accuracy_code,
  currencyConversions_0.dateFormat_code,
  currencyConversions_0.steps_code,
  currencyConversions_0.configurationConnection_ID,
  currencyConversions_0.rateConnection_ID,
  currencyConversions_0.prefactorConnection_ID
FROM localized_fr_CurrencyConversions AS currencyConversions_0;

CREATE VIEW localized_de_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_de_UnitConversions AS unitConversions_0;

CREATE VIEW localized_fr_ModelingService_UnitConversions AS SELECT
  unitConversions_0.createdAt,
  unitConversions_0.createdBy,
  unitConversions_0.modifiedAt,
  unitConversions_0.modifiedBy,
  unitConversions_0.environment_ID,
  unitConversions_0.ID,
  unitConversions_0.unitConversion,
  unitConversions_0.description,
  unitConversions_0.errorHandling_code,
  unitConversions_0.rateConnection_ID,
  unitConversions_0.dimensionConnection_ID
FROM localized_fr_UnitConversions AS unitConversions_0;

CREATE VIEW localized_de_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_de_Partitions AS partitions_0;

CREATE VIEW localized_fr_ModelingService_Partitions AS SELECT
  partitions_0.createdAt,
  partitions_0.createdBy,
  partitions_0.modifiedAt,
  partitions_0.modifiedBy,
  partitions_0.environment_ID,
  partitions_0.ID,
  partitions_0."partition",
  partitions_0.description,
  partitions_0.field_ID
FROM localized_fr_Partitions AS partitions_0;

CREATE VIEW localized_de_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_de_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnits AS SELECT
  calculationUnits_0.createdAt,
  calculationUnits_0.createdBy,
  calculationUnits_0.modifiedAt,
  calculationUnits_0.modifiedBy,
  calculationUnits_0.environment_ID,
  calculationUnits_0.function_ID,
  calculationUnits_0.ID
FROM localized_fr_CalculationUnits AS calculationUnits_0;

CREATE VIEW localized_de_ModelingService_Queries AS SELECT
  queries_0.createdAt,
  queries_0.createdBy,
  queries_0.modifiedAt,
  queries_0.modifiedBy,
  queries_0.environment_ID,
  queries_0.function_ID,
  queries_0.ID,
  queries_0.Editable,
  queries_0.inputFunction_ID
FROM localized_de_Queries AS queries_0;

CREATE VIEW localized_fr_ModelingService_Queries AS SELECT
  queries_0.createdAt,
  queries_0.createdBy,
  queries_0.modifiedAt,
  queries_0.modifiedBy,
  queries_0.environment_ID,
  queries_0.function_ID,
  queries_0.ID,
  queries_0.Editable,
  queries_0.inputFunction_ID
FROM localized_fr_Queries AS queries_0;

CREATE VIEW localized_de_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_de_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_fr_ModelingService_FieldHierarchies AS SELECT
  FieldHierarchies_0.createdAt,
  FieldHierarchies_0.createdBy,
  FieldHierarchies_0.modifiedAt,
  FieldHierarchies_0.modifiedBy,
  FieldHierarchies_0.environment_ID,
  FieldHierarchies_0.field_ID,
  FieldHierarchies_0.ID,
  FieldHierarchies_0.hierarchy,
  FieldHierarchies_0.description
FROM localized_fr_FieldHierarchies AS FieldHierarchies_0;

CREATE VIEW localized_de_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_de_FieldValues AS FieldValues_0;

CREATE VIEW localized_fr_ModelingService_FieldValues AS SELECT
  FieldValues_0.createdAt,
  FieldValues_0.createdBy,
  FieldValues_0.modifiedAt,
  FieldValues_0.modifiedBy,
  FieldValues_0.environment_ID,
  FieldValues_0.field_ID,
  FieldValues_0.ID,
  FieldValues_0.value,
  FieldValues_0.isNode,
  FieldValues_0.description
FROM localized_fr_FieldValues AS FieldValues_0;

CREATE VIEW localized_de_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value
FROM localized_de_PartitionRanges AS PartitionRanges_0;

CREATE VIEW localized_fr_ModelingService_PartitionRanges AS SELECT
  PartitionRanges_0.createdAt,
  PartitionRanges_0.createdBy,
  PartitionRanges_0.modifiedAt,
  PartitionRanges_0.modifiedBy,
  PartitionRanges_0.environment_ID,
  PartitionRanges_0.ID,
  PartitionRanges_0.partition_ID,
  PartitionRanges_0."range",
  PartitionRanges_0.sequence,
  PartitionRanges_0.level,
  PartitionRanges_0.value
FROM localized_fr_PartitionRanges AS PartitionRanges_0;

CREATE VIEW localized_de_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_de_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationSelectionFields AS SELECT
  AllocationSelectionFields_0.createdAt,
  AllocationSelectionFields_0.createdBy,
  AllocationSelectionFields_0.modifiedAt,
  AllocationSelectionFields_0.modifiedBy,
  AllocationSelectionFields_0.environment_ID,
  AllocationSelectionFields_0.function_ID,
  AllocationSelectionFields_0.ID,
  AllocationSelectionFields_0.allocation_ID,
  AllocationSelectionFields_0.field_ID
FROM localized_fr_AllocationSelectionFields AS AllocationSelectionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_de_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationActionFields AS SELECT
  AllocationActionFields_0.createdAt,
  AllocationActionFields_0.createdBy,
  AllocationActionFields_0.modifiedAt,
  AllocationActionFields_0.modifiedBy,
  AllocationActionFields_0.environment_ID,
  AllocationActionFields_0.function_ID,
  AllocationActionFields_0.ID,
  AllocationActionFields_0.allocation_ID,
  AllocationActionFields_0.field_ID
FROM localized_fr_AllocationActionFields AS AllocationActionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_de_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverSelectionFields AS SELECT
  AllocationReceiverSelectionFields_0.createdAt,
  AllocationReceiverSelectionFields_0.createdBy,
  AllocationReceiverSelectionFields_0.modifiedAt,
  AllocationReceiverSelectionFields_0.modifiedBy,
  AllocationReceiverSelectionFields_0.environment_ID,
  AllocationReceiverSelectionFields_0.function_ID,
  AllocationReceiverSelectionFields_0.ID,
  AllocationReceiverSelectionFields_0.allocation_ID,
  AllocationReceiverSelectionFields_0.field_ID
FROM localized_fr_AllocationReceiverSelectionFields AS AllocationReceiverSelectionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_de_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationReceiverActionFields AS SELECT
  AllocationReceiverActionFields_0.createdAt,
  AllocationReceiverActionFields_0.createdBy,
  AllocationReceiverActionFields_0.modifiedAt,
  AllocationReceiverActionFields_0.modifiedBy,
  AllocationReceiverActionFields_0.environment_ID,
  AllocationReceiverActionFields_0.function_ID,
  AllocationReceiverActionFields_0.ID,
  AllocationReceiverActionFields_0.allocation_ID,
  AllocationReceiverActionFields_0.field_ID
FROM localized_fr_AllocationReceiverActionFields AS AllocationReceiverActionFields_0;

CREATE VIEW localized_de_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_de_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_fr_ModelingService_AllocationOffsets AS SELECT
  AllocationOffsets_0.createdAt,
  AllocationOffsets_0.createdBy,
  AllocationOffsets_0.modifiedAt,
  AllocationOffsets_0.modifiedBy,
  AllocationOffsets_0.environment_ID,
  AllocationOffsets_0.function_ID,
  AllocationOffsets_0.ID,
  AllocationOffsets_0.allocation_ID,
  AllocationOffsets_0.field_ID,
  AllocationOffsets_0.offsetField_ID
FROM localized_fr_AllocationOffsets AS AllocationOffsets_0;

CREATE VIEW localized_de_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_de_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_fr_ModelingService_AllocationDebitCredits AS SELECT
  AllocationDebitCredits_0.createdAt,
  AllocationDebitCredits_0.createdBy,
  AllocationDebitCredits_0.modifiedAt,
  AllocationDebitCredits_0.modifiedBy,
  AllocationDebitCredits_0.environment_ID,
  AllocationDebitCredits_0.function_ID,
  AllocationDebitCredits_0.ID,
  AllocationDebitCredits_0.allocation_ID,
  AllocationDebitCredits_0.field_ID,
  AllocationDebitCredits_0.debitSign,
  AllocationDebitCredits_0.creditSign,
  AllocationDebitCredits_0.sequence
FROM localized_fr_AllocationDebitCredits AS AllocationDebitCredits_0;

CREATE VIEW localized_de_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_de_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_fr_ModelingService_AllocationChecks AS SELECT
  AllocationChecks_0.createdAt,
  AllocationChecks_0.createdBy,
  AllocationChecks_0.modifiedAt,
  AllocationChecks_0.modifiedBy,
  AllocationChecks_0.environment_ID,
  AllocationChecks_0.function_ID,
  AllocationChecks_0.ID,
  AllocationChecks_0.allocation_ID,
  AllocationChecks_0.check_ID
FROM localized_fr_AllocationChecks AS AllocationChecks_0;

CREATE VIEW localized_de_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID,
  ModelTableFields_0.sourceField
FROM localized_de_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_fr_ModelingService_ModelTableFields AS SELECT
  ModelTableFields_0.createdAt,
  ModelTableFields_0.createdBy,
  ModelTableFields_0.modifiedAt,
  ModelTableFields_0.modifiedBy,
  ModelTableFields_0.environment_ID,
  ModelTableFields_0.field_ID,
  ModelTableFields_0.ID,
  ModelTableFields_0.modelTable_ID,
  ModelTableFields_0.sourceField
FROM localized_fr_ModelTableFields AS ModelTableFields_0;

CREATE VIEW localized_de_ModelingService_CalculationLookupFunctions AS SELECT
  CalculationLookupFunctions_0.createdAt,
  CalculationLookupFunctions_0.createdBy,
  CalculationLookupFunctions_0.modifiedAt,
  CalculationLookupFunctions_0.modifiedBy,
  CalculationLookupFunctions_0.environment_ID,
  CalculationLookupFunctions_0.function_ID,
  CalculationLookupFunctions_0.lookupFunction_ID,
  CalculationLookupFunctions_0.ID,
  CalculationLookupFunctions_0.calculation_ID
FROM localized_de_CalculationLookupFunctions AS CalculationLookupFunctions_0;

CREATE VIEW localized_fr_ModelingService_CalculationLookupFunctions AS SELECT
  CalculationLookupFunctions_0.createdAt,
  CalculationLookupFunctions_0.createdBy,
  CalculationLookupFunctions_0.modifiedAt,
  CalculationLookupFunctions_0.modifiedBy,
  CalculationLookupFunctions_0.environment_ID,
  CalculationLookupFunctions_0.function_ID,
  CalculationLookupFunctions_0.lookupFunction_ID,
  CalculationLookupFunctions_0.ID,
  CalculationLookupFunctions_0.calculation_ID
FROM localized_fr_CalculationLookupFunctions AS CalculationLookupFunctions_0;

CREATE VIEW localized_de_ModelingService_CalculationSignatureFields AS SELECT
  CalculationSignatureFields_0.createdAt,
  CalculationSignatureFields_0.createdBy,
  CalculationSignatureFields_0.modifiedAt,
  CalculationSignatureFields_0.modifiedBy,
  CalculationSignatureFields_0.environment_ID,
  CalculationSignatureFields_0.function_ID,
  CalculationSignatureFields_0.field_ID,
  CalculationSignatureFields_0.selection,
  CalculationSignatureFields_0."action",
  CalculationSignatureFields_0.granularity,
  CalculationSignatureFields_0.ID,
  CalculationSignatureFields_0.calculation_ID
FROM localized_de_CalculationSignatureFields AS CalculationSignatureFields_0;

CREATE VIEW localized_fr_ModelingService_CalculationSignatureFields AS SELECT
  CalculationSignatureFields_0.createdAt,
  CalculationSignatureFields_0.createdBy,
  CalculationSignatureFields_0.modifiedAt,
  CalculationSignatureFields_0.modifiedBy,
  CalculationSignatureFields_0.environment_ID,
  CalculationSignatureFields_0.function_ID,
  CalculationSignatureFields_0.field_ID,
  CalculationSignatureFields_0.selection,
  CalculationSignatureFields_0."action",
  CalculationSignatureFields_0.granularity,
  CalculationSignatureFields_0.ID,
  CalculationSignatureFields_0.calculation_ID
FROM localized_fr_CalculationSignatureFields AS CalculationSignatureFields_0;

CREATE VIEW localized_de_ModelingService_CalculationRules AS SELECT
  CalculationRules_0.createdAt,
  CalculationRules_0.createdBy,
  CalculationRules_0.modifiedAt,
  CalculationRules_0.modifiedBy,
  CalculationRules_0.environment_ID,
  CalculationRules_0.function_ID,
  CalculationRules_0.ID,
  CalculationRules_0.calculation_ID,
  CalculationRules_0.sequence,
  CalculationRules_0.description
FROM localized_de_CalculationRules AS CalculationRules_0;

CREATE VIEW localized_fr_ModelingService_CalculationRules AS SELECT
  CalculationRules_0.createdAt,
  CalculationRules_0.createdBy,
  CalculationRules_0.modifiedAt,
  CalculationRules_0.modifiedBy,
  CalculationRules_0.environment_ID,
  CalculationRules_0.function_ID,
  CalculationRules_0.ID,
  CalculationRules_0.calculation_ID,
  CalculationRules_0.sequence,
  CalculationRules_0.description
FROM localized_fr_CalculationRules AS CalculationRules_0;

CREATE VIEW localized_de_ModelingService_CalculationChecks AS SELECT
  CalculationChecks_0.createdAt,
  CalculationChecks_0.createdBy,
  CalculationChecks_0.modifiedAt,
  CalculationChecks_0.modifiedBy,
  CalculationChecks_0.environment_ID,
  CalculationChecks_0.function_ID,
  CalculationChecks_0.ID,
  CalculationChecks_0.calculation_ID,
  CalculationChecks_0.check_ID
FROM localized_de_CalculationChecks AS CalculationChecks_0;

CREATE VIEW localized_fr_ModelingService_CalculationChecks AS SELECT
  CalculationChecks_0.createdAt,
  CalculationChecks_0.createdBy,
  CalculationChecks_0.modifiedAt,
  CalculationChecks_0.modifiedBy,
  CalculationChecks_0.environment_ID,
  CalculationChecks_0.function_ID,
  CalculationChecks_0.ID,
  CalculationChecks_0.calculation_ID,
  CalculationChecks_0.check_ID
FROM localized_fr_CalculationChecks AS CalculationChecks_0;

CREATE VIEW localized_de_ModelingService_DerivationSignatureFields AS SELECT
  DerivationSignatureFields_0.createdAt,
  DerivationSignatureFields_0.createdBy,
  DerivationSignatureFields_0.modifiedAt,
  DerivationSignatureFields_0.modifiedBy,
  DerivationSignatureFields_0.environment_ID,
  DerivationSignatureFields_0.function_ID,
  DerivationSignatureFields_0.field_ID,
  DerivationSignatureFields_0.selection,
  DerivationSignatureFields_0."action",
  DerivationSignatureFields_0.granularity,
  DerivationSignatureFields_0.ID,
  DerivationSignatureFields_0.derivation_ID
FROM localized_de_DerivationSignatureFields AS DerivationSignatureFields_0;

CREATE VIEW localized_fr_ModelingService_DerivationSignatureFields AS SELECT
  DerivationSignatureFields_0.createdAt,
  DerivationSignatureFields_0.createdBy,
  DerivationSignatureFields_0.modifiedAt,
  DerivationSignatureFields_0.modifiedBy,
  DerivationSignatureFields_0.environment_ID,
  DerivationSignatureFields_0.function_ID,
  DerivationSignatureFields_0.field_ID,
  DerivationSignatureFields_0.selection,
  DerivationSignatureFields_0."action",
  DerivationSignatureFields_0.granularity,
  DerivationSignatureFields_0.ID,
  DerivationSignatureFields_0.derivation_ID
FROM localized_fr_DerivationSignatureFields AS DerivationSignatureFields_0;

CREATE VIEW localized_de_ModelingService_DerivationRules AS SELECT
  DerivationRules_0.createdAt,
  DerivationRules_0.createdBy,
  DerivationRules_0.modifiedAt,
  DerivationRules_0.modifiedBy,
  DerivationRules_0.environment_ID,
  DerivationRules_0.function_ID,
  DerivationRules_0.ID,
  DerivationRules_0.derivation_ID,
  DerivationRules_0.sequence,
  DerivationRules_0.description
FROM localized_de_DerivationRules AS DerivationRules_0;

CREATE VIEW localized_fr_ModelingService_DerivationRules AS SELECT
  DerivationRules_0.createdAt,
  DerivationRules_0.createdBy,
  DerivationRules_0.modifiedAt,
  DerivationRules_0.modifiedBy,
  DerivationRules_0.environment_ID,
  DerivationRules_0.function_ID,
  DerivationRules_0.ID,
  DerivationRules_0.derivation_ID,
  DerivationRules_0.sequence,
  DerivationRules_0.description
FROM localized_fr_DerivationRules AS DerivationRules_0;

CREATE VIEW localized_de_ModelingService_DerivationChecks AS SELECT
  DerivationChecks_0.createdAt,
  DerivationChecks_0.createdBy,
  DerivationChecks_0.modifiedAt,
  DerivationChecks_0.modifiedBy,
  DerivationChecks_0.environment_ID,
  DerivationChecks_0.function_ID,
  DerivationChecks_0.ID,
  DerivationChecks_0.derivation_ID,
  DerivationChecks_0.check_ID
FROM localized_de_DerivationChecks AS DerivationChecks_0;

CREATE VIEW localized_fr_ModelingService_DerivationChecks AS SELECT
  DerivationChecks_0.createdAt,
  DerivationChecks_0.createdBy,
  DerivationChecks_0.modifiedAt,
  DerivationChecks_0.modifiedBy,
  DerivationChecks_0.environment_ID,
  DerivationChecks_0.function_ID,
  DerivationChecks_0.ID,
  DerivationChecks_0.derivation_ID,
  DerivationChecks_0.check_ID
FROM localized_fr_DerivationChecks AS DerivationChecks_0;

CREATE VIEW localized_de_ModelingService_JoinSignatureFields AS SELECT
  JoinSignatureFields_0.createdAt,
  JoinSignatureFields_0.createdBy,
  JoinSignatureFields_0.modifiedAt,
  JoinSignatureFields_0.modifiedBy,
  JoinSignatureFields_0.environment_ID,
  JoinSignatureFields_0.function_ID,
  JoinSignatureFields_0.field_ID,
  JoinSignatureFields_0.selection,
  JoinSignatureFields_0."action",
  JoinSignatureFields_0.granularity,
  JoinSignatureFields_0.ID,
  JoinSignatureFields_0.Join_ID
FROM localized_de_JoinSignatureFields AS JoinSignatureFields_0;

CREATE VIEW localized_fr_ModelingService_JoinSignatureFields AS SELECT
  JoinSignatureFields_0.createdAt,
  JoinSignatureFields_0.createdBy,
  JoinSignatureFields_0.modifiedAt,
  JoinSignatureFields_0.modifiedBy,
  JoinSignatureFields_0.environment_ID,
  JoinSignatureFields_0.function_ID,
  JoinSignatureFields_0.field_ID,
  JoinSignatureFields_0.selection,
  JoinSignatureFields_0."action",
  JoinSignatureFields_0.granularity,
  JoinSignatureFields_0.ID,
  JoinSignatureFields_0.Join_ID
FROM localized_fr_JoinSignatureFields AS JoinSignatureFields_0;

CREATE VIEW localized_de_ModelingService_JoinChecks AS SELECT
  JoinChecks_0.createdAt,
  JoinChecks_0.createdBy,
  JoinChecks_0.modifiedAt,
  JoinChecks_0.modifiedBy,
  JoinChecks_0.environment_ID,
  JoinChecks_0.function_ID,
  JoinChecks_0.ID,
  JoinChecks_0.Join_ID,
  JoinChecks_0.check_ID
FROM localized_de_JoinChecks AS JoinChecks_0;

CREATE VIEW localized_fr_ModelingService_JoinChecks AS SELECT
  JoinChecks_0.createdAt,
  JoinChecks_0.createdBy,
  JoinChecks_0.modifiedAt,
  JoinChecks_0.modifiedBy,
  JoinChecks_0.environment_ID,
  JoinChecks_0.function_ID,
  JoinChecks_0.ID,
  JoinChecks_0.Join_ID,
  JoinChecks_0.check_ID
FROM localized_fr_JoinChecks AS JoinChecks_0;

CREATE VIEW localized_de_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_de_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_fr_ModelingService_FieldHierarchyStructures AS SELECT
  FieldHierarchyStructures_0.createdAt,
  FieldHierarchyStructures_0.createdBy,
  FieldHierarchyStructures_0.modifiedAt,
  FieldHierarchyStructures_0.modifiedBy,
  FieldHierarchyStructures_0.environment_ID,
  FieldHierarchyStructures_0.field_ID,
  FieldHierarchyStructures_0.ID,
  FieldHierarchyStructures_0.sequence,
  FieldHierarchyStructures_0.hierarchy_ID,
  FieldHierarchyStructures_0.value_ID,
  FieldHierarchyStructures_0.parentValue_ID
FROM localized_fr_FieldHierarchyStructures AS FieldHierarchyStructures_0;

CREATE VIEW localized_de_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_de_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_fr_ModelingService_FieldValueAuthorizations AS SELECT
  FieldValueAuthorizations_0.createdAt,
  FieldValueAuthorizations_0.createdBy,
  FieldValueAuthorizations_0.modifiedAt,
  FieldValueAuthorizations_0.modifiedBy,
  FieldValueAuthorizations_0.environment_ID,
  FieldValueAuthorizations_0.field_ID,
  FieldValueAuthorizations_0.ID,
  FieldValueAuthorizations_0.value_ID,
  FieldValueAuthorizations_0.userGrp,
  FieldValueAuthorizations_0.readAccess,
  FieldValueAuthorizations_0.writeAccess
FROM localized_fr_FieldValueAuthorizations AS FieldValueAuthorizations_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_de_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleSenderValueFields AS SELECT
  AllocationRuleSenderValueFields_0.createdAt,
  AllocationRuleSenderValueFields_0.createdBy,
  AllocationRuleSenderValueFields_0.modifiedAt,
  AllocationRuleSenderValueFields_0.modifiedBy,
  AllocationRuleSenderValueFields_0.environment_ID,
  AllocationRuleSenderValueFields_0.function_ID,
  AllocationRuleSenderValueFields_0.ID,
  AllocationRuleSenderValueFields_0.rule_ID,
  AllocationRuleSenderValueFields_0.field_ID
FROM localized_fr_AllocationRuleSenderValueFields AS AllocationRuleSenderValueFields_0;

CREATE VIEW localized_de_ModelingService_CalculationRuleConditions AS SELECT
  CalculationRuleConditions_0.createdAt,
  CalculationRuleConditions_0.createdBy,
  CalculationRuleConditions_0.modifiedAt,
  CalculationRuleConditions_0.modifiedBy,
  CalculationRuleConditions_0.environment_ID,
  CalculationRuleConditions_0.function_ID,
  CalculationRuleConditions_0.ID,
  CalculationRuleConditions_0.rule_ID,
  CalculationRuleConditions_0.field_ID
FROM localized_de_CalculationRuleConditions AS CalculationRuleConditions_0;

CREATE VIEW localized_fr_ModelingService_CalculationRuleConditions AS SELECT
  CalculationRuleConditions_0.createdAt,
  CalculationRuleConditions_0.createdBy,
  CalculationRuleConditions_0.modifiedAt,
  CalculationRuleConditions_0.modifiedBy,
  CalculationRuleConditions_0.environment_ID,
  CalculationRuleConditions_0.function_ID,
  CalculationRuleConditions_0.ID,
  CalculationRuleConditions_0.rule_ID,
  CalculationRuleConditions_0.field_ID
FROM localized_fr_CalculationRuleConditions AS CalculationRuleConditions_0;

CREATE VIEW localized_de_ModelingService_CalculationRuleActions AS SELECT
  CalculationRuleActions_0.createdAt,
  CalculationRuleActions_0.createdBy,
  CalculationRuleActions_0.modifiedAt,
  CalculationRuleActions_0.modifiedBy,
  CalculationRuleActions_0.environment_ID,
  CalculationRuleActions_0.function_ID,
  CalculationRuleActions_0.formula,
  CalculationRuleActions_0.ID,
  CalculationRuleActions_0.rule_ID,
  CalculationRuleActions_0.field_ID
FROM localized_de_CalculationRuleActions AS CalculationRuleActions_0;

CREATE VIEW localized_fr_ModelingService_CalculationRuleActions AS SELECT
  CalculationRuleActions_0.createdAt,
  CalculationRuleActions_0.createdBy,
  CalculationRuleActions_0.modifiedAt,
  CalculationRuleActions_0.modifiedBy,
  CalculationRuleActions_0.environment_ID,
  CalculationRuleActions_0.function_ID,
  CalculationRuleActions_0.formula,
  CalculationRuleActions_0.ID,
  CalculationRuleActions_0.rule_ID,
  CalculationRuleActions_0.field_ID
FROM localized_fr_CalculationRuleActions AS CalculationRuleActions_0;

CREATE VIEW localized_de_ModelingService_DerivationRuleConditions AS SELECT
  DerivationRuleConditions_0.createdAt,
  DerivationRuleConditions_0.createdBy,
  DerivationRuleConditions_0.modifiedAt,
  DerivationRuleConditions_0.modifiedBy,
  DerivationRuleConditions_0.environment_ID,
  DerivationRuleConditions_0.function_ID,
  DerivationRuleConditions_0.ID,
  DerivationRuleConditions_0.rule_ID,
  DerivationRuleConditions_0.field_ID
FROM localized_de_DerivationRuleConditions AS DerivationRuleConditions_0;

CREATE VIEW localized_fr_ModelingService_DerivationRuleConditions AS SELECT
  DerivationRuleConditions_0.createdAt,
  DerivationRuleConditions_0.createdBy,
  DerivationRuleConditions_0.modifiedAt,
  DerivationRuleConditions_0.modifiedBy,
  DerivationRuleConditions_0.environment_ID,
  DerivationRuleConditions_0.function_ID,
  DerivationRuleConditions_0.ID,
  DerivationRuleConditions_0.rule_ID,
  DerivationRuleConditions_0.field_ID
FROM localized_fr_DerivationRuleConditions AS DerivationRuleConditions_0;

CREATE VIEW localized_de_ModelingService_DerivationRuleActions AS SELECT
  DerivationRuleActions_0.createdAt,
  DerivationRuleActions_0.createdBy,
  DerivationRuleActions_0.modifiedAt,
  DerivationRuleActions_0.modifiedBy,
  DerivationRuleActions_0.environment_ID,
  DerivationRuleActions_0.function_ID,
  DerivationRuleActions_0.formula,
  DerivationRuleActions_0.ID,
  DerivationRuleActions_0.rule_ID,
  DerivationRuleActions_0.field_ID
FROM localized_de_DerivationRuleActions AS DerivationRuleActions_0;

CREATE VIEW localized_fr_ModelingService_DerivationRuleActions AS SELECT
  DerivationRuleActions_0.createdAt,
  DerivationRuleActions_0.createdBy,
  DerivationRuleActions_0.modifiedAt,
  DerivationRuleActions_0.modifiedBy,
  DerivationRuleActions_0.environment_ID,
  DerivationRuleActions_0.function_ID,
  DerivationRuleActions_0.formula,
  DerivationRuleActions_0.ID,
  DerivationRuleActions_0.rule_ID,
  DerivationRuleActions_0.field_ID
FROM localized_fr_DerivationRuleActions AS DerivationRuleActions_0;

CREATE VIEW localized_de_ModelingService_CalculationUnitProcessTemplateActivityChecks AS SELECT
  CalculationUnitProcessTemplateActivityChecks_0.createdAt,
  CalculationUnitProcessTemplateActivityChecks_0.createdBy,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedAt,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedBy,
  CalculationUnitProcessTemplateActivityChecks_0.environment_ID,
  CalculationUnitProcessTemplateActivityChecks_0.function_ID,
  CalculationUnitProcessTemplateActivityChecks_0.ID,
  CalculationUnitProcessTemplateActivityChecks_0.activity_ID,
  CalculationUnitProcessTemplateActivityChecks_0.check_ID
FROM localized_de_CalculationUnitProcessTemplateActivityChecks AS CalculationUnitProcessTemplateActivityChecks_0;

CREATE VIEW localized_fr_ModelingService_CalculationUnitProcessTemplateActivityChecks AS SELECT
  CalculationUnitProcessTemplateActivityChecks_0.createdAt,
  CalculationUnitProcessTemplateActivityChecks_0.createdBy,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedAt,
  CalculationUnitProcessTemplateActivityChecks_0.modifiedBy,
  CalculationUnitProcessTemplateActivityChecks_0.environment_ID,
  CalculationUnitProcessTemplateActivityChecks_0.function_ID,
  CalculationUnitProcessTemplateActivityChecks_0.ID,
  CalculationUnitProcessTemplateActivityChecks_0.activity_ID,
  CalculationUnitProcessTemplateActivityChecks_0.check_ID
FROM localized_fr_CalculationUnitProcessTemplateActivityChecks AS CalculationUnitProcessTemplateActivityChecks_0;

CREATE VIEW localized_de_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_de_CheckFields AS CheckFields_0;

CREATE VIEW localized_fr_ModelingService_CheckFields AS SELECT
  CheckFields_0.createdAt,
  CheckFields_0.createdBy,
  CheckFields_0.modifiedAt,
  CheckFields_0.modifiedBy,
  CheckFields_0.ID,
  CheckFields_0.check_ID,
  CheckFields_0.field_ID
FROM localized_fr_CheckFields AS CheckFields_0;

CREATE VIEW localized_de_ModelingService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_de_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_fr_ModelingService_RuntimeProcessChains AS SELECT
  RuntimeProcessChains_0.createdAt,
  RuntimeProcessChains_0.createdBy,
  RuntimeProcessChains_0.modifiedAt,
  RuntimeProcessChains_0.modifiedBy,
  RuntimeProcessChains_0.ID,
  RuntimeProcessChains_0.function_ID,
  RuntimeProcessChains_0.level
FROM localized_fr_RuntimeProcessChains AS RuntimeProcessChains_0;

CREATE VIEW localized_de_ModelingService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_de_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_fr_ModelingService_RuntimeInputFunctions AS SELECT
  RuntimeInputFunctions_0.createdAt,
  RuntimeInputFunctions_0.createdBy,
  RuntimeInputFunctions_0.modifiedAt,
  RuntimeInputFunctions_0.modifiedBy,
  RuntimeInputFunctions_0.ID,
  RuntimeInputFunctions_0.function_ID,
  RuntimeInputFunctions_0.inputFunction_ID
FROM localized_fr_RuntimeInputFunctions AS RuntimeInputFunctions_0;

CREATE VIEW localized_de_ModelingService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_de_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_fr_ModelingService_RuntimeProcessChainFunctions AS SELECT
  RuntimeProcessChainFunctions_0.createdAt,
  RuntimeProcessChainFunctions_0.createdBy,
  RuntimeProcessChainFunctions_0.modifiedAt,
  RuntimeProcessChainFunctions_0.modifiedBy,
  RuntimeProcessChainFunctions_0.ID,
  RuntimeProcessChainFunctions_0.processChain_ID,
  RuntimeProcessChainFunctions_0.function_ID
FROM localized_fr_RuntimeProcessChainFunctions AS RuntimeProcessChainFunctions_0;

CREATE VIEW localized_de_ModelingService_ApplicationLogStatistics AS SELECT
  ApplicationLogStatistics_0.createdAt,
  ApplicationLogStatistics_0.createdBy,
  ApplicationLogStatistics_0.modifiedAt,
  ApplicationLogStatistics_0.modifiedBy,
  ApplicationLogStatistics_0.ID,
  ApplicationLogStatistics_0.applicationLog_ID,
  ApplicationLogStatistics_0.function,
  ApplicationLogStatistics_0.startTimestamp,
  ApplicationLogStatistics_0.endTimestamp,
  ApplicationLogStatistics_0.inputRecords,
  ApplicationLogStatistics_0.resultRecords,
  ApplicationLogStatistics_0.successRecords,
  ApplicationLogStatistics_0.warningRecords,
  ApplicationLogStatistics_0.errorRecords,
  ApplicationLogStatistics_0.abortRecords,
  ApplicationLogStatistics_0.inputDuration,
  ApplicationLogStatistics_0.processingDuration,
  ApplicationLogStatistics_0.outputDuration
FROM localized_de_ApplicationLogStatistics AS ApplicationLogStatistics_0;

CREATE VIEW localized_fr_ModelingService_ApplicationLogStatistics AS SELECT
  ApplicationLogStatistics_0.createdAt,
  ApplicationLogStatistics_0.createdBy,
  ApplicationLogStatistics_0.modifiedAt,
  ApplicationLogStatistics_0.modifiedBy,
  ApplicationLogStatistics_0.ID,
  ApplicationLogStatistics_0.applicationLog_ID,
  ApplicationLogStatistics_0.function,
  ApplicationLogStatistics_0.startTimestamp,
  ApplicationLogStatistics_0.endTimestamp,
  ApplicationLogStatistics_0.inputRecords,
  ApplicationLogStatistics_0.resultRecords,
  ApplicationLogStatistics_0.successRecords,
  ApplicationLogStatistics_0.warningRecords,
  ApplicationLogStatistics_0.errorRecords,
  ApplicationLogStatistics_0.abortRecords,
  ApplicationLogStatistics_0.inputDuration,
  ApplicationLogStatistics_0.processingDuration,
  ApplicationLogStatistics_0.outputDuration
FROM localized_fr_ApplicationLogStatistics AS ApplicationLogStatistics_0;

CREATE VIEW localized_de_ModelingService_EnvironmentFolders AS SELECT
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

CREATE VIEW localized_fr_ModelingService_EnvironmentFolders AS SELECT
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

CREATE VIEW localized_de_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_de_UnitFields AS UnitFields_0;

CREATE VIEW localized_fr_ModelingService_UnitFields AS SELECT
  UnitFields_0.createdAt,
  UnitFields_0.createdBy,
  UnitFields_0.modifiedAt,
  UnitFields_0.modifiedBy,
  UnitFields_0.environment_ID,
  UnitFields_0.ID,
  UnitFields_0.field,
  UnitFields_0.class_code,
  UnitFields_0.type_code,
  UnitFields_0.hanaDataType_code,
  UnitFields_0.dataLength,
  UnitFields_0.dataDecimals,
  UnitFields_0.unitField_ID,
  UnitFields_0.isLowercase,
  UnitFields_0.hasMasterData,
  UnitFields_0.hasHierarchies,
  UnitFields_0.calculationHierarchy_ID,
  UnitFields_0.masterDataQuery_ID,
  UnitFields_0.description,
  UnitFields_0.documentation
FROM localized_fr_UnitFields AS UnitFields_0;

CREATE VIEW localized_de_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_de_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationCycleIterationFields AS SELECT
  AllocationCycleIterationFields_0.createdAt,
  AllocationCycleIterationFields_0.createdBy,
  AllocationCycleIterationFields_0.modifiedAt,
  AllocationCycleIterationFields_0.modifiedBy,
  AllocationCycleIterationFields_0.environment_ID,
  AllocationCycleIterationFields_0.ID,
  AllocationCycleIterationFields_0.field,
  AllocationCycleIterationFields_0.class_code,
  AllocationCycleIterationFields_0.type_code,
  AllocationCycleIterationFields_0.hanaDataType_code,
  AllocationCycleIterationFields_0.dataLength,
  AllocationCycleIterationFields_0.dataDecimals,
  AllocationCycleIterationFields_0.unitField_ID,
  AllocationCycleIterationFields_0.isLowercase,
  AllocationCycleIterationFields_0.hasMasterData,
  AllocationCycleIterationFields_0.hasHierarchies,
  AllocationCycleIterationFields_0.calculationHierarchy_ID,
  AllocationCycleIterationFields_0.masterDataQuery_ID,
  AllocationCycleIterationFields_0.description,
  AllocationCycleIterationFields_0.documentation
FROM localized_fr_AllocationCycleIterationFields AS AllocationCycleIterationFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_de_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermIterationFields AS SELECT
  AllocationTermIterationFields_0.createdAt,
  AllocationTermIterationFields_0.createdBy,
  AllocationTermIterationFields_0.modifiedAt,
  AllocationTermIterationFields_0.modifiedBy,
  AllocationTermIterationFields_0.environment_ID,
  AllocationTermIterationFields_0.ID,
  AllocationTermIterationFields_0.field,
  AllocationTermIterationFields_0.class_code,
  AllocationTermIterationFields_0.type_code,
  AllocationTermIterationFields_0.hanaDataType_code,
  AllocationTermIterationFields_0.dataLength,
  AllocationTermIterationFields_0.dataDecimals,
  AllocationTermIterationFields_0.unitField_ID,
  AllocationTermIterationFields_0.isLowercase,
  AllocationTermIterationFields_0.hasMasterData,
  AllocationTermIterationFields_0.hasHierarchies,
  AllocationTermIterationFields_0.calculationHierarchy_ID,
  AllocationTermIterationFields_0.masterDataQuery_ID,
  AllocationTermIterationFields_0.description,
  AllocationTermIterationFields_0.documentation
FROM localized_fr_AllocationTermIterationFields AS AllocationTermIterationFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_de_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermYearFields AS SELECT
  AllocationTermYearFields_0.createdAt,
  AllocationTermYearFields_0.createdBy,
  AllocationTermYearFields_0.modifiedAt,
  AllocationTermYearFields_0.modifiedBy,
  AllocationTermYearFields_0.environment_ID,
  AllocationTermYearFields_0.ID,
  AllocationTermYearFields_0.field,
  AllocationTermYearFields_0.class_code,
  AllocationTermYearFields_0.type_code,
  AllocationTermYearFields_0.hanaDataType_code,
  AllocationTermYearFields_0.dataLength,
  AllocationTermYearFields_0.dataDecimals,
  AllocationTermYearFields_0.unitField_ID,
  AllocationTermYearFields_0.isLowercase,
  AllocationTermYearFields_0.hasMasterData,
  AllocationTermYearFields_0.hasHierarchies,
  AllocationTermYearFields_0.calculationHierarchy_ID,
  AllocationTermYearFields_0.masterDataQuery_ID,
  AllocationTermYearFields_0.description,
  AllocationTermYearFields_0.documentation
FROM localized_fr_AllocationTermYearFields AS AllocationTermYearFields_0;

CREATE VIEW localized_de_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_de_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationTermFields AS SELECT
  AllocationTermFields_0.createdAt,
  AllocationTermFields_0.createdBy,
  AllocationTermFields_0.modifiedAt,
  AllocationTermFields_0.modifiedBy,
  AllocationTermFields_0.environment_ID,
  AllocationTermFields_0.ID,
  AllocationTermFields_0.field,
  AllocationTermFields_0.class_code,
  AllocationTermFields_0.type_code,
  AllocationTermFields_0.hanaDataType_code,
  AllocationTermFields_0.dataLength,
  AllocationTermFields_0.dataDecimals,
  AllocationTermFields_0.unitField_ID,
  AllocationTermFields_0.isLowercase,
  AllocationTermFields_0.hasMasterData,
  AllocationTermFields_0.hasHierarchies,
  AllocationTermFields_0.calculationHierarchy_ID,
  AllocationTermFields_0.masterDataQuery_ID,
  AllocationTermFields_0.description,
  AllocationTermFields_0.documentation
FROM localized_fr_AllocationTermFields AS AllocationTermFields_0;

CREATE VIEW localized_de_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_de_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_fr_ModelingService_AllocationRuleDriverResultFields AS SELECT
  AllocationRuleDriverResultFields_0.createdAt,
  AllocationRuleDriverResultFields_0.createdBy,
  AllocationRuleDriverResultFields_0.modifiedAt,
  AllocationRuleDriverResultFields_0.modifiedBy,
  AllocationRuleDriverResultFields_0.environment_ID,
  AllocationRuleDriverResultFields_0.ID,
  AllocationRuleDriverResultFields_0.field,
  AllocationRuleDriverResultFields_0.class_code,
  AllocationRuleDriverResultFields_0.type_code,
  AllocationRuleDriverResultFields_0.hanaDataType_code,
  AllocationRuleDriverResultFields_0.dataLength,
  AllocationRuleDriverResultFields_0.dataDecimals,
  AllocationRuleDriverResultFields_0.unitField_ID,
  AllocationRuleDriverResultFields_0.isLowercase,
  AllocationRuleDriverResultFields_0.hasMasterData,
  AllocationRuleDriverResultFields_0.hasHierarchies,
  AllocationRuleDriverResultFields_0.calculationHierarchy_ID,
  AllocationRuleDriverResultFields_0.masterDataQuery_ID,
  AllocationRuleDriverResultFields_0.description,
  AllocationRuleDriverResultFields_0.documentation
FROM localized_fr_AllocationRuleDriverResultFields AS AllocationRuleDriverResultFields_0;

CREATE VIEW localized_de_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_de_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_fr_ModelingService_AllocationEarlyExitChecks AS SELECT
  AllocationEarlyExitChecks_0.createdAt,
  AllocationEarlyExitChecks_0.createdBy,
  AllocationEarlyExitChecks_0.modifiedAt,
  AllocationEarlyExitChecks_0.modifiedBy,
  AllocationEarlyExitChecks_0.environment_ID,
  AllocationEarlyExitChecks_0.ID,
  AllocationEarlyExitChecks_0."check",
  AllocationEarlyExitChecks_0.messageType_code,
  AllocationEarlyExitChecks_0.category_code,
  AllocationEarlyExitChecks_0.description
FROM localized_fr_AllocationEarlyExitChecks AS AllocationEarlyExitChecks_0;

CREATE VIEW localized_de_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_de_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_fr_ModelingService_MasterDataQueries AS SELECT
  MasterDataQueries_0.createdAt,
  MasterDataQueries_0.createdBy,
  MasterDataQueries_0.modifiedAt,
  MasterDataQueries_0.modifiedBy,
  MasterDataQueries_0.environment_ID,
  MasterDataQueries_0.ID,
  MasterDataQueries_0.function,
  MasterDataQueries_0.sequence,
  MasterDataQueries_0.parent_ID,
  MasterDataQueries_0.type_code,
  MasterDataQueries_0.description,
  MasterDataQueries_0.documentation
FROM localized_fr_MasterDataQueries AS MasterDataQueries_0;

CREATE VIEW localized_de_ModelingService_FunctionParentFunctionsVH AS SELECT
  FunctionParentFunctionsVH_0.createdAt,
  FunctionParentFunctionsVH_0.createdBy,
  FunctionParentFunctionsVH_0.modifiedAt,
  FunctionParentFunctionsVH_0.modifiedBy,
  FunctionParentFunctionsVH_0.environment_ID,
  FunctionParentFunctionsVH_0.ID,
  FunctionParentFunctionsVH_0.function,
  FunctionParentFunctionsVH_0.sequence,
  FunctionParentFunctionsVH_0.parent_ID,
  FunctionParentFunctionsVH_0.type_code,
  FunctionParentFunctionsVH_0.description,
  FunctionParentFunctionsVH_0.documentation
FROM localized_de_FunctionParentFunctionsVH AS FunctionParentFunctionsVH_0;

CREATE VIEW localized_fr_ModelingService_FunctionParentFunctionsVH AS SELECT
  FunctionParentFunctionsVH_0.createdAt,
  FunctionParentFunctionsVH_0.createdBy,
  FunctionParentFunctionsVH_0.modifiedAt,
  FunctionParentFunctionsVH_0.modifiedBy,
  FunctionParentFunctionsVH_0.environment_ID,
  FunctionParentFunctionsVH_0.ID,
  FunctionParentFunctionsVH_0.function,
  FunctionParentFunctionsVH_0.sequence,
  FunctionParentFunctionsVH_0.parent_ID,
  FunctionParentFunctionsVH_0.type_code,
  FunctionParentFunctionsVH_0.description,
  FunctionParentFunctionsVH_0.documentation
FROM localized_fr_FunctionParentFunctionsVH AS FunctionParentFunctionsVH_0;

CREATE VIEW localized_de_ModelingService_FunctionResultFunctionsVH AS SELECT
  FunctionResultFunctionsVH_0.createdAt,
  FunctionResultFunctionsVH_0.createdBy,
  FunctionResultFunctionsVH_0.modifiedAt,
  FunctionResultFunctionsVH_0.modifiedBy,
  FunctionResultFunctionsVH_0.environment_ID,
  FunctionResultFunctionsVH_0.ID,
  FunctionResultFunctionsVH_0.function,
  FunctionResultFunctionsVH_0.sequence,
  FunctionResultFunctionsVH_0.parent_ID,
  FunctionResultFunctionsVH_0.type_code,
  FunctionResultFunctionsVH_0.description,
  FunctionResultFunctionsVH_0.documentation
FROM localized_de_FunctionResultFunctionsVH AS FunctionResultFunctionsVH_0;

CREATE VIEW localized_fr_ModelingService_FunctionResultFunctionsVH AS SELECT
  FunctionResultFunctionsVH_0.createdAt,
  FunctionResultFunctionsVH_0.createdBy,
  FunctionResultFunctionsVH_0.modifiedAt,
  FunctionResultFunctionsVH_0.modifiedBy,
  FunctionResultFunctionsVH_0.environment_ID,
  FunctionResultFunctionsVH_0.ID,
  FunctionResultFunctionsVH_0.function,
  FunctionResultFunctionsVH_0.sequence,
  FunctionResultFunctionsVH_0.parent_ID,
  FunctionResultFunctionsVH_0.type_code,
  FunctionResultFunctionsVH_0.description,
  FunctionResultFunctionsVH_0.documentation
FROM localized_fr_FunctionResultFunctionsVH AS FunctionResultFunctionsVH_0;
