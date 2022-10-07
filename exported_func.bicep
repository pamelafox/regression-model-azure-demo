param sites_PamelasChainFunction_name string = 'PamelasChainFunction'
param components_pamelaschainfunction_name string = 'pamelaschainfunction'
param storageAccounts_pamelaschainfunction_name string = 'pamelaschainfunction'
param serverfarms_ASP_PamelasChainFunction_f09a_name string = 'ASP-PamelasChainFunction-f09a'
param service_PamelasChainFunction_apim_name string = 'PamelasChainFunction-apim'
param actionGroups_Application_Insights_Smart_Detection_name string = 'Application Insights Smart Detection'
param smartdetectoralertrules_failure_anomalies_pamelaschainfunction_name string = 'failure anomalies - pamelaschainfunction'

param location string = 'eastus'

resource service_PamelasChainFunction_apim_name_resource 'Microsoft.ApiManagement/service@2021-12-01-preview' = {
  name: service_PamelasChainFunction_apim_name
  location: location
  sku: {
    name: 'Consumption'
    capacity: 0
  }
  properties: {
    publisherEmail: 'pamela.fox@gmail.com'
    publisherName: 'Pamela\'s Functions'
    notificationSenderEmail: 'apimgmt-noreply@mail.windowsazure.com'
    hostnameConfigurations: [
      {
        type: 'Proxy'
        hostName: 'pamelaschainfunction-apim.azure-api.net'
        negotiateClientCertificate: false
        defaultSslBinding: true
        certificateSource: 'BuiltIn'
      }
    ]
    customProperties: {
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls11': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Tls10': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Security.Backend.Protocols.Ssl30': 'false'
      'Microsoft.WindowsAzure.ApiManagement.Gateway.Protocols.Server.Http2': 'false'
    }
    virtualNetworkType: 'None'
    enableClientCertificate: false
    disableGateway: false
    apiVersionConstraint: {
    }
    publicNetworkAccess: 'Enabled'
  }
}

resource actionGroups_Application_Insights_Smart_Detection_name_resource 'microsoft.insights/actionGroups@2022-06-01' = {
  name: actionGroups_Application_Insights_Smart_Detection_name
  location: location
  properties: {
    groupShortName: 'SmartDetect'
    enabled: true
    emailReceivers: []
    smsReceivers: []
    webhookReceivers: []
    eventHubReceivers: []
    itsmReceivers: []
    azureAppPushReceivers: []
    automationRunbookReceivers: []
    voiceReceivers: []
    logicAppReceivers: []
    azureFunctionReceivers: []
    armRoleReceivers: [
      {
        name: 'Monitoring Contributor'
        roleId: '749f88d5-cbae-40b8-bcfc-e573ddc772fa'
        useCommonAlertSchema: true
      }
      {
        name: 'Monitoring Reader'
        roleId: '43d0d8ad-25c7-4714-9337-8ba259a9fe05'
        useCommonAlertSchema: true
      }
    ]
  }
}

resource components_pamelaschainfunction_name_resource 'microsoft.insights/components@2020-02-02' = {
  name: components_pamelaschainfunction_name
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    RetentionInDays: 90
    IngestionMode: 'ApplicationInsights'
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource storageAccounts_pamelaschainfunction_name_resource 'Microsoft.Storage/storageAccounts@2022-05-01' = {
  name: storageAccounts_pamelaschainfunction_name
  location: location
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  kind: 'Storage'
  properties: {
    minimumTlsVersion: 'TLS1_0'
    allowBlobPublicAccess: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
  }
}

resource serverfarms_ASP_PamelasChainFunction_f09a_name_resource 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: serverfarms_ASP_PamelasChainFunction_f09a_name
  location: 'East US'
  sku: {
    name: 'Y1'
    tier: 'Dynamic'
    size: 'Y1'
    family: 'Y'
    capacity: 0
  }
  kind: 'functionapp'
  properties: {
    perSiteScaling: false
    elasticScaleEnabled: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: true
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
    zoneRedundant: false
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/apis@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    displayName: 'PamelasChainFunction'
    apiRevision: '1'
    description: 'Import from "PamelasChainFunction" Function App'
    subscriptionRequired: true
    path: 'PamelasChainFunction'
    protocols: [
      'https'
    ]
    authenticationSettings: {
    }
    subscriptionKeyParameterNames: {
      header: 'Ocp-Apim-Subscription-Key'
      query: 'subscription-key'
    }
    isCurrent: true
  }
}

