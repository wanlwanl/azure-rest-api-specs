import "@typespec/rest";
import "@typespec/http";

using TypeSpec.Rest;
using TypeSpec.Http;

namespace Microsoft.ApiCenter;

interface Operations extends Azure.ResourceManager.Operations {}

@doc("The odata filter")
model OdataFilterParameter {
  @doc("OData filter parameter.")
  @query("$filter")
  filter?: string;
}

/** The expected types of origin */
enum Origin {
  /** Origin with User */
  user,

  /** Origin with System */
  system,

  /** Origin with user and system */
  `user,system`,
}

/** The type of action */
enum ActionType {
  /** an internal action */
  Internal,
}

/** The provisioning state of the resource */
enum ProvisioningState {
  ...Azure.ResourceManager.ResourceProvisioningState,
}

/** The type of managed service identity */
enum ManagedServiceIdentityType {
  /** No identity */
  None,

  /** Assigned by the system */
  SystemAssigned,

  /** assigned by the user */
  UserAssigned,

  /** Both system-assigned and user-assigned identities */
  `SystemAssigned,UserAssigned`,
}

/** How the resource was created */
enum CreatedByType {
  /** Created by user */
  User,

  /** Created by Application */
  Application,

  /** Created by Managed Identity */
  ManagedIdentity,

  /** Created By Key */
  Key,
}

/** Assignment entity for Metadata */
enum MetadataAssignmentEntity {
  /** Assigned to API */
  api,

  /** Assigned to Environment */
  environment,

  /** Assigned to Deployment */
  deployment,
}

/** The format for schema export */
enum MetadataSchemaExportFormat {
  @doc("The inlined content of a schema document.")
  inline,

  @doc("The link to a schema document. The URL is valid for 5 minutes.")
  link,
}

/** The kind of the API */
enum ApiKind {
  /** A Representational State Transfer Api */
  rest,

  /** A Graph query language Api */
  graphql,

  /** A gRPC Api */
  grpc,

  /** A SOAP Api */
  soap,

  /** Web Hook */
  webhook,

  /** Web Socket */
  websocket,
}

/** The stage of the Api development lifecycle */
enum LifecycleStage {
  /** design stage */
  design,

  /** development stage */
  development,

  /** testing stage */
  testing,

  /** In preview */
  preview,

  /** In production */
  production,

  /** deprecated stage */
  deprecated,

  /** Retired stage */
  retired,
}

/** Source format for imported Api spec */
enum ApiSpecImportSourceFormat {
  @doc("The inlined content of a specification document.") inline,

  @doc("""
The link to a specification document hosted on a publicly accessible internet
address.
""")
  link,
}

/** Result format for exported Api spec */
enum ApiSpecExportResultFormat {
  @doc("The inlined content of a specification document.") inline,

  @doc("The link to the result of the export operation. The URL is valid for 5 minutes.")
  link,
}

/** State of the Deployment */
enum DeploymentState {
  /** Active State */
  active,

  /** Inactive State */
  inactive,
}

/** The kind of environment */
enum EnvironmentKind {
  /** Development environment */
  development,

  /** Testing environment */
  testing,

  /** Staging environment */
  staging,

  /** Production environment */
  production,
}

/** The type of environment server */
enum EnvironmentServerType {
  /** Api Management Server */
  `Azure API Management`,

  /** Compute server */
  `Azure compute service`,

  /** Apigee server */
  `Apigee API Management`,

  /** AWS Api Gateway server */
  `AWS API Gateway`,

  /** Kong API Gateway server */
  `Kong API Gateway`,

  /** Kubernetes server */
  Kubernetes,

  /** Mulesoft Api Management server */
  `MuleSoft API Management`,
}

@doc("The properties of the service.")
model ServiceProperties {
  @doc("Provisioning state of the service.")
  @visibility("read")
  provisioningState?: ProvisioningState;
}

@doc("The metadata schema export request.")
model MetadataSchemaExportRequest {
  @doc("An entity the metadata schema is requested for.")
  assignedTo?: MetadataAssignmentEntity;
}

