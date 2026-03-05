package com.utopsofit.project.config;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Contact;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.servers.Server;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.Arrays;

/**
 * Swagger / OpenAPI 설정
 * UI 접근: http://localhost:8080/swagger-ui/index.html
 */
@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .info(new Info()
                        .title("Utopsoft 앱 API")
                        .version("v1.0.0")
                        .description("앱 서비스 연동 API 문서\n\n" +
                                "- **공지사항**: 앱 공지사항 목록 조회\n" +
                                "- **문의**: 앱 회원 문의 목록 조회 / 등록")
                        .contact(new Contact()
                                .name("Utopsoft 개발팀")
                                .email("dev@utopsoft.com")))
                .servers(Arrays.asList(
                        new Server().url("/").description("현재 서버")
                ));
    }

    @Bean
    public GroupedOpenApi appApi() {
        return GroupedOpenApi.builder()
                .group("app-api")
                .displayName("앱 API")
                .pathsToMatch("/api/**", "/board/notice/**")
                .build();
    }
}
