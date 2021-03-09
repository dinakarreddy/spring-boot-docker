package com.payufin.assessmentengine;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.PropertySource;

@SpringBootApplication
@PropertySource("classpath:application.yaml")
public class AssessmentEngineApplication {

	public static void main(String[] args) {
		SpringApplication.run(AssessmentEngineApplication.class, args);
	}

}