resource Microsoft_ApiManagement_service_backends_service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/backends@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    description: 'PamelasChainFunction'
    url: 'https://pamelaschainfunction.azurewebsites.net/api'
    protocol: 'http'
    resourceId: 'https://management.azure.com/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/Microsoft.Web/sites/PamelasChainFunction'
    credentials: {
      header: {
        'x-functions-key': [
          '{{pamelaschainfunction-key}}'
        ]
      }
    }
  }
}

resource service_PamelasChainFunction_apim_name_62df5d7e200ea717445d7009 'Microsoft.ApiManagement/service/namedValues@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: '62df5d7e200ea717445d7009'
  properties: {
    displayName: 'Logger-Credentials--62df5d7e200ea717445d700a'
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_key 'Microsoft.ApiManagement/service/namedValues@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction-key'
  properties: {
    displayName: 'pamelaschainfunction-key'
    tags: [
      'key'
      'function'
      'auto'
    ]
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_policy 'Microsoft.ApiManagement/service/policies@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'policy'
  properties: {
    value: '<!--\r\n    IMPORTANT:\r\n    - Policy elements can appear only within the <inbound>, <outbound>, <backend> section elements.\r\n    - Only the <forward-request> policy element can appear within the <backend> section element.\r\n    - To apply a policy to the incoming request (before it is forwarded to the backend service), place a corresponding policy element within the <inbound> section element.\r\n    - To apply a policy to the outgoing response (before it is sent back to the caller), place a corresponding policy element within the <outbound> section element.\r\n    - To add a policy position the cursor at the desired insertion point and click on the round button associated with the policy.\r\n    - To remove a policy, delete the corresponding policy statement from the policy document.\r\n    - Policies are applied in the order of their appearance, from the top down.\r\n-->\r\n<policies>\r\n  <inbound></inbound>\r\n  <backend>\r\n    <forward-request />\r\n  </backend>\r\n  <outbound></outbound>\r\n</policies>'
    format: 'xml'
  }
}

resource Microsoft_ApiManagement_service_properties_service_PamelasChainFunction_apim_name_62df5d7e200ea717445d7009 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: '62df5d7e200ea717445d7009'
  properties: {
    displayName: 'Logger-Credentials--62df5d7e200ea717445d700a'
    value: '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    secret: true
  }
}

resource Microsoft_ApiManagement_service_properties_service_PamelasChainFunction_apim_name_pamelaschainfunction_key 'Microsoft.ApiManagement/service/properties@2019-01-01' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction-key'
  properties: {
    displayName: 'pamelaschainfunction-key'
    value: '/l31iJBZSKFLax4gRxXCKHfvvsRilu5lbPE14iDnYV2e7t4YcARryQ=='
    tags: [
      'key'
      'function'
      'auto'
    ]
    secret: true
  }
}

resource service_PamelasChainFunction_apim_name_master 'Microsoft.ApiManagement/service/subscriptions@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'master'
  properties: {
    scope: '${service_PamelasChainFunction_apim_name_resource.id}/'
    displayName: 'Built-in all-access subscription'
    state: 'active'
    allowTracing: false
  }
}

