<!DOCTYPE html>
<html xmlns:th="http://www.thymeleaf.org">
<head>
  <link rel="stylesheet" th:href="@{/css/style.css}">
</head>
<body>
  <main th:fragment="task-list">
    <p th:if="${#lists.isEmpty(tasks)}">No tasks found.</p>
    <ul th:unless="${#lists.isEmpty(tasks)}">
      <li th:each="task : ${tasks}" th:text="${task.description}">Task</li>
    </ul>
  </main>
  <script th:src="@{/js/tasks.js}"></script>
</body>
</html>