@doc("The metadata schema export result.")
model MetadataSchemaExportResult {
  @doc("The export format for the schema")
  format?: MetadataSchemaExportFormat;

  @doc("The result of the export operation.")
  value?: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("Metadata schema properties.")
model MetadataSchemaProperties {
  @doc("The schema defining the type.")
  schema: string;

  @doc("The assignees")
  assignedTo?: MetadataAssignment[];
}

@doc("Assignment metadata")
model MetadataAssignment {
  @doc("The entities this metadata schema component gets applied to.")
  entity?: MetadataAssignmentEntity;

  @doc("Required assignment")
  required?: boolean;

  @doc("Deprecated assignment")
  deprecated?: boolean;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("Workspace properties.")
model WorkspaceProperties {
  @doc("Workspace title.")
  @maxLength(50)
  @minLength(1)
  title: string;

  @doc("Workspace description.")
  description?: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("API properties.")
model ApiProperties {
  @doc("API title.")
  @maxLength(50)
  @minLength(1)
  title: string;

  @doc("Kind of API. For example, REST or GraphQL.")
  kind: ApiKind;

  @doc("Description of the API.")
  @maxLength(1000)
  description?: string;

  @doc("Short description of the API.")
  @maxLength(200)
  summary?: string;

  @doc("Current lifecycle stage of the API.")
  @visibility("read")
  lifecycleStage?: LifecycleStage;

  @doc("Terms of service for the API.")
  termsOfService?: TermsOfService;

  @doc("The set of external documentation")
  @maxItems(20)
  externalDocumentation?: ExternalDocumentation[];

  @doc("The set of contacts")
  contacts?: Contact[];

  @doc("The license information for the API.")
  license?: License;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Existing spec"
  @doc("The custom metadata defined for API catalog entities.")
  customProperties?: CustomProperties;
}

@doc("Terms of service for the API.")
model TermsOfService {
  @doc("URL pointing to the terms of service.")
  @maxLength(200)
  url: url;
}

@doc("Additional, external documentation for the API.")
model ExternalDocumentation {
  @doc("Title of the documentation.")
  @maxLength(50)
  title?: string;

  @doc("Description of the documentation.")
  @maxLength(500)
  description?: string;

  @doc("URL pointing to the documentation.")
  @maxLength(200)
  url: url;
}

@doc("Contact information")
model Contact {
  @doc("Name of the contact.")
  @maxLength(100)
  name?: string;

  @doc("URL for the contact.")
  @maxLength(200)
  url?: url;

  @doc("Email address of the contact.")
  @maxLength(100)
  email?: string;
}

@doc("The license information for the API.")
model License {
  @doc("Name of the license.")
  @maxLength(100)
  name?: string;

  @doc("""
URL pointing to the license details. The URL field is mutually exclusive of the
identifier field.
""")
  @maxLength(200)
  url?: url;

  @doc("""
SPDX license information for the API. The identifier field is mutually
exclusive of the URL field.
""")
  @maxLength(50)
  identifier?: url;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("API version properties entity.")
model ApiVersionProperties {
  @doc("API version title.")
  @maxLength(50)
  @minLength(1)
  title: string;

  @doc("Current lifecycle stage of the API.")
  lifecycleStage: LifecycleStage;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("API definition properties entity.")
model ApiDefinitionProperties {
  @doc("API definition title.")
  @maxLength(50)
  @minLength(1)
  title: string;

  @doc("API definition description.")
  description?: string;

  @doc("API specification details.")
  @visibility("read")
  specification?: ApiDefinitionPropertiesSpecification;
}

@doc("API specification details.")
model ApiDefinitionPropertiesSpecification {
  @doc("Specification name.")
  name?: string;

  @doc("Specification version.")
  version?: string;
}

@doc("The API specification source entity properties.")
model ApiSpecImportRequest {
  @doc("Value of the API specification source.")
  value?: string;

  @doc("Format of the API specification source.")
  format?: ApiSpecImportSourceFormat;

  @doc("API specification details.")
  specification?: ApiSpecImportRequestSpecification;
}

@doc("API specification details.")
model ApiSpecImportRequestSpecification {
  @doc("Specification name.")
  name?: string;

  @doc("Specification version.")
  version?: string;
}

@doc("The API specification export result.")
model ApiSpecExportResult {
  @doc("The format of exported result")
  format?: ApiSpecExportResultFormat;

  @doc("The result of the export operation.")
  value?: string;
}

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("API deployment entity properties.")
model DeploymentProperties {
  @doc("API deployment title")
  @maxLength(50)
  @minLength(1)
  title?: string;

  @doc("Description of the deployment.")
  @maxLength(500)
  description?: string;

  @doc("API center-scoped environment resource ID.")
  environmentId?: string;

  @doc("API center-scoped definition resource ID.")
  definitionId?: string;

  @doc("State of API deployment.")
  state?: DeploymentState;

  @doc("The deployment server")
  server?: DeploymentServer;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Existing spec"
  @doc("The custom metadata defined for API catalog entities.")
  customProperties?: CustomProperties;
}

@summary("Custom Properties")
@doc("The custom metadata defined for API catalog entities.")
model CustomProperties {}

@doc("Server")
model DeploymentServer {
  @doc("Base runtime URLs for this deployment.")
  runtimeUri?: SmallString[];
}

/** Used for restricted length uris */
@maxLength(200)
scalar SmallString extends url;

#suppress "@azure-tools/typespec-azure-resource-manager/arm-resource-provisioning-state" "Existing service"
@doc("Environment properties entity.")
model EnvironmentProperties {
  @doc("Environment title.")
  @maxLength(50)
  @minLength(1)
  title: string;

  @doc("The environment description.")
  description?: string;

  @doc("Environment kind.")
  kind: EnvironmentKind;

  @doc("Server information of the environment.")
  server?: EnvironmentServer;

  @doc("Environment onboarding information")
  onboarding?: Onboarding;

  #suppress "@azure-tools/typespec-azure-core/bad-record-type" "Existing spec"
  @doc("The custom metadata defined for API catalog entities.")
  customProperties?: CustomProperties;
}

@doc("Server information of the environment.")
model EnvironmentServer {
  @doc("Type of the server that represents the environment.")
  type?: EnvironmentServerType;

  @maxItems(1)
  @doc("The location of the management portal")
  managementPortalUri?: string[];
}

@doc("Onboarding information")
model Onboarding {
  @doc("Onboarding guide.")
  instructions?: string;

  @maxItems(1)
  @doc("The location of the development portal")
  developerPortalUri?: string[];
}