resource components_pamelaschainfunction_name_degradationindependencyduration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'degradationindependencyduration'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'degradationindependencyduration'
      DisplayName: 'Degradation in dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_degradationinserverresponsetime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'degradationinserverresponsetime'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'degradationinserverresponsetime'
      DisplayName: 'Degradation in server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_digestMailConfiguration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'digestMailConfiguration'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'digestMailConfiguration'
      DisplayName: 'Digest Mail Configuration'
      Description: 'This rule describes the digest mail preferences'
      HelpUrl: 'www.homail.com'
      IsHidden: true
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_billingdatavolumedailyspikeextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_billingdatavolumedailyspikeextension'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_billingdatavolumedailyspikeextension'
      DisplayName: 'Abnormal rise in daily data volume (preview)'
      Description: 'This detection rule automatically analyzes the billing data generated by your application, and can warn you about an unusual increase in your application\'s billing costs'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/tree/master/SmartDetection/billing-data-volume-daily-spike.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_canaryextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_canaryextension'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_canaryextension'
      DisplayName: 'Canary extension'
      Description: 'Canary extension'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/'
      IsHidden: true
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_exceptionchangeextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_exceptionchangeextension'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_exceptionchangeextension'
      DisplayName: 'Abnormal rise in exception volume (preview)'
      Description: 'This detection rule automatically analyzes the exceptions thrown in your application, and can warn you about unusual patterns in your exception telemetry.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/abnormal-rise-in-exception-volume.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_memoryleakextension 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_memoryleakextension'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_memoryleakextension'
      DisplayName: 'Potential memory leak detected (preview)'
      Description: 'This detection rule automatically analyzes the memory consumption of each process in your application, and can warn you about potential memory leaks or increased memory consumption.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/tree/master/SmartDetection/memory-leak.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_securityextensionspackage 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_securityextensionspackage'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_securityextensionspackage'
      DisplayName: 'Potential security issue detected (preview)'
      Description: 'This detection rule automatically analyzes the telemetry generated by your application and detects potential security issues.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/application-security-detection-pack.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_extension_traceseveritydetector 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'extension_traceseveritydetector'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'extension_traceseveritydetector'
      DisplayName: 'Degradation in trace severity ratio (preview)'
      Description: 'This detection rule automatically analyzes the trace logs emitted from your application, and can warn you about unusual patterns in the severity of your trace telemetry.'
      HelpUrl: 'https://github.com/Microsoft/ApplicationInsights-Home/blob/master/SmartDetection/degradation-in-trace-severity-ratio.md'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_longdependencyduration 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'longdependencyduration'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'longdependencyduration'
      DisplayName: 'Long dependency duration'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_migrationToAlertRulesCompleted 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'migrationToAlertRulesCompleted'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'migrationToAlertRulesCompleted'
      DisplayName: 'Migration To Alert Rules Completed'
      Description: 'A configuration that controls the migration state of Smart Detection to Smart Alerts'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: true
      IsEnabledByDefault: false
      IsInPreview: true
      SupportsEmailNotifications: false
    }
    Enabled: false
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_slowpageloadtime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'slowpageloadtime'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'slowpageloadtime'
      DisplayName: 'Slow page load time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource components_pamelaschainfunction_name_slowserverresponsetime 'microsoft.insights/components/ProactiveDetectionConfigs@2018-05-01-preview' = {
  parent: components_pamelaschainfunction_name_resource
  name: 'slowserverresponsetime'
  location: 'eastus'
  properties: {
    RuleDefinitions: {
      Name: 'slowserverresponsetime'
      DisplayName: 'Slow server response time'
      Description: 'Smart Detection rules notify you of performance anomaly issues.'
      HelpUrl: 'https://docs.microsoft.com/en-us/azure/application-insights/app-insights-proactive-performance-diagnostics'
      IsHidden: false
      IsEnabledByDefault: true
      IsInPreview: false
      SupportsEmailNotifications: true
    }
    Enabled: true
    SendEmailsToSubscriptionOwners: true
    CustomEmails: []
  }
}

resource storageAccounts_pamelaschainfunction_name_default 'Microsoft.Storage/storageAccounts/blobServices@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: false
    }
  }
}

resource Microsoft_Storage_storageAccounts_fileServices_storageAccounts_pamelaschainfunction_name_default 'Microsoft.Storage/storageAccounts/fileServices@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_resource
  name: 'default'
  sku: {
    name: 'Standard_LRS'
    tier: 'Standard'
  }
  properties: {
    protocolSettings: {
      smb: {
      }
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource Microsoft_Storage_storageAccounts_queueServices_storageAccounts_pamelaschainfunction_name_default 'Microsoft.Storage/storageAccounts/queueServices@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource Microsoft_Storage_storageAccounts_tableServices_storageAccounts_pamelaschainfunction_name_default 'Microsoft.Storage/storageAccounts/tableServices@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource sites_PamelasChainFunction_name_resource 'Microsoft.Web/sites@2022-03-01' = {
  name: sites_PamelasChainFunction_name
  location: 'East US'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/microsoft.insights/components/pamelaschainfunction'
    'hidden-link: /app-insights-instrumentation-key': '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=30c48d81-4bf6-45c1-8f60-1937caef2a3b;IngestionEndpoint=https://eastus-5.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/'
  }
  kind: 'functionapp,linux'
  properties: {
    enabled: true
    hostNameSslStates: [
      {
        name: 'pamelaschainfunction.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Standard'
      }
      {
        name: 'pamelaschainfunction.scm.azurewebsites.net'
        sslState: 'Disabled'
        hostType: 'Repository'
      }
    ]
    serverFarmId: serverfarms_ASP_PamelasChainFunction_f09a_name_resource.id
    reserved: true
    isXenon: false
    hyperV: false
    vnetRouteAllEnabled: false
    vnetImagePullEnabled: false
    vnetContentShareEnabled: false
    siteConfig: {
      numberOfWorkers: 1
      linuxFxVersion: 'Python|3.9'
      acrUseManagedIdentityCreds: false
      alwaysOn: false
      http20Enabled: false
      functionAppScaleLimit: 200
      minimumElasticInstanceCount: 0
    }
    scmSiteAlsoStopped: false
    clientAffinityEnabled: false
    clientCertEnabled: false
    clientCertMode: 'Required'
    hostNamesDisabled: false
    customDomainVerificationId: '5860E660CF601D768D3872F5B04C070AB4E43F1BAE9B19BD5B90667EBDFC03BD'
    containerSize: 0
    dailyMemoryTimeQuota: 0
    httpsOnly: false
    redundancyMode: 'None'
    storageAccountRequired: false
    keyVaultReferenceIdentity: 'SystemAssigned'
  }
}

resource sites_PamelasChainFunction_name_ftp 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_PamelasChainFunction_name_resource
  name: 'ftp'
  location: 'East US'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/microsoft.insights/components/pamelaschainfunction'
    'hidden-link: /app-insights-instrumentation-key': '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=30c48d81-4bf6-45c1-8f60-1937caef2a3b;IngestionEndpoint=https://eastus-5.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/'
  }
  properties: {
    allow: true
  }
}

