package com.example.demo.task;

import java.util.Objects;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
class TaskPageController {

  private final TaskService taskService;

  TaskPageController(TaskService taskService) {
    this.taskService = Objects.requireNonNull(taskService);
  }

  @GetMapping
  String list(Model model) {
    model.addAttribute("tasks", taskService.findAll());

    return "task/list";
  }
}