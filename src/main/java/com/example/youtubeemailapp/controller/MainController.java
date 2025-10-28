package com.example.youtubeemailapp.controller;

import com.example.youtubeemailapp.service.EmailService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.ui.Model;

@Controller
public class MainController {

    @Autowired
    private EmailService emailService;

    @PostMapping("/sendEmail")
    public String sendEmail(@RequestParam String name,
                            @RequestParam String fromEmail,
                            @RequestParam String message,
                            Model model) {

        String subject = "New message from " + name;
        String to = "your_email@example.com"; // <-- Replace with your real email
        String body = "From: " + fromEmail + "\n\n" + message;

        emailService.sendEmail(to, subject, body);


        model.addAttribute("success", "Message sent successfully!");
        return "contact";
    }
}