resource sites_PamelasChainFunction_name_scm 'Microsoft.Web/sites/basicPublishingCredentialsPolicies@2022-03-01' = {
  parent: sites_PamelasChainFunction_name_resource
  name: 'scm'
  location: 'East US'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/microsoft.insights/components/pamelaschainfunction'
    'hidden-link: /app-insights-instrumentation-key': '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=30c48d81-4bf6-45c1-8f60-1937caef2a3b;IngestionEndpoint=https://eastus-5.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/'
  }
  properties: {
    allow: true
  }
}

resource sites_PamelasChainFunction_name_ChainFunction 'Microsoft.Web/sites/functions@2022-03-01' = {
  parent: sites_PamelasChainFunction_name_resource
  name: 'ChainFunction'
  location: 'East US'
  properties: {
    script_root_path_href: 'https://pamelaschainfunction.azurewebsites.net/admin/vfs/home/site/wwwroot/ChainFunction/'
    script_href: 'https://pamelaschainfunction.azurewebsites.net/admin/vfs/home/site/wwwroot/ChainFunction/__init__.py'
    config_href: 'https://pamelaschainfunction.azurewebsites.net/admin/vfs/home/site/wwwroot/ChainFunction/function.json'
    test_data_href: 'https://pamelaschainfunction.azurewebsites.net/admin/vfs/tmp/FunctionsData/ChainFunction.dat'
    href: 'https://pamelaschainfunction.azurewebsites.net/admin/functions/ChainFunction'
    config: {
    }
    invoke_url_template: 'https://pamelaschainfunction.azurewebsites.net/api/chainfunction'
    language: 'python'
    isDisabled: false
  }
}

resource sites_PamelasChainFunction_name_sites_PamelasChainFunction_name_azurewebsites_net 'Microsoft.Web/sites/hostNameBindings@2022-03-01' = {
  parent: sites_PamelasChainFunction_name_resource
  name: '${sites_PamelasChainFunction_name}.azurewebsites.net'
  location: 'East US'
  properties: {
    siteName: 'PamelasChainFunction'
    hostNameType: 'Verified'
  }
}

resource smartdetectoralertrules_failure_anomalies_pamelaschainfunction_name_resource 'microsoft.alertsmanagement/smartdetectoralertrules@2021-04-01' = {
  name: smartdetectoralertrules_failure_anomalies_pamelaschainfunction_name
  location: 'global'
  properties: {
    description: 'Failure Anomalies notifies you of an unusual rise in the rate of failed HTTP requests or dependency calls.'
    state: 'Enabled'
    severity: 'Sev3'
    frequency: 'PT1M'
    detector: {
      id: 'FailureAnomaliesDetector'
    }
    scope: [
      components_pamelaschainfunction_name_resource.id
    ]
    actionGroups: {
      groupIds: [
        actionGroups_Application_Insights_Smart_Detection_name_resource.id
      ]
    }
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction 'Microsoft.ApiManagement/service/apis/operations@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction
  name: 'get-chainfunction'
  properties: {
    displayName: 'ChainFunction'
    method: 'GET'
    urlTemplate: '/ChainFunction'
    templateParameters: []
    request: {
      queryParameters: [
        {
          name: 'kind'
          description: 'Specifies which chain to query.'
          type: 'string'
          required: true
          values: [
            'planet'
          ]
        }
        {
          name: 'seed'
          description: 'Specifies seed for random number generator.'
          type: 'integer'
          values: []
        }
      ]
      headers: []
      representations: []
    }
    responses: []
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource
  ]
}

resource service_PamelasChainFunction_apim_name_applicationinsights 'Microsoft.ApiManagement/service/diagnostics@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    logClientIp: true
    loggerId: Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
    frontend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
    backend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
  }
}

