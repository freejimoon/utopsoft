package com.utopsofit.project;

import org.apache.ibatis.annotations.Mapper;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
@MapperScan(
    basePackages   = {"com.utopsofit.project.portal", "com.utopsofit.project.api", "com.utopsofit.project.cmm"},
    annotationClass = Mapper.class
)
public class UtopsofitApplication extends SpringBootServletInitializer {

	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder builder) {
		return builder.sources(UtopsofitApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(UtopsofitApplication.class, args);
	}
}
