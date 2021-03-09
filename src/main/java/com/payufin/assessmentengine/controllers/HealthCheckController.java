package com.payufin.assessmentengine.controllers;

import lombok.extern.log4j.Log4j2;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@Log4j2
public class HealthCheckController {

    @GetMapping("health")
    public ResponseEntity<String> healthCheck() {
        log.info("Health check api called");
        return ResponseEntity.ok("Received healthCheck");
    }
}
