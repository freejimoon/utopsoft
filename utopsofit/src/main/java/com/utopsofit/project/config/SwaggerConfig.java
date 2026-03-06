package com.utopsofit.project.config;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/**
 * Swagger / OpenAPI 설정
 * UI 접근: http://localhost:8080/swagger-ui/index.html
 */
@Configuration
public class SwaggerConfig {

    private static final String BEARER_AUTH = "BearerAuth";

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
        		.addServersItem(new Server().url("http://172.16.12.103:8080").description("개발 서버"))
                //.addServersItem(new Server().url("https://172.16.12.103").description("운영 서버"))
                .info(new Info()
                        .title("Utopsoft 앱 API")
                        .version("v1.0.0")
                        .description("앱 서비스 연동 API 문서\n\n" +
                                "① `POST /api/token` 으로 토큰 발급\n\n" +
                                "② 우측 상단 **Authorize** 버튼 클릭 후 토큰 입력\n\n" +
                                "- **Token**: appId / appSecret 으로 JWT 발급\n" +
                                "- **FAQ**: 카테고리 검색 + 페이징 목록 조회 / 단건 조회")
                        .contact(new Contact()
                                .name("Utopsoft 개발팀")
                                .email("dev@utopsoft.co.kr")))
                /* Bearer JWT 보안 스키마 등록 */
                .components(new Components()
                        .addSecuritySchemes(BEARER_AUTH, new SecurityScheme()
                                .type(SecurityScheme.Type.HTTP)
                                .scheme("bearer")
                                .bearerFormat("JWT")
                                .description("발급된 JWT 토큰을 입력하세요 (Bearer 접두사 제외)")))
                /* 모든 엔드포인트에 BearerAuth 적용 */
                .addSecurityItem(new SecurityRequirement().addList(BEARER_AUTH));
    }

    @Bean
    public GroupedOpenApi appApi() {
        SecurityScheme bearerScheme = new SecurityScheme()
                .type(SecurityScheme.Type.HTTP)
                .scheme("bearer")
                .bearerFormat("JWT")
                .description("발급된 JWT 토큰을 입력하세요 (Bearer 접두사 제외)");

        return GroupedOpenApi.builder()
                .group("app-api")
                .displayName("앱 API")
                .pathsToMatch("/api/**")
                /* GroupedOpenApi 에 보안 스키마 직접 등록 — 기존 components(schemas) 유지 */
                .addOpenApiCustomizer(openApi -> {
                    if (openApi.getComponents() == null) {
                        openApi.setComponents(new Components());
                    }
                    openApi.getComponents().addSecuritySchemes(BEARER_AUTH, bearerScheme);
                    openApi.addSecurityItem(new SecurityRequirement().addList(BEARER_AUTH));
                })
                .build();
    }
}