resource service_PamelasChainFunction_apim_name_applicationinsights_pamelaschainfunction 'Microsoft.ApiManagement/service/diagnostics/loggers@2018-01-01' = {
  parent: service_PamelasChainFunction_apim_name_applicationinsights
  name: 'pamelaschainfunction'
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource
  ]
}

resource Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction 'Microsoft.ApiManagement/service/loggers@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'pamelaschainfunction'
  properties: {
    loggerType: 'applicationInsights'
    credentials: {
      instrumentationKey: '{{Logger-Credentials--62df5d7e200ea717445d700a}}'
    }
    isBuffered: true
    resourceId: components_pamelaschainfunction_name_resource.id
  }
}

resource service_PamelasChainFunction_apim_name_eliott_fantasy_planet 'Microsoft.ApiManagement/service/subscriptions@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_resource
  name: 'eliott-fantasy-planet'
  properties: {
    scope: service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    displayName: 'Eliott\'s Fantasy Planet'
    state: 'active'
    allowTracing: true
  }
}

resource storageAccounts_pamelaschainfunction_name_default_azure_webjobs_hosts 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_default
  name: 'azure-webjobs-hosts'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_pamelaschainfunction_name_resource
  ]
}

resource storageAccounts_pamelaschainfunction_name_default_azure_webjobs_secrets 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_default
  name: 'azure-webjobs-secrets'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_pamelaschainfunction_name_resource
  ]
}

resource storageAccounts_pamelaschainfunction_name_default_scm_releases 'Microsoft.Storage/storageAccounts/blobServices/containers@2022-05-01' = {
  parent: storageAccounts_pamelaschainfunction_name_default
  name: 'scm-releases'
  properties: {
    immutableStorageWithVersioning: {
      enabled: false
    }
    defaultEncryptionScope: '$account-encryption-key'
    denyEncryptionScopeOverride: false
    publicAccess: 'None'
  }
  dependsOn: [

    storageAccounts_pamelaschainfunction_name_resource
  ]
}

resource storageAccounts_pamelaschainfunction_name_default_storageAccounts_pamelaschainfunction_name_b0a0f9 'Microsoft.Storage/storageAccounts/fileServices/shares@2022-05-01' = {
  parent: Microsoft_Storage_storageAccounts_fileServices_storageAccounts_pamelaschainfunction_name_default
  name: '${storageAccounts_pamelaschainfunction_name}b0a0f9'
  properties: {
    accessTier: 'TransactionOptimized'
    shareQuota: 5120
    enabledProtocols: 'SMB'
  }
  dependsOn: [

    storageAccounts_pamelaschainfunction_name_resource
  ]
}

