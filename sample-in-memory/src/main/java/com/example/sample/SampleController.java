package com.example.sample;

import java.net.InetAddress;
import java.net.UnknownHostException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.server.WebSession;

import jakarta.servlet.http.HttpSession;
import org.springframework.web.bind.annotation.RequestBody;

@Controller
public class SampleController {

  private static final String SESSION_VALUE_KEY = "sessionValue";
  private static final String SESSION_DATE_KEY = "sessionDate";
  private static final String SESSION_ACCESS_COUNT_KEY = "accessCount";

  @GetMapping("/hello")
  public String helloPage() {
    return "hello";
  }

  @GetMapping("/")
  public String indexPage(Model model, HttpSession session) {
    // hostname
    String hostname;
    try {
      hostname = InetAddress.getLocalHost().getHostName();
    } catch (UnknownHostException e) {
      hostname = "Unknown";
    }
    model.addAttribute("hostname", hostname);

    // count
    Integer accessCount = (Integer) session.getAttribute(SESSION_ACCESS_COUNT_KEY);
    if (accessCount == null) {
      accessCount = 1;
    } else {
      accessCount++;
    }
    session.setAttribute(SESSION_ACCESS_COUNT_KEY, accessCount);
    model.addAttribute("accessCount", accessCount);

    // sessionId
    model.addAttribute("sessionId", session.getId());
    
    // value
    String sessionValue = (String) session.getAttribute(SESSION_VALUE_KEY);
    LocalDateTime sessionDate = (LocalDateTime) session.getAttribute(SESSION_DATE_KEY);

    model.addAttribute("sessionValue", sessionValue);
    model.addAttribute("sessionDate",
        sessionDate != null ? sessionDate.format(DateTimeFormatter.ofPattern("yyyy/MM/dd HH:mm:ss")) : "");
    return "session";
  }

  @PostMapping("/setSession")
  public String setSession(@RequestParam("value") String value, HttpSession session) {
    session.setAttribute(SESSION_VALUE_KEY, value);
    session.setAttribute(SESSION_DATE_KEY, LocalDateTime.now());
    return "redirect:/";
  }

  @GetMapping("/clearSession")
  public String clearSession(HttpSession session) {
    session.invalidate();
    return "redirect:/";
  }
}
