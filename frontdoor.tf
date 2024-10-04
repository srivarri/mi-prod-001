# resource "azurerm_cdn_frontdoor_custom_domain" "mi-billing" {
#   name                     = "medimpact-billing-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "medimpact.billing.medadvantage360.com"
# #   tls {
# #     certificate_type    = "CustomerCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
#   provider             = azurerm.sub_hub
# }
# resource "azurerm_cdn_frontdoor_custom_domain" "mi-keycloak" {
#   name                     = "iam-mi-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "iam-mi.medadvantage360.com"
# #   tls {
# #     certificate_type    = "CustomerCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
#   provider             = azurerm.sub_hub
# }
# resource "azurerm_cdn_frontdoor_custom_domain" "mi-associate" {
#   name                     = "medimpact-associate-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "medimpact.associate.medadvantage360.com"
# #   tls {
# #     certificate_type    = "CustomerCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
#   provider             = azurerm.sub_hub
# }
# resource "azurerm_cdn_frontdoor_custom_domain" "mi-member" {
#   name                     = "medimpact-member-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "medimpact.member.medadvantage360.com"
# #   tls {
# #     certificate_type    = "CustomerCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
#   provider             = azurerm.sub_hub
# }
# resource "azurerm_cdn_frontdoor_custom_domain" "mi-healthpartners" {
#   name                     = "mi-healthpartners-member-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "mi-healthpartners.member.medadvantage360.com"
# #   tls {
# #     certificate_type    = "CustomerCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
#   provider             = azurerm.sub_hub
# }
# resource "azurerm_cdn_frontdoor_custom_domain" "mi-mcs" {
#   name                     = "mi-mcs-member-medadvantage360-com"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   host_name                = "mi-mcs.member.medadvantage360.com"
#   tls {
#     certificate_type    = "CustomerCertificate"
#     minimum_tls_version = "TLS12"
#   }
#   provider             = azurerm.sub_hub
# }
# #
# # resource "azurerm_cdn_frontdoor_custom_domain" "example" {
# #   name                     = "example-customDomain"
# #   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
# #  # dns_zone_id              = azurerm_dns_zone.example.id
# #   host_name                = join(".", [
# #     azurerm_cdn_frontdoor_custom_domain.mi-billing.name,
# #     azurerm_cdn_frontdoor_custom_domain.mi-keycloak.name,
# #     azurerm_cdn_frontdoor_custom_domain.mi-associate.name,
# #     azurerm_cdn_frontdoor_custom_domain.mi-member.name,
# #     azurerm_cdn_frontdoor_custom_domain.mi-healthpartners.name,
# #     azurerm_cdn_frontdoor_custom_domain.mi-associate.name
# #   ])
# #   tls {
# #     certificate_type    = "ManagedCertificate"
# #     minimum_tls_version = "TLS12"
# #   }
# #   provider             = azurerm.sub_hub
# # }
#
# resource "azurerm_cdn_frontdoor_origin" "app_gateway_origin" {
#   name                          = "cdnfd-mi-prod-cus-001"
#   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.new_origin_group.id
#
#   enabled                        = true
#   host_name                      = data.azurerm_public_ip.appgatewaypublicip.ip_address
#   http_port                      = 80
#   https_port                     = 443
#   origin_host_header             = data.azurerm_public_ip.appgatewaypublicip.ip_address # Replace with the host header of your Application Gateway
#   priority                       = 1                                                # Set the priority according to your needs
#   weight                         = 1000                                             # Adjust weight if needed
#   certificate_name_check_enabled = false                                            # Enable/disable certificate name check as needed
# }
#
# resource "azurerm_cdn_frontdoor_origin_group" "new_origin_group" {
#   name                     = "fdmiprodcus001OriginGroup"
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#   session_affinity_enabled = false
#
#   load_balancing {
#     sample_size                 = 4
#     successful_samples_required = 3
#   }
#
#   health_probe {
#     path                = "/"
#     request_type        = "HEAD"
#     protocol            = "Https"
#     interval_in_seconds = 100
#   }
# }
#
# resource "azurerm_cdn_frontdoor_endpoint" "existing_endpoint" {
#   name                     = data.azurerm_cdn_frontdoor_profile.example.name
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
#
# #   routing_rule {
# #     route_id = azurerm_cdn_frontdoor_route.new_route.id
# #   }
# }
#
#
# resource "random_id" "front_door_endpoint_name" {
#   byte_length = 2
# }
#
# locals {
#   front_door_endpoint_name     = "afd-${lower(random_id.front_door_endpoint_name.hex)}"
# }
# resource "azurerm_cdn_frontdoor_endpoint" "my_endpoint" {
#   name                     = local.front_door_endpoint_name
#   cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.example.id
# }
#
# resource "azurerm_cdn_frontdoor_route" "new_route" {
#   name                     = "fdmiprodcus001route"
#   cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.my_endpoint.id
#   cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.new_origin_group.id
#   cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.app_gateway_origin.id]
#   cdn_frontdoor_custom_domain_ids = [
#         azurerm_cdn_frontdoor_custom_domain.mi-billing.id,
#         azurerm_cdn_frontdoor_custom_domain.mi-keycloak.id,
#         azurerm_cdn_frontdoor_custom_domain.mi-associate.id,
#         azurerm_cdn_frontdoor_custom_domain.mi-member.id,
#         azurerm_cdn_frontdoor_custom_domain.mi-healthpartners.id,
#         azurerm_cdn_frontdoor_custom_domain.mi-associate.id
#       ]
#   supported_protocols    = ["Http", "Https"]
#   patterns_to_match      = ["/*"]
#   forwarding_protocol    = "HttpOnly"
#   link_to_default_domain = true
#   https_redirect_enabled = false
#   cache {
#     compression_enabled = true
#     content_types_to_compress = [
#       "application/eot",
#       "application/font",
#       "application/font-sfnt",
#       "application/javascript",
#       "application/json",
#       "application/opentype",
#       "application/otf",
#       "application/pkcs7-mime",
#       "application/truetype",
#       "application/ttf",
#       "application/vnd.ms-fontobject",
#       "application/xhtml+xml",
#       "application/xml",
#       "application/xml+rss",
#       "application/x-font-opentype",
#       "application/x-font-truetype",
#       "application/x-font-ttf",
#       "application/x-httpd-cgi",
#       "application/x-javascript",
#       "application/x-mpegurl",
#       "application/x-opentype",
#       "application/x-otf",
#       "application/x-perl",
#       "application/x-ttf",
#       "font/eot",
#       "font/ttf",
#       "font/otf",
#       "font/opentype",
#       "image/svg+xml",
#       "text/css",
#       "text/csv",
#       "text/html",
#       "text/javascript",
#       "text/js",
#       "text/plain",
#       "text/richtext",
#       "text/tab-separated-values",
#       "text/xml",
#       "text/x-script",
#       "text/x-component",
#       "text/x-java-source",
#     ]
#     query_string_caching_behavior = "UseQueryString"
#     query_strings = []
#   }
#
#   lifecycle {
#     ignore_changes = all
#   }
#   depends_on = [
#     azurerm_cdn_frontdoor_origin_group.new_origin_group
#   ]
# }
#
