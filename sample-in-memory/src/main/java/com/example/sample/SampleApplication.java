package com.example.sample;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class SampleApplication {

	public static void main(String[] args) {
		SpringApplication.run(SampleApplication.class, args);
	}

	// Cookieの名前をredis版と同じ "SESSIONID" とする。デフォルトはJSESSIONID
	// @Bean
	// public ServletContextInitializer servletContextInitializer() {
	// return servletContext ->
	// servletContext.getSessionCookieConfig().setName("SESSIONID");
	// }

}
