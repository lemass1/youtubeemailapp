package com.example.youtubeemailapp.controller;

import com.example.youtubeemailapp.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api")
public class ApiController {

    private final EmailService emailService;

    @Autowired
    public ApiController(EmailService emailService) {
        this.emailService = emailService;
    }

    @PostMapping("/send-email")
    public ResponseEntity<Map<String, String>> sendEmail(@RequestBody Map<String, String> request) {
        String recipient = request.get("recipient");
        String subject = request.get("subject");
        String body = request.get("body");

        emailService.sendEmail(recipient, subject, body);

        return ResponseEntity.ok(Map.of("status", "Email sent successfully"));
    }
}