resource sites_PamelasChainFunction_name_web 'Microsoft.Web/sites/config@2022-03-01' = {
  parent: sites_PamelasChainFunction_name_resource
  name: 'web'
  location: 'East US'
  tags: {
    'hidden-link: /app-insights-resource-id': '/subscriptions/74feb6f3-f646-478d-a99b-37fafee75e29/resourceGroups/pamelaschainfunction/providers/microsoft.insights/components/pamelaschainfunction'
    'hidden-link: /app-insights-instrumentation-key': '30c48d81-4bf6-45c1-8f60-1937caef2a3b'
    'hidden-link: /app-insights-conn-string': 'InstrumentationKey=30c48d81-4bf6-45c1-8f60-1937caef2a3b;IngestionEndpoint=https://eastus-5.in.applicationinsights.azure.com/;LiveEndpoint=https://eastus.livediagnostics.monitor.azure.com/'
  }
  properties: {
    numberOfWorkers: 1
    defaultDocuments: [
      'Default.htm'
      'Default.html'
      'Default.asp'
      'index.htm'
      'index.html'
      'iisstart.htm'
      'default.aspx'
      'index.php'
    ]
    netFrameworkVersion: 'v4.0'
    linuxFxVersion: 'Python|3.9'
    requestTracingEnabled: false
    remoteDebuggingEnabled: false
    httpLoggingEnabled: false
    acrUseManagedIdentityCreds: false
    logsDirectorySizeLimit: 35
    detailedErrorLoggingEnabled: false
    publishingUsername: '$PamelasChainFunction'
    scmType: 'None'
    use32BitWorkerProcess: false
    webSocketsEnabled: false
    alwaysOn: false
    managedPipelineMode: 'Integrated'
    virtualApplications: [
      {
        virtualPath: '/'
        physicalPath: 'site\\wwwroot'
        preloadEnabled: false
      }
    ]
    loadBalancing: 'LeastRequests'
    experiments: {
      rampUpRules: []
    }
    autoHealEnabled: false
    vnetRouteAllEnabled: false
    vnetPrivatePortsCount: 0
    cors: {
      allowedOrigins: [
        'http://fantasy-planet.us-west-1.elasticbeanstalk.com'
      ]
      supportCredentials: false
    }
    apiManagementConfig: {
      id: service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    }
    localMySqlEnabled: false
    ipSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictions: [
      {
        ipAddress: 'Any'
        action: 'Allow'
        priority: 2147483647
        name: 'Allow all'
        description: 'Allow all access'
      }
    ]
    scmIpSecurityRestrictionsUseMain: false
    http20Enabled: false
    minTlsVersion: '1.2'
    scmMinTlsVersion: '1.2'
    ftpsState: 'AllAllowed'
    preWarmedInstanceCount: 0
    functionAppScaleLimit: 200
    functionsRuntimeScaleMonitoringEnabled: false
    minimumElasticInstanceCount: 0
    azureStorageAccounts: {
    }
  }
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights 'Microsoft.ApiManagement/service/apis/diagnostics@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction
  name: 'applicationinsights'
  properties: {
    alwaysLog: 'allErrors'
    httpCorrelationProtocol: 'Legacy'
    logClientIp: true
    loggerId: Microsoft_ApiManagement_service_loggers_service_PamelasChainFunction_apim_name_pamelaschainfunction.id
    sampling: {
      samplingType: 'fixed'
      percentage: 100
    }
    frontend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
    backend: {
      request: {
        dataMasking: {
          queryParams: [
            {
              value: '*'
              mode: 'Hide'
            }
          ]
        }
      }
    }
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_resource

  ]
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights_pamelaschainfunction 'Microsoft.ApiManagement/service/apis/diagnostics/loggers@2018-01-01' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction_applicationinsights
  name: 'pamelaschainfunction'
  dependsOn: [

    service_PamelasChainFunction_apim_name_pamelaschainfunction
    service_PamelasChainFunction_apim_name_resource
  ]
}

resource service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction_policy 'Microsoft.ApiManagement/service/apis/operations/policies@2021-12-01-preview' = {
  parent: service_PamelasChainFunction_apim_name_pamelaschainfunction_get_chainfunction
  name: 'policy'
  properties: {
    value: '<policies>\r\n  <inbound>\r\n    <base />\r\n    <set-backend-service id="apim-generated-policy" backend-id="pamelaschainfunction" />\r\n    <cors allow-credentials="false">\r\n      <allowed-origins>\r\n        <origin>http://fantasy-planet.us-west-1.elasticbeanstalk.com</origin>\r\n        <origin>http://eliottgray.com</origin>\r\n        <origin>https://pamelafox.github.io</origin>\r\n        <origin>https://eliottgray.github.io</origin>\r\n      </allowed-origins>\r\n      <allowed-methods>\r\n        <method>GET</method>\r\n      </allowed-methods>\r\n    </cors>\r\n    <validate-parameters specified-parameter-action="prevent" unspecified-parameter-action="ignore" />\r\n  </inbound>\r\n  <backend>\r\n    <base />\r\n  </backend>\r\n  <outbound>\r\n    <base />\r\n  </outbound>\r\n  <on-error>\r\n    <base />\r\n  </on-error>\r\n</policies>'
    format: 'xml'
  }
  dependsOn: [

    service_PamelasChainFunction_apim_name_pamelaschainfunction
    service_PamelasChainFunction_apim_name_resource
  ]
}
